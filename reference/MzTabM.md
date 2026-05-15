# mzTab-M data container

The `MzTabM` class is a simple container for the mzTab-M data/file
content. Methods for this class allow adding or updating information and
validating its content.

New instances can be created using the `MzTabM()` function providing the
content for the MTD, SML, SMF and SML sections (through parameters
`mtd`, `sml`, `smf`, and `sml`, respectively).

## Usage

``` r
MzTabM(
  mtd = mtdSkeleton(id = "<replace>", software = "<replace>"),
  sml = matrix(ncol = 0, nrow = 0),
  smf = matrix(ncol = 0, nrow = 0),
  sme = matrix(ncol = 0, nrow = 0)
)
```

## Arguments

- mtd:

  Two-column `matrix` or \`data.frame with the MTD content (see
  [MTD-export](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-export.md)
  for details and expected format/content).

- sml:

  `matrix` or `data.frame` with the SML content (see
  [SML-export](https://rformassspectrometry.github.io/RmzTabM/reference/SML-export.md)
  for details and expected format/content).

- smf:

  `matrix` or `data.frame` with the SMF content (see
  [SMF-export](https://rformassspectrometry.github.io/RmzTabM/reference/SMF-export.md)
  for details and expected format/content).

- sme:

  `matrix` or `data.frame` with the SME content (see
  [SME-export](https://rformassspectrometry.github.io/RmzTabM/reference/SME-export.md)
  for details and expected format/content).

## Adding/getting metadata to/from the MTD section

Various functions are available to get or set metadata information of a
`MzTabM` class:

- [`getMtdInstrument()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdInstrument.md)
  and
  [`setMtdInstrument()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdInstrument.md)
  for instrument information.

## Author

Johannes Rainer

## Examples

``` r

## Create a minimal mzTab-M with only MTD content.
m <- MzTabM(mtd = mtdSkeleton(id = "001", software = "[,,RmzTabM,]"))
m
#> Object of class MzTabM
#> mzTab-M version 2.1.0-M
#>  MTD section with 23 rows.

## Add instrument information to the MTD section
m <- setMtdInstrument(m, name = "[MS, MS:1000449, LTQ Orbitrap,]",
          source = "[MS, MS:1000073, ESI,]",
          analyzer = c(`analyzer[1]` = "[MS, MS:1000291, linear ion trap,]"),
          detector = "[MS, MS:1000253, electron multiplier,]")
m
#> Object of class MzTabM
#> mzTab-M version 2.1.0-M
#>  MTD section with 27 rows.
getMtdInstrument(m)
#>                       instrument[1]-name 
#>        "[MS, MS:1000449, LTQ Orbitrap,]" 
#>                     instrument[1]-source 
#>                 "[MS, MS:1000073, ESI,]" 
#>                   instrument[1]-detector 
#> "[MS, MS:1000253, electron multiplier,]" 
#>                instrument[1]-analyzer[1] 
#>     "[MS, MS:1000291, linear ion trap,]" 
```
