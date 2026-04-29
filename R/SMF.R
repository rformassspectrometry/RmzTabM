## Code related to import/export of the SMF element

################################################################################
##    Create SMF section
##
################################################################################

#' @title Create the mzTab-M Small Molecule Feature (SMF) Table
#'
#' @name SMF-export
#'
#' @aliases smf_create
#'
#' @description
#'
#' The Small Molecule Feature (SMF) section of the mzTab-M definition captures
#' information on the individual MS features (quantified regions, e.g.,
#' elution profiles of specific *m/z* and retention times) that were measured
#' across the assays.
#'
#' - `smf_create()` provides a simplified workflow to generate this table in a
#'   single step. It takes a matrix of abundances (rows=features,
#'   columns=assays) and optional vectors defining feature properties.
#'
#'   It automatically:
#'
#'   - Formats the abundance matrix (renaming columns to `abundance_assay[n]`).
#'   - Adds the required `SMF_ID` and standard mzTab-M columns (e.g.,
#'     `exp_mass_to_charge`).
#'   - Populates missing mandatory columns with `"null"` strings to ensure
#'     compliance.
#'   - Sets the line prefix column `SFH` to `"SMF"`.
#'   - Orders columns according to the mzTab-M specification.
#'
#'   **Important:** to support the optional additional parameters passed along
#'   with `...` **all** parameters (such as `adduct_ion`,
#'   `retention_time_in_seconds` etc) have to be **fully** spelled out. All
#'   parameters are vectorized and recycled as needed to match the number of rows
#'   in the abundance matrix. If their length is not equal to the number of rows
#'   or 1, an error is raised.
#'
#'   See also the [specification of the SMF section](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#64-small-molecule-feature-smf-section)
#'   for details.
#'
#' - `smf_sort()` can be used to sort the columns of the SMF data frame
#'   according to the standard order defined in the mzTab-M specification.
#'   This is useful if you have added custom columns and want to ensure the
#'   standard columns are in the correct order for export.
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
#' @param exp_mass_to_charge `numeric` vector of experimental m/z values. This
#'   parameter **must** be provided and can not contain any missing values. Its
#'   length has to match `nrow(x)`
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
#' @details
#'
#' All parameters passed to the `smf_create()` function must be **fully named**.
#'
#' @author Philippine Louail
#'
#' @seealso [MTD-export] and [SML-export] for creating and formatting the
#'     metadata (MTD) and small molecule (SML) sections.
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
#'
#' @export
smf_create <- function(..., x, exp_mass_to_charge = numeric(),
                       retention_time_in_seconds = numeric(),
                       retention_time_in_seconds_start = numeric(),
                       retention_time_in_seconds_end = numeric(),
                       SME_ID_REFS = character(),
                       SME_ID_REF_ambiguity_code = character(),
                       charge = numeric(), adduct_ion = character(),
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
    smf_df[names(cols_to_fill)] <- lapply(cols_to_fill, .check_fill_column,
                                          lout = nrow(smf_df))
    smf_df <- .add_opt_cols(x = smf_df, ...)
    smf_sort(smf_df)
}

#' @export
#'
#' @rdname SMF-export
smf_sort <- function(x) {
    x[, .sort_order(colnames(x), .SMF_ORDER), drop = FALSE]
}

#' @description
#' Standard SMF column order defined by the mzTab-M specification.
#'
#' @noRd
.SMF_ORDER <- c(
    "^SFH",
    "^SMF_ID",
    "^SME_ID_REFS",
    "^SME_ID_REF_ambiguity_code",
    "^adduct_ion",
    "^isotopomer",
    "^exp_mass_to_charge",
    "^charge",
    "^retention_time_in_seconds",
    "^retention_time_in_seconds_start",
    "^retention_time_in_seconds_end",
    "^abundance_assay\\[\\d+\\]$",
    "^opt_"
)

################################################################################
##    Parse SMF section
##
################################################################################
