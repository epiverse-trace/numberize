# Categorizes functions found in `file` as vectorized or not.
# Vectorized functions are defined as ones that are written entirely
# in C, Fortran etc, or R wrappers around `.Internal()`, `.Call`.
# https://www.noamross.net/archives/2014-04-16-vectorization-in-r-why/
# https://adv-r.hadley.nz/functions.html
ftype <- function(file_or_url = NULL, packages = NULL) {
  stopifnot("File path or url required!" = !is.null(file_or_url))
  contents <- data.table::fread(file_or_url, sep = "\n", header = FALSE)$V1
  # can the next line be |> to the line after? How?
  tmp <- parse(text = contents, keep.source = TRUE) |> getParseData()
  fns <- tmp[tmp["token"] == "SYMBOL_FUNCTION_CALL", "text"] |>
    unique()

  # TODO Include additional packages if library(), require() or pkg:: found
  if (is.null(packages)) packages <- c("base", getOption("defaultPackages"))
  fn <- lapply(packages, function(pkg) ls(paste0("package:", pkg)))
  package <- rep(packages, lengths(fn))
  fn <- unlist(fn)

  . <- type <- vectorized <- NA # for data.table lintr

  data.table::data.table(package, fn)[
    , .(
      package, fn,
      body = sapply(fn, function(fn_name) {
        tryCatch(as.character(body(fn_name))[1], error = function(e) NA)
      }),
      type = unlist(lapply(fn, function(x) {
        tryCatch(typeof(match.fun(x)), error = function(e) typeof(x))
      }))
    )
  ][
    , .(
      package, fn, body, type,
      vectorized = body %in% c(".Call", ".Internal", NA) & type != "character"
    )
  ][list(fn = fns), on = "fn"][
    ,
    .(fn, vectorized, package)
  ][
    order(vectorized, fn)
  ]
}

url <- "https://raw.githubusercontent.com/epiverse-trace/numberize/refs/heads/main/R/numberize.R" # nolint
ftype(url)

# Ways to extend
# ==============
# Vectorize by sending a vector of URLs
# Include static analysis of how many times each function is called
# Add calls to library/require and such to the packages to search for
# Include in CI/CD pipeline

b <- NULL |> data.table::setDT() # create empty DT
