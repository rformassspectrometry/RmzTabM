# Add or Update Controlled Vocabularies (CV) Metadata of an mzTab-M MTD section

`setMtdCv()` sets or updates CV-related metadata fields within an MTD
(metadata) section. When CV metadata already exists, the function can
either replace it entirely or append new values to the existing ones.

`getMtdCv()` returns the CV information from an MTD section.

## Usage

``` r
# S4 method for class 'dfmatrix'
setMtdCv(
  x = matrix(),
  label = character(),
  full_name = character(),
  version = character(),
  uri = character(),
  replace = FALSE
)

getMtdCv(x = matrix())
```

## Arguments

- x:

  A MTD section that stores metadata fields. Can be a two-column
  `character` matrix, a two-column `data.frame` or a
  [`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md)
  object. Defaults to [`matrix()`](https://rdrr.io/r/base/matrix.html).
  If all values are `NA`, the function returns `x` unchanged.

- label:

  `character` describing the labels of the controlled
  vocabularies/ontologies used in the *mzTab-M* file (e.g. `"MS"` for
  PSI-MS).

- full_name:

  `character` describing the full names of the controlled
  vocabularies/ontologies used.

- version:

  `character` describing the version of the controlled
  vocabularies/ontologies used. (e.g. `"4.1.11"`)

- uri:

  `character` containing the URIs of the controlled vocabularies/
  ontologies used in the mzTab file. Note: For OBO ontologies, always
  use an OBO PURL rather than raw repository links to ensure long-term
  stability (e.g. `"https://purl.obolibrary.org/obo/ms.obo"`). For other
  ontology formats, please use the fully qualified PURL pointing to the
  ontology file.

- replace:

  `logical` flag controlling how pre-existing CV metadata is handled:

  - `FALSE` (default): new values are appended to any existing values.

  - `TRUE`: existing instrument metadata is discarded and replaced
    entirely by the supplied arguments.

## Value

- For `setMtdCv()`: the input object `x` updated to include the new or
  merged CV metadata fields. If `x` is empty, the empty `x`.

- For `getMtdCv()`: a named `character` with the CV information, names
  being the field names.

## Author

Gabriele Tomè

## Examples

``` r

x <- mtdSkeleton("001", software = "[MS, MS:1001582, xmcs, 4.0.0]")
## Add CV metadata to an existing mzTab object
mtd <- setMtdCv(x, label = "MS",
          full_name = "PSI-MS controlled vocabulary",
          version = "4.1.11",
          uri = "https://purl.obolibrary.org/obo/ms.obo")

## Replace all existing CV metadata
mtd <- setMtdCv(mtd, label = "MS",
          full_name = "PSI-MS controlled vocabulary",
          version = "4.1.11",
          uri = "https://purl.obolibrary.org/obo/ms.obo",
          replace = TRUE)

## Get CV infrmation
getMtdCv(mtd)
#>                              cv[1]-label 
#>                                     "MS" 
#>                          cv[1]-full_name 
#>           "PSI-MS controlled vocabulary" 
#>                            cv[1]-version 
#>                                 "4.1.11" 
#>                                cv[1]-uri 
#> "https://purl.obolibrary.org/obo/ms.obo" 
```
