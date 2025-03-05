# Maps numbers to words. Used in digits_from().
digit_mappings <- data.frame(
  stringsAsFactors = FALSE,
  digit = c(
    0:30, # because es is unique to 30
    seq(40, 70, by = 10),
    71:99,
    seq(100, 900, by = 100), 1000, 1E6, 1E9, 1E12
  ),
  en = c(
    "zero", "one", "two", "three", "four", "five", "six", "seven", "eight",
    "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen",
    "sixteen", "seventeen", "eighteen", "nineteen",
    "twenty", "", "", "", "", "", "", "", "", "",
    "thirty", "forty", "fifty", "sixty",
    "seventy", "", "", "", "", "", "", "", "", "",
    "eighty", "", "", "", "", "", "", "", "", "",
    "ninety", "", "", "", "", "", "", "", "", "",
    "hundred", "", "", "", "", "", "", "", "",
    "thousand", "million", "billion", "trillion"
  ),
  es = c(
    "cero", "uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho",
    "nueve", "diez", "once", "doce", "trece", "catorce", "quince",
    "diecis\u00e9is", "diecisiete", "dieciocho", "diecinueve", "veinte",
    "veintiuno", "veintid\u00f3s", "veintitr\u00e9s", "veinticuatro",
    "veinticinco", "veintis\u00e9is", "veintisiete", "veintiocho", "veintinueve", # nolint
    "treinta", "cuarenta", "cincuenta", "sesenta",
    "setenta", "", "", "", "", "", "", "", "", "",
    "ochenta", "", "", "", "", "", "", "", "", "",
    "noventa", "", "", "", "", "", "", "", "", "",
    "ciento", "doscientos", "trescientos", "cuatrocientos", "quinientos",
    "seiscientos", "setecientos", "ochocientos", "novecientos",
    "mil", "mill\u00f3n", "mil-millones", "bill\u00f3n"
  ),
  fr = c(
    "z\u00e9ro", "un", "deux", "trois", "quatre",
    "cinq", "six", "sept", "huit", "neuf",
    "dix", "onze", "douze", "treize", "quatorze",
    "quinze", "seize", "dix sept", "dix huit", "dix neuf",
    "vingt", "", "", "", "", "", "", "", "", "",
    "trente", "quarante", "cinquante", "soixante",
    "soixante-dix", "soixante-onze", "soixante-douze", "soixante-treize",
    "soixante-quatorze", "soixante-quinze", "soixante-seize",
    "soixante-dix-sept", "soixante-dix-huit", "soixante-dix-neuf",
    "quatre-vingt", "quatre-vingt-un", "quatre-vingt-deux",
    "quatre-vingt-trois", "quatre-vingt-quatre", "quatre-vingt-cinq",
    "quatre-vingt-six", "quatre-vingt-sept", "quatre-vingt-huit",
    "quatre-vingt-neuf", "quatre-vingt-dix", "quatre-vingt-onze",
    "quatre-vingt-douze", "quatre-vingt-treize", "quatre-vingt-quatorze",
    "quatre-vingt-quinze", "quatre-vingt-seize", "quatre-vingt-dix-sept",
    "quatre-vingt-dix-huit", "quatre-vingt-dix-neuf",
    "cent", "", "", "", "", "", "", "", "",
    "mille", "million", "milliard", "billion"
  ),
  position = c(
    rep("units", 10),
    rep("tens", 54),
    rep("hundreds", 9),
    "thousand", "million", "billion", "trillion"
  )
)

#' Test if a given numeric vector can have different meanings.
#'
#' @param digits A numeric vector.
#'
#' @return Logical. True if the number vector has multiple interpretations.
#' @keywords internal
ambiguous <- function(digits) {
  current_position <- digit_mappings[
    match(digits, digit_mappings[["digit"]]), "position"
  ]
  next_position <- c(current_position[-1], NA) # move forward by 1

  # returns true if consecutive positions are the same type e.g. unit, unit etc
  uncertain <- any(current_position == next_position, na.rm = TRUE)
  if (uncertain) {
    warning(toString(digits))
  }
  uncertain
}

