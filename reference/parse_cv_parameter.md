# Parse a CV parameter

mzTab-M makes use of controlled vocabulary (CV) parameters. These
parameters are expected to be provided in the format
`"[CV label, accession, name, value]"`. In addition, also *user
parameters* where only the *name* and *value* are provided are
supported, but it is recommendet to use full CV parameters where
possible.

## Usage

``` r
parse_cv_parameter(x, element = 2L)
```

## Arguments

- x:

  `character` with the CV parameter(s) to parse.

- element:

  `integer(1)` defining which *element* to extract: `1` for the CV
  label, `2` for the CV term (accession), `3` for the name and `4` for
  the value element.

## Value

`character` of `length(x)` with the parsed CV parameter elements or
`NA_character_` if not present.

## Note

While mzTab supports `","` in the *name* and *value* field (in which
case the respective field must be placed between `"`), this is currently
not supported. Thus, CV label and term (accession) are expected to be
correctly extracted, the name and value field might not if `","` are
present in them.

## Author

Johannes Rainer

## Examples

``` r

## Extract CV term
x <- c("[MS, MS:1002962, mean, ]", "[MS, MS:1002883, median, ]")
parse_cv_parameter(x, 1)
#> [1] "MS" "MS"

parse_cv_parameter(x)
#> [1] "MS:1002962" "MS:1002883"

parse_cv_parameter(x, 3)
#> [1] "mean"   "median"

parse_cv_parameter(x, 4)
#> [1] NA NA

## CV term missing
parse_cv_parameter("[, , user, value]")
#> [1] NA
parse_cv_parameter("[, , user, value]", 3)
#> [1] "user"
parse_cv_parameter("[, , user, value]", 4)
#> [1] "value"
```
