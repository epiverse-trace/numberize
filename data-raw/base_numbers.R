## code to prepare `base_numbers` dataset goes here
base_numbers <- data.frame(
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

usethis::use_data(base_numbers, overwrite = TRUE, internal = TRUE, version = 3)