#' Generate a numeric vector from text in a supported language.
#'
#' @param text Word(s) that spell numbers. e.g. "one", "deux", "trois"
#' @param lang The text's language. Currently one of `"en" | "fr" | "es"`.
#'
#' @return A numeric vector.
#' @keywords internal
digits_from <- function(text, lang = "en") {
  text <- gsub("\\sand|-|,|\\bet\\b|\\sy\\s", " ", text) # replace and, et, y

  if (lang == "es") {
    text <- gsub("\\bcien\\b", "ciento", text)
    text <- gsub("millones", "mill\u00f3n", text, fixed = TRUE)
    text <- gsub("billones", "bill\u00f3n", text, fixed = TRUE)
    text <- gsub("veinti\u00fan", "veintiuno", text, fixed = TRUE) # edge case
    text <- gsub("\\sun\\s", " uno ", text)
  }
  if (lang == "fr") {
    # plural to singular
    text <- gsub("(vingt|cent|mille|million|milliard|billion)s\\b", "\\1", text)
    # handle 70-79
    text <- gsub(
      "soixante\\s+(dix|onze|douze|treize|quatorze|quinze|seize)",
      "soixante-\\1", text
    )
    text <- gsub("soixante-dix (sept|huit|neuf)", "soixante-dix-\\1", text)
    text <- gsub("quatre\\s+vingt", "quatre-vingt", text) # as in digit_mappings

    # handle 87-96
    text <- gsub(
      "quatre-vingt\\s+(un|une|deux|trois|quatre|cinq|six|sept|huit|neuf|dix|onze|douze|treize|quatorze|quinze|seize)",
      "quatre-vingt-\\1", text
    )
  }

  words <- strsplit(text, "\\s+")

  # It's faster to unlist()/relist() than looping over the list
  digits <- digit_mappings[
    match(unlist(words), digit_mappings[[lang]]), "digit"
  ]
  utils::relist(digits, words)
}

#' Generate a number from a numeric vector.
#' Uses `digits_from()` output to generate the numeric value of the text.
#'
#' @param digits A numeric vector translated from words.
#'
#' @return A numeric value.
#'
#' @keywords internal
number_from <- function(digits) {
  if (anyNA(digits)) {
    return(NA)
  }

  if (ambiguous(digits)) {
    return(NA)
  }

  thousand_index <- match(1000, digits, nomatch = 0)
  million_index <- match(1E6, digits, nomatch = 0)

  # for lang = "es" multiply 1000 * 1E6 for billion
  if (thousand_index < million_index) { # es thousand million = billion
    digits[thousand_index] <- digits[thousand_index] * digits[million_index]
  }

  summed <- 0
  total <- 0
  for (d in digits) {
    if (d == 100) {
      summed <- d + d * (summed - 1) * (summed != 0)
    } else if (d %in% c(1E3, 1E6, 1E9, 1E12)) {
      total <- total + d + d * (summed - 1) * (summed != 0)
      summed <- 0
    } else {
      summed <- summed + d
    }
  }
  summed + total
}

#' Convert a vector string of spelled numbers in a supported language to
#' its numeric equivalent.
#'
#' The range of words supported is between \strong{zero} and
#' \strong{nine hundred and ninety nine trillion, nine hundred and}
#' \strong{ninety nine billion, nine hundred and ninety nine million, nine}
#' \strong{hundred and ninety nine thousand, nine hundred and ninety nine}
#'
#' @param text String vector of spelled numbers in a supported language.
#' @param lang The text's language. Currently one of `c("en", "fr", "es")`.
#' Default is "en"
#'
#' @return A numeric vector.
#'
#' @examples
#' # convert to numbers a scalar
#' numberize("five hundred and thirty eight")
#'
#' # convert a vector of values
#' numberize(c("dix", "soixante-cinq", "deux mille vingt-quatre"), lang = "fr")
#'
#' @export
numberize <- function(text, lang = c("en", "fr", "es")) {
  lang <- tolower(lang)
  lang <- match.arg(lang) # match.arg(tolower(lang)) doesn't work

  text[is.infinite(text)] <- NA # handle INF
  if (length(text) == 0) { # handle NULL
    return(NA)
  }
  text <- trimws(tolower(text))
  not_empty_or_na <- !(text == "" | is.na(text))
  # Shortcut if already a numeric (stored as character)
  res <- suppressWarnings(as.numeric(text))
  digits <- digits_from(text[is.na(res) & not_empty_or_na], lang)
  res[is.na(res) & not_empty_or_na] <- vapply(digits, number_from, double(1))
  return(res)
}
