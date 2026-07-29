## Functions and methods to build an mzTab-M from a  `SummarizedExperiment`

#' @title Create a mzTab-M file from a `SummarizedExperiment` object
#'
#' @name SummarizedExperiment-mzTab-M
#'
#' @description
#'
#' The `MzTabM()` method for the [SummarizedExperiment::SummarizedExperiment]
#' class compiles a [MzTabM] data object from the content and data of the
#' `SummarizedExperiment` object passed through the function's first parameter
#' (`mtd`). The function extracts relevant information from the
#' `SummarizedExperiment`'s `rowData()` and `colData()`. The
#' `SummarizedExperiment`'s `rowData()` is expected to contain necessary
#' information to characterize the individual features. The `colData()` should
#' provide experiment and sample information for the mzTab-M metadata section.
#' `MzTabM()` uses the [mtdFromSampleData()] and `smf()` method (described
#' below) to compile the mzTab-M's MTD and SMF sections, respectively.
#'
#' - **MTD** section: information is extracted from the `SummarizedExperiment`'s
#'   `colData()`. If not already present, relevant and required information
#'   should be added to the `colData()`. The [mtdFromSampleData()] function is
#'   used to extract and compile the MTD section.
#'
#' - **SMF** section: the small molecule feature section is compiled from the
#'   `SummarizedExperiment`'s `rowData()` (for feature characteristics) and
#'   `assay()` (abundance matrix). The `smfCols.` parameter of the `smf()` and
#'   `MzTabM()` methods allows to define the mapping between feature *fields*
#'   and column names of the `rowData()` containing the relevant information.
#'
#' @section Generate mzTab-M content from a `SummarizedExperiment`:
#'
#' - `MzTabM()`: function to compile a [MzTabM] object from the information
#'   available in the `SummarizedExperiment`. The resulting `MzTabM` object
#'   should be completed by adding additional metadata through e.g.
#'   [setMtdInstrument()], [setMtdDatabase()], [setMtdCv()], [setMtdContact()],
#'   [setMtdProtocol()] or [setMtdField()]. See [mtdFromSampleData()] for
#'   details and parameters to compile the MTD section. See `smf()` below for
#'   information and parameters to compile the SMF section. Note that the SMF
#'   section is only created if `smfCols.` is defined and not empty.
#'   See [MTD-export] for more details on the mzTab-M metadata and [SMF-export]
#'   for fields/columns to characterize features in an SMF section.
#'
#' - `smf()`: generate a SMF matrix from a `SummarizedExperiment`. The
#'   `SummarizedExperiment`'s *assay* containing the feature abundances can be
#'   specified with parameter `assayName` which defaults to `assayName = 1L`
#'   hence using the first assay. Use `assayNames()` on the
#'   `SummarizedExperiment` to list all available assays. Parameter `smfCols.`
#'   defines the mapping between SMF field names and column names in the
#'   `SummarizedExperiment`'s `rowData()`. The `smfCols()` function can be used
#'   to assist compiling this mapping. SMF field *exp_mass_to_charge* is
#'   mandatory. See also [SMF-export] for details and description of the
#'   individual fields.
#'
#' - `smfCols()`: allows to define which columns of the `SummarizedExperiment`'s
#'   `rowData()` should be used as columns characterizing the features in the
#'   mzTab-M SMF section. Each argument of the function (such as
#'   `exp_mass_to_charge`) represents one of the mzTab-M SMF fields (columns).
#'   Using e.g. `exp_mass_to_charge = "mzmed"` would use the `"mzmed"` column
#'   of the `rowData()` as `exp_mass_to_charge` field/column of the mzTab-M SMF
#'   section. See [SMF-export] for details on the individual SMF fields.
#'
#' @param adduct_ion For `smfCols()`: `character(1)` defining the column name
#'     in the `SummarizedExperiment`'s `rowData()` containing information on
#'     the adduct/ion for each feature. Optional.
#'
#' @param assayName For `MzTabM()` or `smf()`: a `character(1)` defining the
#'     name of the `SummarizedExperiment`'s assay that contains the abundances.
#'
#' @param assayCols. named `character` vector defining the columns in the
#'     `SummarizedExperiment`'s `colData()` containing information for the
#'     individual assays fields (with names being the name of the mzTab-M field
#'     and values the respective column name in `colData()`). Parameter/field
#'     `assay` is mandatory. The [assayCols()] function can be used to assist
#'     compiling this parameter. See [mtdAssay()] and
#'     [mtdFromSampleData()] for more information.
#'
#' @param charge For `smfCols()`: `character(1)` defining the column name in
#'     the `SummarizedExperiment`'s `rowData()` containing the information on
#'     the features' charge state (integer). Optional.
#'
#' @param exp_mass_to_charge For `smfCols()`: `character(1)` defining the
#'     column name in the `SummarizedExperiment`'s `rowData()` containing the
#'     information on the features' m/z. **Mandatory**.
#'
#' @param group_datatype For `MzTabM()`: optional `character` defining the data
#'     type of the values (i.e., study variables) for the study variable group.
#'     If provided, its length has to match the length of paramter `groups`.
#'     Supported values are `"xsd:string"`, `"xsd:integer"`, `"xsd:decimal"`,
#'     `"xsd:boolean"`, `"xsd:date"`, `"xsd:time"`, `"xsd:dateTime"`,
#'     `"xsd:anyURI"`, and `"Parameter"` (for *CV Parameters*). Date, time and
#'     dateTime values **must** be encoded in ISO 8601 format. If not provided
#'     the type is guessed by the data type of the respective column in the
#'     `SummarizedExperiment`'s `colData()`.
#'
#' @param group_description For `MzTabM()`: `character` with an optional
#'     description of each study variable group. If provided its length has to
#'     match the length of parameter `groups`.
#'
#' @param group_type For `MzTabM()`: `character` defining the type for each
#'     study variable group. If provided its length has to match the length of
#'     parameter `groups`. Supported values are
#'     `"[STATO, STATO:0000252, categorical variable, ]"`,
#'     `"[STATO, STATO:0000228, ordinal variable, ]"` and
#'     `"[STATO, STATO:0000251, continuous variable, ]"` for categorical,
#'     ordinal or numerical values, respectively. If not provided (the default)
#'     the study variable group type will be inferred from the data type of the
#'     respective columns in the `SummarizeExperiment`'s `colData()`.
#'
#' @param group_unit For `MzTabM()`: optional `character` defining the unit of
#'     the group variable (for numeric data types). If provided, its length has
#'     to match the length of parameter `groups`. `NA` or `""` has to be
#'     provided for groups for which no unit should be reported. By default
#'     (`group_unit = character()`) no unit is reported for any group.
#'
#' @param groups For `MzTabM()`: `character` with the name(s) of the column(s)
#'     in the `SummarizedExperiment`'s `colData()` that should be used as
#'     *study variable groups*. If not defined (the default) a single study
#'     variable group `"undefined"` and single study variable
#'     `"undefined"` will be used.
#'
#' @param id For `MzTabM()`: `character(1)` with an ID for the mzTab-M file.
#'     **Mandatory**.
#'
#' @param isotopomer For `smfCols()`: `character(1)` defining the column name in
#'     the `SummarizedExperiment`'s `rowData()` containing the information on
#'     the features' isotopomer description. Optional.
#'
#' @param opt_identifier `character` with the identifier to be used for optional
#'     columns passed through `...`. This is used to create the column names for
#'     optional columns in the format `opt_{opt_identifier}_{column_name}`. If
#'     not provided, the default is `"global"`. Must be of length 1 or matching
#'     the number of opt columns provided in `...`. Optional.
#'
#' @param msRunCols. named `character` vector defining the columns in the
#'     `SummarizedExperiment`'s `colData()` containing information on the MS
#'     runs (with names being the name of the mzTab-M field and values the
#'     respective column name in `colData()`). Required fields/parameters are
#'     `location` and `scan_polarity`. The [msRunCols()] function can be used
#'     to define this parameter. See also [mtdMsRun()] and
#'     [mtdFromSampleData()] for more information.
#'
#' @param mtd For `MzTabM()`: `SummarizedExperiment` containing all information
#'     to compile the `MzTabM` object.
#'
#' @param object A `SummarizedExperiment`.
#'
#' @param retention_time_in_seconds For `smfCols()`: `character(1)` defining the
#'     column name in the `SummarizedExperiment`'s `rowData()` containing the
#'     retention times of the features. Optional
#'
#' @param retention_time_in_seconds_start For `smfCols()`: `character(1)`
#'     defining the column name in the `SummarizedExperiment`'s `rowData()`
#'     with the retention time start of the features' chromatographic signal.
#'     Optional.
#'
#' @param retention_time_in_seconds_end For `smfCols()`: `character(1)`
#'     defining the column name in the `SummarizedExperiment`'s `rowData()`
#'     with the retention time end of the features' chromatographic signal.
#'     Optional.
#'
#' @param sampleCols. named `character` vector defining the columns in the
#'     `SummarizedExperiment`'s `colData()` containing information for the
#'     individual sample fields (with names being the name of the mzTab-M field
#'     and values the respective column name in `colData()`). The
#'     [sampleCols()] function can be used to define this parameter. See also
#'     [mtdSample()] and [mtdFromSampleData()] for more information.
#'
#' @param SME_ID_REFS For `smfCols()`: `character(1)` defining the column name
#'     in the `SummarizedExperiment`'s `rowData()` providing the references
#'     to rows in the *small molecule evidence* (SME) section.
#'
#' @param SME_ID_REF_ambiguity_code For `smfCols`: `character(1)` defining the
#'     column name in the `SummarizedExperiment`'s `rowData()` with ambiguity
#'     codes for SME ID references.
#'
#' @param smfCols. For `MzTabM()` and `smf()`: named `character` defining which
#'     column names in the `SummarizedExperiment`'s `rowData()` (values of
#'     `smfCols.`) contain information for which feature characteristics
#'     (names of `smfCols.`).
#'     Mappings to columns not present in the `SummarizedExperiment`'s
#'     `rowData()` are ignored. Supports also the definition of additional,
#'     optional columns to be added as *opt* columns to the SMF section. For
#'     `MzTabM()`: an empty `character()` (the default) will skip generation
#'     of the SMF section.
#'
#' @param ... For `MzTabM()`: additional arguments to be passed to
#'     [mtdFromSampleData()] such as `average_function`, `variation_function`
#'     or `description`
#'
#' @return
#'
#' - The `MzTabM()` function returns a [MzTabM] object.
#'
#' - `smfCols()` returns a named `character` vector.
#'
#' - `smf()` returns a `data.frame`.
#'
#' @author Johannes Rainer, Philippine Louail, Gabriele Tomè
#'
#' @examples
#'
#' ## Load an example `SummarizedExperiment`: contains the results from the
#' ## xcms-based preprocessing and data analysis described in Metabonaut
#' library(SummarizedExperiment)
#' data(se)
#' se
#'
#' ## Information on the features:
#' rowData(se)
#'
#' ## Available information on samples/MS runs:
#' colData(se)
#'
#' ## Available abundance assays:
#' assayNames(se)
#'
#' #############################################################################
#' ## Create a `MzTabM` object with only metadata defined
#'
#' ## Metadata information is extracted from the `SummarizedExperiment`'s
#' ## `colData()` which is expected to contain the relevant information to
#' ## define and characterize the MS runs, the assays, the samples and the
#' ## experimental/phenotypic conditions. The mapping between the MTD fields
#' ## and the column names in `colData()` can be configured with parameters
#' ## `sampleCols.`, `msRunCols.` and `assayCols.`. We use the respective
#' ## helper functions to define these mappings:
#'
#' ## We use available `colData()` columns `"sample_name"`, `"species"` and
#' ## `"tissue"` for the MTD sample fields *sample*, *species* and *tissue*:
#' s_cols <- sampleCols(sample = "sample_name", species = "species",
#'     tissue = "tissue")
#'
#' ## We use `colData()` columns `"derived_spectra_data_file"` for *location*
#' ## (i.e., the originating MS data file) and `"polarity"` for the
#' ## *scan_polarity* field:
#' m_cols <- msRunCols(location = "derived_spectra_data_file",
#'     scan_polarity = "polarity")
#'
#' ## For the present data set one MS run corresponds to one *assay*, hence we
#' ## use also the MS data file name for the MTD field *assay*:
#' a_cols <- assayCols(assay = "derived_spectra_data_file")
#'
#' ## For the experimental design we use columns `"phenotype"` and `"age"`,
#' ## which we provide with parameter `groups`. Having all these parameters
#' ## defined we create now a `MzTabM` from the `SummarizedExperiment`:
#' m <- MzTabM(se, id = "MTBLS8735", sampleCols. = s_cols, msRunCols. = m_cols,
#'     assayCols. = a_cols, groups = c("phenotype", "age"))
#' m
#' head(mtd(m))
#'
#' ## Importantly, depending on the provided information, the MTD section might
#' ## be needed to be completed. See also the help for `MzTabM` for more
#' ## information and helper functions to add/replace metadata content.
#'
#' #############################################################################
#' ## Create a `MzTabM` with MTD + SMF
#'
#' ## We need to specify which columns in the `SummarizedExperiment`'s
#' ## `rowData()` contain information characterizing the individual features.
#' colnames(rowData(se))
#'
#' ## - *mzmed* defines the features *m/z* value and can be mapped to the SMF
#' ##   field (column) *exp_mass_to_charge*.
#' ## - *rtmed* reports the median retention time of the feature and can be
#' ##   used for the SMF field *retention_time_in_seconds*.
#' ## We will in addition add an optional field *feature_id* to report and add
#' ## the IDs of the individual features from the `SummarizedExperiment`:
#' ## add a column `"feature_id"` to the `rowData()`
#' rowData(se)$feature_id <- rownames(se)
#'
#' ## Define the mapping of SMF fields to `rowData()` columns:
#' smf_cols <- smfCols(exp_mass_to_charge = "mzmed",
#'     retention_time_in_seconds = "rtmed", feature_id = "feature_id")
#'
#' ## We can use the `smf()` function to create the SMF section. For the
#' ## SMF abundances we use the data from the `"raw_filled"` assay
#' assayNames(se)
#'
#' tmp <- smf(se, assayName = "raw_filled", smfCols. = smf_cols)
#' head(tmp)
#'
#' ## We use the same parameters in the `MzTabM()` function to create a mzTab-M
#' ## with MTD + SMF content. For the MTD we re-use all parameters defined above
#' m <- MzTabM(se, id = "MTBLS8735", sampleCols. = s_cols, msRunCols. = m_cols,
#'     assayCols. = a_cols, groups = c("phenotype", "age"),
#'     assayName = "raw_filled", smfCols. = smf_cols)
#' m
#' head(smf(m))
NULL

