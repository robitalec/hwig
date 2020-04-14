#' Calculate HWI
#'
#' Calculates the Half-Weight Association Index
#'
#' Expects an input `DT` with id and group column, e.g. as returned by \link[spatsoc]{group_pts}.
#'
#' @param DT input group membership data, in individual/group format
#' @param id column indicating id in DT
#' @param group column indicating group in DT
#' @param by column(s) to split calculation by. e.g.: year
#'
#' @return HWI data.table or list of data.tables.
#' @export
#'
#' @import data.table
#' @seealso \link[hwig]{calc_hwig}
#'
#' @examples
#' # Load data.table
#' library(data.table)
#'
#' # Load example data
#' DT <- fread(system.file("extdata", "DT.csv", package = "hwig"))
#'
#' # Calculate HWI
#' hwi <- calc_hwi(DT, 'id', 'group', 'yr')
calc_hwi <- function(DT, id, group, by = NULL) {
	if (missing(DT)) stop('DT is missing')
	if (missing(id)) stop('id is missing')
	if (missing(group)) stop('group is missing')

	if (!(group %in% colnames(DT))) {
		stop('group column not found in DT')
	}

	if (!(id %in% colnames(DT))) {
		stop('id column not found in DT')
	}

	calc <- function(DT) {
		memb.matrix <- spatsoc::get_gbi(DT, group = group, id = id)

		hwi <-
			data.table::data.table(asnipe::get_network(
				memb.matrix,
				data_format = 'GBI',
				association_index = 'HWI'
			))
	}

	if (is.null(by)) {
		return(calc(DT))
	} else if (all(by %in% colnames(DT))) {
		combs <- unique(DT[, .SD, .SDcols = by])
		return(lapply(seq_len(nrow(combs)), function(i) {
			calc(DT[combs[i], on = by])
		}))
	} else {
		stop('by column(s) not found in DT')
	}
}

#' Calculate HWIG
#'
#' Calculates the Half-Weight Association Index according to the method described in Godde et al. (2013).
#'
#' It is expected that the input `hwi` is the output from `calc_hwi`. If `by`
#' was provided in that function, `hwi` will be a list of data.tables.
#' Alternatively if `by` wasn't provided, `hwi` will be a single data.table.
#'
#'
#' @param hwi output of \link[hwig]{calc_hwi}. Either a data.table or a list of
#'   data.tables. See Details.
#'
#' @return HWIG data.table or list of data.tables.
#' @seealso \link[hwig]{calc_hwi} \link[hwig]{get_names}
#' @export
#'
#' @references Sophie Godde, Lionel Humbert, Steeve D. Côté, Denis Réale, Hal
#'   Whitehead. Correcting for the impact of gregariousness in social network
#'   analyses. Animal Behaviour. Volume 85, Issue 3. 2013.
#'
#'
#' @examples
#' # Load data.table
#' library(data.table)
#'
#' # Load example data
#' DT <- fread(system.file("extdata", "DT.csv", package = "hwig"))
#'
#' # Calculate HWI
#' hwi <- calc_hwi(DT, 'id', 'group', 'yr')
#'
#' # Calculate HWIG
#' hwig <- calc_hwig(hwi)
calc_hwig <- function(hwi) {
	# NSE
	HWI <- ID <- total <- NULL

	if (missing(hwi)) {
		stop('hwi missing. did you run calc_hwi?')
	}

	calc <- function(hwi) {
		sums <- data.table::melt(
			hwi[, lapply(.SD, sum), .SDcols = colnames(hwi)],
			measure.vars = colnames(hwi),
			variable.name = 'ID',
			value.name = 'HWI'
		)

		sums[, total := sum(HWI) / 2]
		grand <- sums[1, total]

		mult <- data.table::data.table(sums[, outer(HWI, HWI, '*')])

		div <-
			mult[, grand / .SD, .SDcols = colnames(mult)]

		for (j in seq_len(ncol(div)))
			data.table::set(div, which(is.infinite(div[[j]])), j, 0)

		hwig <- div * hwi
		colnames(hwig) <- sums[, as.character(ID)]
		return(hwig)
	}

	if (inherits(hwi, 'data.table')) {
		calc(hwi)
	} else if (inherits(hwi, 'list')) {
		lapply(hwi, calc)
	} else {
		stop('hwi must be either a data.table or list of data.tables from calc_hwi')
	}
}

#' Get HWI/HWIG names
#'
#' Helper function, to return names of each matrix
#'
#' @inheritParams calc_hwi
#'
#' @return names corresponding to values of by for each of the returned list of
#'   matrices in \link[hwig]{calc_hwi} and \link[hwig]{calc_hwig}.
#' @export
#' @seealso \link[hwig]{calc_hwi} \link[hwig]{calc_hwig}
#'
#' @examples
#' # Load data.table
#' library(data.table)
#'
#' # Load example data
#' DT <- fread(system.file("extdata", "DT.csv", package = "hwig"))
#'
#' # Calculate HWI
#' hwi <- calc_hwi(DT, 'id', 'group', 'yr')
#'
#' # Calculate HWIG
#' hwig <- calc_hwig(hwi)
#'
#' # Set names
#' nms <- get_names(DT, 'yr')
#' names(hwig) <- nms
get_names <- function(DT, by) {
	return(unlist(unique(DT[, .SD, .SDcols = by]), use.names = FALSE))
}
