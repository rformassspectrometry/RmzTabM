# Import a mzTab-M 2.1 file

Reads and parses an mzTab-M (version 2.1) file into a
[MzTabM](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md)
object.

The parser recognises the four standard sections:

- **MTD** (Metadata): Always required. The metadata section provides
  additional information about the dataset(s) reported in the mzTab-M
  2.1 file.

- **SML** (Small Molecule Summary): Optional. Each row of the small
  molecule section is intended to report one final result to be
  communicated in terms of a molecule that has been quantified.

- **SMF** (Small Molecule Feature): Optional but required when the SME
  section is present. The small molecule feature section represents
  individual MS regions that have been measured/quantified. Each SMF row
  SHOULD represent a single isotopomer.

- **SME** (Small Molecule Evidence): Optional. The small molecule
  evidence section represents evidence for identifications of small
  molecules/features. In a typical case, each row represents one result
  from a single search or intepretation of a piece of evidence.

Section headers (`SMH`, `SFH`, `SEH`) are used as column names for their
respective data sections. The `MTD` section does not have a dedicated
header row; its two-column key–value structure is returned without
column names.

## Usage

``` r
readMzTabM(path, validate = TRUE, ...)
```

## Arguments

- path:

  `character(1)` with the path to the mzTab-M file.

- validate:

  `logical(1)` to run the validation on the file. Default: `TRUE`.

- ...:

  Additional arguments forwarded to every internal call to
  [`data.table::fread`](https://rdrr.io/pkg/data.table/man/fread.html).

## Value

A `MzTabM` object containing between one and four elements, depending on
which sections are present in the file:

- `MTD`: A `matrix` with two columns. Column names are absent (the
  prefix column is dropped).

- `SML`: A `matrix` whose column names are taken from the `SMH` header
  row. Present only when `SMH` is found in the file.

- `SMF`: A `matrix` whose column names are taken from the `SFH` header
  row. Present only when `SFH` is found in the file.

- `SME`: A `matrix` whose column names are taken from the `SEH` header
  row. Present only when both `SFH` and `SEH` are found in the file.

## Author

Gabriele Tomè

## Examples

``` r

## Basic usage
result <- readMzTabM(system.file("example_mztabm","MTBLS8735_mtd_smf.mzTab",
                                   package = "RmzTabM"))
#> Validation finished successfully: 2 message(s) found, including:
#>  - Info(s): 2
#>  - Warning(s): 0
#>  - Error(s): 0
#> 
#> Validation messages:
#>   level code line_no
#> 1  Info 2057      -1
#> 2  Info 2057      -1
#>                                                                                                                                           text
#> 1 "small_molecule-quantification_unit" is present but the profile "M+F" has no "small molecule summary (SML)" section that would require it.\r
#> 2                          "database" is present but the profile "M+F" has no "small molecule evidence (SME)" section that would require it.\r
result
#> Object of class MzTabM
#> mzTab-M version 2.1.0-M
#>  MTD section with 203 rows.
#>  SMF section with 9068 rows and 22 columns.

## Read without validation
result <- readMzTabM(system.file("example_mztabm","MTBLS8735_mtd_smf.mzTab",
                                   package = "RmzTabM"),
                     validate = FALSE)
result
#> Object of class MzTabM
#> mzTab-M version 2.1.0-M
#>  MTD section with 203 rows.
#>  SMF section with 9068 rows and 22 columns.
```
