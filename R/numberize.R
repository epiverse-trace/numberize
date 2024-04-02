# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Generate a numeric vector from text in a supported language.
#'
#' @param text Word(s) that spell numbers. e.g. "one", "deux", "trois"
#' @param lang The text's language. Currently one of `"en" | "fr" | "es"`.
#'
#' @return A numeric vector.
#' @keywords internal
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
      "diecis\u00e9is", "diecisiete", "dieciocho", "diecinueve", "veinte",
      "veintiuno", "veintid\u00f3s", "veintitr\u00e9s", "veinticuatro",
      "veinticinco", "veintis\u00e9is", "veintisiete", "veintiocho",
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

  # TODO check the words are in the selected lang or return NA
  if (lang == "es") {
    text <- gsub("\\bcien\\b", "ciento", text)
    text <- gsub("millones", "mill\u00f3n", text, fixed = TRUE)
    text <- gsub("billones", "bill\u00f3n", text, fixed = TRUE)
    text <- gsub("veinti\u00fan", "veintiuno", text, fixed = TRUE) # edge case
    text <- gsub("\\sun\\s", " uno ", text)
  }
  if (lang == "fr") {
    # lang=fr plural-> singular
    text <- gsub("(cent|mille|million|milliard|billion)s\\b", "\\1", text)
    # lang=fr one word
    text <- gsub("quatre vingt", "quatre-vingt", text, fixed = TRUE)
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
#' @return A numeric value.
#' 
#' @keywords internal
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
      total <- ifelse(summed == 0, total + d, total + summed * d)
      summed <- 0
    } else if (d == 100) {
      summed <- ifelse(summed == 0, d, summed * d)
    } else {
      summed <- summed + d
    }
  }
  summed + total
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Internal function used in the numberize() call for vectors.
#'
#' @param text Character string in a supported language.
#' @param lang Language of the character string.
#' Currently one of `"en" | "fr" | "es"`.
#'
#' @return A numeric value.
#' 
#' @keywords internal
#'
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.numberize <- function(text, lang = c("en", "fr", "es")) {
  lang <- match.arg(lang)
  digits <- digits_from(text, lang)
  if (anyNA(digits)) {
    return(NA)
  }
  number_from(digits)
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert a vector string of spelled numbers in a supported language to
#' its numeric equivalent.
#'
#' @param text Vector containing spelled numbers in a supported language.
#' @param lang The text's language. Currently one of `"en" | "fr" | "es"`.
#'
#' @return A vector of numeric values.
#'
#' @examples
#' # convert to numbers a scalar
#' numberize("five hundred and thirty eight")
#' 
#' # convert a vector of values
#' numberize(c("dix", "soixante-cinq", "deux mille vingt-quatre"), lang = "fr")
#'
#' @export
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
numberize <- function(text, lang = c("en", "fr", "es")) {
  vapply(text, .numberize, FUN.VALUE = double(1), lang = lang)
}
