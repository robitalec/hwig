#' Example data for input to `hwig`
#'
#' @format A data.table with 14297 rows and 3 variables: \describe{
#'   \item{ID}{individual identifier}
#'   \item{year}{integer representing the year}}
#'
#' @name DT
#'
#' @source
#'
#' # Load packages
#' library(spatsoc)
#' library(data.table)
#'
#' # Read example data
#' DT <- fread(system.file("extdata", "DT.csv", package = "spatsoc"))
#'
#' # Cast the character column to POSIXct
#' DT[, datetime := as.POSIXct(datetime, tz = 'UTC')]
#'
#' # Temporal grouping
#' group_times(DT, datetime = 'datetime', threshold = '20 minutes')
#'
#' # Spatial grouping with timegroup
#' group_pts(
#'   DT,
#'   threshold = 5,
#'   id = 'ID',
#'   coords = c('X', 'Y'),
#'   timegroup = 'timegroup'
#' )
#'
#' fwrite(DT[, .(id = ID, group, yr = year(datetime))],
#' 			 'inst/extdata/DT.csv')
#'
#'
#' @examples
#' # Load data.table
#' library(data.table)
#'
#' # Read example data
#' DT <- fread(system.file("extdata", "DT.csv", package = "hwig"))
NULL
