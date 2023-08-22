# Create a package using epiverse/packagetemplate

- Go to [epiverse-trace/packagetemplate](https://github.com/epiverse-trace/packagetemplate) on GH
- Click `Use this template`, `Create a new repository`
- Name the repo then click `Create repository`
- Clone the repo down to your developer machine
- Install dev dependency {etdev} using `pak::pak("epiverse-trace/etdev")`
- Run `devtools::load_all()` to check for errors
- Update the `DESCRIPTION` and `NAMESPACE` files
- Start developing
- Replace `packagetemplate` with `your package name` in the `tests/testthat.R` file

# Various README fixes
- Codecov, sign up for an account then follow [these instructions](https://docs.codecov.com/docs/github-2-getting-a-codecov-account-and-uploading-coverage) to set it up
- Recon. Used [this image](https://www.reconverse.org/images/badge-experimental.svg) instead of the repo image which appear broken but that might have been temporary.
- Updated `render_readme.yml` by adding trailing `--` to `git diff-index --quiet HEAD --` line 87. Based on [SO reference](https://stackoverflow.com/questions/28296130/what-does-this-git-diff-index-quiet-head-mean)
- Also found in the GH Action logs that the script didn't have permission to commit the build README.md file to the repo. This was fixed by allowing workflow permission to be read/write in GH repo > Actions > General (scroll to bottom)

# TODO
- Include brand guide in {hexstickers repo}
- Update package template README.md with steps to do as you start to build your package
- Fix README.Rmd `fig.path = "man/figures/README-",` linter message
- Fix issue where rendered README.md is not updated on the website