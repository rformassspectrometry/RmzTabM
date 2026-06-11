# Quantified LC-MS preprocessing result test data from Metabonaut

The `se` variable is a
[`SummarizedExperiment::SummarizedExperiment()`](https://rdrr.io/pkg/SummarizedExperiment/man/SummarizedExperiment-class.html)
object representing the results from a *xcms*-based pre-processing of an
LC-MS untargeted metabolomics data set. The raw MS data is available in
MetaboLights with accession number *MTBLS8735*. Details and settings for
the preprocessing are provided in the
[*Metabonaut*](https://rformassspectrometry.github.io/Metabonaut)
resource (end-to-end metabolomics data analysis workflow) [Louail et
al.; Zenodo](https://doi.org/10.5281/zenodo.15062929).

The data set contains two abundance matrices (*assays*):

- `"raw"`: the original quantified feature abunances representing the
  integrated peak areas of the identified chromatographic peaks.

- `"raw_filled"`: gap-filled feature abundance matrix. Same content as
  assay `"raw"` but with missing values replaced by the MS signal
  measured in the expected peak area for the respective ions/features.

## Examples

``` r

## Load the data
data(se)

library(SummarizedExperiment)

## Access row (feature) data
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

## List the available assays
assayNames(se)
#> [1] "raw"        "raw_filled"
```