#' @rdname SummarizedExperiment-mzTab-M
#'
#' @importFrom SummarizedExperiment assayNames
#'
#' @importMethodsFrom SummarizedExperiment rowData
#'
#' @importMethodsFrom SummarizedExperiment colData
#'
#' @importFrom utils packageVersion
setMethod("MzTabM", signature(mtd = "SummarizedExperiment"),
          function(mtd, id = character(),
                   sampleCols. = sampleCols(), msRunCols. = msRunCols(),
                   assayCols. = assayCols(), groups = character(),
                   group_description = character(), group_type = character(),
                   group_datatype = character(), group_unit = character(),
                   smfCols. = character(), assayName = 1L, ...) {
              m <- mtdSkeleton(
                  id = id,
                  software = paste0(
                      "[,,RmzTabM,RmzTabM version ",
                      as.character(packageVersion("RmzTabM")), "]"))
              m <- rbind(m, mtdFromSampleData(
                  as.data.frame(colData(mtd)), sampleCols. = sampleCols.,
                  msRunCols. = msRunCols., assayCols. = assayCols.,
                  groups = groups, group_description = group_description,
                  group_type = group_type, group_datatype = group_datatype,
                  group_unit = group_unit, ...))
              res <- MzTabM(mtd = mtdSort(m))
              if (length(smfCols.))
                  res@smf <- .smf_from_summarized_experiment(
                      mtd, smfCols. = smfCols., assayName = assayName)
              res
          })

