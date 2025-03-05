#' Convert a numeric number in a supported language to its string equivalent.
#'
#' The range of words supported is between \strong{0} and
#' \strong{999999999999999999999999}
#' 
#' Uses `convert_fr_chunk_to_words()` output to generate 3-digits chunks
#'
#' @param number Digital number to write in words.
#' @param lang The text's language. Currently one of `c(fr")`.
#' Default is "fr"
#'
#' @return string
#'
#' @examples
#' # returns "quatre-vingts mille trois cent vingt et un"
#' verbalize(80321, lang = "fr")
#'
#' @export
verbalize <- function(number = NA, lang = "fr") {
  if (!is.numeric(number) || is.na(number)) {
    warning(paste0("Your input was ", deparse(substitute(number)), " but a number is expected"))
    return(NA)
  }
  accepted_languages <- c("fr")
  if (!(lang %in% accepted_languages)) {
    warning(paste0("lang must be in the following known tranlated languages : ", accepted_languages))
    return(NA)
  }
  
  # choose special_digit_mappings and digit_mappings for each specific lang
  assign(substitute("special_digit_mappings"), get(paste0("special_", lang, "_digit_mappings")))
  assign(substitute("digit_mappings"), get(paste0(lang, "_digit_mappings")))
  
  if (lang == "fr"){
    
    if (number < 0 || number > 999999999999999999999999) {
      stop("Number out of supported range. Le nombre demand\u00e9 est trop grand")
    }
    # easy cases : the number is specific to translate
    if (number %in% special_digit_mappings$digit){
      return(special_digit_mappings$translation[match(number, special_digit_mappings$digit)])
    } else {
      # otherwise, loop into chunks of three digits
      chunks <- c("trilliard" = 1E21, "trillion" = 1E18, "billiard" = 1E15, "billion" = 1E12, "milliard" = 1E9, "million" = 1E6, "mille" = 1E3)
      words <- c()
      
      while (number > 1E3) {
        for (chunk in names(chunks)) {
          value <- number %/% chunks[[chunk]]
          if (value > 0) {
            if (value == 1) {
              if (chunks[[chunk]] == 1E3) {
                chunk_words <- chunk # 1000 is not written "1 1000" but just "1000" in french
              } else {
                chunk_words <- convert_fr_chunk_to_words(value, lang)
                chunk_words <- paste0(chunk_words, " ", chunk)
              }
            } else {
              chunk_words <- convert_fr_chunk_to_words(value, lang)
              if (chunks[[chunk]] == 1E3) { # "1000" never ends with an "s" in french
                chunk_words <- paste0(chunk_words, " ", chunk)
              } else {
                chunk_words <- paste0(chunk_words, " ", chunk, "s")
              }
            }
            words <- c(words, chunk_words)
          }
          number <- number %% chunks[[chunk]]
        }
      }
      # if smaller than 1000, just use the 100s conversion
      words <- c(words, convert_fr_chunk_to_words(number, lang))
      # print(words)
      return(paste(words, collapse = " "))
    }
  }
}

# maps special French numbers from digits to spelled
special_fr_digit_mappings <- data.frame(
  stringsAsFactors = FALSE,
  digit = c(
    0:19,
    seq(20, 90, by = 10),
    seq(20, 60, by = 10) + 1,
    81,
    71:79,
    91:99,
    1E2, 1E3, 1E6, 1E9, 1E12, 1E15, 1E18, 1E21
  ),
  translation = c(
    # 0-19
    "z\u00e9ro", "un", "deux", "trois", "quatre", "cinq", "six", "sept",
    "huit", "neuf", "dix", "onze", "douze", "treize", "quatorze", "quinze",
    "seize", "dix-sept", "dix-huit", "dix-neuf",
    # seq(20, 90, by = 10)
    "vingt", "trente", "quarante", "cinquante", "soixante", "soixante-dix",
    "quatre-vingts", "quatre-vingt-dix",
    # seq(20, 60, by = 10) + 1 and 81
    "vingt et un", "trente et un", "quarante et un", "cinquante et un",
    "soixante et un", "quatre-vingt-un",
    # 71:79
    "soixante et onze", "soixante-douze", "soixante-treize",
    "soixante-quatorze", "soixante-quinze", "soixante-seize",
    "soixante-dix-sept", "soixante-dix-huit", "soixante-dix-neuf",
    # 91-99
    "quatre-vingt-onze", "quatre-vingt-douze", "quatre-vingt-treize",
    "quatre-vingt-quatorze", "quatre-vingt-quinze", "quatre-vingt-seize",
    "quatre-vingt-dix-sept", "quatre-vingt-dix-huit", "quatre-vingt-dix-neuf",
    # 1E2, 1E3, 1E6, 1E9, 1E12, 1E15, 1E18, 1E21
    "cent", "mille", "un million", "un milliard", "un billion",
    "un billiard", "un trillion", "un trilliard"
  )
)

