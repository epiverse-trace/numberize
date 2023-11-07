# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Generate a numeric vector from text in a supported language.
#'
#' @param text Word(s) that spell numbers. e.g. "one", "deux", "trois"
#' @param lang The text's language. Currently one of `"en" | "fr" | "es"`.
#'
#'
#' @examples
#' \dontrun{
#' digits_from("five hundred and thirty eight")
#' # [1]   5 100  30   8
#' }
#'
#' @return A numeric vector.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
digits_from <- function(text, lang = "en") {
  # data frame that maps numbers to words
  numbers <- data.frame(
    stringsAsFactors = FALSE,
    digit = c(
      0:30, # because es is unique to 30
      seq(40, 90, by = 10),
      seq(100, 900, by = 100), 1000, 1E6, 1E9, 1E12
    ),
    en = c(
      "zero", "one", "two", "three", "four", "five", "six", "seven", "eight",
      "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen",
      "sixteen", "seventeen", "eighteen", "nineteen",
      "twenty", "", "", "", "", "", "", "", "", "",
      "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety",
      "hundred", "", "", "", "", "", "", "", "",
      "thousand", "million", "billion", "trillion"
    ),
    es = c(
      "cero", "uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho",
      "nueve", "diez", "once", "doce", "trece", "catorce", "quince",
      "diecis\u00e9is", "diecisiete", "dieciocho", "diecinueve", "veinte", # nolint: nonportable_path_linter, line_length_linter.
      "veintiuno", "veintid\u00f3s", "veintitr\u00e9s", "veinticuatro", # nolint: nonportable_path_linter, line_length_linter.
      "veinticinco", "veintis\u00e9is", "veintisiete", "veintiocho", # nolint: nonportable_path_linter, line_length_linter.
      "veintinueve", "treinta", "cuarenta", "cincuenta", "sesenta",
      "setenta", "ochenta", "noventa",
      "ciento", "doscientos", "trescientos", "cuatrocientos", "quinientos",
      "seiscientos", "setecientos", "ochocientos", "novecientos",
      "mil", "mill\u00f3n", "mil-millones", "bill\u00f3n"
    ),
    fr = c(
      "z\u00e9ro", "un", "deux", "trois", "quatre", "cinq", "six", "sept",
      "huit", "neuf", "dix", "onze", "douze", "treize", "quatorze",
      "quinze", "seize", "dix sept", "dix huit", "dix neuf",
      "vingt", "", "", "", "", "", "", "", "", "",
      "trente", "quarante", "cinquante",
      "soixante", "soixante dix", "quatre-vingt", "quatre-vingt dix",
      "cent", "", "", "", "", "", "", "", "",
      "mille", "million", "milliard", "billion"
    )
  )

  # clean and prep
  text <- tolower(text)
  text <- gsub("\\sand|-|,|\\bet\\b|\\sy\\s", " ", text) # all lang
  if (lang == "es") {
    text <- gsub("\\bcien\\b", "ciento", text)
    text <- gsub("millones", "mill\u00f3n", text, fixed = TRUE)
    text <- gsub("billones", "bill\u00f3n", text, fixed = TRUE)
    text <- gsub("veinti\u00fan", "veintiuno", text, fixed = TRUE) # edge case
    text <- gsub("\\sun\\s", " uno ", text)
  }
  if (lang == "fr") {
    text <- gsub("(cent|mille|million|milliard|billion)s\\b", "\\1", text) # lang=fr plural->singular # nolint: nonportable_path_linter, line_length_linter.
    text <- gsub("quatre vingt", "quatre-vingt", text, fixed = TRUE) # lang=fr one word # nolint: line_length_linter.
  }

  words <- strsplit(text, "\\s+")[[1]]
  digits <- numbers[match(words, numbers[[lang]]), "digit"]
  digits
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Generate a number from a numeric vector.
#' Uses `digits_from()` output to generate the numeric value of the text.
#'
#' @param digits A numeric vector translated from words.
#'
#'
#' @examples
#' \dontrun{
#' number_from(c(5, 100, 30, 8))
#' # [1] 538
#' }
#'
#' @return A numeric value.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
number_from <- function(digits) {
  thousand_index <- match(1000, digits, nomatch = 0)
  million_index <- match(1E6, digits, nomatch = 0)

  # for lang = "es" multiply 1000 * 1E6 for billion
  if (thousand_index < million_index) { # es thousand million = billion
    digits[thousand_index] <- digits[thousand_index] * digits[million_index]
  }

  summed <- 0
  total <- 0
  for (d in digits) {
    if (d %in% c(1E3, 1E6, 1E9, 1E12)) {
      total <- total + summed * d
      summed <- 0
    } else if (d == 100) {
      if (summed == 0) summed <- 1 # needed for standalone cent/100 (fr)
      summed <- summed * d
    } else {
      summed <- summed + d
    }
  }
  summed + total
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert a string of spelt numbers in a supported language to its numeric
#' equivalent.
#'
#' @param text String containing spelt numbers in a supported language.
#' @param lang The text's language. Currently one of `"en" | "fr" | "es"`.
#'
#' @return A numeric value.
#'
#' @examples
#' numberize("five hundred and thirty eight")
#'
#' @return A numeric value.
#'
#' @export
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
numberize <- function(text, lang = c("en", "fr", "es")) {
  lang <- match.arg(lang)
  number_from(digits_from(text, lang))
}
