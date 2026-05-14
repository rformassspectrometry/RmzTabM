## MzTabM S4 class. Container for the 4 potential sections of mzTab-M and allow
## adding/extending information and validating content.

#' @title mzTab-M data container
#'
#' @aliases MzTabM-class
#'
#' @description
#'
#' The `MzTabM` class is a simple container for the mzTab-M data/file content.
#' Methods for this class allow adding or updating information and validating
#' its content.
#'
#' New instances can be created using the `MzTabM()` function providing the
#' content for the MTD, SML, SMF and SML sections (through parameters `mtd`,
#' `sml`, `smf`, and `sml`, respectively).
#'
#' @section Adding/getting metadata to/from the MTD section:
#'
#' Various functions are available to get or set metadata information of a
#' `MzTabM` class:
#'
#' - [getMtdInstrument()] and [setMtdInstrument()] for instrument information.
#'
#' @param mtd Two-column `matrix` with the MTD content (see [MTD-export] for
#'     details and expected format/content).
#'
#' @param sml `matrix` with the SML content (see [SML-export] for details
#'     and expected format/content).
#'
#' @param smf `matrix` with the SMF content (see [SMF-export] for details
#'     and expected format/content).
#'
#' @param sme `matrix` with the SME content (see [SME-export] for details
#'     and expected format/content).
#'
#' @author Johannes Rainer
#'
#' @name MzTabM
#'
#' @examples
#'
#' ## Create a minimal mzTab-M with only MTD content.
#' m <- MzTabM(mtd = mtdSkeleton(id = "001", software = "[,,RmzTabM,]"))
#' m
#'
#' ## Add instrument information to the MTD section
#' m <- setMtdInstrument(m, name = "[MS, MS:1000449, LTQ Orbitrap,]",
#'           source = "[MS, MS:1000073, ESI,]",
#'           analyzer = c(`analyzer[1]` = "[MS, MS:1000291, linear ion trap,]"),
#'           detector = "[MS, MS:1000253, electron multiplier,]")
#' m
#' getMtdInstrument(m)
NULL

#' @noRd
#'
#' @export
setClass("MzTabM",
         slots = c(mtd = "dfmatrix",
                   sml = "dfmatrix",
                   smf = "dfmatrix",
                   sme = "dfmatrix"),
         prototype = prototype(mtd = matrix(ncol = 2, nrow = 0),
                               sml = matrix(ncol = 0, nrow = 0),
                               smf = matrix(ncol = 0, nrow = 0),
                               sme = matrix(ncol = 0, nrow = 0))
         )

################################################################################
##    METHODS

setValidity("MzTabM", function(object) {
    ## just do simple validation here. nothing complex as we might call this
    ## frequently
    msg <- .mztab_validate_slots(object)
    if (length(msg)) return(msg)
    TRUE
})

setMethod("show", "MzTabM", function(object) {
    cat("Object of class ", class(object)[1L], "\n", sep = "")
    if (nrow(object@mtd)) {
        if (!is.na((ver <- .mtd_get_field(
                        object@mtd, name = "mzTab-version")[[1L]])))
            cat("mzTab-M version ", ver, "\n", sep = "")
        cat(" MTD section with ", nrow(object@mtd), " rows.\n", sep = "")
    }
    if (nrow(object@sml))
        cat(" SML section with ", nrow(object@sml), " rows and ",
            ncol(object@sml), " columns.\n", sep = "")
    if (nrow(object@smf))
        cat(" SMF section with ", nrow(object@smf), " rows and ",
            ncol(object@smf), " columns.\n", sep = "")
    if (nrow(object@sme))
        cat(" SME section with ", nrow(object@sme), " rows and ",
            ncol(object@sme), " columns.\n", sep = "")
})

setMethod("setMtdInstrument", "MzTabM", function(x, name = character(),
                                                 source = character(),
                                                 analyzer = character(),
                                                 detector = character(),
                                                 replace = FALSE) {
    x@mtd <- setMtdInstrument(x@mtd, name, source, analyzer, detector, replace)
    x
})

################################################################################
##   FUNCTIONS

#' @rdname MzTabM
#'
#' @importFrom methods new validObject
#'
#' @export
MzTabM <- function(mtd = mtdSkeleton(id = "<replace>", software = "<replace>"),
                   sml = matrix(ncol = 0, nrow = 0),
                   smf = matrix(ncol = 0, nrow = 0),
                   sme = matrix(ncol = 0, nrow = 0)) {
    res <- new("MzTabM", mtd = mtd, sml = sml, smf = smf, sme = sme)
    validObject(res)
    res
}

#' Basic check on presence and content of the slots.
#'
#' @noRd
.mztab_validate_slots <- function(x) {
    msg <- NULL
    r_mtd <- nrow(x@mtd)
    r_sml <- nrow(x@sml)
    r_smf <- nrow(x@smf)
    r_sme <- nrow(x@sme)
    if (!r_mtd && (r_sml | r_smf | r_sme))
        msg <- "MTD section can not be empty."
    if (r_mtd && ncol(x@mtd) != 2)
        msg <- c(msg, "MTD has to be a matrix with two columns")
    if (r_sme &! r_smf)
        msg <- c(msg, "SMF section needs to be defined if SME is present")
    msg
}

#' Use the official validator to run a validity check including semantic
#' validity
#'
#' @noRd
.mztab_semantic_validation <- function(x) {
    ## Use the validator... write content to temp file and run the validator.
}
