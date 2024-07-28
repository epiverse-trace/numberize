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
    # lang=fr plural-> singular
    text <- gsub("(cent|mille|million|milliard|billion)s\\b", "\\1", text)
    # lang=fr one word
    text <- gsub("quatre vingt", "quatre-vingt", text, fixed = TRUE)
  }

  words <- strsplit(text, "\\s+")

  # It's faster to unlist()/relist() than looping over the list
  digits <- base_numbers[match(unlist(words), base_numbers[[lang]]), "digit"]
  relist(digits, words)
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

  if (anyNA(digits)) {
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
#' Convert a vector string of spelled numbers in a supported language to
#' its numeric equivalent.
#'
#' @param text Vector containing spelled numbers in a supported language.
#' @param lang The text's language. Currently one of `"en" | "fr" | "es"`.
#' Default is "en"
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
  lang <- match.arg(lang)
  
  # Shortcut if already a numeric (stored as character)
  res <- suppressWarnings(as.numeric(text))

  digits <- digits_from(text[is.na(res)], lang)
  res[is.na(res)] <- vapply(digits, number_from, double(1))

  return(res)
}
