## General helper functions

.prefix_zero <- function(x) {
    sprintf(paste0("%0", ceiling(log10(max(x) + 1)), "d"), x)
}

#' Mapping between OBO CV terms and R functions. This is used by
#' `sml_add_study_variable_columns()` (and `resolce_fun()`) to get the function
#' to aggregate values per study variables based on the information/CV terms
#' specified in the mzTab-M's metadata section.
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

#' Maps/resolves a CV term to an R function.
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

#' @title Utility functions for CV parameters
#'
#' @description
#'
#' mzTab-M makes use of controlled vocabulary (CV) parameters. These parameters
#' are expected to be provided in the format
#' `"[CV label, accession, name, value]"`. In addition, also *user parameters*
#' where only the *name* and *value* are provided are supported, but it is
#' recommendet to use full CV parameters where possible.
#'
#' `parse_cv_parameter()` allows to extract individual fields from a CV
#' parameter.
#'
#' `is_cv_parameter()` tests whether a string is in the expected (CV parameter)
#' format.
#'
#' @note
#'
#' While mzTab supports `","` in the *name* and *value* field (in which case
#' the respective field must be placed between `"`), this is currently not
#' supported. Thus, CV label and term (accession) are expected to be correctly
#' extracted, the name and value field might not if `","` are present in them.
#'
#' @param x `character` with the CV parameter(s) to parse or test.
#'
#' @param element `integer(1)` defining which *element* to extract: `1` for the
#'     CV label, `2` for the CV term (accession), `3` for the name and `4` for
#'     the value element.
#'
#' @return `character` of `length(x)` with the parsed CV parameter elements or
#'     `NA_character_` if not present.
#'
#' @export
#'
#' @family mzTab-M utility functions
#'
#' @author Johannes Rainer
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
#'
#' ## Check validity of CV parameters
#' is_cv_parameter(c(x, "[a, b, c, d, e]", "d"))
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

#' @export
#'
#' @rdname parse_cv_parameter
is_cv_parameter <- function(x) {
    grepl("^\\[([^,]*,){3}[^,]*\\]$", x)
}

#' @title Internal helper to format an abundance matrix
#'
#' @description
#'
#' `.abundance_matrix()` is a helper function called by `smf_create()` or
#' `sml_create()`. It takes a numeric `matrix` or `data.frame` of
#' quantification values and converts it into a basic data frame structure for
#' mzTab-M.
#'
#' It performs the following actions:
#'
#' - Generates sequential `SMF_ID` or `SML_ID`s.
#' - Renames input columns to the strictly required format `abundance_assay[n]`.
#'
#' @param x A `numeric` `matrix` or `data.frame` where rows
#'   represent features and columns represent samples/assays. The order of
#'   columns is assumed to match the order of assays defined in the Metadata
#'   (MTD) section.
#'
#' @param id_col `character(1)` defining the name for the ID column.
#'
#' @return A `data.frame` containing the `id_col` column and the renamed
#'   abundance columns.
#'
#' @author Philippine Louail
#'
#' @noRd
.abundance_matrix <- function(x, id_col = "SMF_ID") {
    if (missing(x))
        stop("The abundance matrix must be provided with parameter 'x'")
    if (!(is.matrix(x) | is.data.frame(x)))
        stop("'x' must be a 'matrix' or 'data.frame'")
    df <- data.frame(id = seq_len(nrow(x)), x, check.names = FALSE)
    colnames(df) <- c(id_col, paste0("abundance_assay[", seq_len(ncol(x)), "]"))
    df
}

#' @description
#'
#' Helper function to recycle inputs or create "null" strings for SMF or SML
#' columns. Parameters `lengths` and `split` allow to check for the expected
#' number of `split`-separated elements (with `lengths` defining the expected
#' number of elements in the input). `"null"` fields are automatically
#' replicated to match `lengths`. This ensures compliance with the SML format
#' and specification.
#'
#' @param x `vector` of data to fill or check.
#'
#' @param lout `integer(1)` defining the expected length of `x`.
#'
#' @param split `character(1)` defining the separator used. Defaults to `"|"`
#'     used in the mzTab-M format.
#'
#' @param lengths optional `numeric` defining the expected number of elements
#'     for each value in `x`. Has to match, if provided, the length of `x`.
#'
#' @return `x` converted to a `character` and eventually completed.
#'
#' @noRd
.check_fill_column <- function(x, lout, split = "|", lengths = numeric()) {
    if (!length(x)) x <- "null"
    if (length(x) == 1L) x <- rep(x, lout)
    if (length(x) != lout)
        stop("Input length ", length(x), " does not match row count : ", lout)
    x[is.na(x)] <- "null"
    if (length(lengths)) { # process | separated elements
        ## paste null fields to the expected number of elements
        nulls <- which(x == "null")
        if (length(nulls))
            x[nulls] <- mapply(
                function(v, t) paste0(rep(v, t), collapse = split),
                x[nulls], lengths[nulls], USE.NAMES = FALSE)
        ## check that the expected number of elements are present
        ls <- lengths(strsplit(x, split = split, fixed = TRUE))
        if (any(ls != lengths))
            stop("Input does not provide the expected number of elements ",
                 "(separated by \"|\")")
    }
    x
}

#' @description
#'
#' Helper function to determine the order of elements in `x` based on an
#' expected order `exp_order`. Elements in `x` that are not defined in
#' `exp_order` will be ordered last (in their original order in `x`).
#'
#' @param x `character` with names or column names for which the order needs
#'     to be determined.
#'
#' @param exp_order `character` with names in their expected order.
#'
#' @return `integer` with the order of the elements in `x` based on `exp_order`
#'
#' @noRd
.sort_order <- function(x, exp_order) {
    ordr <- rep(NA_integer_, length(x)) # NA will be last
    for (i in seq_along(exp_order)) {
        idx <- grep(exp_order[i], x)
        if (length(idx))
            ordr[idx] <- i
    }
    order(ordr)
}

#' @description
#'
#' Add optional columns to a `data.frame` `x`. These have to be passed as
#' named paramters and an `"opt_"` will be prepended to their name.
#'
#' @param x `data.frame` to which columns should be added.
#'
#' @param ... **named** parameters with values that should be appended as
#'     optional columns.
#'
#' @return `data.frame` with optional columns added.
#'
#' @author Philippine Louail
#'
#' @noRd
.add_opt_cols <- function(..., x) {
    dots <- list(...)
    if (length(dots) > 0) {
        if (is.null(names(dots)) || any(names(dots) == ""))
            stop("All optional arguments provided in '...' must be named.",
                 call. = FALSE)
        nms <- names(dots)
        needs_prefix <- !grepl("^opt_", nms)
        nms[needs_prefix] <- paste0("opt_", nms[needs_prefix])
        names(dots) <- nms
        nx <- nrow(x)
        for (i in seq_along(dots))
            x[[nms[i]]] <- .check_fill_column(dots[[i]], nx)
    }
    x
}
