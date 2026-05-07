# Add or Update Controlled Vocabularies (CV) Metadata in an MTD section

Sets or updates CV-related metadata fields within an MTD (metadata)
section. When CV metadata already exists, the function can either
replace it entirely or append new values to the existing ones.

Get the CV fields within an MTD (metadata) section.

## Usage

``` r
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

  A MTD section that stores metadata fields. Defaults to
  [`matrix()`](https://rdrr.io/r/base/matrix.html).

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

The input object `x` updated to include the new or merged CV metadata
fields. If `x` is empty, the empty `x`.

`character` with the CV.

## Author

Gabriele Tomè

## Examples

``` r

x <- mtd_skeleton("001", software = "[MS, MS:1001582, xmcs, 4.0.0]")
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


x <- mtd_skeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
mtd <- setMtdCv(x, label = "MS",
          full_name = "PSI-MS controlled vocabulary",
          version = "4.1.11",
          uri = "https://purl.obolibrary.org/obo/ms.obo")

getMtdCv(x)
#>                                                               cv[1]-label 
#>                                                                      "MS" 
#>                                                           cv[1]-full_name 
#>                                            "PSI-MS controlled vocabulary" 
#>                                                             cv[1]-version 
#>                                                                 "4.1.138" 
#>                                                                 cv[1]-uri 
#>  "https://raw.githubusercontent.com/HUPO-PSI/psi-ms-CV/master/psi-ms.obo" 
#>                                                               cv[2]-label 
#>                                                                   "PRIDE" 
#>                                                           cv[2]-full_name 
#> "PRIDE PRoteomics IDEntifications (PRIDE) database controlled vocabulary" 
#>                                                             cv[2]-version 
#>                                                        "16:10:2023 11:38" 
#>                                                                 cv[2]-uri 
#>                              "https://www.ebi.ac.uk/ols/ontologies/pride" 
#>                                                               cv[3]-label 
#>                                                                   "STATO" 
#>                                                           cv[3]-full_name 
#>                                     "General purpose STATistics Ontology" 
#>                                                             cv[3]-version 
#>                                                              "2026-04-20" 
#>                                                                 cv[3]-uri 
#>                             "https://www.ebi.ac.uk/ols4/ontologies/stato" 
```
