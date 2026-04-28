## Code related to import/export of the SME table

## internal notes:
##
## - Create SME from user provided info
## - have a helper function that links between SMF/SML and SME?
## - SME should also contain averages/variation for the study variables
##   (defined in the MTD section)
##

################################################################################
##    Create SME section
##
################################################################################

#' @title Creating the mzTab-M Small Molecule (SME) Table
#'
#' @name SME-export
#'
#' @aliases sme_create
#'
#' @aliases sme_sort
#'
#' @description
#'
#' The Small Molecule (SME) table is representing evidence for identifications
#' of small molecules/features, from database search or any other process used
#' to give putative identifications to molecules. In a typical case, each row
#' represents one result from a single search or intepretation of a piece of
#' evidence (e.g. a database search with a fragmentation spectrum). Multiple
#' results from a given input data item (e.g. one fragment spectrum) SHOULD
#' share the same value under `"evidence_input_id"`.
#' The small molecule evidence section MUST always come after the
#' `"Small Molecule Feature"` (SMF) Table. There MUST NOT be any empty cells
#' and missing values MUST be reported using `"null"`. All columns are
#' MANDATORY except for `"opt_"` columns.
#'
#' A detailed description of the SME format and its columns is provided in the
#' [respective section](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#65-small-molecule-evidence-sme-section)
#' of the mzTab-M specification.
#'
#' The functions to create and format the SME content are:
#'
#' - `sme_create()`: provides a simplified workflow to generate this table in a
#'   single step. It takes vectors defining feature properties.
#'
#'   It automatically:
#'
#'   - Adds the required `SME_ID` and standard mzTab-M columns (e.g.,
#'     `evidence_input_id`).
#'   - Populates missing mandatory columns with `"null"` strings to ensure
#'     compliance.
#'   - Sets the line prefix column `SEH` to `"SME"`.
#'   - Orders columns according to the mzTab-M specification.
#'
#'   **Important:** to support the optional additional parameters passed along
#'   with `...` **all** parameters have to be **fully** spelled out. All
#'   parameters are vectorized and recycled as needed to match the number of
#'   rows in the abundance matrix. If their length is not equal to the number
#'   of rows or 1, an error is raised.
#'
#'   See also the [specification of the SMF section](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#65-small-molecule-evidence-sme-section)
#'   for details.
#'
#' - `sme_sort()`: can be used to sort the columns of the SME data frame
#'   according to the standard order defined in the mzTab-M specification.
#'   This is useful if you have added custom columns and want to ensure the
#'   standard columns are in the correct order for export.
#'
#' @param ... optional columns to be added to the SME. The length of arguments
#'     passed through `...` has to match `nrow(x)` and the arguments **have**
#'     to be named. The name of the argument is used for the column name,
#'     prefixed with `"opt_"`.
#'
#' @param evidence_input_id `character` with the file unique identifier for the
#'     input data used to support this identification e.g. fragment spectrum,
#'     RT and m/z pair, isotope profile that was used for the identification
#'     process, to serve as a grouping mechanism, whereby multiple rows of
#'     results from the same input data share the same ID. The identifiers
#'     may be human readable but should not be assumed to be interpretable. For
#'     example, if fragmentation spectra have been searched then the ID may be
#'     the spectrum reference, or for accurate mass search, the
#'     `"ms_run[2]:458.75"`.
#'
#' @param database_identifier `character` with the putative identification for
#'     the small molecule sourced from an external database.
#'     This could include additionally a chemical class or an identifier to a
#'     spectral library entity, even if its actual identity is unknown.
#'     Has to be in the format *<SOURCE>:<ID>* to provide the database/source
#'     of annotation and the ID (e.g. `"HMDB:HMDB0001847"`).
#'     Can be `"null"` or `NA` for molecules without annotations. The length
#'     of `database_identifier` has to match the number of rows of `x`. If not
#'     provided (the default) `"null"` is assigned to each row/molecule.
#'
#' @param chemical_formula `character` with the chemical formula of the
#'     compound. This should be specified in Hill notation (EA Hill 1900), i.e.
#'     elements in the order C, H and then alphabetically all other elements.
#'     Counts of one may be omitted. Elements should be capitalized properly to
#'     avoid confusion (e.g., `“CO”` vs. `“Co”`). The chemical formula reported
#'     should refer to the neutral form. Charge state is reported by the charge
#'     field. For example: `"N-acetylglucosamine"` would be encoded by the
#'     string `“C8H15NO6”`. Can be `"null"` but, if provided, its length has to
#'     match the number of rows of `x`.
#'
#' @param smiles `character` with the potential molecule structures in the
#'     simplified molecular-input line-entry system (SMILES) for the small
#'     molecule. Can be `"null"` but, if provided, its length has to match the
#'     number of rows of `x`.
#'
#' @param inchi `character` with the potential standard IUPAC International
#'     Chemical Identifier (InChI) of the given substance. Can be `"null"` but,
#'     if provided, its length has to match the number of rows of `x`.
#'
#' @param chemical_name `character` with the possible chemical/common names for
#'     the small molecule, or general description if a chemical name is
#'     unavailable. Can be `"null"` but, if provided, its length has to match
#'     the number of rows of `x`.
#'
#' @param uri `character` with the URI pointing to the small molecule’s entry
#'     in a reference database (e.g., the small molecule’s HMDB or KEGG entry).
#'     Can be `"null"` but, if provided, its length has to match the number of
#'     rows of `x`.
#'
#' @param derivatized_form `character` with the derivatized form that has been
#'     analysed by MS, then the functional group attached to the molecule
#'     should be reported using suitable CV terms as appropriate.
#'
#' @param adduct_ions `character()` with the assumed classification of
#'     molecule’s adduct ion after detection, following the general style in
#'     the 2013 IUPAC recommendations on terms relating to MS (e.g.
#'     `"[M+Na]1"`, `"[M+NH4]1+"`, `"[M-H]1-"`, `"[M+Cl]1-"`).
#'     Can be `"null"` (or `NA`) but, if provided, its length has to match the
#'     number of rows of `x`.
#'
#' @param exp_mass_to_charge `numeric` with the experimental mass/charge value
#'     for the precursor ion. If multiple adduct forms have been combined into
#'     a single identification event/search, then a single value e.g. for the
#'     protonated form SHOULD be reported here.
#'
#' @param charge `numeric` with the small molecule evidence’s charge value
#'     using positive integers both for positive and negative polarity modes.
#'
#' @param theoretical_mass_to_charge `numeric` with the theoretical mass/charge
#'     value for the small molecule or the database mass/charge value.
#'
#' @param spectra_ref `character` Reference to a spectrum in a spectrum file.
#'     If a separate spectrum file has been used for fragmentation spectrum,
#'     this MUST be reported in the metadata section as additional ms_runs. The
#'     reference must be in the format `"ms_run[1-n]:{SPECTRA_REF}"`. Multiple
#'     spectra MUST be referenced using a `"|"` delimited list for the (rare)
#'     cases in which search engines have combined or aggregated multiple
#'     spectra in advance of the search to make identifications.
#'     If a fragmentation spectrum has not been used, the value should indicate
#'     the ms_run to which is identification is mapped e.g. `"ms_run[1]"`.
#'
#' @param identification_method `character` with the database search, search
#'     engine or process that was used to identify this small molecule (e.g.
#'     the name of software, database or manual curation etc). If manual
#'     validation has been performed quality, the following CV term SHOULD be
#'     used: `"quality estimation by manual validation"` `MS:1001058`.
#'
#' @param ms_level `character` with the highest MS level used to inform
#'     identification (e.g. from an MS2 fragmentation spectrum =
#'     `""[MS, MS:1000511, ms level, 2]""`. For direct fragmentation
#'     or data independent approaches where fragmentation data is used,
#'     appropriate CV terms SHOULD be used.
#'
#' @param id_confidence_measure `matrix` with any statistical value or score
#'     for the identification. The metadata section reports the type of score
#'     used, as `"id_confidence_measure[1-n]"`.
#'
#' @param rank `numeric`with the rank of this identification from
#'     this approach as increasing integers from 1 (best ranked
#'     identification). Ties (equal score) are represented by using the same
#'     rank, defaults to `"1"` if there is no ranking system used.
#'
#' @param mtd two-column `matrix` or `data.frame` with the metadata (MTD)
#'     definition of the data set. The first column needs to contain the
#'     metadata field names, the second the corresponding values. See
#'     [MTD-export] help page for more information.
#'
#' @param x for `sme_spectra_ref_validator()`: `character` with reference to a
#'     spectrum in a spectrum file.
#'     For `sme_id_confidence_measure()`: `matrix` or `data.frame` with any
#'     statistical value or score for the identification.
#'     For `sml_sort()`: a SML `data.frame`, such as created by `sml_create()`.
#'
#' @param nr `numeric` with the number of small molecule evidence.
#'
#' @return A complete SME `data.frame` ready for export. The data frame contains
#'   the 'SEH' line prefix, standard columns ordered according to spec, and any
#'   optional columns.
#'
#' @details
#'
#' All parameters passed to the `sme_create()` function must be **fully named**.
#'
#' @seealso [MTD-export], [SMF-export] and [SML-export] for creating and
#'     formatting the metadata (MTD), small molecule feature (SMF) and small
#'     molecule (SML) sections.
#'
#' @author Gabriele Tomè
#'
#' @examples
#'
#' ## Define minimum required MTD section
#' mtd <- cbind(c("ms_run[1]-location", "ms_run[1]-format",
#'                "ms_run[1]-id_format", "ms_run[1]-scan_polarity[1]",
#'                "ms_run[2]-location", "ms_run[2]-format",
#'                "ms_run[2]-id_format", "ms_run[2]-scan_polarity[1]",
#'                "ms_run[3]-location", "ms_run[3]-format",
#'                "ms_run[3]-id_format", "ms_run[3]-scan_polarity[1]"),
#'              c("1.mzML", "[MS, MS:1000584, mzML file, ]",
#'                "[MS, MS:1000530, mzML unique identifier, ]",
#'                "[MS, MS:1000130, positive scan, ]",
#'                "2.mzML", "[MS, MS:1000584, mzML file, ]",
#'                "[MS, MS:1000530, mzML unique identifier, ]",
#'                "[MS, MS:1000130, positive scan, ]",
#'                "3.mzML", "[MS, MS:1000584, mzML file, ]",
#'                "[MS, MS:1000530, mzML unique identifier, ]",
#'                "[MS, MS:1000130, positive scan, ]"))
#'
#' ## Define minimum parameter to build SME section
#' evidence_input_id = c("ms_run[1]:mass=700.5255;rt=20·5",
#'                       "ms_run[2]:mass=452.2782;rt=35.1",
#'                       "ms_run[3]:mass=882.6210;rt=40.0")
#' exp_mass_to_charge = c(700.5255, 452.2782, 882.6210)
#' charge = c(1, 1, 1)
#' theoretical_mass_to_charge = c(700.5281, 452.2777, 882.6224)
#' spectra_ref = c("ms_run[1]:index=7646", "ms_run[2]:index=7640",
#'                 "ms_run[3]:index=7671|ms_run[3]:index=7725")
#' identification_method = "[, , LipidDataAnalyzer, 2.11.1]"
#' ms_level = "[MS, MS:1000511, ms level, 2]"
#'
#' ## Create the final dataframe ready for export
#' ## Note: Fields not provided are automatically set to "null"
#' sme_final <- sme_create(
#'     evidence_input_id = evidence_input_id,
#'     exp_mass_to_charge = exp_mass_to_charge,
#'     charge = charge,
#'     theoretical_mass_to_charge = theoretical_mass_to_charge,
#'     spectra_ref = spectra_ref,
#'     identification_method = identification_method,
#'     ms_level = ms_level,
#'     mtd = mtd
#' )
#'
#' ## The result contains the 'SEH' line prefix and standard columns
#' head(sme_final)
#'
#' @export
#'
sme_create <- function(..., evidence_input_id = character(),
                       database_identifier = character(),
                       chemical_formula = character(),
                       smiles = character(), inchi = character(),
                       chemical_name = character(), uri = character(),
                       derivatized_form = character(),
                       adduct_ions = character(),
                       exp_mass_to_charge = numeric(), charge = numeric(),
                       theoretical_mass_to_charge = numeric(),
                       spectra_ref = character(),
                       identification_method = character(),
                       ms_level = character(),
                       id_confidence_measure = NULL,
                       rank = 1, mtd = NULL) {
    if (!length(evidence_input_id))
        stop("The argument 'evidence_input_id' is mandatory.")
    if (!length(exp_mass_to_charge))
        stop("The argument 'exp_mass_to_charge' is mandatory.")
    if (!length(charge))
        stop("The argument 'charge' is mandatory.")
    if (!length(theoretical_mass_to_charge))
        stop("The argument 'theoretical_mass_to_charge' is mandatory.")
    if (!length(spectra_ref))
        stop("The argument 'spectra_ref' is mandatory.")
    if (!length(identification_method))
        stop("The argument 'identification_method' is mandatory.")
    if (!length(ms_level))
        stop("The argument 'ms_level' is mandatory.")
    if (!length(rank))
        stop("The argument 'rank' is mandatory.")
    l = length(evidence_input_id)
    x <- data.frame(SEH = rep("SME", l))
    x$evidence_input_id <- .check_fill_column(evidence_input_id, lout = l)
    x$database_identifier <- .check_fill_column(database_identifier, lout = l)
    x$chemical_formula <- .check_fill_column(chemical_formula, l)
    x$smiles <- .check_fill_column(smiles, l)
    x$inchi <- .check_fill_column(inchi, l)
    x$chemical_name <- .check_fill_column(chemical_name, l)
    x$uri <- .check_fill_column(uri, l)
    x$derivatized_form <- .check_fill_column(derivatized_form, l)
    x$adduct_ions <- .check_fill_column(adduct_ions, l)
    x$exp_mass_to_charge <- .check_fill_column(exp_mass_to_charge, l)
    x$charge <- .check_fill_column(charge, l)
    x$theoretical_mass_to_charge <- .check_fill_column(
                                            theoretical_mass_to_charge, l)

    if(is.null(mtd))
        stop("To add 'spectra_ref' provide a valid MTD section")
    x$spectra_ref <- .check_fill_column(
                        sme_spectra_ref_validator(spectra_ref, mtd), l)
    x$identification_method <- .check_fill_column(identification_method, l)
    x$ms_level <- .check_fill_column(ms_level, l)
    x$rank <- .check_fill_column(rank, l)

    ## Add columns id_confidence_measure[1-n]
    if (!is.null(id_confidence_measure))
        x <- cbind(x, sme_id_confidence_measure(id_confidence_measure, mtd, l))

    ## Add optional columns
    x <- .add_opt_cols(x = x, ...)
    sme_sort(x)
}

