#' Convert a numeric value to its spelled-out equivalent in French.
#'
#' @param number A numeric value to convert.
#'
#' @return A character string representing the number in words.
#'
#' @examples
#' # Convert a number to words
#' verbalise(14)
#'
#' @export
verbalise <- function(number) {
  if (!is.numeric(number) || is.na(number)) {
    stop("Input must be a numeric value.")
  }

  number <- as.integer(number)
  if (number < 0 || number > 999999999999) {
    stop("Number out of supported range.")
  }

  digit_mappings <- data.frame(
    stringsAsFactors = FALSE,
    digit = c(
      0:30, # because es is unique to 30
      seq(40, 70, by = 10),
      71:80,
      90:99,
      seq(100, 900, by = 100), 1000, 1E6, 1E9, 1E12
    ),
    fr = c(
      "z\u00e9ro", "un", "deux", "trois", "quatre", "cinq", "six", "sept",
      "huit", "neuf", "dix", "onze", "douze", "treize", "quatorze",
      "quinze", "seize", "dix sept", "dix huit", "dix neuf",
      "vingt", "", "", "", "", "", "", "", "", "",
      "trente", "quarante", "cinquante", "soixante",
      "soixante-dix", "soixante-onze", "soixante-douze", "soixante-treize",
      "soixante-quatorze", "soixante-quinze", "soixante-seize",
      "soixante-dix-sept", "soixante-dix-huit", "soixante-dix-neuf",
      "quatre-vingt",
      "quatre-vingt-dix", "quatre-vingt-onze", "quatre-vingt-douze", "quatre-vingt-treize",
      "quatre-vingt-quatorze", "quatre-vingt-quinze", "quatre-vingt-seize",
      "quatre-vingt-dix-sept", "quatre-vingt-dix-huit", "quatre-vingt-dix-neuf",
      "cent", "", "", "", "", "", "", "", "",
      "mille", "million", "milliard", "billion"
    )
  )

  convert_to_words <- function(n) {
    if (n == 0) return("z\u00e9ro")

    words <- c()
    if (n >= 1E12) {
      words <- c(words, convert_to_words(floor(n / 1E12)), "billion")
      n <- n %% 1E12
    }
    if (n >= 1E9) {
      words <- c(words, convert_to_words(floor(n / 1E9)), "milliard")
      n <- n %% 1E9
    }
    if (n >= 1E6) {
      words <- c(words, convert_to_words(floor(n / 1E6)), "million")
      n <- n %% 1E6
    }
    if (n >= 1000) {
      words <- c(words, convert_to_words(floor(n / 1000)), "mille")
      n <- n %% 1000
    }
    if (n >= 100) {
      words <- c(words, digit_mappings$fr[match(floor(n / 100) * 100, digit_mappings$digit)])
      n <- n %% 100
    }
    if (n > 0) {
      words <- c(words, digit_mappings$fr[match(n, digit_mappings$digit)])
    }

    return(paste(words, collapse = " "))
  }

  return(convert_to_words(number))
}