#' @rdname SummarizedExperiment-mzTab-M
#'
#' @exportMethod smf
setMethod("smf", signature(object = "SummarizedExperiment"),
          function(object, smfCols. = smfCols(), assayName = 1L) {
              .smf_from_summarized_experiment(object, smfCols. = smfCols.,
                                              assayName = assayName)
          })


#' @title Convert mzTabM object to SummarizedExperiment
#'
#' @rdname SummarizedExperiment-mzTab-M
#'
#' @description
#'
#' `makeSummarizedExperimentFromMzTabM` converts the content of an `MzTabM`
#' object into a `SummarizedExperiment` object. Sample information is extracted
#' from the *MTD* (metadata) section and used to populate the `colData` of the
#' resulting object, while feature-level quantification values and feature
#' annotations are extracted from the *SMF* section and used to populate the
#' assay data and `rowData`, respectively.
#' If the `MzTabM` object does not contain any small molecule feature data, a
#' `SummarizedExperiment` with only `colData` populated is returned.
#'
#' @param mzt A `MzTabM` object.
#'
#' @param assayName `character(1)` defining the name of the assay to be used
#'     for the `SummarizedExperiment` assay. Defaults to `1L`.
#'
#' @param rowIdCol `character(1)` defining the column name in the SMF section
#'     which should be used as row names for the `SummarizedExperiment`.
#'     Defaults to `"SMF_ID"`.
#'
#' @param smfCols. named `character` defining which SMF section columns should
#'     be use to characterize each feature.
#'
#' @return A `SummarizedExperiment` object.
#'
#' @importFrom SummarizedExperiment SummarizedExperiment
#'
#' @importMethodsFrom SummarizedExperiment rowData
#'
#' @importMethodsFrom SummarizedExperiment colData
#'
#' @importFrom stats setNames
#'
#' @importFrom stats reshape
#'
#' @author Gabriele Tomè
#'
#' @export
makeSummarizedExperimentFromMzTabM <- function(mzt, assayName = 1L,
                                    rowIdCol = "SMF_ID", smfCols. = smfCols()) {
    ## Extract sampleData from MTD section
    sampleData <- mtdToSampleData(mtd(mzt))
    se <- SummarizedExperiment(colData = sampleData)

    ## If SMF section is present add as assay
    if (nrow(smf(mzt))){
        smf <- smf(mzt)
        if (is.matrix(smf))
            smf <- as.data.frame(smf, stringsAsFactors = FALSE)
        smf$SFH <- NULL

        if (rowIdCol != "SMF_ID" && !rowIdCol %in% colnames(smf))
            stop("Column '", rowIdCol, "' not found in the SMF section.",
                call. = FALSE)

        if (rowIdCol != "SMF_ID")
            rownames(smf) <- smf[, rowIdCol]

        featureData <- .smfToFeatureData(smf, smfCols. = smfCols.)
        assayData <- .smfToAssayData(smf, sampleData = sampleData)

        sampleData  <- sampleData[colnames(assayData), , drop = FALSE]
        se <- SummarizedExperiment(
            assays = setNames(list(assayData), assayName),
            rowData = featureData,
            colData = sampleData)
    }
    se
}

