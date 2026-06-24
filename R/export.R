#' @title Export a mzTab-M 2.1 file
#'
#' @name MzTabM-export
#'
#' @description
#' Write and validate an mzTab-M (version 2.1) file.
#'
#' The writer recognises the four standard sections:
#'  - **MTD** (Metadata): Always required. The metadata section
#'     provides additional information about the dataset(s) reported in the
#'     mzTab-M 2.1 file.
#'  - **SML** (Small Molecule Summary): Optional. Each row of the
#'     small molecule section is intended to report one final result to be
#'     communicated in terms of a molecule that has been quantified.
#'  - **SMF** (Small Molecule Feature): Optional but required when
#'     the SME section is present. The small molecule feature section
#'     represents individual MS regions that have been measured/quantified.
#'     Each SMF row SHOULD represent a single isotopomer.
#'  - **SME** (Small Molecule Evidence): Optional. The small
#'     molecule evidence section represents evidence for identifications of
#'     small molecules/features. In a typical case, each row represents one
#'     result from a single search or intepretation of a piece of evidence.
#'
#' Column names of `SMH`, `SFH` and `SEH` are used as section headers.
#'
#' @param x `list` containing the mzTab-M data to be written.
#'
#' @param path `character(1)` with the path where save the mzTab-M file.
#'
#' @param comments `character` vector of comments to add to the file. The
#'     comments will be written after the `MTD` section and before any other
#'     section.
#'
#' @importFrom utils write.table
#'
#' @author Gabriele Tomè
#'
#' @examples
#'
#' ## Basic usage
#' exp <- data.frame(
#'     sample_name = c("S1_T1", "S1_T2", "S2_T1", "S2_T2", "S3_T1", "S3_T2"),
#'     sample_id = c("S1", "S1", "S2", "S2", "S3", "S3"),
#'     timepoint = c("0h", "6h", "0h", "6h", "0h", "6h"),
#'     genotype = c("WT", "WT", "KO", "KO", "KO", "KO"),
#'     operator = c("BB", "BB", "BB", "BB", "FB", "FB"),
#'     file_name = c("s1-t1.mzML", "s1-t2.mzML", "s2-t1.mzML", "s2-t2.mzML",
#'                  "s3-t1.mzML", "s3-t2.mzML")
#' )
#' mtd <- mtdSkeleton(id = "EXP_1", software = "[MS, MS:1001582, xcms, 4.1.0]")
#'
#' mtd_s <- mtdSample(sample = unique(exp$sample_id))
#' mtd <- rbind(mtd, mtd_s)
#'
#' mtd_msr <- mtdMsRun(
#'     location = exp$file_name,
#'     format = "[MS, MS:1000584, mzML file, ]",
#'     id_format = "[MS, MS:1000530, mzML unique identifier, ]",
#'     scan_polarity = "positive")
#' mtd <- rbind(mtd, mtd_msr)
#'
#' mtd_a <- mtdAssay(
#'     assay = exp$sample_name,
#'     sample_ref = c("sample[1]", "sample[1]", "sample[2]", "sample[2]",
#'                    "sample[3]", "sample[3]"),
#'     ms_run_ref = paste0("ms_run[", seq_len(nrow(exp)), "]")
#' )
#' mtd <- rbind(mtd, mtd_a)
#'
#' mtd_svar <- mtdStudyVariables(
#'     exp, groups = c("timepoint", "genotype", "operator"),
#'     group_unit = c("[, , hours, ]", "", ""))
#' mtd <- rbind(mtd, mtd_svar)
#' mtd <- mtdSort(mtd)
#'
#' x <- list("MTD" = mtd)
#' filepath <- file.path(tempdir(), "example.mztab")
#'
#' result <- writeMzTabM(x, path = filepath)
#'
#' ## Add comments
#' comments <- c("Test comment")
#' results <- writeMzTabM(x, path = filepath, comments = comments)
#'
#' @export
writeMzTabM <- function(x, path, comments = character()) {
    if(inherits(x, "MzTabM"))
        x <- as.list(x)

    if (!is.list(x))
        stop("x must be a list.")

    if (!("MTD" %in% names(x)))
        stop("x must contain at least the MTD section.")

    ## If SME is present also SMF must be present.
    if ("SME" %in% names(x) && !("SMF" %in% names(x)))
        stop("The file cannot be generated. Missing \"SFH\" section, which is
              required if \"SME\" section is present.")

    dir <- dirname(path)
    if (!dir.exists(dir))
        dir.create(dir, recursive = TRUE, showWarnings = FALSE)

    if (!grepl(".mztab$|.mzTab$", path))
        path = paste0(path, ".mztab")

    ## MTD
    write.table(cbind(data.frame(rep("MTD", nrow(x[["MTD"]]))),
                                 as.data.frame(x[["MTD"]])),
                file = path, sep = "\t", row.names = FALSE,
                col.names = FALSE, quote = FALSE, fileEncoding = "UTF-8")

    ## COMMENTS
    if (length(comments)) {
        write.table(data.frame(rep("COM", length(comments)), comments),
                    file = path, sep = "\t", row.names = FALSE,
                    col.names = FALSE, append = TRUE, quote = FALSE,
                    fileEncoding = "UTF-8")
    }
    ## Empty line between sections
    write.table("", file = path, sep = "\t", row.names = FALSE,
                col.names = FALSE, append = TRUE, quote = FALSE,
                fileEncoding = "UTF-8")

    ## SML
    if ("SML" %in% names(x)) {
        sml <- .NAtonull(x[["SML"]])
        suppressWarnings(write.table(as.data.frame(sml), file = path,
                                    sep = "\t", row.names = FALSE,
                                    append = TRUE, quote = FALSE,
                                    fileEncoding = "UTF-8"))
        ## Empty line between sections
        write.table("", file = path, sep = "\t", row.names = FALSE,
                    col.names = FALSE, append = TRUE, quote = FALSE,
                    fileEncoding = "UTF-8")
    }
    ## SMF
    if ("SMF" %in% names(x)) {
        smf <- .NAtonull(x[["SMF"]])
        suppressWarnings(write.table(as.data.frame(smf), file = path,
                                    sep = "\t", row.names = FALSE,
                                    append = TRUE, quote = FALSE,
                                    fileEncoding = "UTF-8"))

        ## Empty line between sections
        write.table("", file = path, sep = "\t", row.names = FALSE,
                    col.names = FALSE, append = TRUE, quote = FALSE,
                    fileEncoding = "UTF-8")
    }
    ## SME
    if ("SME" %in% names(x)) {
        sme <- .NAtonull(x[["SME"]])
        suppressWarnings(write.table(as.data.frame(sme), file = path,
                                    sep = "\t", row.names = FALSE,
                                    append = TRUE, quote = FALSE,
                                    fileEncoding = "UTF-8"))
    }

    ## TODO: call the validator on the file.
}
