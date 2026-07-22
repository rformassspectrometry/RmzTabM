# Create a mzTab-M file from a `SummarizedExperiment` object

The
[`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md)
method for the
[SummarizedExperiment::SummarizedExperiment](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
class compiles a
[MzTabM](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md)
data object from the content and data of the `SummarizedExperiment`
object passed through the function's first parameter (`mtd`). The
function extracts relevant information from the `SummarizedExperiment`'s
`rowData()` and `colData()`. The `SummarizedExperiment`'s `rowData()` is
expected to contain necessary information to characterize the individual
features. The `colData()` should provide experiment and sample
information for the mzTab-M metadata section.
[`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md)
uses the
[`mtdFromSampleData()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdFromSampleData.md)
and
[`smf()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md)
method (described below) to compile the mzTab-M's MTD and SMF sections,
respectively.

- **MTD** section: information is extracted from the
  `SummarizedExperiment`'s `colData()`. If not already present, relevant
  and required information should be added to the `colData()`. The
  [`mtdFromSampleData()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdFromSampleData.md)
  function is used to extract and compile the MTD section.

- **SMF** section: the small molecule feature section is compiled from
  the `SummarizedExperiment`'s `rowData()` (for feature characteristics)
  and `assay()` (abundance matrix). The `smfCols.` parameter of the
  [`smf()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md)
  and
  [`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md)
  methods allows to define the mapping between feature *fields* and
  column names of the `rowData()` containing the relevant information.

`makeSummarizedExperimentFromMzTabM` converts the content of an `MzTabM`
object into a `SummarizedExperiment` object. Sample information is
extracted from the *MTD* (metadata) section and used to populate the
`colData` of the resulting object, while feature-level quantification
values and feature annotations are extracted from the *SMF* section and
used to populate the assay data and `rowData`, respectively. If the
`MzTabM` object does not contain any small molecule feature data, a
`SummarizedExperiment` with only `colData` populated is returned.

## Usage

``` r
# S4 method for class 'SummarizedExperiment'
MzTabM(
  mtd,
  id = character(),
  sampleCols. = sampleCols(),
  msRunCols. = msRunCols(),
  assayCols. = assayCols(),
  groups = character(),
  group_description = character(),
  group_type = character(),
  group_datatype = character(),
  group_unit = character(),
  smfCols. = character(),
  assayName = 1L,
  ...
)

# S4 method for class 'SummarizedExperiment'
smf(object, smfCols. = smfCols(), assayName = 1L)

makeSummarizedExperimentFromMzTabM(
  mzt,
  assayName = 1L,
  rowIdCol = "SMF_ID",
  smfCols. = smfCols()
)

smfCols(
  exp_mass_to_charge = "exp_mass_to_charge",
  retention_time_in_seconds = "retention_time_in_seconds",
  retention_time_in_seconds_start = "retention_time_in_seconds_start",
  retention_time_in_seconds_end = "retention_time_in_seconds_end",
  SME_ID_REFS = "SME_ID_REFS",
  SME_ID_REF_ambiguity_code = "SME_ID_REF_ambiguity_code",
  charge = "charge",
  adduct_ion = "adduct_ion",
  isotopomer = "isotopomer",
  opt_identifier = "global",
  ...
)
```

## Arguments

- mtd:

  For
  [`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md):
  `SummarizedExperiment` containing all information to compile the
  `MzTabM` object.

