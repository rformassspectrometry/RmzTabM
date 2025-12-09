## Code related to import/export of the SMF element

#' @title Defining and exporting the mzTab-M Small Molecule Feature table
#'
#' @name SMF-export
#'
#' @description
#'
#' The Small Molecule Feature (SMF) section of the mzTab-M definition captures
#' information on the individual MS features (quantified regions, e.g.,
#' elution profiles of specific m/z and retention times) that were measured
#' across the assays.
#'
#' The *RmzTabM* package provides a two-step workflow to generate this table:
#'
#' 1. **Skeleton Generation**: [create_basic_smf()] takes a numeric matrix of
#'    abundances (rows=features, columns=assays) and creates the basic data
#'    frame structure with the required `SMF_ID` and formatted abundance columns.
#'
#' 2. **Finalization**: [finalize_smf()] adds the standard mandatory columns
#'    required by the specification (e.g., `exp_mass_to_charge`,
#'    `retention_time_in_seconds`, `charge`) and fills missing values with
#'    "null" strings to ensure compliance with the standard.
#'
#' See also the [specification of the SMF section](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#64-small-molecule-feature-smf-section)
#' for details.
#'
#' @author Philippine Louail, Johannes Rainer
#'
#' @examples
#'
#' ## --------------------------------------------------------------------------
#' ## Step 1: Create the basic structure from quantification data
#' ## --------------------------------------------------------------------------
#'
#' ## Assume we have a matrix of abundances (e.g., from XCMS or similar tools)
#' ## Rows are features, Columns are Samples/Assays.
#' abund_mat <- matrix(
#'     c(100.1, 105.2, 110.3,
#'       200.5, 198.2, 201.0,
#'       50.0, 55.0, 52.1),
#'     nrow = 3, byrow = TRUE
#' )
#'
#' ## Create the skeleton table
#' smf_basic <- create_basic_smf(abund_mat)
#' head(smf_basic)
#'
#' ## --------------------------------------------------------------------------
#' ## Step 2: Finalize with metadata
#' ## --------------------------------------------------------------------------
#'
#' ## Define feature metadata (vectors must match number of rows in matrix)
#' mz_values <- c(150.05, 200.10, 300.15)
#' rt_values <- c(20.5, 35.1, 40.0)
#' adducts <- c("[M+H]+", "[M+Na]+", "[M+H]+")
#'
#' ## Create the final dataframe ready for export
#' ## Note: Fields not provided (like charge) are automatically set to "null"
#' smf_final <- finalize_smf(
#'     smf_df = smf_basic,
#'     exp_mass_to_charge = mz_values,
#'     retention_time_in_seconds = rt_values,
#'     adduct_ion = adducts
#' )
#'
#' ## The result contains the 'SFH' line prefix, standard columns, and
#' ## abundances
#' head(smf_final)
NULL

#' @title Create a skeleton SMF table from an abundance matrix
#'
#' @description
#'
#' `create_basic_smf()` is the first step in the SMF export workflow. It takes
#' a numeric matrix or data frame of quantification values and converts it into
#' the basic mzTab-M structure.
#'
#' It performs the following actions:
#' * Generates sequential `SMF_ID`s.
#' * Renames input columns to the strictly required format `abundance_assay[n]`.
#' * Preserves the numeric data structure.
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
#' @seealso [finalize_smf()] for the second step of the workflow.
#'
#' @export
create_basic_smf <- function(abundance_matrix) {
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

    return(smf_df)
}

#' @title Finalize SMF Table with Mandatory Columns
#'
#' @description
#'
#' `finalize_smf()` completes the SMF table by adding the standard mzTab-M
#' columns required by the specification. It accepts the skeleton data frame
#' created by [create_basic_smf()] and various vectors describing the features.
#'
#' Any mandatory column that is not provided (i.e., left as `NULL`) will be
#' populated with the string `"null"`, ensuring the output is valid mzTab-M
#' (where missing values must be explicit).
#'
#' @param smf_df `data.frame`. The result from [create_basic_smf()].
#'
#' @param exp_mass_to_charge `numeric` vector of experimental m/z values.
#'   Defaults to `"null"`.
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
#' @param adduct_ion `character` vector of adducts (e.g. `"[M+H]+"`).
#'   Defaults to `"null"`.
#'
#' @param isotopomer `character` vector for isotopomer description.
#'   Defaults to `"null"`.
#'
#' @return A complete SMF `data.frame` with the line prefix column `SFH` set
#'   to `"SMF"`. Columns are ordered according to the mzTab-M specification.
#'   Missing values are represented as literal `"null"` strings.
#'
#' @author Philippine Louail, Johannes Rainer
#'
#' @export
finalize_smf <- function(smf_df,
                         exp_mass_to_charge = NULL,
                         retention_time_in_seconds = NULL,
                         retention_time_in_seconds_start = NULL,
                         retention_time_in_seconds_end = NULL,
                         charge = NULL,
                         adduct_ion = NULL,
                         isotopomer = NULL) {

    cols_to_fill <- list(
        SME_ID_REFS = NULL,
        SME_ID_REF_ambiguity_code = NULL,
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
    abundance_cols <- grep("^abundance_assay", names(smf_df), value = TRUE)
    opt_cols <- grep("^opt_", names(smf_df), value = TRUE)

    return(smf_df[, c(.SMF, abundance_cols, opt_cols)])
}
