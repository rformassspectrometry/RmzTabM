## Generic helper functions and constant

.prefix_zero <- function(x) {
    sprintf(paste0("%0", ceiling(log10(max(x) + 1)), "d"), x)
}

#' @description
#' Helper function to recycle inputs or create "null" strings for SMF columns.
#'
#' @param input_data Vector of data to fill or NULL.
#' @param length_out Integer, the number of rows to fill.
#'
#' @noRd
.fill_column <- function(input_data, length_out) {
    if (is.null(input_data)) return(rep("null", length_out))

    input_data[is.na(input_data)] <- "null"

    if (length(input_data) != length_out && length(input_data) != 1) {
        warning(sprintf("Input length %d does not match row count %d",
                        length(input_data), length_out))
    }

    return(rep(input_data, length.out = length_out))
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
