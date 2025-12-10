## Code related to import/export of the SMF element

#' @title Create the mzTab-M Small Molecule Feature (SMF) Table
#'
#' @name smf_create
#'
#' @description
#'
#' The Small Molecule Feature (SMF) section of the mzTab-M definition captures
#' information on the individual MS features (quantified regions, e.g.,
#' elution profiles of specific m/z and retention times) that were measured
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
#' See also the [specification of the SMF section](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#64-small-molecule-feature-smf-section)
#' for details.
#'
#' @param smf_df `matrix` or `data.frame` of abundances. Rows are features,
#'   columns are assays. The order of columns is assumed to match the order of
#'   assays defined in the Metadata (MTD) section.
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
#'   times in seconds. Defaults to `"null"`.
#'
#' @param retention_time_in_seconds_end `numeric` vector of end retention times
#'   in seconds. Defaults to `"null"`.
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
#' @author Philippine Louail, Johannes Rainer
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
#'     smf_df = abund_mat,
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
smf_create <- function(
    smf_df,
    exp_mass_to_charge = NULL,
    retention_time_in_seconds = NULL,
    retention_time_in_seconds_start = NULL,
    retention_time_in_seconds_end = NULL,
    SME_ID_REFS = NULL,
    SME_ID_REF_ambiguity_code = NULL,
    charge = NULL,
    adduct_ion = NULL,
    isotopomer = NULL,
    ...
) {
    if (is.null(exp_mass_to_charge)) {
        stop(
            "The argument 'exp_mass_to_charge' is mandatory and cannot be NULL."
        )
    }

    smf_df <- .smf_abundance_matrix(smf_df)
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

#' @title Internal helper to format abundance matrix
#'
#' @description
#'
#' `.smf_abundance_matrix()` is a helper function called by [smf_create()].
#' It takes a numeric matrix or data frame of quantification values and
#' converts it into a basic data frame structure for mzTab-M.
#'
#' It performs the following actions:
#'
#' - Generates sequential `SMF_ID`s.
#' - Renames input columns to the strictly required format `abundance_assay[n]`.
#'
#' @param abundance_matrix A `numeric` `matrix` or `data.frame` where rows
#'   represent features and columns represent samples/assays. The order of
#'   columns is assumed to match the order of assays defined in the Metadata
#'   (MTD) section.
#'
#' @return A `data.frame` containing the `SMF_ID` column and the renamed
#'   abundance columns.
#'
#' @author Philippine Louail, Johannes Rainer
#'
#' @noRd
.smf_abundance_matrix <- function(abundance_matrix) {
    if (!is.matrix(abundance_matrix) && !is.data.frame(abundance_matrix)) {
        stop("Input must be a matrix or data frame of abundances.")
    }
    smf_df <- data.frame(
        SMF_ID = seq_len(nrow(abundance_matrix)),
        abundance_matrix,
        check.names = FALSE,
        stringsAsFactors = FALSE
    )
    colnames(smf_df)[-1] <- paste0(
        "abundance_assay[",
        seq_len(ncol(abundance_matrix)),
        "]"
    )
    smf_df
}

#' @description
#' Helper function to recycle inputs or create "null" strings for SMF columns.
#'
#' @param input_data Vector of data to fill or NULL.
#' @param length_out Integer, the number of rows to fill.
#'
#' @noRd
.fill_column <- function(input_data, length_out) {
    if (is.null(input_data)) {
        return(rep("null", length_out))
    }
    input_data[is.na(input_data)] <- "null"
    if (length(input_data) != length_out && length(input_data) != 1) {
        warning(
            "Input length ",
            length(input_data),
            " does not match row count : ",
            length_out
        )
    }
    rep(input_data, length.out = length_out)
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