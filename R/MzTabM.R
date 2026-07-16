## MzTabM S4 class. Container for the 4 potential sections of mzTab-M and allow
## adding/extending information and validating content.

#' @title mzTab-M data container
#'
#' @aliases MzTabM-class
#'
#' @aliases MzTabM,missing-method
#'
#' @aliases mtd
#'
#' @aliases smf
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
#' @section MTD section; adding or getting metadata:
#'
#' Various functions are available to get or set metadata information of a
#' `MzTabM` class:
#'
#' - [getMtdInstrument()] and [setMtdInstrument()] for instrument information.
#' - [getMtdDatabase()] and [setMtdDatabase()] for database information.
#' - [getMtdCv()] and [setMtdCv()] for CV information.
#' - [getMtdContact()] and [setMtdContact()] for contact information.
#' - [getMtdProtocol()] and [setMtdProtocol()] for protocol information.
#' - [getMtdField()] and [setMtdField()] for additional information.
#'
#' @section SMF section; adding or getting small feature abundance matrix:
#'
#' - `smf()`: returns the SMF feature abundance matrix of an `MzTabM` object.
#'
#' @param mtd Two-column `matrix` or `data.frame` with the MTD content (see
#'     [MTD-export] for details and expected format/content).
#'
#' @param object `MzTabM` object.
#'
#' @param sml `matrix` or `data.frame` with the SML content (see [SML-export]
#'     for details and expected format/content).
#'
#' @param smf `matrix` or `data.frame` with the SMF content (see [SMF-export]
#'     for details and expected format/content).
#'
#' @param sme `matrix` or `data.frame` with the SME content (see [SME-export]
#'     for details and expected format/content).
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
#'
#' ## Add database metadata to an existing mzTab object
#' m <- setMtdDatabase(m, name = "[MIRIAM, MIR:00100079, HMDB, ]",
#'           prefix = "hmdb",
#'           version = "3.6",
#'           uri = "http://www.hmdb.ca/")
#' m
#' getMtdDatabase(m)
#'
#' ## Add CV metadata to an existing mzTab object
#' m <- setMtdCv(m, label = "MS",
#'           full_name = "PSI-MS controlled vocabulary",
#'           version = "4.1.11",
#'           uri = "https://purl.obolibrary.org/obo/ms.obo")
#' m
#' getMtdCv(m)
#'
#' ## Add contact metadata to an existing mzTab object
#' m <- setMtdContact(m, name = "Name Surname",
#'           affiliation = "PSI-MS",
#'           email = "name.surname@mail.com", orcid = "0000-0002-1825-0097")
#' m
#' getMtdContact(m)
#'
#' ## Add protocol metadata to an existing mzTab object
#' m <- setMtdProtocol(m, name = c("Mass Spectrometry"),
#'        type = c("[CHMO, CHMO:0000470, mass spectrometry, ]"),
#'        description = c("Eluting compounds were detected ..."),
#'        parameters = paste0("[MS, MS:1000008, ionization type, ",
#'                            "[MS,MS:1000073, electrospray ionization, ]]"))
#' m
#' getMtdProtocol(m)
#'
#' ## Add a metadata field to an existing mzTab object
#' m <- setMtdField(m, field = "publication",
#'           value = "pubmed:21063943|doi:10.1007/978-1-60761-987-1_6")
#' m
#' getMtdField(m, field = "publication")
#'
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

setMethod("setMtdDatabase", "MzTabM", function(x, name = character(),
                                                 prefix = character(),
                                                 version = character(),
                                                 uri = character(),
                                                 replace = FALSE) {
    x@mtd <- setMtdDatabase(x@mtd, name, prefix, version, uri, replace)
    x
})

setMethod("setMtdCv", "MzTabM", function(x, label = character(),
                                         full_name = character(),
                                         version = character(),
                                         uri = character(), replace = FALSE) {
    x@mtd <- setMtdCv(x@mtd, label, full_name, version, uri, replace)
    x
})

setMethod("setMtdContact", "MzTabM", function(x, name = character(),
                                              affiliation = character(),
                                              email = character(),
                                              orcid = character(),
                                              replace = FALSE) {
    x@mtd <- setMtdContact(x@mtd, name, affiliation, email, orcid, replace)
    x
})

setMethod("setMtdProtocol", "MzTabM", function(x = matrix(),
                                            name = character(),
                                            type = character(),
                                            description = character(),
                                            parameters = character(),
                                            replace = FALSE) {
    x@mtd <- setMtdProtocol(x@mtd, name, type, description, parameters, replace)
    x
})

setMethod("setMtdField", "MzTabM", function(x, field = character(),
                                            value = character(),
                                            replace = FALSE) {
    x@mtd <- setMtdField(x@mtd, field, value, replace)
    x
})

#' @rdname MzTabM
#'
#' @importFrom methods new validObject
#'
#' @exportMethod MzTabM
setMethod("MzTabM", signature(mtd = "dfmatrix"),
          function(mtd = mtdSkeleton(id = "<replace>", software = "<replace>"),
                   sml = matrix(ncol = 0, nrow = 0),
                   smf = matrix(ncol = 0, nrow = 0),
                   sme = matrix(ncol = 0, nrow = 0)) {
              res <- new("MzTabM", mtd = mtd, sml = sml, smf = smf, sme = sme)
              validObject(res)
              res
          })

setMethod("MzTabM", signature(mtd = "missing"),
          function(...) {
              MzTabM(mtdSkeleton(id = "<replace>", software = "<replace>"))
          })


#' @rdname MzTabM
#'
#' @exportMethod mtd
setMethod("mtd", signature(object = "MzTabM"), function(object) {
    object@mtd
})

#' @rdname MzTabM
#'
#' @exportMethod sml
setMethod("sml", signature(object = "MzTabM"), function(object) {
    object@sml
})

#' @rdname MzTabM
#'
#' @exportMethod smf
setMethod("smf", signature(object = "MzTabM"), function(object) {
    object@smf
})

#' @rdname MzTabM
#'
#' @exportMethod sme
setMethod("sme", signature(object = "MzTabM"), function(object) {
    object@sme
})

setMethod("as.list", "MzTabM", function(x, ...) {
    .mztab_to_list(x)
})

setAs("MzTabM", "list", function(from, to) {
    .mztab_to_list(from)
})

################################################################################
##   FUNCTIONS

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

#' Convert a MzTabM object to a list
#'
#' @noRd
.mztab_to_list <- function(x) {
    l <- list()
    if (nrow(x@mtd))
        l[["MTD"]] <- x@mtd
    if (nrow(x@sml))
        l[["SML"]] <- x@sml
    if (nrow(x@smf))
        l[["SMF"]] <- x@smf
    if (nrow(x@sme))
        l[["SME"]] <- x@sme
    l
}

#' Use the official validator to run a validity check including semantic
#' validity
#'
#' @noRd
.mztab_semantic_validation <- function(x) {
    ## Use the validator... write content to temp file and run the validator.
}
