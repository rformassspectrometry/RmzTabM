# Download the jmztabm-validator binary

This function downloads the jmztabm-validator binary for the current
platform (*Linux*, *macOS*, or *Windows*) from the GitHub releases of
the [jmztabm-validator
repository](https://github.com/lifs-tools/jmzTab-m/releases). It caches
the downloaded binary using *BiocFileCache* to avoid repeated downloads.

## Usage

``` r
mzTabMValidator_download(tag = "dev-latest", force = FALSE)
```

## Arguments

- tag:

  `character(1)` specifying the release tag to download. Defaults
  `"dev-latest"`.

- force:

  `logical(1)` indicating whether to force re-download of the binary
  even if a cached copy exists.

## Value

`character(1)` with the path of the jmztabm-validator.

## Author

Gabriele Tomè

## Examples

``` r

mzTabMValidator_download()
#>                                                                             BFC2 
#> "/github/home/.cache/R/BiocFileCache/3c4c10308a75_jmztabm-validator-amd64-linux" 
```
