
<!-- README.md is generated from README.Rmd. Please edit that file. -->
<!-- The code to render this README is stored in .github/workflows/render-readme.yaml -->
<!-- Variables marked with double curly braces will be transformed beforehand: -->
<!-- `packagename` is extracted from the DESCRIPTION file -->
<!-- `gh_repo` is extracted via a special environment variable in GitHub Actions -->

# numberizeR <img src="man/figures/logo.svg" align="right" width="120" />

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/license/mit/)
[![R-CMD-check](https://github.com/bahadzie/numberizeR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/bahadzie/numberizeR/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/bahadzie/numberizeR/branch/main/graph/badge.svg)](https://app.codecov.io/gh/bahadzie/numberizeR?branch=main)
[![lifecycle-experimental](https://www.reconverse.org/images/badge-experimental.svg)](https://www.reconverse.org/lifecycle.html#experimental)
<!-- badges: end -->

*numberizeR* is an R package to convert whole numbers written as words
from zero to nine hundred and ninety nine trillion, nine hundred and
ninety nine billion, nine hundred and ninety nine million, nine hundred
and ninety nine thousand, nine hundred and ninety nine in English,
French and Spanish from a character string to a numeric value.

<!-- This sentence is optional and can be removed -->

numberizeR is developed at the [Centre for the Mathematical Modelling of
Infectious
Diseases](https://www.lshtm.ac.uk/research/centres/centre-mathematical-modelling-infectious-diseases)
at the London School of Hygiene and Tropical Medicine as part of the
[Epiverse-TRACE program](https://data.org/initiatives/epiverse/).

## Installation

You can install the development version of numberizeR from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("bahadzie/numberizeR")
```

## Example

These examples illustrate some of the current functionalities

``` r
devtools::load_all()

formatC(numberize("nine hundred and ninety-nine trillion, nine hundred and ninety-nine billion, nine hundred and ninety-nine million, nine hundred and ninety-nine thousand, nine hundred and ninety-nine"), big.mark = ",", format = "fg")
#> "999,999,999,999,999"
    
numberize("Siete mil quinientos cuarenta y cinco", lang = "es")
#> 7545

numberize("zéro",  lang = "fr")
#> 0
```

## Development

### Lifecycle

This package is currently *experimental*, as defined by the [RECON
software lifecycle](https://www.reconverse.org/lifecycle.html). This
means it is a draft of a functional package, but interfaces and
functionalities may change over time, testing and documentation may be
lacking.

### Contributions

Contributions are welcome via [pull
requests](https://github.com/bahadzie/numberizeR/pulls).

### Code of Conduct

Please note that the numberizeR project is released with a [Contributor
Code of
Conduct](https://github.com/epiverse-trace/.github/blob/main/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.
