## Code related to import/export of the SMF element

################################################################################
##    Create SMF section
##
################################################################################

#' @title Create the mzTab-M Small Molecule Feature (SMF) Table
#'
#' @name smf_create
#'
#' @description
#'
#' The Small Molecule Feature (SMF) section of the mzTab-M definition captures
#' information on the individual MS features (quantified regions, e.g.,
#' elution profiles of specific *m/z* and retention times) that were measured
#' across the assays.
#'
#' `smf_create()` provides a simplified workflow to generate this table in a
#' single step. It takes a matrix of abundances (rows=features, columns=assays)
#' and optional vectors defining feature properties.
#'
#' It automatically:
#'
#' - Formats the abundance matrix (renaming columns to `abundance_assay[n]`).
#' - Adds the required `SMF_ID` and standard mzTab-M columns (e.g.,
#'   `exp_mass_to_charge`).
#' - Populates missing mandatory columns with `"null"` strings to ensure
#'   compliance.
#' - Sets the line prefix column `SFH` to `"SMF"`.
#' - Orders columns according to the mzTab-M specification.
#'
#' **Important:** to support the optional additional parameters passed along
#' with `...` **all** parameters (such as `adduct_ion`,
#' `retention_time_in_seconds` etc) have to be **fully** spelled out. All
#' parameters are vectorized and recycled as needed to match the number of rows
#' in the abundance matrix, if their length is not equal to the number of rows
#' or 1, an error is raised.
#'
#' See also the [specification of the SMF section](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#64-small-molecule-feature-smf-section)
#' for details.
#'
#' @param x `matrix` or `data.frame` of abundances. Rows are features,
#'   columns are assays. The order of columns is assumed to match the order of
#'   assays defined in the Metadata (MTD) section (see [mtd_assay()] for more
#'   information).
#'
#' @param SME_ID_REFS `character` vector of SME IDs referencing small molecules.
#'   Defaults to `"null"`.
#'
#' @param SME_ID_REF_ambiguity_code `character` vector of ambiguity codes for
#'   SME ID references. Defaults to `"null"`.
#'
#' @param adduct_ion `character` vector of adducts (e.g. `"[M+H]+"`).
#'   Defaults to `"null"`.
#'
#' @param exp_mass_to_charge `numeric` vector of experimental m/z values.
#'   **Cannot** be `NULL`.
#'
#' @param retention_time_in_seconds `numeric` vector of retention times in
#'   seconds. Defaults to `"null"`.
#'
#' @param retention_time_in_seconds_start `numeric` vector of start retention
#'   times in seconds (i.e., start retention time of the chromatographic peak
#'   of feature). Defaults to `"null"`.
#'
#' @param retention_time_in_seconds_end `numeric` vector of end retention times
#'   in seconds (i.e., end retention time of the chromatographic peak or
#'   feature). Defaults to `"null"`.
#'
#' @param charge `integer` vector of charge states. Defaults to `"null"`.
#'
#' @param isotopomer `character` vector for isotopomer description.
#'   Defaults to `"null"`.
#'
#' @param ... Additional optional columns to add. These arguments must be named.
#'   The function will automatically prepend `"opt_"` to the names if not
#'   already present.
#'
#' @return A complete SMF `data.frame` ready for export. The data frame contains
#'   the 'SFH' line prefix, standard columns ordered according to spec,
#'   abundance columns, and any optional columns.
#'
#' @author Philippine Louail
#'
#' @examples
#'
#' ## Assume we have a matrix of abundances (e.g., from xcms or similar tools)
#' ## Rows are features, Columns are Samples/Assays.
#' abund_mat <- matrix(
#'     c(100.1, 105.2, 110.3,
#'       200.5, 198.2, 201.0,
#'       50.0, 55.0, 52.1),
#'     nrow = 3, byrow = TRUE
#' )
#'
#' ## Define feature metadata (vectors must match number of rows in matrix)
#' mz_values <- c(150.05, 200.10, 300.15)
#' rt_values <- c(20.5, 35.1, 40.0)
#' adducts <- c("[M+H]+", "[M+Na]+", "[M+H]+")
#'
#' ## Create the final dataframe ready for export
#' ## Note: Fields not provided (like charge) are automatically set to "null"
#' smf_final <- smf_create(
#'     x = abund_mat,
#'     exp_mass_to_charge = mz_values,
#'     retention_time_in_seconds = rt_values,
#'     adduct_ion = adducts,
#'     ## Optional custom column example
#'     global_custom_attribute = c("A", "B", "C")
#' )
#'
#' ## The result contains the 'SFH' line prefix, standard columns, and
#' ## abundances
#' head(smf_final)
#' @export
smf_create <- function(..., x, exp_mass_to_charge = character(),
                       retention_time_in_seconds = character(),
                       retention_time_in_seconds_start = character(),
                       retention_time_in_seconds_end = character(),
                       SME_ID_REFS = character(),
                       SME_ID_REF_ambiguity_code = character(),
                       charge = character(), adduct_ion = character(),
                       isotopomer = character()) {
    if (!length(exp_mass_to_charge))
        stop("The argument 'exp_mass_to_charge' is mandatory.")

    smf_df <- .abundance_matrix(x)
    cols_to_fill <- list(
        SME_ID_REFS = SME_ID_REFS,
        SME_ID_REF_ambiguity_code = SME_ID_REF_ambiguity_code,
        adduct_ion = adduct_ion,
        isotopomer = isotopomer,
        exp_mass_to_charge = exp_mass_to_charge,
        charge = charge,
        retention_time_in_seconds = retention_time_in_seconds,
        retention_time_in_seconds_start = retention_time_in_seconds_start,
        retention_time_in_seconds_end = retention_time_in_seconds_end
    )

    smf_df$SFH <- "SMF"
    smf_df[names(cols_to_fill)] <- lapply(
        cols_to_fill,
        .fill_column,
        length_out = nrow(smf_df)
    )

    dots <- list(...)
    if (length(dots) > 0) {
        if (is.null(names(dots)) || any(names(dots) == "")) {
            stop("All optional arguments provided in '...' must be named.")
        }
        nms <- names(dots)
        needs_prefix <- !grepl("^opt_", nms)
        nms[needs_prefix] <- paste0("opt_", nms[needs_prefix])
        names(dots) <- nms
        for (i in seq_along(dots)) {
            smf_df[[nms[i]]] <- .fill_column(dots[[i]], nrow(smf_df))
        }
    }

    abundance_cols <- grep("^abundance_assay", names(smf_df), value = TRUE)
    opt_cols <- grep("^opt_", names(smf_df), value = TRUE)
    smf_df[, c(.SMF, abundance_cols, opt_cols)]
}

#' @description
#' Standard SMF column order defined by the mzTab-M specification.
#'
#' @noRd
.SMF <- c(
    "SFH",
    "SMF_ID",
    "SME_ID_REFS",
    "SME_ID_REF_ambiguity_code",
    "adduct_ion",
    "isotopomer",
    "exp_mass_to_charge",
    "charge",
    "retention_time_in_seconds",
    "retention_time_in_seconds_start",
    "retention_time_in_seconds_end"
)

################################################################################
##    Parse SMF section
##
################################################################################
