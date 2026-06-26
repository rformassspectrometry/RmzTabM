# Add, update or get instrument metadata of an mzTab-M MTD section

`setMtdInstrument()` sets or updates instrument-related metadata fields
within an MTD (metadata) section. When instrument metadata already
exists, the function can either replace it entirely or append new values
to the existing ones.

`getMtdInstrument()` returns the instrument information from an MTD
section.

## Usage

``` r
# S4 method for class 'dfmatrix'
setMtdInstrument(
  x = matrix(),
  name = character(),
  source = character(),
  analyzer = character(),
  detector = character(),
  replace = FALSE
)

getMtdInstrument(x = matrix())
```

## Arguments

- x:

  A MTD section that stores metadata fields. Can be a two-column
  `character` matrix, a two-column `data.frame` or a
  [`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md)
  object. Defaults to [`matrix()`](https://rdrr.io/r/base/matrix.html).
  If all values are `NA`, the function returns `x` unchanged.

- name:

  `character` with the name of the instrument used in the experiment.
  (e.g., `"[MS, MS:1000449, LTQ Orbitrap,]"`).

- source:

  `character` with the instrument’s source used in the experiment.
  (e.g., `"[MS, MS:1000073, ESI,]"`).

- analyzer:

  `character` with the instrument’s analyzer type(s) used in the
  experiment. **Must** be provided in the form
  `c("analyzer[1]" = "[MS, MS:1000291, linear ion trap,]")` for a single
  analyzer, or `c("analyzer[1]" = "<analyzer 1>", "analyzer[2] = ...")`
  for multiple analyzers.

- detector:

  `character` with the instrument’s detector type used in the
  experiment. (e.g., `"[MS, MS:1000253, electron multiplier,]"`).

- replace:

  `logical` flag controlling how pre-existing instrument metadata is
  handled:

  - `FALSE` (default): new values are appended to any existing values.

  - `TRUE`: existing instrument metadata is discarded and replaced
    entirely by the supplied arguments.

## Value

- For `setMtdInstrument()`: the input object `x` updated to include the
  new or merged instrument metadata fields. If `x` is empty, the empty
  `x`.

- For `getMtdInstrument()`: a named `character` with the instrument
  information, names being the field names.

## Author

Gabriele Tomè

## Examples

``` r

x <- mtdSkeleton("001", software = "[MS, MS:1001582, xmcs, 4.0.0]")
## Add instrument metadata to an existing mzTab object
mtd <- setMtdInstrument(x, name = "[MS, MS:1000449, LTQ Orbitrap,]",
          source = "[MS, MS:1000073, ESI,]",
          analyzer = c(`analyzer[1]` = "[MS, MS:1000291, linear ion trap,]"),
          detector = "[MS, MS:1000253, electron multiplier,]")

## Replace all existing instrument metadata
mtd <- setMtdInstrument(mtd, name = "[MS, MS:1000449, LTQ Orbitrap,]",
          source = "[MS, MS:1000073, ESI,]",
          analyzer = c(`analyzer[1]` = "[MS, MS:1000291, linear ion trap,]"),
          detector = "[MS, MS:1000253, electron multiplier,]",
          replace = TRUE)

x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
mtd <- setMtdInstrument(x, name = "[MS, MS:1000449, LTQ Orbitrap,]",
          source = "[MS, MS:1000073, ESI,]",
          analyzer = c(`analyzer[1]` = "[MS, MS:1000291, linear ion trap,]"),
          detector = "[MS, MS:1000253, electron multiplier,]")

getMtdInstrument(mtd)
#>                       instrument[1]-name 
#>        "[MS, MS:1000449, LTQ Orbitrap,]" 
#>                     instrument[1]-source 
#>                 "[MS, MS:1000073, ESI,]" 
#>                instrument[1]-analyzer[1] 
#>     "[MS, MS:1000291, linear ion trap,]" 
#>                   instrument[1]-detector 
#> "[MS, MS:1000253, electron multiplier,]" 
```
