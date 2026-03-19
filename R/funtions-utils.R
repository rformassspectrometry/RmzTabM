## Generic helper functions

.prefix_zero <- function(x) {
    sprintf(paste0("%0", ceiling(log10(max(x) + 1)), "d"), x)
}


#' Mapping between OBO CV terms and R functions
#'
#' @noRd
.FUN_MAP <- c(
    `MS:1002962` = mean,
    `MS:1002963` = function(x) sd(x, na.rm = TRUE) /
                               mean(x, na.rm = TRUE),
    `MS:1002883` = median,
    `MS:1002885` = function(x) sd(x, na.rm = TRUE) /
                               sqrt(sum(!is.na(x)))
)

#' maps/resolves a CV term to an R function.
#'
#' @param x `character(1)` OBO CV term to resolve to an R function.
#'
#' @return `list` of `length(x)` with the function(s) for the provided `x`.
#'
#' @noRd
.resolve_fun <- function(x) {
    idx <- match(gsub(" ", "", x, fixed = TRUE), names(.FUN_MAP))
    if (anyNA(idx)) {
        stop("Can not resolve ",
             paste0("\"", x[is.na(idx)], "\"", collapse = ", "),
             ". Currently only ",
             paste0("\"", names(.FUN_MAP), "\"", collapse = ", "),
             " are supported.")
    }
    else .FUN_MAP[idx]
}

#' @title Parse a CV parameter
#'
#' @description
#'
#' mzTab-M makes use of controlled vocabulary (CV) parameters. These parameters
#' are expected to be provided in the format
#' `"[CV label, accession, name, value]"`. In addition, also *user parameters*
#' where only the *name* and *value* are provided are supported, but it is
#' recommendet to use full CV parameters where possible.
#'
#' @note
#'
#' While mzTab supports `","` in the *name* and *value* field (in which case
#' the respective field must be placed between `"`), this is currently not
#' supported. Thus, CV label and term (accession) are expected to be correctly
#' extracted, the name and value field might not if `","` are present in them.
#'
#' @param x `character` with the CV parameter(s) to parse.
#'
#' @param element `integer(1)` defining which *element* to extract: `1` for the
#'     CV label, `2` for the CV term (accession), `3` for the name and `4` for
#'     the value element.
#'
#' @return `character` of `length(x)` with the parsed CV parameter elements or
#'     `NA_character_` if not present.
#'
#' @noRd
#'
#' @family mzTab-M utility functions
#'
#' @examples
#'
#' ## Extract CV term
#' x <- c("[MS, MS:1002962, mean, ]", "[MS, MS:1002883, median, ]")
#' parse_cv_parameter(x, 1)
#'
#' parse_cv_parameter(x)
#'
#' parse_cv_parameter(x, 3)
#'
#' parse_cv_parameter(x, 4)
#'
#' ## CV term missing
#' parse_cv_parameter("[, , user, value]")
#' parse_cv_parameter("[, , user, value]", 3)
#' parse_cv_parameter("[, , user, value]", 4)
parse_cv_parameter <- function(x, element = 2L) {
    if (!all(grepl("^\\[.*\\]$", x)))
        stop("Unexpected CV parameter format: string is expected to start with",
             " a [ and end with a ].")
    ## Note: for `element = 3L` we might use a different way to extract the
    ## element because of the special case supporting , within the element if
    ## the element is quoted...
    flds <- strsplit(gsub("^\\[|\\]$", "", x), split = ",\\s?")
    res <- vapply(flds, function(z) z[element],
                  NA_character_, USE.NAMES = FALSE)
    res[which(res == "")] <- NA_character_
    res
}
