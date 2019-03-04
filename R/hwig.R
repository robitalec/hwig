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
CalculateHWI <- function(ind.groups, input.data.format = 'individuals',
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
