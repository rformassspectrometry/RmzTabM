# Reconstruct a sample data frame from mzTab-M MTD content

`mtdToSampleData()` is the inverse of
[`mtdFromSampleData()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdFromSampleData.md):
it takes an MTD section and reconstructs a *sample data* `data.frame`
with one row per *ms_run*, analogous to the input expected by
[`mtdFromSampleData()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdFromSampleData.md).

## Usage

``` r
mtdToSampleData(mtd)
```

## Arguments

- mtd:

  MTD section of the MzTabM object.

## Value

`data.frame` with one row per `"ms_run"` and columns with information on
`"ms_run"`, `"assay"`, `"sample"`, `"study_variables"`, `"instrument"`,
`"protocol"` sections.

## See also

[`mtdFromSampleData()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdFromSampleData.md)
for the inverse function.

## Author

Gabriele Tomè

## Examples

``` r

## Defining an example sample data:
## - file: the mzML file, i.e., the *MS run*.
## - name: the name of the measurement. This is also the name of the sample:
##         QC is the pool of all samples, s1 to s4 the ID of the individual.
## - phenotype: defining the biological replicates, 2 for CVD, 2 for CTR.
## - age: covariate, age of the individuals.
## - injection_index: the order in which samples were measured.
sdata <- data.frame(
    file = c("1.mzML", "2.mzML", "3.mzML", "4.mzML", "5.mzML", "6.mzML"),
    name = c("QC", "s1", "s2", "QC", "s3", "s4"),
    phenotype = c(NA, "CVD", "CTR", NA, "CTR", "CVD"),
    age = c(NA, 35, 32, NA, 43, 32),
    injection_index = c(1, 2, 3, 4, 5, 6))
## Add additional required columns:
sdata$polarity <- "positive"

## Add columns with optional, additional information to the individual
## samples or assays.
sdata$organism <- "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"
sdata$assay_info <- c("run1", "run2", "run3", "run4", "run5", "run6")

## Define the columns in `sdata` that provide information on the individual
## samples.
scols <- sampleCols(sample = "name", species = "organism")

## Define the columns in `sdata` that provide MS run information
mscols <- msRunCols(location = "file", scan_polarity = "polarity")

## Define the columns in `sdata` that provide assay information; we use
## the MS run/file name also for the assay name and add an additional
## column with optional content/information.
acols <- assayCols(assay = "file", assay_info = "assay_info")

## Create the MTD section from the `sdata` `data.frame`. Parameter `groups`
## allows to define the columns in `sdata` that should be encoded as
## *study variable groups*.
m <- mtdFromSampleData(sdata, sampleCols = scols, msRunCols = mscols,
    assayCols = acols, groups = c("phenotype", "age", "injection_index"))

## Reconstruct the sample data from the MTD section. The column names might
## differ from the original `sdata` `data.frame` if non-mzTabM names are
## used in the original sdata, but the content is identical.
sdata2 <- mtdToSampleData(m)
sdata2
#>              id sample_ref ms_run_ref  assay            custom.1. location
#> 1.mzML assay[1]  sample[1]  ms_run[1] 1.mzML [,,assay_info, run1]   1.mzML
#> 2.mzML assay[2]  sample[2]  ms_run[2] 2.mzML [,,assay_info, run2]   2.mzML
#> 3.mzML assay[3]  sample[3]  ms_run[3] 3.mzML [,,assay_info, run3]   3.mzML
#> 4.mzML assay[4]  sample[1]  ms_run[4] 4.mzML [,,assay_info, run4]   4.mzML
#> 5.mzML assay[5]  sample[4]  ms_run[5] 5.mzML [,,assay_info, run5]   5.mzML
#> 6.mzML assay[6]  sample[5]  ms_run[6] 6.mzML [,,assay_info, run6]   6.mzML
#>                         scan_polarity.1. sample
#> 1.mzML [MS, MS:1000130, positive scan, ]     QC
#> 2.mzML [MS, MS:1000130, positive scan, ]     s1
#> 3.mzML [MS, MS:1000130, positive scan, ]     s2
#> 4.mzML [MS, MS:1000130, positive scan, ]     QC
#> 5.mzML [MS, MS:1000130, positive scan, ]     s3
#> 6.mzML [MS, MS:1000130, positive scan, ]     s4
#>                                         species.1. phenotype  age
#> 1.mzML [NCBITaxon, NCBITaxon:9606, Homo sapiens, ]      <NA> <NA>
#> 2.mzML [NCBITaxon, NCBITaxon:9606, Homo sapiens, ]       CVD   35
#> 3.mzML [NCBITaxon, NCBITaxon:9606, Homo sapiens, ]       CTR   32
#> 4.mzML [NCBITaxon, NCBITaxon:9606, Homo sapiens, ]      <NA> <NA>
#> 5.mzML [NCBITaxon, NCBITaxon:9606, Homo sapiens, ]       CTR   43
#> 6.mzML [NCBITaxon, NCBITaxon:9606, Homo sapiens, ]       CVD   32
#>        injection_index
#> 1.mzML               1
#> 2.mzML               2
#> 3.mzML               3
#> 4.mzML               4
#> 5.mzML               5
#> 6.mzML               6
```
