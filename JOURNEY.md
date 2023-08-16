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