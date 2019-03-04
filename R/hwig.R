#' Calculate HWI
#'
#' @param DT input group membership data, in individual/group format
#' @param id column indicating id in DT
#' @param group column indicating group in DT
#'
#' @return data.table of HWI
#' @export
#'
#' @examples
calc_hwi <- function(DT, id, group) {
	if (missing(DT)) stop('DT is missing')
	if (missing(group)) stop('group is missing')
	if (missing(id)) stop('id is missing')

	if (!(group %in% colnames(DT))) {
		stop('id column not found in DT')
	}

	if (!(id %in% colnames(DT))) {
		stop('id column not found in DT')
	}

	memb.matrix <- spatsoc::get_gbi(DT, group = group, id = id)

	hwi <-
		data.table::data.table(asnipe::get_network(
			memb.matrix,
			data_format = 'GBI',
			association_index = 'HWI'
		))
	return(hwi)
}

#' Calculate HWIG
#' @param hwi output of `calc_hwi``
#'
#' @return HWIG matrix
#' @export
#'
#' @examples
calc_hwig <- function(hwi) {
	hwi.sums <- melt(
		hwi[, lapply(.SD, sum), .SDcols = colnames(hwi)],
		measure.vars = colnames(hwi),
		variable.name = 'ID',
		value.name = 'HWI'
	)

	hwi.sums[, hwiTotal := sum(HWI) / 2]
	hwi.grand.total <- hwi.sums[1, hwiTotal]

	hwi.mult.inds <- data.table(hwi.sums[, outer(HWI, HWI, '*')])

	hwi.div <-
		hwi.mult.inds[, hwi.grand.total / .SD, .SDcols = colnames(hwi.mult.inds)]


	for (j in 1:ncol(hwi.div))
		set(hwi.div, which(is.infinite(hwi.div[[j]])), j, 0)

	hwig <- hwi.div * hwi
	colnames(hwig) <- hwi.sums[, as.character(ID)]
	return(hwig)
}