#' @rdname SummarizedExperiment-mzTab-M
#'
#' @export
smfCols <- function(exp_mass_to_charge = "exp_mass_to_charge",
                    retention_time_in_seconds = "retention_time_in_seconds",
                    retention_time_in_seconds_start = "retention_time_in_seconds_start",
                    retention_time_in_seconds_end = "retention_time_in_seconds_end",
                    SME_ID_REFS = "SME_ID_REFS",
                    SME_ID_REF_ambiguity_code = "SME_ID_REF_ambiguity_code",
                    charge = "charge",
                    adduct_ion = "adduct_ion",
                    isotopomer = "isotopomer", opt_identifier = "global", ...) {
    dots <- list(...)
    opt_cn <- as.character(dots)
    names(opt_cn) <- names(dots)
    c(exp_mass_to_charge = exp_mass_to_charge,
      retention_time_in_seconds = retention_time_in_seconds,
      retention_time_in_seconds_start = retention_time_in_seconds_start,
      retention_time_in_seconds_end = retention_time_in_seconds_end,
      SME_ID_REFS = SME_ID_REFS,
      SME_ID_REF_ambiguity_code = SME_ID_REF_ambiguity_code,
      charge = charge,
      adduct_ion = adduct_ion,
      isotopomer = isotopomer,
      opt_identifier = opt_identifier,
      opt_cn)
}

