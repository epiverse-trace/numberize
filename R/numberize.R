test_df <- data.frame(
  stringsAsFactors = FALSE,
  num = c(
    100, 7545, 5670, 91192, 833377, 8333776, 98397717, 3400615618,
    839740543461, 27499856960, 808204960098, 578208177855, 494466250917,
    808204960098, 808204960019
  ),
  fr = c(
    "cent",
    "sept mille cinq cent quarante-cinq",
    "Cinq mille six cent soixante-dix",
    "Quatre-vingt-onze mille cent quatre-vingt-douze",
    "Huit cent trente-trois mille trois cent soixante-dix-sept",
    "Huit millions trois cent trente-trois mille sept cent soixante-seize",
    "Quatre-vingt-dix-huit millions trois cent quatre-vingt-dix-sept mille sept cent dix-sept",
    "Trois milliards quatre cent millions six cent quinze mille six cent dix-huit",
    "Huit cent trente-neuf milliards sept cent quarante millions cinq cent quarante-trois mille quatre cent soixante-et-un",
    "Vingt-sept milliards quatre cent quatre-vingt-dix-neuf millions huit cent cinquante-six mille neuf cent soixante",
    "Huit cent huit milliards deux cent quatre millions neuf cent soixante mille quatre-vingt-dix-huit",
    "Cinq cent soixante-dix-huit milliards deux cent huit millions cent soixante-dix-sept mille huit cent cinquante-cinq",
    "Quatre cent quatre-vingt-quatorze milliards quatre cent soixante-six millions deux cent cinquante mille neuf cent dix-sept",
    "Huit cent huit milliards deux cent quatre millions neuf cent soixante mille quatre-vingt-dix-huit",
    "Huit cent huit milliards deux cent quatre millions neuf cent soixante mille dix-neuf"
  ),
  es = c(
    "Cien",
    "Siete mil quinientos cuarenta y cinco",
    "Cinco mil seiscientos setenta",
    "Noventa y un mil ciento noventa y dos",
    "ochocientos treinta y tres mil trescientos setenta y siete",
    "Ocho millones trescientos treinta y tres mil setecientos setenta y seis",
    "Noventa y ocho millones trescientos noventa y siete mil setecientos diecisiete",
    "Tres mil cuatrocientos millones seiscientos quince mil seiscientos dieciocho",
    "ochocientos treinta y nueve mil setecientos cuarenta millones quinientos cuarenta y tres mil cuatrocientos sesenta y uno",
    "Veintisiete mil cuatrocientos noventa y nueve millones ochocientos cincuenta y seis mil novecientos sesenta",
    "Ochocientos ocho mil doscientos cuatro millones novecientos sesenta mil noventa y ocho",
    "Quinientos setenta y ocho mil doscientos ocho millones ciento setenta y siete mil ochocientos cincuenta y cinco",
    "Cuatrocientos noventa y cuatro mil cuatrocientos sesenta y seis millones doscientos cincuenta mil novecientos diecisiete",
    "Ochocientos ocho mil doscientos cuatro millones novecientos sesenta mil noventa y ocho",
    "Ochocientos ocho mil doscientos cuatro millones novecientos sesenta mil diecinueve"
  ),
  en = c(
    "one hundred",
    "seven thousand, five hundred and forty-five",
    "five thousand, six hundred and seventy",
    "ninety-one thousand, one hundred and ninety-two",
    "eight hundred and thirty-three thousand, three hundred and seventy-seven",
    "eight million, three hundred and thirty-three thousand, seven hundred and seventy-six",
    "ninety-eight million, three hundred and ninety-seven thousand, seven hundred and seventeen",
    "three billion, four hundred million, six hundred and fifteen thousand, six hundred and eighteen",
    "eight hundred and thirty-nine billion, seven hundred and forty million, five hundred and forty-three thousand, four hundred and sixty-one",
    "twenty-seven billion, four hundred and ninety-nine million, eight hundred and fifty-six thousand, nine hundred and sixty",
    "eight hundred and eight billion, two hundred and four million, nine hundred and sixty thousand and ninety-eight",
    "five hundred and seventy-eight billion, two hundred and eight million, one hundred and seventy-seven thousand, eight hundred and fifty-five",
    "four hundred and ninety-four billion, four hundred and sixty-six million, two hundred and fifty thousand, nine hundred and seventeen",
    "eight hundred and eight billion, two hundred and four million, nine hundred and sixty thousand and ninety-eight",
    "eight hundred and eight billion, two hundred and four million, nine hundred and sixty thousand and nineteen"
  )
)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Generate digits from text with spelt numbers in a supported language.
#'
#' @param text word(s) that spell numbers
#' @param lang the language of the numbers currently en|fr|es
#'
#'
#' @examples
#' \dontrun{
#' digits_from("five hundred and thirty eight")
#' }
#'
#' @return numeric vector
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
digits_from <- function(text, lang = "en") {
  # data frame that maps numbers to words
  numbers <- data.frame(
    stringsAsFactors = FALSE,
    digit = c(
      1:30, # because es is unique to 30
      seq(40, 90, by = 10),
      seq(100, 900, by = 100), 1000, 1E6, 1E9, 1E12
    ),
    en = c(
      "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
      "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen",
      "seventeen", "eighteen", "nineteen",
      "twenty", "", "", "", "", "", "", "", "", "",
      "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety",
      "hundred", "", "", "", "", "", "", "", "",
      "thousand", "million", "billion", "trillion"
    ),
    es = c(
      "uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho",
      "nueve", "diez", "once", "doce", "trece", "catorce", "quince",
      "dieciséis", "diecisiete", "dieciocho", "diecinueve", "veinte",
      "veintiuno", "veintidós", "veintitrés", "veinticuatro", "veinticinco",
      "veintiséis", "veintisiete", "veintiocho", "veintinueve",
      "treinta", "cuarenta", "cincuenta", "sesenta",
      "setenta", "ochenta", "noventa",
      "ciento", "doscientos", "trescientos", "cuatrocientos", "quinientos",
      "seiscientos", "setecientos", "ochocientos", "novecientos",
      "mil", "millón", "mil-millones", "billón"
    ),
    fr = c(
      "un", "deux", "trois", "quatre", "cinq", "six", "sept",
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
    text <- gsub("millones", "millón", text)
    text <- gsub("\\sun\\s", " uno ", text)
  }
  if (lang == "fr") {
    text <- gsub("(\\w+ill\\w+)s\\b", "\\1", text) # lang=fr plural->singular
    text <- gsub("quatre vingt", "quatre-vingt", text) # lang=fr one word
  }

  text <- gsub("\\s{2,}", " ", text) # collapse spaces
  words <- strsplit(text, " ")[[1]]
  mapping <- numbers[numbers[[lang]] %in% words, c("digit", lang)]
  row.names(mapping) <- mapping[[lang]] # to easily subset next line
  digits <- mapping[words, ]$digit
  digits
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Generate number from a numeric vector.
#' This is the output of the digits_from()
#'
#' @param digits a numeric vector translated from words
#'
#'
#' @examples
#' \dontrun{
#' number_from(c(500, 40, 5))
#' }
#'
#' @return numeric vector
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
number_from <- function(digits) {
  # match can return NA so make a vector ending 0 and get the first non NA
  thousand_index <- c(match(1000, digits), 0)
  million_index <- c(match(1E6, digits), 0)
  thousand_index <- thousand_index[!is.na(thousand_index)][1]
  million_index <- million_index[!is.na(million_index)][1]

  # for lang = "es" multiply 1000 * 1E6 for billion
  if (thousand_index < million_index) { # es thousand million = billion
    digits[thousand_index] <- digits[thousand_index] * digits[million_index]
  }

  summed <- 0
  total <- 0
  for (i in seq_along(digits)) {
    if (digits[i] %in% c(1E3, 1E6, 1E9, 1E12)) {
      total <- total + summed * digits[i]
      summed <- 0
    } else if (digits[i] %in% c(100)) {
      if (summed == 0) summed <- 1 # needed for standalone cent/100 (fr)
      summed <- summed * digits[i]
    } else {
      summed <- summed + digits[i]
    }
  }
  summed + total
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert a text string of spelt numbers to its numeric equivalent.
#'
#' @param text string containing spelt numbers in a supported language.
#' @param lang the language of the spelt numbers. Currently en|fr|es.
#'
#' @return numeric value
#'
#' @examples
#' \dontrun{
#' numberize("five hundred and thirty eight")
#' }
#'
#' @return numeric vector
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
numberize <- function(text, lang = "en") {
  number_from(digits_from(text, lang))
}

# res <- sapply(test_df$fr, numberize, lang = "fr")
# res <- setNames(res, NULL)
# sum(res == test_df$num) / length(test_df$num)

# number_from(test_df$es[8], lang = "es")

# devtools::load_all()
# rlang::last_trace(drop = FALSE)
