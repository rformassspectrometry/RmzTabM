## Documentation for the `SummarizedExperiment` `se`

#' @title Quantified LC-MS preprocessing result test data from Metabonaut
#'
#' @description
#'
#' The `se` variable is a [SummarizedExperiment::SummarizedExperiment()]
#' object representing the results from a *xcms*-based pre-processing of an
#' LC-MS untargeted metabolomics data set. The raw MS data is available in
#' MetaboLights with accession number *MTBLS8735*. Details and settings for
#' the preprocessing are provided in the
#' [*Metabonaut*](https://rformassspectrometry.github.io/Metabonaut)
#' resource (end-to-end metabolomics data analysis workflow)
#' [Louail et al.; Zenodo](https://doi.org/10.5281/zenodo.15062929).
#'
#' The data set contains two abundance matrices (*assays*):
#'
#' - `"raw"`: the original quantified feature abunances representing the
#'   integrated peak areas of the identified chromatographic peaks.
#' - `"raw_filled"`: gap-filled feature abundance matrix. Same content as assay
#'   `"raw"` but with missing values replaced by the MS signal measured in the
#'   expected peak area for the respective ions/features.
#'
#' @name se
#'
#' @examples
#'
#' ## Load the data
#' data(se)
#'
#' library(SummarizedExperiment)
#'
#' ## Access row (feature) data
#' rowData(se)
#'
#' ## List the available assays
#' assayNames(se)
NULL
