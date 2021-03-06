% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hwig.R
\name{calc_hwig}
\alias{calc_hwig}
\title{Calculate HWIG}
\usage{
calc_hwig(hwi)
}
\arguments{
\item{hwi}{output of \link[hwig]{calc_hwi}. Either a data.table or a list of
data.tables. See Details.}
}
\value{
HWIG data.table or list of data.tables.
}
\description{
Calculates the Half-Weight Association Index according to the method described in Godde et al. (2013).
}
\details{
It is expected that the input `hwi` is the output from `calc_hwi`. If `by`
was provided in that function, `hwi` will be a list of data.tables.
Alternatively if `by` wasn't provided, `hwi` will be a single data.table.
}
\examples{
# Load data.table
library(data.table)

# Load example data
DT <- fread(system.file("extdata", "DT.csv", package = "hwig"))

# Calculate HWI
hwi <- calc_hwi(DT, 'id', 'group', 'yr')

# Calculate HWIG
hwig <- calc_hwig(hwi)
}
\references{
Sophie Godde, Lionel Humbert, Steeve D. Côté, Denis Réale, Hal
  Whitehead. Correcting for the impact of gregariousness in social network
  analyses. Animal Behaviour. Volume 85, Issue 3. 2013.
}
\seealso{
\link[hwig]{calc_hwi} \link[hwig]{get_names}
}
