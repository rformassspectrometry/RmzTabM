#' @title Import a mzTab-M 2.1 file
#'
#' @name MzTabM-import
#'
#' @description
#' Reads and parses an mzTab-M (version 2.1) file into a MzTabM object.
#'
#' The parser recognises the four standard sections:
#' - **MTD** (Metadata): Always required. The metadata section
#'     provides additional information about the dataset(s) reported in the
#'     mzTab-M 2.1 file.
#' - **SML** (Small Molecule Summary): Optional. Each row of the
#'     small molecule section is intended to report one final result to be
#'     communicated in terms of a molecule that has been quantified.
#' - **SMF** (Small Molecule Feature): Optional but required when
#'     the SME section is present. The small molecule feature section
#'     represents individual MS regions that have been measured/quantified.
#'     Each SMF row SHOULD represent a single isotopomer.
#' - **SME** (Small Molecule Evidence): Optional. The small
#'     molecule evidence section represents evidence for identifications of
#'     small molecules/features. In a typical case, each row represents one
#'     result from a single search or intepretation of a piece of evidence.
#'
#' Section headers (`SMH`, `SFH`, `SEH`) are used as column names for their
#' respective data sections. The `MTD` section does not have a dedicated header
#' row; its two-column key–value structure is returned without column names.
#'
#' @param path `character(1)` with the path to the mzTab-M file.
#'
#' @param ... Additional arguments forwarded to every internal call to
#'     `data.table::fread`.
#'
#' @return
#' A `MzTabM` object containing between one and four elements, depending on
#' which sections are present in the file:
#' - `MTD`: A `matrix` with two columns. Column names are absent (the
#'     prefix column is dropped).
#' - `SML`: A `matrix` whose column names are taken from the `SMH`
#'     header row. Present only when `SMH` is found in the file.
#' - `SMF`: A `matrix` whose column names are taken from the `SFH`
#'     header row. Present only when `SFH` is found in the file.
#' - `SME`: A `matrix` whose column names are taken from the `SEH`
#'     header row. Present only when both `SFH` and `SEH` are found in the file.
#'
#' @importFrom data.table fread
#'
#' @author Gabriele Tomè
#'
#' @examples
#'
#' ## Basic usage
#' result <- readMzTabM(system.file("mztabm/out","xcms_mzTab-M_2-1_v2.mzTab",
#'                                    package = "RmzTabM"))
#' result
#'
#' @export
readMzTabM <- function(path, ...) {
    if(!file.exists(path))
        stop("The file does not exist.")

    ## TODO: call the validator on the file.

    lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
    if (length(which(!grepl("^\\s*$", lines))) == 0L)
        stop("The file is empty.")

    if (!any(grepl("^MTD\\t", lines)))
        stop("The file is not in the mzTab-M format. Missing \"MTD\" section.")

    ## If SME is present also SMF must be present.
    if (any(grepl("^SEH\\t", lines)) && !any(grepl("^SFH\\t", lines)))
        stop("The file is not in the mzTab-M format. Missing \"SFH\" header
              for SMF section, which is required if SME section is present.")

    out <- list()
    ## MTD
    mtd_lines <- grep("^MTD\\t", lines, value = TRUE)
    out[["mtd"]] <- as.matrix(fread(text = mtd_lines, sep = "\t",
                                    header = FALSE, fill = TRUE, drop = 1, ...))

    ## SML
    if (any(grepl("^SMH\\t", lines))) {
        sml_lines <- grep("^SMH\\t|^SML\\t", lines, value = TRUE)
        out[["sml"]] <- as.matrix(fread(text = sml_lines, sep = "\t",
                                        header = TRUE, fill = TRUE, ...))
    }

    ## SMF
    if (any(grepl("^SFH\\t", lines))) {
        smf_lines <- grep("^SFH\\t|^SMF\\t", lines, value = TRUE)
        out[["smf"]] <- as.matrix(fread(text = smf_lines, sep = "\t",
                                        header = TRUE, fill = TRUE, ...))
    }

    ## If both SMF and SME are present, read SME
    if (any(grepl("^SFH\\t", lines)) && any(grepl("^SEH\\t", lines))) {
        ## SME
        sme_lines <- grep("^SEH\\t|^SME\\t", lines, value = TRUE)
        out[["sme"]] <- as.matrix(fread(text = sme_lines, sep = "\t",
                                        header = TRUE, fill = TRUE, ...))
    }

    out <- do.call(MzTabM, out)
    out
}


