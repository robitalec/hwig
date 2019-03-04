#' Calculate HWI
#'
#' @param ind.groups input group membership data, in ID/GROUP format
#' @param input.data.format groups or individuals, as string (for get_group_by..)
#' @param network.data.format  GBI or SP, group by individual or sampling period
#' @param assc.ind SRI or HWI, for association_index
#'
#' @return data.table of HWI for each individual pair combination
#' @export
#'
#' @examples
calc_hwi <- function(ind.groups, input.data.format = 'individuals',
												 network.data.format = 'GBI', assc.ind = 'HWI'){
	if (!'ID' %in% colnames(ind.groups)) {
		warning("Column named 'ID' not found, ensure that an ID column is present in the input data")
	}
	if (!'GROUP' %in% colnames(ind.groups)) {
		warning("Column named 'GROUP' not found, ensure that a GROUP column is present in the input data")
	}
	if (!is.character(input.data.format)) {
		stop('require string input to all named variables (input.data.format)')
	}
	if (!is.character(network.data.format)) {
		stop('require string input to all named variables (network.data.format)')
	}
	if (!is.character(assc.ind)) {
		stop('require string input to all named variables (assc.ind)')
	}

	# Process:
	# Re-sort input data into group by individual with asnipe function
	memb.matrix <- get_group_by_individual(ind.groups, data_format = input.data.format)

	# Output HWI matrix into a data.table
	hwi.full <- data.table(get_network(memb.matrix, data_format = network.data.format,
																		 association_index = assc.ind))
	return(hwi.full)
}


#' @param hwi.dt output of `calc_hwi``
#'
#' @return HWIG matrix
#' @export
#'
#' @examples
calc_hwig <- function(hwi.dt){
	hwi.sums <- melt(hwi.dt[, lapply(.SD, sum), .SDcols = colnames(hwi.dt)],
									 measure.vars = colnames(hwi.dt),
									 variable.name = 'ID', value.name = 'HWI')

	hwi.sums[, hwiTotal := sum(HWI)/2]
	hwi.grand.total <- hwi.sums[1, hwiTotal]

	hwi.mult.inds <- data.table(hwi.sums[, outer(HWI, HWI, '*')])

	hwi.div <- hwi.mult.inds[, hwi.grand.total / .SD, .SDcols = colnames(hwi.mult.inds)]


	for (j in 1:ncol(hwi.div)) set(hwi.div, which(is.infinite(hwi.div[[j]])), j, 0)

	hwig <- hwi.div * hwi.dt
	colnames(hwig) <- hwi.sums[, as.character(ID)]
	return(hwig)
}
