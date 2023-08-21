
<!-- README.md is generated from README.Rmd. Please edit that file. -->

<!-- The code to render this README is stored in .github/workflows/render-readme.yaml -->

<!-- Variables marked with double curly braces will be transformed beforehand: -->

<!-- `packagename` is extracted from the DESCRIPTION file -->

<!-- `gh_repo` is extracted via a special environment variable in GitHub Actions -->

# *{{ packagename }}* <img src="man/figures/logo.svg" align="right" width="120" />

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/license/mit/)
[![R-CMD-check](https://github.com/%7B%7B%20gh_repo%20%7D%7D/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/%7B%7B%20gh_repo%20%7D%7D/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/%7B%7B%20gh_repo%20%7D%7D/branch/main/graph/badge.svg)](https://app.codecov.io/gh/%7B%7B%20gh_repo%20%7D%7D?branch=main)
[![lifecycle-experimental](https://www.reconverse.org/images/badge-experimental.svg)](https://www.reconverse.org/lifecycle.html#experimental)
<!-- badges: end -->

*{{ packagename }}* is an R package to convert numbers written as words
from zero to nine hundred and ninety nine trillion, nine hundred and
ninety nine billion, nine hundred and ninety nine million, nine hundred
and ninety nine thousand, nine hundred and ninety nine in English,
French and Spanish from a character string to a numeric value.

<!-- This sentence is optional and can be removed -->

*{{ packagename }}* is developed at the [Centre for the Mathematical
Modelling of Infectious
Diseases](https://www.lshtm.ac.uk/research/centres/centre-mathematical-modelling-infectious-diseases)
at the London School of Hygiene and Tropical Medicine as part of the
[Epiverse-TRACE program](https://data.org/initiatives/epiverse/).

## Installation

You can install the development version of *{{ packagename }}* from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("{{ gh_repo }}")
```

## Example

These examples illustrate the current functionality.

``` r
# pak::pak("devtools")
devtools::load_all()

numberize("zéro",  lang = "fr")
#> 0
    
numberize("Siete mil quinientos cuarenta y cinco", lang = "es")
#> 7545

formatC(numberize("nine hundred and ninety-nine trillion, nine hundred and ninety-nine billion, nine hundred and ninety-nine million, nine hundred and ninety-nine thousand, nine hundred and ninety-nine"), big.mark = ",", format = "fg")
#> "999,999,999,999,999"
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
requests](https://github.com/%7B%7B%20gh_repo%20%7D%7D/pulls).

### Code of Conduct

Please note that the *{{ packagename }}* project is released with a
[Contributor Code of
Conduct](https://github.com/epiverse-trace/.github/blob/main/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.