# Maps French numbers from digits to spelled that can be used to "count" 
# other numbers. For exemple note that "quatre-vingts" cannot be used to 
# count 80 000
fr_digit_mappings <- data.frame(
  stringsAsFactors = FALSE,
  digit = c(
    1:19,
    seq(20, 90, by = 10),
    1E2, 1E3, 1E6, 1E9, 1E12, 1E15, 1E18, 1E21
  ),
  translation = c(
    # 1:19
    "un", "deux", "trois", "quatre", "cinq", "six", "sept",
    "huit", "neuf", "dix", "onze", "douze", "treize", "quatorze", "quinze",
    "seize", "dix-sept", "dix-huit", "dix-neuf",
    # seq(20, 90, by = 10)
    "vingt", "trente", "quarante", "cinquante", "soixante", "soixante-dix",
    "quatre-vingt", "quatre-vingt-dix",
    # 1E2, 1E3, 1E6, 1E9, 1E12, 1E15, 1E18, 1E21
    "cent", "mille", "million", "milliard", "billion",
    "billiard", "trillion", "trilliard"
  )
)


#' Converts 3 digits chunks in French. Indeed, in French, every 3 digits of a
#' number is a chunk, and use the same rule to count thousands, millions, 
#' billions, ...
#'
#' @param number A digitally written numeric.
#' @param lang The language to write the number in
#'
#' @return A String value.
#'
#' @keywords internal
convert_fr_chunk_to_words <- function(number = NA, lang = "fr") {
  # choose special digit mappings and digit mappings for different lang
  assign(substitute("special_digit_mappings"), get(paste0("special_", lang, "_digit_mappings")))
  assign(substitute("digit_mappings"), get(paste0(lang, "_digit_mappings")))
  
  # print(paste0("Doing number ", number, " in ", lang))
  words <- c()
  # easy cases : the number is special and does not apply to regular lang rules
  # if (number %in% special_digit_mappings[,1]){
  #   words <- c(words, special_digit_mappings$translation[match(number, special_digit_mappings$digit)])
  # } else { # The number applies to regular lang rules
    if (number >= 100) { # manage the chunk's hundreds
      hundreds <- number %/% 100
      tens_and_units <- number %% 100
      if (tens_and_units == 0) { # if number is a multiple of 100, it takes an "s"
        words <- c(words, digit_mappings$translation[match(hundreds, digit_mappings$digit)], paste0(digit_mappings$translation[match(100, digit_mappings$digit)], "s"))
      } else {
        if (hundreds > 1){
          words <- c(words, digit_mappings$translation[match(hundreds, digit_mappings$digit)])
        }
        words <- c(words, paste0(digit_mappings$translation[match(100, digit_mappings$digit)]))
        }
      number <- number %% 100
    }
    if (number > 0) { # manage the chunk's tens
      separator <- "-"
      tens <- number %/% 10
      units <- number %% 10
      if (number %in% special_digit_mappings[,1]){ # easy cases : the number is special and does not apply to regular lang rules
        words <- c(words, special_digit_mappings$translation[match(number, special_digit_mappings$digit)])
      } else { # The number applies to regular lang rules
        words <- c(words, paste0(digit_mappings$translation[match(tens * 10, digit_mappings$digit)], separator, digit_mappings$translation[match(units, digit_mappings$digit)]))
      }
    }
    return(paste(words, collapse = " "))
}