#' @param x `SummarizedExperiment`
#'
#' @param smfCols. named `character` defining which `rowData()` columns should
#'     be used to characterize each feature.
#'
#' @param assayName `character(1)` defining the name of the `assay()` containing
#'     the feature abundances.
#'
#' @importFrom SummarizedExperiment assayNames
#'
#' @importFrom SummarizedExperiment rowData
#'
#' @importFrom SummarizedExperiment assay
#'
#' @noRd
.smf_from_summarized_experiment <- function(x, smfCols. = smfCols(),
                                            assayName = 1L) {
    if (is.character(assayName) && !assayName %in% assayNames(x))
        stop("Assay '", assayName, "' not found. Please use one of the ",
             "assay names reported by 'assayNames()'", call. = FALSE)
    if (!any(names(smfCols.) %in% "exp_mass_to_charge") ||
        !any(colnames(rowData(x)) %in% smfCols.["exp_mass_to_charge"]))
        stop("Column \"", smfCols.["exp_mass_to_charge"], "\" not found in ",
             "the object's 'rowData()'. This column is mandatory. Please ",
             "provide the respective column name with ",
             "'smfCols. = smfCols(exp_mass_to_charge = <column name>, ...)'.",
             call. = FALSE)
    smfCols. <- smfCols.[smfCols. %in% colnames(rowData(x))]
    xcols <- rowData(x)[, smfCols., drop = FALSE]
    colnames(xcols) <- names(smfCols.)
    do.call(smfCreate, c(list(x = as.matrix(assay(x, assayName))),
                         as.list(xcols)))
}

