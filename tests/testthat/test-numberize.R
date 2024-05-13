test_df <- data.frame(
  stringsAsFactors = FALSE,
  num = c(
    100, 400, 1515, 7545, 5670, 91192, 833377, 8333776, 98397717, 3400615618,
    839740543461, 27499856960, 808204960098, 578208177855, 494466250917,
    808204960098, 808204960019
  ),
  fr = c(
    "cent",
    "quatre cents", # edge case when "cent" is plural
    "mille cinq cent quinze",
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
    "cuatrocientos",
    "mil quinientos quince",
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
    "four hundred",
    "one thousand five hundred and fifteen",
    "seven thousand, five hundred and forty-five",
    "five thousand, six hundred and seventy",
    "ninety-one thousand, one hundred and ninety-two",
    "eight hundred and thirty-three thousand, three hundred and seventy-seven",
    "eight million, three hundred and thirty-three thousand,seven hundred and seventy-six",
    "ninety-eight million, three hundred and ninety-seven thousand,seven hundred and seventeen",
    "three billion, four hundred million, six hundred and fifteen thousand,six hundred and eighteen",
    "eight hundred and thirty-nine billion, seven hundred and forty million,five hundred and forty-three thousand, four hundred and sixty-one",
    "twenty-seven billion, four hundred and ninety-nine million,eight hundred and fifty-six thousand, nine hundred and sixty",
    "eight hundred and eight billion, two hundred and four million,nine hundred and sixty thousand and ninety-eight",
    "five hundred and seventy-eight billion, two hundred and eight million,one hundred and seventy-seven thousand, eight hundred and fifty-five",
    "four hundred and ninety-four billion, four hundred and sixty-six million,two hundred and fifty thousand, nine hundred and seventeen",
    "eight hundred and eight billion, two hundred and four million,nine hundred and sixty thousand and ninety-eight",
    "eight hundred and eight billion, two hundred and four million,nine hundred and sixty thousand and nineteen"
  )
)

test_that("translating vector of English numbers works", {
  res <- numberize(test_df[["en"]])
  expect_identical(res, test_df[["num"]])
})

test_that("translating vector of French numbers works", {
  res <- numberize(test_df[["fr"]], lang = "fr")
  expect_identical(res, test_df[["num"]])
})

test_that("translating vector of Spanish numbers works", {
  res <- numberize(test_df[["es"]], lang = "es")
  expect_identical(res, test_df[["num"]])
})

test_that("translating single french text works", {
  res <- numberize("mille cinq cent quinze", lang = "fr")
  expect_identical(res, 1515)
})


test_that("text with non digit word returns NA", {
  res <- numberize("epiverse", lang = "en")
  expect_true(is.na(res))
})

# NB: this vector is coerced into character by R
test_that("vector with number and words and NA is properly handled", {
  res <- numberize(
    c(17, "dix", "soixante-cinq", "deux mille vingt-quatre", NA),
    lang = "fr"
  )
  expect_identical(res, c(17, 10, 65, 2024, NA))
})

test_that("text with leading and trailing whitespace works", {
  res <- numberize("  mille cinq  cent quinze
    ", lang = "fr")
  expect_identical(res, 1515)
})

test_that("text with ambigious number conversion returns NA", {
  res <- numberize("twenty twenty four", lang = "fr")
  expect_true(is.na(res))
})

test_that("NA to return NA", {
  res <- numberize(NA, lang = "fr")
  expect_true(is.na(res))
})

test_that("NaN to return NA", {
  res <- numberize(NaN, lang = "fr")
  expect_true(is.na(res))
})

test_that("TRUE to return NA", {
  res <- numberize(TRUE, lang = "fr")
  expect_true(is.na(res))
})
test_that("FALSE to return NA", {
  res <- numberize(FALSE, lang = "fr")
  expect_true(is.na(res))
})
test_that("NULL to return NA", {
  res <- numberize(NULL, lang = "fr")
  expect_true(is.na(res))
})
test_that("Inf to return NA", {
  res <- numberize(Inf, lang = "fr")
  expect_true(is.na(res))
})
