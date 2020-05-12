
# hwig

Calculates the half-weight index gregariousness (HWIG) as described in
Godde et al. (2013) [\[1\]](#references).

## Installation

``` r
devtools::install_gitlab('robit.a/hwig')

# CRAN
install.packages('hwig')
```

## Usage

``` r
# Load packages
library(hwig)
library(data.table)

# Load example data
DT <- fread(system.file("extdata", "DT.csv", package = "hwig"))

# Calculate HWI
hwi <- calc_hwi(DT, 'id', 'group', 'yr')
#> Generating  10  x  10  matrix
#> Generating  10  x  10  matrix

# Calculate HWIG
hwig <- calc_hwig(hwi)

# Set names
nms <- get_names(DT, 'yr')
names(hwig) <- nms

# Print first year's result
hwig[1]
#> $`2016`
#>       A     B      C D      E      F     G      H      I     J
#>  0.0000 0.000 1.0006 0 0.6857 1.3337 0.000 0.2727 1.5114 1.000
#>  0.0000 0.000 0.0000 0 0.0000 0.0000 3.058 0.0000 0.0000 0.000
#>  1.0006 0.000 0.0000 0 0.0000 1.1153 0.000 0.8868 1.3630 0.000
#>  0.0000 0.000 0.0000 0 0.0000 0.0000 0.000 0.0000 0.0000 0.000
#>  0.6857 0.000 0.0000 0 0.0000 0.5944 0.000 2.2281 0.4953 0.000
#>  1.3337 0.000 1.1153 0 0.5944 0.0000 0.000 0.4728 0.6936 0.000
#>  0.0000 3.058 0.0000 0 0.0000 0.0000 0.000 0.0000 0.0000 0.000
#>  0.2727 0.000 0.8868 0 2.2281 0.4728 0.000 0.0000 0.6303 1.773
#>  1.5114 0.000 1.3630 0 0.4953 0.6936 0.000 0.6303 0.0000 0.867
#>  1.0001 0.000 0.0000 0 0.0000 0.0000 0.000 1.7727 0.8670 0.000
```

## References

\[1\] [Sophie Godde, Lionel Humbert, Steeve D. Côté, Denis Réale, Hal
Whitehead. Correcting for the impact of gregariousness in social network
analyses. *Animal Behaviour*. Volume 85, Issue 3.
2013.](https://www.sciencedirect.com/science/article/pii/S0003347212005593)
