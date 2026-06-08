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

- [`getMtdDatabase()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdDatabase.md)
  and
  [`setMtdDatabase()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdDatabase.md)
  for database information.

- [`getMtdCv()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdCv.md)
  and
  [`setMtdCv()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdCv.md)
  for CV information.

- [`getMtdContact()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdContact.md)
  and
  [`setMtdContact()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdContact.md)
  for contact information.

- [`getMtdField()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdField.md)
  and
  [`setMtdField()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdField.md)
  for additional information.

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

## Add database metadata to an existing mzTab object
m <- setMtdDatabase(m, name = "[MIRIAM, MIR:00100079, HMDB, ]",
          prefix = "hmdb",
          version = "3.6",
          uri = "http://www.hmdb.ca/")
m
#> Object of class MzTabM
#> mzTab-M version 2.1.0-M
#>  MTD section with 27 rows.
getMtdDatabase(m)
#>                      database[1]               database[1]-prefix 
#> "[MIRIAM, MIR:00100079, HMDB, ]"                           "hmdb" 
#>              database[1]-version                  database[1]-uri 
#>                            "3.6"            "http://www.hmdb.ca/" 

## Add CV metadata to an existing mzTab object
m <- setMtdCv(m, label = "MS",
          full_name = "PSI-MS controlled vocabulary",
          version = "4.1.11",
          uri = "https://purl.obolibrary.org/obo/ms.obo")
m
#> Object of class MzTabM
#> mzTab-M version 2.1.0-M
#>  MTD section with 31 rows.
getMtdCv(m)
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
#>                                                               cv[4]-label 
#>                                                                      "MS" 
#>                                                           cv[4]-full_name 
#>                                            "PSI-MS controlled vocabulary" 
#>                                                             cv[4]-version 
#>                                                                  "4.1.11" 
#>                                                                 cv[4]-uri 
#>                                  "https://purl.obolibrary.org/obo/ms.obo" 

## Add contact metadata to an existing mzTab object
m <- setMtdContact(m, name = "Name Surname",
          affiliation = "PSI-MS",
          email = "name.surname@mail.com", orcid = "0000-0002-1825-0097")
m
#> Object of class MzTabM
#> mzTab-M version 2.1.0-M
#>  MTD section with 35 rows.
getMtdContact(m)
#>         contact[1]-name  contact[1]-affiliation        contact[1]-email 
#>          "Name Surname"                "PSI-MS" "name.surname@mail.com" 
#>        contact[1]-orcid 
#>   "0000-0002-1825-0097" 

## Add a metadata field to an existing mzTab object
m <- setMtdField(m, field = "publication",
          value = "pubmed:21063943|doi:10.1007/978-1-60761-987-1_6")
m
#> Object of class MzTabM
#> mzTab-M version 2.1.0-M
#>  MTD section with 36 rows.
getMtdField(m, field = "publication")
#>                                    publication[1] 
#> "pubmed:21063943|doi:10.1007/978-1-60761-987-1_6" 
```
