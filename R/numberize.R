#' Generate a numeric vector from text in a supported language.
#'
#' @param text Word(s) that spell numbers. e.g. "one", "deux", "trois"
#' @param lang The text's language. Currently one of `"en" | "fr" | "es"`.
#'
#' @return A numeric vector.
#' @keywords internal
digits_from <- function(text, lang = "en") {
  invalid_structure <- function(positions) {
    valid_position <- c(
      "units", "tens", "hundreds", "thousand", "million", "billion", "trillion"
    )
    for (i in seq_along(valid_position)) {
      index <- which(positions %in% valid_position[i])
      is_adjacent <- any(diff(index) == 1)
      if (is_adjacent) {
        return(is_adjacent)
      }
    }
    FALSE
  }

  # data frame that maps numbers to words
  numbers <- data.frame(
    stringsAsFactors = FALSE,
    digit = c(
      0:30, # because es is unique to 30
      seq(40, 70, by = 10),
      71:80,
      90:99,
      seq(100, 900, by = 100), 1000, 1E6, 1E9, 1E12
    ),
    en = c(
      "zero", "one", "two", "three", "four", "five", "six", "seven", "eight",
      "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen",
      "sixteen", "seventeen", "eighteen", "nineteen",
      "twenty", "", "", "", "", "", "", "", "", "",
      "thirty", "forty", "fifty", "sixty",
      "seventy", "", "", "", "", "", "", "", "", "",
      "eighty",
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
      "ochenta",
      "noventa", "", "", "", "", "", "", "", "", "",
      "ciento", "doscientos", "trescientos", "cuatrocientos", "quinientos",
      "seiscientos", "setecientos", "ochocientos", "novecientos",
      "mil", "mill\u00f3n", "mil-millones", "bill\u00f3n"
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
      "quatre-vingt-dix", "quatre-vingt-onze", "quatre-vingt-douze", "quatre-vingt-treize", # nolint
      "quatre-vingt-quatorze", "quatre-vingt-quinze", "quatre-vingt-seize",
      "quatre-vingt-dix-sept", "quatre-vingt-dix-huit", "quatre-vingt-dix-neuf",
      "cent", "", "", "", "", "", "", "", "",
      "mille", "million", "milliard", "billion"
    ),
    position = c(
      rep("units", 10),
      rep("tens", 45),
      rep("hundreds", 9),
      "thousand", "million", "billion", "trillion"
    ),
    positional_digit = c(
      0:9, # units
      rep(1, 10), # tens (10-19)
      rep(2, 10), # tens (20-29)
      3:6, # tens (30-60)
      rep(7, 10), # tens (70-79)
      8, # tens (80)
      rep(9, 10), # tens (90-99)
      1:9, # hundreds (100-900)
      rep(1, 4) # thousand, million, billion, trillion
    )
  )

  original_text <- text # to report warning if necessary
  # clean and prep
  text <- tolower(text) # converts to string as a side effect
  text <- trimws(text)
  text <- gsub("\\sand|-|,|\\bet\\b|\\sy\\s", " ", text) # all lang

  if (lang == "es") {
    text <- gsub("\\bcien\\b", "ciento", text)
    text <- gsub("millones", "mill\u00f3n", text, fixed = TRUE)
    text <- gsub("billones", "bill\u00f3n", text, fixed = TRUE)
    text <- gsub("veinti\u00fan", "veintiuno", text, fixed = TRUE) # edge case
    text <- gsub("\\sun\\s", " uno ", text)
  }
  if (lang == "fr") {
    # plural to singular
    text <- gsub("(cent|mille|million|milliard|billion)s\\b", "\\1", text)
    # handle 70-79
    text <- gsub(
      "soixante (dix|onze|douze|treize|quatorze|quinze|seize)",
      "soixante-\\1", text
    )
    text <- gsub("soixante-dix (sept|huit|neuf)", "soixante-dix-\\1", text)
    # handle 90-99
    text <- gsub(
      "quatre vingt (dix|onze|douze|treize|quatorze|quinze|seize)",
      "quatre-vingt-\\1", text
    )
    text <- gsub("quatre-vingt (sept|huit|neuf)", "quatre-vingt-\\1", text)
  }

  words <- strsplit(text, "\\s+")[[1]]
  positions <- numbers[match(words, numbers[[lang]]), "position"]
  if (invalid_structure(positions)) {
    warning(
      "[", original_text, "] can be interpreted in different ways.\n"
    )
    return(NA)
  }
  numbers[match(words, numbers[[lang]]), "digit"]
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
.numberize <- function(text, lang = c("en", "fr", "es")) {
  text <- toString(text)
  if (
    trimws(text) %in%
      c("NA", "TRUE", "FALSE", "nan", "Inf", "") || # check other R keywords
      length(text) == 0) { # check for NULL
    return(NA)
  }

  # convert to numeric. Numeric values will pass and non numeric values will be
  # coerced to NA and converted into numbers.
  tmp_text <- suppressWarnings(as.numeric(text))
  if (!is.na(tmp_text)) {
    return(tmp_text)
  } else {
    # when the text does not correspond to a number, digits_from() returns NA
    digits <- digits_from(text, lang)
    if (anyNA(digits)) {
      return(NA)
    }
    number_from(digits)
  }
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
  lang <- match.arg(lang)
  if (is.null(text)) {
    return(NA)
  }
  vapply(
    text,
    .numberize,
    FUN.VALUE = double(1),
    lang = lang,
    USE.NAMES = FALSE
  )
}
