# Add or Update Instrument Metadata in an MTD section

Sets or updates instrument-related metadata fields within an MTD
(metadata) section. When instrument metadata already exists, the
function can either replace it entirely or append new values to the
existing ones.

Get the Instrument fields within an MTD (metadata) section.

## Usage

``` r
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

  A MTD section that stores metadata fields. Defaults to
  [`matrix()`](https://rdrr.io/r/base/matrix.html).

- name:

  `character` with the name of the instrument used in the experiment.
  (e.g., `"[MS, MS:1000449, LTQ Orbitrap,]"`).

- source:

  `character` with the instrument’s source used in the experiment.
  (e.g., `"[MS, MS:1000073, ESI,]"`).

- analyzer:

  `character` with the instrument’s analyzer type(s) used in the
  experiment. (e.g.,
  `c("analyzer[1]" = "[MS, MS:1000291, linear ion trap,]")`).

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

The input object `x` updated to include the new or merged instrument
metadata fields. If `x` is empty, the empty `x`.

`character` with the Instrument.

## Author

Gabriele Tomè

## Examples

``` r

x <- mtd_skeleton("001", software = "[MS, MS:1001582, xmcs, 4.0.0]")
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


x <- mtd_skeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
mtd <- setMtdInstrument(x, name = "[MS, MS:1000449, LTQ Orbitrap,]",
          source = "[MS, MS:1000073, ESI,]",
          analyzer = c(`analyzer[1]` = "[MS, MS:1000291, linear ion trap,]"),
          detector = "[MS, MS:1000253, electron multiplier,]")

getMtdInstrument(x)
#> [1] NA
```