#' @export
#'
#' @rdname SME-export
sme_sort <- function(x) {
    x[, .sort_order(colnames(x), .SME_ORDER), drop = FALSE]
}

#' @description
#'
#' Standard SME column order defined by the mzTab-M specification.
#'
#' @noRd
.SME_ORDER <- c(
    "^SEH",
    "^SME_ID",
    "^evidence_input_id",
    "^database_identifier",
    "^chemical_formula",
    "^smiles",
    "^inchi",
    "^chemical_name",
    "^uri",
    "^derivatized_form",
    "^adduct_ions",
    "^exp_mass_to_charge",
    "^charge",
    "^theoretical_mass_to_charge",
    "^spectra_ref",
    "^identification_method",
    "^ms_level",
    "^id_confidence_measure\\[\\d+\\]$",
    "^rank",
    "^opt_"
)

################################################################################
##    Parse SME section
##
#################################################################################' @rdname SME-export
#'
#' @export
sme_id_confidence_measure <- function(x, mtd, nr = numeric()) {
    if (!is.matrix(x))
        x <- as.matrix(x)

    if (nrow(x) != nr)
        stop("Number row in parameter 'id_confidence_measure' has to be ",
             "equal to the number of 'evidence_input_id'", call. = FALSE)

    nc = length(.mtd_get_field(mtd, "id_confidence_measure\\[\\d.*\\]$",
                               exact = FALSE, fixed = FALSE)[[1]])
    if(ncol(x) != nc)
        stop("Number column in parameter 'id_confidence_measure' has to be ",
             "equal to the number of 'id_confidence_measure' in MTD",
             call. = FALSE)

    colnames(x) <- paste0("id_confidence_measure[", seq_len(ncol(x)), "]")
    x
}

#' @rdname SME-export
#'
#' @export
sme_spectra_ref_validator <- function(x, mtd) {
    if (!length(x))
        stop("Provide a vector of \"spectra_ref\"")

    if (!length(mtd))
        stop("Provide a MTD section.")

    n_ms <- .mtd_get_field(mtd, "ms_run\\[\\d.*\\]-location$",
                            exact = FALSE, fixed = FALSE)[[1]]

    if (any(is.na(n_ms)))
        stop("No \"ms_run\" detected in MTD section.")

    n_ms <- length(n_ms)

    ms_runs_ref <- strsplit(x, split = "|", fixed = TRUE)
    ms_runs_valid <- unlist(lapply(ms_runs_ref, function(z) {
            all(grepl(paste0("ms_run\\[", 1:n_ms, "\\]:", collapse = "|"), z))
    }))

    if (!all(ms_runs_valid)) {
        stop("Invalid \"ms_run\" index at position: ",
             paste0(which(!ms_runs_valid), collapse = ", "))
    }
    x
}
