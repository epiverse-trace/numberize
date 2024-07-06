pak::pak("epiverse-trace/etdev")
library(devtools)
devtools::load_all()
devtools::check()
devtools::test()
devtools::submit_cran()
a <- numberize("twenty twenty four")
res <- numberize("  mille cinq  cent quinze    ", lang = "en")

# Thanks,

# If there are references describing the methods in your package, please
# add these in the description field of your DESCRIPTION file in the form
# authors (year) <doi:...>
# authors (year, ISBN:...)
# or if those are not available: <https:...>
# with no space after 'doi:', 'https:' and angle brackets for
# auto-linking. (If you want to add a title as well please put it in
# quotes: "Title")

# You write information messages to the console that cannot be easily
# suppressed.
# It is more R like to generate objects that can be used to extract the
# information a user is interested in, and then print() that object.
# Instead of print()/cat() rather use message()/warning() or
# if(verbose)cat(..) (or maybe stop()) if you really have to write text to
# the console. (except for print, summary, interactive functions)
# Right now, you have:
# warning(cat(...))

# This will however, not be supressable. Therefore, please omit the cat()
# call and simply write:
# warning(...)

# Please fix and resubmit.

# Best,
# Benjamin Altmann
