test_df <- data.frame(
  stringsAsFactors = FALSE,
  num = c(
    21, 71, 80, 82,
    90, 91,
    100, 400, 1515, 7545, 5670, 91192, 833377, 8333776, 98397717, 3400615618,
    839740543461, 
    27499856960,
    808204960098, 578208177855, 494466250917,
    808204960098, 808204960019
  ),
  fr = c(
    "vingt et un", "soixante et onze", "quatre-vingts", "quatre-vingt-deux",
    "quatre-vingt-dix", "quatre-vingt-onze",
    "cent",
    "quatre cents", # edge case when "cent" is plural
    "mille cinq cent quinze",
    "sept mille cinq cent quarante-cinq",
    "cinq mille six cent soixante-dix",
    "quatre-vingt-onze mille cent quatre-vingt-douze",
    "huit cent trente-trois mille trois cent soixante-dix-sept",
    "huit millions trois cent trente-trois mille sept cent soixante-seize",
    "quatre-vingt-dix-huit millions trois cent quatre-vingt-dix-sept mille sept cent dix-sept",
    "trois milliards quatre cents millions six cent quinze mille six cent dix-huit",
    "huit cent trente-neuf milliards sept cent quarante millions cinq cent quarante-trois mille quatre cent soixante et un",
    "vingt-sept milliards quatre cent quatre-vingt-dix-neuf millions huit cent cinquante-six mille neuf cent soixante",
    "huit cent huit milliards deux cent quatre millions neuf cent soixante mille quatre-vingt-dix-huit",
    "cinq cent soixante-dix-huit milliards deux cent huit millions cent soixante-dix-sept mille huit cent cinquante-cinq",
    "quatre cent quatre-vingt-quatorze milliards quatre cent soixante-six millions deux cent cinquante mille neuf cent dix-sept",
    "huit cent huit milliards deux cent quatre millions neuf cent soixante mille quatre-vingt-dix-huit",
    "huit cent huit milliards deux cent quatre millions neuf cent soixante mille dix-neuf"
  ) #,
  # es = c(
  #   "Cien",
  #   "cuatrocientos",
  #   "mil quinientos quince",
  #   "Siete mil quinientos cuarenta y cinco",
  #   "Cinco mil seiscientos setenta",
  #   "Noventa y un mil ciento noventa y dos",
  #   "ochocientos treinta y tres mil trescientos setenta y siete",
  #   "Ocho millones trescientos treinta y tres mil setecientos setenta y seis",
  #   "Noventa y ocho millones trescientos noventa y siete mil setecientos diecisiete",
  #   "Tres mil cuatrocientos millones seiscientos quince mil seiscientos dieciocho",
  #   "ochocientos treinta y nueve mil setecientos cuarenta millones quinientos cuarenta y tres mil cuatrocientos sesenta y uno",
  #   "Veintisiete mil cuatrocientos noventa y nueve millones ochocientos cincuenta y seis mil novecientos sesenta",
  #   "Ochocientos ocho mil doscientos cuatro millones novecientos sesenta mil noventa y ocho",
  #   "Quinientos setenta y ocho mil doscientos ocho millones ciento setenta y siete mil ochocientos cincuenta y cinco",
  #   "Cuatrocientos noventa y cuatro mil cuatrocientos sesenta y seis millones doscientos cincuenta mil novecientos diecisiete",
  #   "Ochocientos ocho mil doscientos cuatro millones novecientos sesenta mil noventa y ocho",
  #   "Ochocientos ocho mil doscientos cuatro millones novecientos sesenta mil diecinueve"
  # ),
  # en = c(
  #   "one hundred",
  #   "four hundred",
  #   "one thousand five hundred and fifteen",
  #   "seven thousand, five hundred and forty-five",
  #   "five thousand, six hundred and seventy",
  #   "ninety-one thousand, one hundred and ninety-two",
  #   "eight hundred and thirty-three thousand, three hundred and seventy-seven",
  #   "eight million, three hundred and thirty-three thousand,seven hundred and seventy-six",
  #   "ninety-eight million, three hundred and ninety-seven thousand,seven hundred and seventeen",
  #   "three billion, four hundred million, six hundred and fifteen thousand,six hundred and eighteen",
  #   "eight hundred and thirty-nine billion, seven hundred and forty million,five hundred and forty-three thousand, four hundred and sixty-one",
  #   "twenty-seven billion, four hundred and ninety-nine million,eight hundred and fifty-six thousand, nine hundred and sixty",
  #   "eight hundred and eight billion, two hundred and four million,nine hundred and sixty thousand and ninety-eight",
  #   "five hundred and seventy-eight billion, two hundred and eight million,one hundred and seventy-seven thousand, eight hundred and fifty-five",
  #   "four hundred and ninety-four billion, four hundred and sixty-six million,two hundred and fifty thousand, nine hundred and seventeen",
  #   "eight hundred and eight billion, two hundred and four million,nine hundred and sixty thousand and ninety-eight",
  #   "eight hundred and eight billion, two hundred and four million,nine hundred and sixty thousand and nineteen"
  # )
)

test_that("Translating all special french numbers work", {
  to_test <- c(
    0:19,
    seq(20, 90, by = 10),
    seq(20, 60, by = 10) + 1,
    81,
    71:79,
    91:99,
    1E2, 1E3, 1E6, 1E9, 1E12, 1E15, 1E18, 1E21
  )
  to_expect <- c(
  
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
  res <- sapply(to_test, verbalize)
  expect_identical(res, to_expect)
})


test_that("warning for no values", {
  expect_warning(res <- verbalize())
  expect_true(is.na(res))
})

test_that("warning for unknow language", {
  expect_warning(res <- verbalize(lang = "unknown"))
  expect_true(is.na(res))
})

test_that("warning for NA, and return NA", {
  expect_warning(res <- verbalize(NA))
  expect_true(is.na(res))
})

test_that("translating vector of French numbers works", {
  res <- sapply(test_df[["num"]], verbalize)
  expect_identical(res, test_df[["fr"]])
})