#' Helper function to convert a long format MTD section to a wide format
#' `data.frame`.
#'
#' The function takes a two columns `data.frame` containing a subsection of the
#' MTD section in long format and return a `data,frame` in wide format with one
#' row per `id`.
#'
#' @param mtd_sub 2-column `data.frame` containing a subsection of the MTD
#'     section.
#'
#' @return `data.frame` in wide format with one row per `id`.
#'
#' @author Gabriele Tomè
#'
#' @noRd
.mtd_long_to_wide <- function(mtd_sub) {
    df_l <- data.frame(id = sub("^([^-]+)(-.*)?$", "\\1", mtd_sub[, 1]),
                        field = sub("^[^-]+-?", "", mtd_sub[, 1]),
                        value = mtd_sub[, 2])
    if (any(df_l$field == ""))
        df_l[df_l$field == "", "field"] <- "name"
    df_w <- reshape(df_l, idvar = "id", timevar = "field", direction = "wide")
    colnames(df_w) <- sub("^value\\.", "", colnames(df_w))
    df_w
}

#' Helper function to extract the feature data from a SMF section and convert it
#' to a `data.frame` suitable for the `rowData()` of a `SummarizedExperiment`.
#'
#' The resulting `data.frame` contains all columns of the SMF section except for
#' the abundance assay columns (i.e., columns starting with `"abundance_"`) and
#' the columns with all values being `"null"`.
#' The column names are renamed according to the mapping provided in `smfCols.`.
#'
#' @param smf `data.frame` containing the SMF section.
#'
#' @param smfCols. named `character` defining which SMF section columns should
#'     be use to characterize each feature.
#'
#' @return `data.frame` suitable for the `rowData()` of a
#'     `SummarizedExperiment`.
#'
#' @importFrom data.table setnames
#'
#' @author Gabriele Tomè
#'
#' @noRd
.smfToFeatureData <- function(smf, smfCols. = smfCols()) {
    ## Recover the rowData columns
    rowdata_df <- smf[, !grepl("^abundance_", names(smf))]
    rowdata_df <- rowdata_df[, !vapply(rowdata_df,
                                        function(col) all(col == "null"),
                                        FUN.VALUE = logical(1)),
                                drop = FALSE]
    setnames(rowdata_df, names(smfCols.), smfCols., skip_absent = TRUE)

    data.frame(rowdata_df, row.names = rownames(smf))
}

#' Helper function to extract the abundance assay data from a SMF section and
#' convert it to a `data.frame` suitable for `SummarizedExperiment`.
#'
#' The resulting `data.frame` contains only the abundance assay columns (i.e.,
#' columns starting with `"abundance_assay"`) and the values are converted to
#' `numeric`.
#' The column names are renamed according to the rownames provided in the
#' `sampleData` `data.frame`.
#'
#' @param smf `data.frame` containing the SMF section.
#'
#' @param sampleData `data.frame` of the `SummarizedExperiment`'s `colData()`.
#'
#' @return `data.frame` containing the `SummarizedExperiment` `assay`.
#'
#' @author Gabriele Tomè
#'
#' @noRd
.smfToAssayData <- function(smf, sampleData) {
    ## Recover the abundance assay columns
    assay_df <- smf[, grepl("^abundance_assay", names(smf))]
    assay_df[assay_df == "null"] <- NA
    assay <- do.call(cbind, lapply(assay_df, as.numeric))
    rownames(assay) <- rownames(smf)

    ## Rename with the assay names from the sampleData
    colnames(assay) <- sub("^abundance_", "", colnames(assay))
    colnames(assay) <- rownames(sampleData)[match(colnames(assay),
                                                  sampleData$id)]

    data.frame(assay)
}
