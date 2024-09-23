# Maps numbers to words. Used in digits_from().
digit_mappings <- data.frame(
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
    "dieciseis", "diecisiete", "dieciocho", "diecinueve", "veinte",
    "veintiuno", "veintidos", "veintitres", "veinticuatro",
    "veinticinco", "veintiseis", "veintisiete", "veintiocho", "veintinueve", # nolint
    "treinta", "cuarenta", "cincuenta", "sesenta",
    "setenta", "", "", "", "", "", "", "", "", "",
    "ochenta",
    "noventa", "", "", "", "", "", "", "", "", "",
    "ciento", "doscientos", "trescientos", "cuatrocientos", "quinientos",
    "seiscientos", "setecientos", "ochocientos", "novecientos",
    "mil", "millon", "mil-millones", "billon"
  ),
  fr = c(
    "zero", "un", "deux", "trois", "quatre", "cinq", "six", "sept",
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
  next_position <- c(tail(current_position, -1), NA) # move forward by 1
  # returns true if consecutive positions are the same type e.g. unit, unit etc
  uncertain <- any(current_position == next_position, na.rm = TRUE)
  if (uncertain) {
    warning(toString(digits))
  }
  uncertain
}

#' Converts a subset of latin characters with accents to their ascii equivalents
#'
#' @param text Character. A string or vector
#'
#' @return Character. ASCII only.
#' @keywords internal
as_ascii <- function(text) {
  ascii_map <- data.frame(
    # Source: https://en.wikipedia.org/wiki/List_of_Unicode_characters
    stringsAsFactors = FALSE,
    ucode = c( # These appear to be unnecessary here
      # "\u00C0", "\u00C1", "\u00C2", "\u00C3", "\u00C4", "\u00C5", "\u00C7",
      # "\u00C8", "\u00C9", "\u00CA", "\u00CB", "\u00CC", "\u00CD", "\u00CE",
      # "\u00CF", "\u00D1", "\u00D2", "\u00D3", "\u00D4", "\u00D5", "\u00D6",
      # "\u00D8", "\u00D9", "\u00DA", "\u00DB", "\u00DC", "\u00DD",
      "\u00E0", "\u00E1", "\u00E2", "\u00E3", "\u00E4", "\u00E5", "\u00E7",
      "\u00E8", "\u00E9", "\u00EA", "\u00EB", "\u00EC", "\u00ED", "\u00EE",
      "\u00EF", "\u00F1", "\u00F2", "\u00F3", "\u00F4", "\u00F5", "\u00F6",
      "\u00F8", "\u00F9", "\u00FA", "\u00FB", "\u00FC", "\u00FD", "\u00FF"
    ),
    latin = c( # expects lowercase strings
      # "À", "Á", "Â", "Ã", "Ä", "Å", "Ç",
      # "È", "É", "Ê", "Ë", "Ì", "Í", "Î",
      # "Ï", "Ñ", "Ò", "Ó", "Ô", "Õ", "Ö",
      # "Ø", "Ù", "Ú", "Û", "Ü", "Ý",
      "à", "á", "â", "ã", "ä", "å", "ç",
      "è", "é", "ê", "ë", "ì", "í", "î",
      "ï", "ñ", "ò", "ó", "ô", "õ", "ö",
      "ø", "ù", "ú", "û", "ü", "ý", "ÿ"
    ),
    ascii = c( # expects lowercase strings
      # "A", "A", "A", "A", "A", "A", "C",
      # "E", "E", "E", "E", "I", "I", "I",
      # "I", "N", "O", "O", "O", "O", "O",
      # "O", "U", "U", "U", "U", "Y",
      "a", "a", "a", "a", "a", "a", "c",
      "e", "e", "e", "e", "i", "i", "i",
      "i", "n", "o", "o", "o", "o", "o",
      "o", "u", "u", "u", "u", "y", "y"
    )
  )
  word_characters <- strsplit(text, "", fixed = TRUE)
  character_vector <- unlist(word_characters)
  ascii <- ascii_map[match(character_vector, ascii_map[["latin"]]), "ascii"]
  ascii[is.na(ascii)] <- character_vector[is.na(ascii)]
  word_characters <- utils::relist(ascii, word_characters)
  text <- as.character(lapply(word_characters, paste, collapse = ""))
  text
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
    text <- gsub("(millon|billon)es\\b", "\\1", text)
    text <- gsub("veintiun", "veintiuno", text, fixed = TRUE) # edge case
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
  text <- trimws(tolower(text)) # do once instead of repeating in digits_from()
  text <- as_ascii(text)
  # Shortcut if already a numeric (stored as character)
  res <- suppressWarnings(as.numeric(text))
  digits <- digits_from(text[is.na(res)], lang)
  res[is.na(res)] <- vapply(digits, number_from, double(1))

  return(res)
}