- id:

  For
  [`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md):
  `character(1)` with an ID for the mzTab-M file. **Mandatory**.

- sampleCols.:

  named `character` vector defining the columns in the
  `SummarizedExperiment`'s
  [`colData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  containing information for the individual sample fields (with names
  being the name of the mzTab-M field and values the respective column
  name in
  [`colData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)).
  The
  [`sampleCols()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdFromSampleData.md)
  function can be used to define this parameter. See also
  [`mtdSample()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdSample.md)
  and
  [`mtdFromSampleData()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdFromSampleData.md)
  for more information.

- msRunCols.:

  named `character` vector defining the columns in the
  `SummarizedExperiment`'s
  [`colData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  containing information on the MS runs (with names being the name of
  the mzTab-M field and values the respective column name in
  [`colData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)).
  Required fields/parameters are `location` and `scan_polarity`. The
  [`msRunCols()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdFromSampleData.md)
  function can be used to define this parameter. See also
  [`mtdMsRun()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdMsRun.md)
  and
  [`mtdFromSampleData()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdFromSampleData.md)
  for more information.

- assayCols.:

  named `character` vector defining the columns in the
  `SummarizedExperiment`'s
  [`colData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  containing information for the individual assays fields (with names
  being the name of the mzTab-M field and values the respective column
  name in
  [`colData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)).
  Parameter/field `assay` is mandatory. The
  [`assayCols()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdFromSampleData.md)
  function can be used to assist compiling this parameter. See
  [`mtdAssay()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdAssay.md)
  and
  [`mtdFromSampleData()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdFromSampleData.md)
  for more information.

- groups:

  For
  [`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md):
  `character` with the name(s) of the column(s) in the
  `SummarizedExperiment`'s
  [`colData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  that should be used as *study variable groups*. If not defined (the
  default) a single study variable group `"undefined"` and single study
  variable `"undefined"` will be used.

- group_description:

  For
  [`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md):
  `character` with an optional description of each study variable group.
  If provided its length has to match the length of parameter `groups`.

- group_type:

  For
  [`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md):
  `character` defining the type for each study variable group. If
  provided its length has to match the length of parameter `groups`.
  Supported values are
  `"[STATO, STATO:0000252, categorical variable, ]"`,
  `"[STATO, STATO:0000228, ordinal variable, ]"` and
  `"[STATO, STATO:0000251, continuous variable, ]"` for categorical,
  ordinal or numerical values, respectively. If not provided (the
  default) the study variable group type will be inferred from the data
  type of the respective columns in the `SummarizeExperiment`'s
  [`colData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html).

- group_datatype:

  For
  [`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md):
  optional `character` defining the data type of the values (i.e., study
  variables) for the study variable group. If provided, its length has
  to match the length of paramter `groups`. Supported values are
  `"xsd:string"`, `"xsd:integer"`, `"xsd:decimal"`, `"xsd:boolean"`,
  `"xsd:date"`, `"xsd:time"`, `"xsd:dateTime"`, `"xsd:anyURI"`, and
  `"Parameter"` (for *CV Parameters*). Date, time and dateTime values
  **must** be encoded in ISO 8601 format. If not provided the type is
  guessed by the data type of the respective column in the
  `SummarizedExperiment`'s
  [`colData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html).

- group_unit:

  For
  [`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md):
  optional `character` defining the unit of the group variable (for
  numeric data types). If provided, its length has to match the length
  of parameter `groups`. `NA` or `""` has to be provided for groups for
  which no unit should be reported. By default
  (`group_unit = character()`) no unit is reported for any group.

- smfCols.:

  named `character` defining which SMF section columns should be use to
  characterize each feature.

- assayName:

  `character(1)` defining the name of the assay to be used for the
  `SummarizedExperiment` assay. Defaults to `1L`.

- ...:

  For
  [`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md):
  additional arguments to be passed to
  [`mtdFromSampleData()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdFromSampleData.md)
  such as `average_function`, `variation_function` or `description`

- object:

  A `SummarizedExperiment`.

- mzt:

  A `MzTabM` object.

- rowIdCol:

  `character(1)` defining the column name in the SMF section which
  should be used as row names for the `SummarizedExperiment`. Defaults
  to `"SMF_ID"`.

- exp_mass_to_charge:

  For `smfCols()`: `character(1)` defining the column name in the
  `SummarizedExperiment`'s
  [`rowData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  containing the information on the features' m/z. **Mandatory**.

- retention_time_in_seconds:

  For `smfCols()`: `character(1)` defining the column name in the
  `SummarizedExperiment`'s
  [`rowData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  containing the retention times of the features. Optional

- retention_time_in_seconds_start:

  For `smfCols()`: `character(1)` defining the column name in the
  `SummarizedExperiment`'s
  [`rowData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  with the retention time start of the features' chromatographic signal.
  Optional.

- retention_time_in_seconds_end:

  For `smfCols()`: `character(1)` defining the column name in the
  `SummarizedExperiment`'s
  [`rowData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  with the retention time end of the features' chromatographic signal.
  Optional.

- SME_ID_REFS:

  For `smfCols()`: `character(1)` defining the column name in the
  `SummarizedExperiment`'s
  [`rowData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  providing the references to rows in the *small molecule evidence*
  (SME) section.

- SME_ID_REF_ambiguity_code:

  For `smfCols`: `character(1)` defining the column name in the
  `SummarizedExperiment`'s
  [`rowData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  with ambiguity codes for SME ID references.

- charge:

  For `smfCols()`: `character(1)` defining the column name in the
  `SummarizedExperiment`'s
  [`rowData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  containing the information on the features' charge state (integer).
  Optional.

- adduct_ion:

  For `smfCols()`: `character(1)` defining the column name in the
  `SummarizedExperiment`'s
  [`rowData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  containing information on the adduct/ion for each feature. Optional.

- isotopomer:

  For `smfCols()`: `character(1)` defining the column name in the
  `SummarizedExperiment`'s
  [`rowData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  containing the information on the features' isotopomer description.
  Optional.

- opt_identifier:

  `character` with the identifier to be used for optional columns passed
  through `...`. This is used to create the column names for optional
  columns in the format `opt_{opt_identifier}_{column_name}`. If not
  provided, the default is `"global"`. Must be of length 1 or matching
  the number of opt columns provided in `...`. Optional.

## Value

- The
  [`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md)
  function returns a
  [MzTabM](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md)
  object.

- `smfCols()` returns a named `character` vector.

- [`smf()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md)
  returns a `data.frame`.

A `SummarizedExperiment` object.

## Generate mzTab-M content from a `SummarizedExperiment`

- [`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md):
  function to compile a
  [MzTabM](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md)
  object from the information available in the `SummarizedExperiment`.
  The resulting `MzTabM` object should be completed by adding additional
  metadata through e.g.
  [`setMtdInstrument()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdInstrument.md),
  [`setMtdDatabase()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdDatabase.md),
  [`setMtdCv()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdCv.md),
  [`setMtdContact()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdContact.md),
  [`setMtdProtocol()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdProtocol.md)
  or
  [`setMtdField()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdField.md).
  See
  [`mtdFromSampleData()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdFromSampleData.md)
  for details and parameters to compile the MTD section. See
  [`smf()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md)
  below for information and parameters to compile the SMF section. Note
  that the SMF section is only created if `smfCols.` is defined and not
  empty. See
  [MTD-export](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-export.md)
  for more details on the mzTab-M metadata and
  [SMF-export](https://rformassspectrometry.github.io/RmzTabM/reference/SMF-export.md)
  for fields/columns to characterize features in an SMF section.

- [`smf()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md):
  generate a SMF matrix from a `SummarizedExperiment`. The
  `SummarizedExperiment`'s *assay* containing the feature abundances can
  be specified with parameter `assayName` which defaults to
  `assayName = 1L` hence using the first assay. Use
  [`assayNames()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  on the `SummarizedExperiment` to list all available assays. Parameter
  `smfCols.` defines the mapping between SMF field names and column
  names in the `SummarizedExperiment`'s
  [`rowData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html).
  The `smfCols()` function can be used to assist compiling this mapping.
  SMF field *exp_mass_to_charge* is mandatory. See also
  [SMF-export](https://rformassspectrometry.github.io/RmzTabM/reference/SMF-export.md)
  for details and description of the individual fields.

- `smfCols()`: allows to define which columns of the
  `SummarizedExperiment`'s
  [`rowData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  should be used as columns characterizing the features in the mzTab-M
  SMF section. Each argument of the function (such as
  `exp_mass_to_charge`) represents one of the mzTab-M SMF fields
  (columns). Using e.g. `exp_mass_to_charge = "mzmed"` would use the
  `"mzmed"` column of the
  [`rowData()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
  as `exp_mass_to_charge` field/column of the mzTab-M SMF section. See
  [SMF-export](https://rformassspectrometry.github.io/RmzTabM/reference/SMF-export.md)
  for details on the individual SMF fields.

## Author

Johannes Rainer, Philippine Louail, Gabriele Tomè

Gabriele Tomè

## Examples

``` r

## Load an example `SummarizedExperiment`: contains the results from the
## xcms-based preprocessing and data analysis described in Metabonaut
library(SummarizedExperiment)
#> Loading required package: MatrixGenerics
#> Loading required package: matrixStats
#> 
#> Attaching package: ‘MatrixGenerics’
#> The following objects are masked from ‘package:matrixStats’:
#> 
#>     colAlls, colAnyNAs, colAnys, colAvgsPerRowSet, colCollapse,
#>     colCounts, colCummaxs, colCummins, colCumprods, colCumsums,
#>     colDiffs, colIQRDiffs, colIQRs, colLogSumExps, colMadDiffs,
#>     colMads, colMaxs, colMeans2, colMedians, colMins, colOrderStats,
#>     colProds, colQuantiles, colRanges, colRanks, colSdDiffs, colSds,
#>     colSums2, colTabulates, colVarDiffs, colVars, colWeightedMads,
#>     colWeightedMeans, colWeightedMedians, colWeightedSds,
#>     colWeightedVars, rowAlls, rowAnyNAs, rowAnys, rowAvgsPerColSet,
#>     rowCollapse, rowCounts, rowCummaxs, rowCummins, rowCumprods,
#>     rowCumsums, rowDiffs, rowIQRDiffs, rowIQRs, rowLogSumExps,
#>     rowMadDiffs, rowMads, rowMaxs, rowMeans2, rowMedians, rowMins,
#>     rowOrderStats, rowProds, rowQuantiles, rowRanges, rowRanks,
#>     rowSdDiffs, rowSds, rowSums2, rowTabulates, rowVarDiffs, rowVars,
#>     rowWeightedMads, rowWeightedMeans, rowWeightedMedians,
#>     rowWeightedSds, rowWeightedVars
#> Loading required package: GenomicRanges
#> Loading required package: stats4
#> Loading required package: BiocGenerics
#> Loading required package: generics
#> 
#> Attaching package: ‘generics’
#> The following objects are masked from ‘package:base’:
#> 
#>     as.difftime, as.factor, as.ordered, intersect, is.element, setdiff,
#>     setequal, union
#> 
#> Attaching package: ‘BiocGenerics’
#> The following objects are masked from ‘package:stats’:
#> 
#>     IQR, mad, sd, var, xtabs
#> The following object is masked from ‘package:utils’:
#> 
#>     data
#> The following objects are masked from ‘package:base’:
#> 
#>     Filter, Find, Map, Position, Reduce, anyDuplicated, aperm, append,
#>     as.data.frame, basename, cbind, colnames, dirname, do.call,
#>     duplicated, eval, evalq, get, grep, grepl, is.unsorted, lapply,
#>     mapply, match, mget, order, paste, pmax, pmax.int, pmin, pmin.int,
#>     rank, rbind, rownames, sapply, saveRDS, scale, sequence, table,
#>     tapply, transform, unique, unsplit, which.max, which.min
#> Loading required package: S4Vectors
#> 
#> Attaching package: ‘S4Vectors’
#> The following object is masked from ‘package:utils’:
#> 
#>     findMatches
#> The following objects are masked from ‘package:base’:
#> 
#>     I, expand.grid, unname
#> Loading required package: IRanges
#> Loading required package: Seqinfo
#> Loading required package: Biobase
#> Welcome to Bioconductor
#> 
#>     Vignettes contain introductory material; view with
#>     'browseVignettes()'. To cite Bioconductor, see
#>     'citation("Biobase")', and for packages 'citation("pkgname")'.
#> 
#> Attaching package: ‘Biobase’
#> The following object is masked from ‘package:MatrixGenerics’:
#> 
#>     rowMedians
#> The following objects are masked from ‘package:matrixStats’:
#> 
#>     anyMissing, rowMedians
data(se)
se
#> class: SummarizedExperiment 
#> dim: 9068 10 
#> metadata(0):
#> assays(2): raw raw_filled
#> rownames(9068): FT0001 FT0002 ... FT9067 FT9068
#> rowData names(11): mzmed mzmin ... QC ms_level
#> colnames(10): MS_QC_POOL_1_POS.mzML MS_A_POS.mzML ... MS_F_POS.mzML
#>   MS_QC_POOL_4_POS.mzML
#> colData names(15): sample_name derived_spectra_data_file ... polarity
#>   instrument

## Information on the features:
rowData(se)
#> DataFrame with 9068 rows and 11 columns
#>            mzmed     mzmin     mzmax     rtmed     rtmin     rtmax    npeaks
#>        <numeric> <numeric> <numeric> <numeric> <numeric> <numeric> <numeric>
#> FT0001   50.9898   50.9893   50.9904   203.600   201.459   208.108         8
#> FT0002   51.0590   51.0581   51.0599   191.167   190.053   194.525         9
#> FT0003   51.9866   51.9863   51.9879   203.147   201.459   207.046         7
#> FT0004   53.0204   53.0161   53.0205   203.234   200.962   217.922        10
#> FT0005   53.5208   53.5184   53.5216   203.194   201.183   209.900        10
#> ...          ...       ...       ...       ...       ...       ...       ...
#> FT9064   998.697   998.691   998.705    25.352   23.6341   26.4839         4
#> FT9065   998.779   998.758   998.784   162.691  161.5110  164.8667         8
#> FT9066   999.204   999.191   999.218   146.163  143.0103  147.9139         8
#> FT9067   999.330   999.318   999.339   157.048  154.3261  159.1735         7
#> FT9068   999.781   999.775   999.794   162.763  161.5110  164.3995         7
#>              CTR       CVD        QC  ms_level
#>        <numeric> <numeric> <numeric> <integer>
#> FT0001         1         3         4         1
#> FT0002         2         3         4         1
#> FT0003         0         3         4         1
#> FT0004         3         3         4         1
#> FT0005         3         3         4         1
#> ...          ...       ...       ...       ...
#> FT9064         0         0         4         1
#> FT9065         2         2         4         1
#> FT9066         3         1         4         1
#> FT9067         3         1         3         1
#> FT9068         1         3         3         1

## Available information on samples/MS runs:
colData(se)
#> DataFrame with 10 rows and 15 columns
#>                       sample_name derived_spectra_data_file
#>                       <character>               <character>
#> MS_QC_POOL_1_POS.mzML        POOL    FILES/MS_QC_POOL_1_P..
#> MS_A_POS.mzML                   A       FILES/MS_A_POS.mzML
#> MS_B_POS.mzML                   B       FILES/MS_B_POS.mzML
#> MS_QC_POOL_2_POS.mzML        POOL    FILES/MS_QC_POOL_2_P..
#> MS_C_POS.mzML                   C       FILES/MS_C_POS.mzML
#> MS_D_POS.mzML                   D       FILES/MS_D_POS.mzML
#> MS_QC_POOL_3_POS.mzML        POOL    FILES/MS_QC_POOL_3_P..
#> MS_E_POS.mzML                   E       FILES/MS_E_POS.mzML
#> MS_F_POS.mzML                   F       FILES/MS_F_POS.mzML
#> MS_QC_POOL_4_POS.mzML        POOL    FILES/MS_QC_POOL_4_P..
#>                       metabolite_asssignment_file      source_name     organism
#>                                       <character>      <character>  <character>
#> MS_QC_POOL_1_POS.mzML      m_MTBLS8735_LC-MS_po.. MS_QC_POOL_1_POS Homo sapiens
#> MS_A_POS.mzML              m_MTBLS8735_LC-MS_po..         MS_A_POS Homo sapiens
#> MS_B_POS.mzML              m_MTBLS8735_LC-MS_po..         MS_B_POS Homo sapiens
#> MS_QC_POOL_2_POS.mzML      m_MTBLS8735_LC-MS_po.. MS_QC_POOL_1_POS Homo sapiens
#> MS_C_POS.mzML              m_MTBLS8735_LC-MS_po..         MS_C_POS Homo sapiens
#> MS_D_POS.mzML              m_MTBLS8735_LC-MS_po..         MS_D_POS Homo sapiens
#> MS_QC_POOL_3_POS.mzML      m_MTBLS8735_LC-MS_po.. MS_QC_POOL_1_POS Homo sapiens
#> MS_E_POS.mzML              m_MTBLS8735_LC-MS_po..         MS_E_POS Homo sapiens
#> MS_F_POS.mzML              m_MTBLS8735_LC-MS_po..         MS_F_POS Homo sapiens
#> MS_QC_POOL_4_POS.mzML      m_MTBLS8735_LC-MS_po.. MS_QC_POOL_1_POS Homo sapiens
#>                       blood_sample_type         sample_type       age
#>                             <character>         <character> <integer>
#> MS_QC_POOL_1_POS.mzML       blood serum                pool        NA
#> MS_A_POS.mzML              blood plasma experimental sample        53
#> MS_B_POS.mzML              blood plasma experimental sample        30
#> MS_QC_POOL_2_POS.mzML       blood serum                pool        NA
#> MS_C_POS.mzML              blood plasma experimental sample        66
#> MS_D_POS.mzML              blood plasma experimental sample        36
#> MS_QC_POOL_3_POS.mzML       blood serum                pool        NA
#> MS_E_POS.mzML              blood plasma experimental sample        66
#> MS_F_POS.mzML              blood plasma experimental sample        44
#> MS_QC_POOL_4_POS.mzML       blood serum                pool        NA
#>                              unit   phenotype injection_index
#>                       <character> <character>       <integer>
#> MS_QC_POOL_1_POS.mzML        year          QC               1
#> MS_A_POS.mzML                year         CVD               2
#> MS_B_POS.mzML                year         CTR               3
#> MS_QC_POOL_2_POS.mzML        year          QC               4
#> MS_C_POS.mzML                year         CTR               5
#> MS_D_POS.mzML                year         CVD               6
#> MS_QC_POOL_3_POS.mzML        year          QC               7
#> MS_E_POS.mzML                year         CTR               8
#> MS_F_POS.mzML                year         CVD               9
#> MS_QC_POOL_4_POS.mzML        year          QC              10
#>                                      species                 tissue    polarity
#>                                  <character>            <character> <character>
#> MS_QC_POOL_1_POS.mzML [NCBITaxon, NCBITaxo.. [BTO, BTO:0000133, b..    positive
#> MS_A_POS.mzML         [NCBITaxon, NCBITaxo.. [BTO, BTO:0000131, b..    positive
#> MS_B_POS.mzML         [NCBITaxon, NCBITaxo.. [BTO, BTO:0000131, b..    positive
#> MS_QC_POOL_2_POS.mzML [NCBITaxon, NCBITaxo.. [BTO, BTO:0000133, b..    positive
#> MS_C_POS.mzML         [NCBITaxon, NCBITaxo.. [BTO, BTO:0000131, b..    positive
#> MS_D_POS.mzML         [NCBITaxon, NCBITaxo.. [BTO, BTO:0000131, b..    positive
#> MS_QC_POOL_3_POS.mzML [NCBITaxon, NCBITaxo.. [BTO, BTO:0000133, b..    positive
#> MS_E_POS.mzML         [NCBITaxon, NCBITaxo.. [BTO, BTO:0000131, b..    positive
#> MS_F_POS.mzML         [NCBITaxon, NCBITaxo.. [BTO, BTO:0000131, b..    positive
#> MS_QC_POOL_4_POS.mzML [NCBITaxon, NCBITaxo.. [BTO, BTO:0000133, b..    positive
#>                        instrument
#>                       <character>
#> MS_QC_POOL_1_POS.mzML           1
#> MS_A_POS.mzML                   1
#> MS_B_POS.mzML                   1
#> MS_QC_POOL_2_POS.mzML           1
#> MS_C_POS.mzML                   1
#> MS_D_POS.mzML                   1
#> MS_QC_POOL_3_POS.mzML           1
#> MS_E_POS.mzML                   1
#> MS_F_POS.mzML                   1
#> MS_QC_POOL_4_POS.mzML           1

## Available abundance assays:
assayNames(se)
#> [1] "raw"        "raw_filled"

#############################################################################
## Create a `MzTabM` object with only metadata defined

## Metadata information is extracted from the `SummarizedExperiment`'s
## `colData()` which is expected to contain the relevant information to
## define and characterize the MS runs, the assays, the samples and the
## experimental/phenotypic conditions. The mapping between the MTD fields
## and the column names in `colData()` can be configured with parameters
## `sampleCols.`, `msRunCols.` and `assayCols.`. We use the respective
## helper functions to define these mappings:

## We use available `colData()` columns `"sample_name"`, `"species"` and
## `"tissue"` for the MTD sample fields *sample*, *species* and *tissue*:
s_cols <- sampleCols(sample = "sample_name", species = "species",
    tissue = "tissue")

## We use `colData()` columns `"derived_spectra_data_file"` for *location*
## (i.e., the originating MS data file) and `"polarity"` for the
## *scan_polarity* field:
m_cols <- msRunCols(location = "derived_spectra_data_file",
    scan_polarity = "polarity")

## For the present data set one MS run corresponds to one *assay*, hence we
## use also the MS data file name for the MTD field *assay*:
a_cols <- assayCols(assay = "derived_spectra_data_file")

## For the experimental design we use columns `"phenotype"` and `"age"`,
## which we provide with parameter `groups`. Having all these parameters
## defined we create now a `MzTabM` from the `SummarizedExperiment`:
m <- MzTabM(se, id = "MTBLS8735", sampleCols. = s_cols, msRunCols. = m_cols,
    assayCols. = a_cols, groups = c("phenotype", "age"))
m
#> Object of class MzTabM
#> mzTab-M version 2.1.0-M
#>  MTD section with 149 rows.
head(mtd(m))
#>                             
#> [1,] "mzTab-version"        
#> [2,] "mzTab-ID"             
#> [3,] "software[1]"          
#> [4,] "quantification_method"
#> [5,] "sample[1]"            
#> [6,] "sample[1]-species[1]" 
#>      values                                                      
#> [1,] "2.1.0-M"                                                   
#> [2,] "MTBLS8735"                                                 
#> [3,] "[,,RmzTabM,RmzTabM version 0.97.19]"                       
#> [4,] "[MS, MS:1001834, LC-MS label-free quantitation analysis, ]"
#> [5,] "POOL"                                                      
#> [6,] "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"               

## Importantly, depending on the provided information, the MTD section might
## be needed to be completed. See also the help for `MzTabM` for more
## information and helper functions to add/replace metadata content.

#############################################################################
## Create a `MzTabM` with MTD + SMF

## We need to specify which columns in the `SummarizedExperiment`'s
## `rowData()` contain information characterizing the individual features.
colnames(rowData(se))
#>  [1] "mzmed"    "mzmin"    "mzmax"    "rtmed"    "rtmin"    "rtmax"   
#>  [7] "npeaks"   "CTR"      "CVD"      "QC"       "ms_level"

## - *mzmed* defines the features *m/z* value and can be mapped to the SMF
##   field (column) *exp_mass_to_charge*.
## - *rtmed* reports the median retention time of the feature and can be
##   used for the SMF field *retention_time_in_seconds*.
## We will in addition add an optional field *feature_id* to report and add
## the IDs of the individual features from the `SummarizedExperiment`:
## add a column `"feature_id"` to the `rowData()`
rowData(se)$feature_id <- rownames(se)

## Define the mapping of SMF fields to `rowData()` columns:
smf_cols <- smfCols(exp_mass_to_charge = "mzmed",
    retention_time_in_seconds = "rtmed", feature_id = "feature_id")

## We can use the `smf()` function to create the SMF section. For the
## SMF abundances we use the data from the `"raw_filled"` assay
assayNames(se)
#> [1] "raw"        "raw_filled"

tmp <- smf(se, assayName = "raw_filled", smfCols. = smf_cols)
head(tmp)
#>        SFH SMF_ID SME_ID_REFS SME_ID_REF_ambiguity_code adduct_ion isotopomer
#> FT0001 SMF      1        null                      null       null       null
#> FT0002 SMF      2        null                      null       null       null
#> FT0003 SMF      3        null                      null       null       null
#> FT0004 SMF      4        null                      null       null       null
#> FT0005 SMF      5        null                      null       null       null
#> FT0006 SMF      6        null                      null       null       null
#>        exp_mass_to_charge charge retention_time_in_seconds
#> FT0001   50.9897946401403   null          203.600077134134
#> FT0002    51.059035992328   null          191.167453757996
#> FT0003   51.9865730172271   null           203.14665178874
#> FT0004   53.0203569195002   null          203.234292327779
#> FT0005   53.5208004472819   null          203.193618564868
#> FT0006   54.0100702952703   null          159.281630787851
#>        retention_time_in_seconds_start retention_time_in_seconds_end
#> FT0001                            null                          null
#> FT0002                            null                          null
#> FT0003                            null                          null
#> FT0004                            null                          null
#> FT0005                            null                          null
#> FT0006                            null                          null
#>        abundance_assay[1] abundance_assay[2] abundance_assay[3]
#> FT0001           421.6162           689.2422           411.3295
#> FT0002           710.8078           875.9192           457.5920
#> FT0003           445.5711           613.4410           277.5022
#> FT0004         16994.5260         24605.7340         19766.7069
#> FT0005          3284.2664          4526.0531          3521.8221
#> FT0006         10681.7476         10009.6602          9599.9701
#>        abundance_assay[4] abundance_assay[5] abundance_assay[6]
#> FT0001           481.7436           314.7567           635.2732
#> FT0002           693.6997           781.2416           648.4344
#> FT0003           497.8866           425.3774           634.9370
#> FT0004         17808.0933         22780.6683         22873.1061
#> FT0005          3379.8909          4396.0762          4317.7734
#> FT0006         10800.5449          4792.2390          7296.4262
#>        abundance_assay[7] abundance_assay[8] abundance_assay[9]
#> FT0001           439.6086           570.5849           579.9360
#> FT0002           700.9716          1054.0207           534.4577
#> FT0003           449.0933           556.2544           461.0465
#> FT0004         16965.7762         23432.1252         22198.4607
#> FT0005          3270.5290          4533.8667          4161.0132
#> FT0006          2382.1788          9236.9799          6817.8785
#>        abundance_assay[10] opt_global_feature_id
#> FT0001            437.0340                FT0001
#> FT0002            711.0361                FT0002
#> FT0003            232.1075                FT0003
#> FT0004          16796.4497                FT0004
#> FT0005           3142.2268                FT0005
#> FT0006           6911.5439                FT0006

## We use the same parameters in the `MzTabM()` function to create a mzTab-M
## with MTD + SMF content. For the MTD we re-use all parameters defined above
m <- MzTabM(se, id = "MTBLS8735", sampleCols. = s_cols, msRunCols. = m_cols,
    assayCols. = a_cols, groups = c("phenotype", "age"),
    assayName = "raw_filled", smfCols. = smf_cols)
m
#> Object of class MzTabM
#> mzTab-M version 2.1.0-M
#>  MTD section with 149 rows.
#>  SMF section with 9068 rows and 22 columns.
head(smf(m))
#>        SFH SMF_ID SME_ID_REFS SME_ID_REF_ambiguity_code adduct_ion isotopomer
#> FT0001 SMF      1        null                      null       null       null
#> FT0002 SMF      2        null                      null       null       null
#> FT0003 SMF      3        null                      null       null       null
#> FT0004 SMF      4        null                      null       null       null
#> FT0005 SMF      5        null                      null       null       null
#> FT0006 SMF      6        null                      null       null       null
#>        exp_mass_to_charge charge retention_time_in_seconds
#> FT0001   50.9897946401403   null          203.600077134134
#> FT0002    51.059035992328   null          191.167453757996
#> FT0003   51.9865730172271   null           203.14665178874
#> FT0004   53.0203569195002   null          203.234292327779
#> FT0005   53.5208004472819   null          203.193618564868
#> FT0006   54.0100702952703   null          159.281630787851
#>        retention_time_in_seconds_start retention_time_in_seconds_end
#> FT0001                            null                          null
#> FT0002                            null                          null
#> FT0003                            null                          null
#> FT0004                            null                          null
#> FT0005                            null                          null
#> FT0006                            null                          null
#>        abundance_assay[1] abundance_assay[2] abundance_assay[3]
#> FT0001           421.6162           689.2422           411.3295
#> FT0002           710.8078           875.9192           457.5920
#> FT0003           445.5711           613.4410           277.5022
#> FT0004         16994.5260         24605.7340         19766.7069
#> FT0005          3284.2664          4526.0531          3521.8221
#> FT0006         10681.7476         10009.6602          9599.9701
#>        abundance_assay[4] abundance_assay[5] abundance_assay[6]
#> FT0001           481.7436           314.7567           635.2732
#> FT0002           693.6997           781.2416           648.4344
#> FT0003           497.8866           425.3774           634.9370
#> FT0004         17808.0933         22780.6683         22873.1061
#> FT0005          3379.8909          4396.0762          4317.7734
#> FT0006         10800.5449          4792.2390          7296.4262
#>        abundance_assay[7] abundance_assay[8] abundance_assay[9]
#> FT0001           439.6086           570.5849           579.9360
#> FT0002           700.9716          1054.0207           534.4577
#> FT0003           449.0933           556.2544           461.0465
#> FT0004         16965.7762         23432.1252         22198.4607
#> FT0005          3270.5290          4533.8667          4161.0132
#> FT0006          2382.1788          9236.9799          6817.8785
#>        abundance_assay[10] opt_global_feature_id
#> FT0001            437.0340                FT0001
#> FT0002            711.0361                FT0002
#> FT0003            232.1075                FT0003
#> FT0004          16796.4497                FT0004
#> FT0005           3142.2268                FT0005
#> FT0006           6911.5439                FT0006
```
