## Code related to import/export of the MTD element

################################################################################
##    Create MTD section
##
################################################################################

#' @title Defining and exporting the mzTab-M metadata table
#'
#' @name MTD-export
#'
#' @description
#'
#' The metadata section/table of the mzTab-M definition is comprehensive, but
#' also tricky to define. The *RmzTabM* package provides a variety of utility
#' functions that help defining this information. These might be re-used for
#' software package developers to export metabolomics results from their
#' respective software. Importantly, the helper functions listed here only
#' define the core elements for the MTD section, helping with re-arranging and
#' reformatting information available e.g. in `data.frame` format into the
#' respective fields in the MTD section. Additional (optional) fields might
#' need to be added manually depending on availability for an experiment.
#'
#' See also the [specification of the MTD section](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section)
#' for details and more information, in particular on the format of the mzTab-M
#' and on mandatory or optional fields.
#'
#' Generally, MTD data can be categorized into the following parts:
#'
#' - *Core information*: general information on the experiment. A minimal
#'   set can be created using the [mtdSkeleton()] function, which might be
#'   further expanded with additional fields. This section allows to describe
#'   the general experimental setup. Also, it should contain references to
#'   **all** controlled vocabulary (CV) ontologies used and refered to in the
#'   mzTab-M file.
#'
#' - *Sample information*: optional information on individual samples that were
#'   measured with the various *assays*/*runs*. The [mtdSample()] function
#'   assists in compiling the information for this section.
#'
#' - *MS run information*: information on the individual MS *runs*
#'   (measurements of the samples). Each data file is one run. Use the
#'   [mtdMsRun()] function to define this part of the metadata section.
#'
#' - *Assay information*: the [mtdAssay()] function assists in compiling the
#'   assay section of the metadata. Mandatory fields are the name (ID) of the
#'   assay and the reference to the *MS run* in which the assay was measured.
#'   Optional information on sample reference, external links or custom
#'   information can be provided too. In most cases (except multiplexed assays
#'   or pre-fractionated samples) one assay will link to one MS run. Each assay
#'   **must** represent one column in the following *abundance matrix* sections.
#'
#' - *Study variable information*: the [mtdStudyVariables()] function allows
#'   to format study variable information from an experiment into the mzTab-M
#'   format. All study variables need to be assigned to at least one assay and
#'   must also be reported in the subsequent abundance matrices.
#'
#' The helper function listed above can be used sequentially to create the
#' metadata information. See the examples below for a general approach how to
#' define the MTD section of an experiment.
#'
#' In addition, various helper functions are available to assist in MTD data
#' generation:
#'
#' - [mtdSort()]: to sort the MTD `matrix` into the expected order.
#' - [mtdFields()]: helps formatting values into the mzTab-M-specific format.
#' - [setMtdInstrument()]/[getMtdInstrument()]: set/get Instrument Metadata in
#'   an MTD section.
#' - [setMtdDatabase()]/[getMtdDatabase()]: set/get Database Metadata in an MTD
#'   section.
#' - [setMtdCv()]/[getMtdCv()]: set/get Controlled Vocabularies (CV) Metadata
#'   in an MTD section.
#' - [setMtdContact()]/[getMtdContact()]: set/get contact Metadata in an MTD
#'   section.
#' - [setMtdProtocol()]/[getMtdProtocol()]: set/get protocol Metadata in an MTD
#'   section.
#' - [setMtdField()]/[getMtdField()]: set/get a Metadata Field in an MTD
#'   section.
#'
#' @note
#'
#' The general relationship between *ms_run*, *assay* and *sample*:
#'
#' - one *ms_run* is the measurement of one assay. In most use cases one
#'   *ms_run* is associated with one *assay*.
#'
#' - one assay can be measured by several MS runs (if fractionated) or multiple
#'   assays can be measured in the same MS run (if multiplexed).
#'
#' - one assay is (generally) one sample, but the same sample can be measured
#'   with multiple assays (i.e., technical replicates).
#'
#' @author Philippine Louail, Johannes Rainer
#'
#' @seealso [SMF-export] and [SML-export] for creating and formatting the small
#'     molecule feature (SMF) and small molecule (SML) sections.
#'
#' @seealso [setMtdInstrument()], [setMtdDatabase()], [setMtdCv()],
#'     [setMtdContact()], [setMtdProtocol()] and [setMtdField()].
#'
#' @examples
#'
#' ## Building the mzTab-M metadata information from a `data.frame` with sample
#' ## information of an experiment. Each row in that `data.frame` is one
#' ## measurement of one sample (i.e., represents one *ms_run*). Columns in
#' ## that `data.frame` provide the phenotypic and experimental variables of
#' ## each sample. The example below represents a simple experiment in which
#' ## 3 samples (e.g. cell lines) were measured. Columns *time_point and
#' ## *cell_count* provide the time point (in hours) when samples were
#' ## collected and the number of cells per sample. In addition, one
#' ## sample has the genotype *WT* and two *KO*. Column `"operator"` contains
#' ## the initials of the researcher extracting the samples
#' exp <- data.frame(
#'     sample_name = c("S1_T1", "S1_T2", "S2_T1", "S2_T2", "S3_T1", "S3_T2"),
#'     sample_id = c("S1", "S1", "S2", "S2", "S3", "S3"),
#'     time_point = c(0, 6, 0, 6, 0, 6),
#'     cell_count = c(13000, 8700, 10100, 6000, 14000, 4500),
#'     genotype = c("WT", "WT", "KO", "KO", "KO", "KO"),
#'     operator = c("BB", "BB", "BB", "BB", "FB", "FB"),
#'     file_name = c("s1-t1.mzML", "s1-t2.mzML", "s2-t1.mzML", "s2-t2.mzML",
#'                   "s3-t1.mzML", "s3-t2.mzML")
#' )
#' exp
#'
#'
#' #############################################################################
#' ## Core metadata information
#'
#' ## We first compile the general metadata information. For the present
#' ## example we assume that we performed only preprocessing of the raw MS
#' ## data using *xcms*, thus we don't specify annotation databases used for
#' ## the compound identification/annotation. These could be provided through
#' ## the `database*` parameters. Also, the quantification method and unit(s)
#' ## could be specified using respective parameters of the function.
#' mtd <- mtdSkeleton(
#'     id = "EXP_001",
#'     software = "[MS, MS:1001582], xcms, 4.0.0")
#' mtd
#'
#' ## We can add additional content to this *skeleton* MTD information with
#' ## any of the `setMtd*` functions.
#' ## We next add a title and description for the experiment.
#' mtd <- setMtdField(mtd, field = "title",
#'     value = "Experiment 1 preprocessed data")
#' mtd <- setMtdField(mtd, field = "description",
#'     value = "The preprocessed data of experiment 1 samples.")
#'
#' ## We also add information on the MS instrumentation used
#' mtd <- setMtdInstrument(mtd,
#'     name = "[MS, MS:1000449, LTQ Orbitrap,]",
#'     source = "[MS, MS:1000073, ESI,]",
#'     analyzer = c("analyzer[1]" = "[MS, MS:1000291, linear ion trap,]"),
#'     detector = "[MS, MS:1000253, electron multiplier,]",
#' )
#'
#' ## We can also add contact information
#' mtd <- setMtdContact(mtd, name = c("frodo", "sauron"),
#'     affiliation = c("fellowship of the ring", "the dark side"),
#'     email = c("frodo@shire.net", "sauron@mordor.net"),
#'     orcid = c("0000-0001-2345-6789", "0000-0001-2345-678X"))
#'
#' mtd
#'
#' ## Other information, such as employed sample processing methods could be
#' ## added in a similar way.
#'
#'
#' #############################################################################
#' ## Sample information
#'
#' ## We next add sample information to the metadata. In addition to the
#' ## specific sample properties that can be defined using the function's
#' ## parameters, arbitrary custom fields can be defined too. Below we add
#' ## information on sample extraction as custom information.
#' mtd_s <- mtdSample(
#'     sample = unique(exp$sample_id),
#'     species = "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]",
#'     tissue = "[BTO, BTO:0000759, liver, ]",
#'     cell_type = "[CL, CL:0000182, hepatocyte, ]",
#'     c("[,,Extraction date, 2011-12-21]",
#'       "[,,Extraction date, 2011-12-22]",
#'       "[,,Extraction date, 2011-12-23]")
#'     )
#' mtd_s
#'
#' mtd <- rbind(mtd, mtd_s)
#'
#'
#' #############################################################################
#' ## MS run information
#'
#' ## The MS run information should capture information of each individual
#' ## measurement run on an MS instrument. For this, the original data file
#' ## names and location should be provided as well as the format of the
#' ## data files as well as polarity etc.
#' mtd_msr <- mtdMsRun(
#'     location = exp$file_name,
#'     format = "[MS, MS:1000584, mzML file, ]",
#'     id_format = "[MS, MS:1000530, mzML unique identifier, ]",
#'     scan_polarity = "positive")
#'
#' mtd <- rbind(mtd, mtd_msr)
#'
#'
#' #############################################################################
#' ## Assay information
#'
#' ## Each measurement should be associated to (at least) one assay. For our
#' ## simple example, each row in the `data.frame` represents one assay, with
#' ## each assay being measured in one MS run.
#' a <- mtdAssay(
#'     assay = exp$sample_name,
#'     sample_ref = c("sample[1]", "sample[1]", "sample[2]", "sample[2]",
#'                    "sample[3]", "sample[3]"),
#'     ms_run_ref = paste0("ms_run[", seq_len(nrow(exp)), "]")
#' )
#' a
#'
#' mtd <- rbind(mtd, a)
#'
#'
#' #############################################################################
#' ## Study variable information
#'
#' ## Study variables can be defined directly from the experiment `data.frame`.
#' ## In our example we use the columns (information on) `"time_point"`,
#' ## `"genotype"`, `"cell_count"` and `"operator"`. Importantly, the row-order
#' ## of the provided `data.frame` has to match the order of the assays (and
#' ## MS runs).
#' svar <- mtdStudyVariables(
#'     exp, groups = c("time_point", "genotype", "cell_count", "operator"))
#' svar
#'
#' ## The individual columns got encoded to a `"study_variable_group"` with a
#' ## defined (statistical) type and a datatype. Both are inferred
#' ## automatically from the columns of the provided `data.frame`, but could
#' ## also be manually provided through the respective function arguments.
#'
#' mtd <- rbind(mtd, svar)
#'
#' ## Finally, the `mtdSort()` function can be used to sort the generated
#' ## two-column matrix in the expected order.
#' mtd <- mtdSort(mtd)
#'
#' ## This metadata information can next be exported manually, or using the
#' ## dedicated export helper functions to an mzTab-M file.
NULL

#' @title Prepare and format information for the mzTab-M metadata section
#'
#' @description
#'
#' This function assists in creating and formatting information for the
#' mzTab-M metadata section (MTD). It combines and formats the provided input
#' values for a specific field.
#'
#' See [mzTab-M documentation](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section)
#' for more information, examples and expected format.
#'
#' @param ... `character` vector(s), each having the same length, with
#'     the values for the field(s). Parameter `field_prefix` defines the name
#'     of the field (e.g., `"cv"`). If names are provided (e.g.
#'     `label = "my label"`), these are appended to the `field_prefix` (e.g.,
#'     for `field_prefix = "cv"`, the returned field's name is combined to
#'     `"cv[1]-label"`).
#'
#' @param field_prefix `character(1)` defining the prefix to be used
#'     (e.g., `prefix = "cv"`). This is the prefix/first part of the field's
#'     name.
#'
#' @return two column `character` `matrix` with the formatted elements.
#'
#' @author Johannes Rainer, Philippine Louail
#'
#' @seealso [MTD-export] for other functions defining metadata information
#'
#' @examples
#'
#' ## Define the CV element with 3 CV terms:
#' mtdFields(
#'     label = c("a", "b", "c"),
#'     full_name = c("A", "B", "C"),
#'     version = c(1, 2, 3),
#'     uri = c("u1", "u2", "u3"),
#'     field_prefix = "cv")
#'
#' ## Define a single software:
#' mtdFields("[MS, MS:1002879, Progenesis QI, 3.0]", field_prefix = "software")
#'
#' ## Define two softwares:
#' mtdFields(c("[MS, MS:1002879, Progenesis QI, 3.0]", "[a, b, c, d]"),
#'     field_prefix = "software")
#'
#' ## Define a software with the optional setting
#' mtdFields(c("[MS, MS:1002879, Progenesis QI, 3.0]", "[a, b, c, d]"),
#'     `setting[1]` = c("my cool settings", "none"),
#'     `setting[2]` = c("other setting", "none"),
#'     field_prefix = "software")
#'
#' ## Define database fields
#' mtdFields(
#'    c("[MITIAM, MRI:00100079, HMDB, ]", "[,, de novo, ]"),
#'    prefix = c("hmdb", "dn"),
#'    version = c("3.6", "Unknown"),
#'    uri = c("http://www.hmdb.ca", "null"),
#'    field_prefix = "database"
#' )
#'
#' @export
mtdFields <- function(..., field_prefix = "") {
    dots <- list(...)
    ls <- lengths(dots)
    if (length(unique(ls)) > 1)
        stop(field_prefix, ": number of provided elements must match",
             call. = FALSE)
    n <- names(dots)
    if (is.null(n)) n <- ""
    n[n != ""] <- paste0("-", n[n != ""])
    l <- seq_len(ls[1L])
    res <- cbind(
        paste0(field_prefix, "[", rep(l, length(n)), "]",
               rep(n, each = ls[1L])),
        unlist(dots, use.names = FALSE),
        .prefix_zero(rep(l, length(n)))
    )
    res[order(res[, 3L]), 1:2, drop = FALSE]
}

#' @title Create a skeleton MTD section with general information
#'
#' @description
#'
#' This *core* MTD section allows to describe the general experimental setup
#' and provides general information of the data set. It should contain
#' references to **all** controlled vocabulary (CV) ontologies used and
#' refered to in the mzTab-M file.
#' The `mtdSkeleton()` function creates a two-column `matrix` with the
#' basic mzTab-M *MTD* section based on the provided data. The returned
#' result contains only minimal information. It should be expanded, corrected
#' and completed with additional fields and information (i.e., the
#' *skeleton* returned by this function should be completed with *flesh*).
#'
#' For details and expected input for the various parameter it is **strongly
#' suggested** to consult the [mzTab-M](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section) documentation.
#'
#' @param id `character(1)` (**mandatory**) with the ID of the data set.
#'
#' @param software `character` (**mandatory**) with the software(s) used.
#'     Can be of length > 1 if multiple softwares were used. Software should
#'     be provided in the order in which they were used.
#'
#' @param quantification_method `character(1)` defining the quantification
#'     method used in the experiment.
#'
#' @param cv_label `character` describing the labels of the controlled
#'     vocabularies/ontologies used in the mzTab file as a short-hand, e.g.
#'     `cv_label = "MS"` for PSI-MS.
#'
#' @param cv_full_name `character` with the full names of the controlled
#'     vocabularies/ontologies used in the mzTab file.
#'
#' @param cv_version `character` with the version of the used
#'     vocabularies/ontologies.
#'
#' @param cv_uri `character` with the URIs of the vocabularies/ontologies.
#'
#' @param database `character` defining the database used for annotation. If no
#'     annotation/identification was performed then `"[,, no database, null]"`
#'     should be used.
#'
#' @param database_prefix `character` defining the prefix used in the
#'     *identifier* column of data tables. For *no database*, `"null"` must
#'     be used.
#'
#' @param database_version `character` with the database version used.
#'
#' @param database_uri `character` with the URI to the database(s). For
#'     *no database* `"null"` must be used.
#'
#' @param small_molecule_quantification_unit `character(1)` defines the type
#'     of units are reported in the small molecule summary quantification/
#'     abundance fields.
#'
#' @param small_molecule_feature_quantification_unit `character(1)` defines
#'     what type of units are reported in the small molecule feature
#'     quantification / abundance fields.
#'
#' @param small_molecule_identification_reliability `character(1)` defines the
#'     system used for giving reliability / confidence codes to small molecule
#'     identifications MUST be specified if not using the default codes.
#'
#' @param mztab_version `character(1)` defining the mzTab-M version of the file.
#'
#' @return two-column `character` `matrix` that should be expanded with
#'     additional fields (such as *title*, *description* etc) and
#'     information (with the help from the `mtdFields()` function).
#'
#' @author Philippine Louail, Johannes Rainer
#'
#' @seealso [MTD-export] for other functions defining metadata information
#'
#' @export
#'
#' @examples
#'
#' ## Define a minimal mzTab-M metadata information
#' mtd <- mtdSkeleton(id = "001", software = "[MS, MS:1001582, xmcs, 4.0.0]")
#'
#' ## Column 1 has the field names
#' mtd[, 1]
#'
#' ## Column 2 the respective values
#' mtd[, 2]
#'
#' ## Add additional fields as defined in the mzTab-M definition
#' mtd <- rbind(
#'     mtd,
#'     c("title", "My simple xcms preprocessed data"),
#'     c("description", "A simple example xcms preprocessing."))
#'
#' tail(mtd)
#'
#' ## Add instrument information
#' instr <- mtdFields(
#'     name = "[MS, MS:1000449, LTQ Orbitrap,]",
#'     source = "[MS, MS:1000073, ESI,]",
#'     `analyzer[1]` = "[MS, MS:1000291, linear ion trap,]",
#'     detector = "[MS, MS:1000253, electron multiplier,]",
#'     field_prefix = "instrument"
#' )
#' instr
#'
#' ## Add this information to the metadata
#' mtd <- rbind(mtd, instr)
#'
#' ## Define sample processing fields using the mtdFields function
#' sp <- mtdFields(
#'     c("[MSIO, MSIO:0000146, centrifugation,]",
#'       "[MSIO, MSIO:0000141, metabolite extraction,]",
#'       "[MSIO, MSIO:0000141, silylation,]"),
#'     field_prefix = "sample_processing")
#' sp
#'
#' ## Add this information to the metadata
#' mtd <- rbind(mtd, sp)
#'
#' ## Since a new ontology was used for the sample processing, we need also to
#' ## add that to the metadata. We manually define the fields to add using
#' ## `"cv[3]"` because there are already 2 CVs defined in the MTD skeleton.
#' cv2 <- rbind(
#'     c("cv[3]-label", "MSIO"),
#'     c("cv[3]-full_name", "Metabolomics Standards Initiative Ontology"),
#'     c("cv[3]-version", "1.0.1"),
#'     c("cv[3]-uri", "http://purl.obolibrary.org/obo/msio.owl")
#' )
#'
#' ## Add this information to the metadata
#' mtd <- rbind(mtd, cv2)
#'
#' ## Finally sort the metadata fields according to the expected order
#' mtd <- mtdSort(mtd)
#' mtd
mtdSkeleton <- function(id = character(),
                        software = character(),
                        quantification_method = "[MS, MS:1001834, LC-MS label-free quantitation analysis, ]",
                        cv_label = c("MS", "PRIDE", "STATO"),
                        cv_full_name = c("PSI-MS controlled vocabulary",
                                         "PRIDE PRoteomics IDEntifications (PRIDE) database controlled vocabulary",
                                         "General purpose STATistics Ontology"),
                        cv_version = c("4.1.138",
                                       "16:10:2023 11:38",
                                       "2026-04-20"),
                        cv_uri = c("https://raw.githubusercontent.com/HUPO-PSI/psi-ms-CV/master/psi-ms.obo",
                                   "https://www.ebi.ac.uk/ols/ontologies/pride",
                                   "https://www.ebi.ac.uk/ols4/ontologies/stato"),
                        database = c("[,, \"no database\", null ]"),
                        database_prefix = c("null"),
                        database_version = c("Unknown"),
                        database_uri = c("null"),
                        small_molecule_quantification_unit = "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]",
                        small_molecule_feature_quantification_unit = "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]",
                        small_molecule_identification_reliability = "[MS, MS:1002896, compound identification confidence level, ]",
                        mztab_version = "2.1.0-M") {
    if (!length(id)) stop("Parameter 'id' is required", call. = FALSE)
    if (!length(software)) stop("Parameter 'software' is required", call.=FALSE)
    if (!isCvParameter(software))
        software <- paste0("[,,", software, ",]")
    sk <- rbind(
        c("mzTab-version", mztab_version),
        c("mzTab-ID", id),
        mtdFields(software, field_prefix = "software"),
        c("quantification_method", quantification_method),
        .cv(cv_label, cv_full_name, cv_version, cv_uri),
        .database(database, database_prefix, database_version, database_uri),
        c("small_molecule-quantification_unit",
          small_molecule_quantification_unit),
        c("small_molecule_feature-quantification_unit",
          small_molecule_feature_quantification_unit),
        c("small_molecule-identification_reliability",
          small_molecule_identification_reliability)
    )
    ## Order them.
    mtdSort(sk)
}

#' @title msTab-M *sample* metadata information
#'
#' @description
#'
#' The `mtdSample()` function aids in creating and formatting the (optional)
#' sample information from the mzTab-M metadata section. If defined, the sample
#' information **must** be correctly linked to from the *assay* section. In
#' particular, the assays need to link to the index of the samples defined in
#' this section. One entry for each originating sample should be defined
#' (without information on experimental properties). For each sample one
#' or more additional characteristics (such as `species`, `tissue`, `cell_type`
#' or `disease`) can be provided. Thus, these parameters expect the input be
#' provided as a `list`. In addition, if a single value needs to be assigned
#' to each sample, a `character(1)` of length 1 can be provided with the
#' respective input parameter.
#'
#' **Important:** to support the optional additional parameters passed along
#' with `...` **all** parameters (such as `sample`, `species` etc) have to
#' be **fully** spelled out.
#'
#' For details and expected input for the various parameter it is **strongly
#' suggested** to consult the [mzTab-M](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section) documentation.
#'
#' @param ... named `character` vectors of length equal to the length of
#'     parameter `sample` with optional *custom* information for each
#'     individual sample.
#'
#' @param sample `character` with the labels/names of the individual samples.
#'
#' @param species `list` of length equal to `length(sample)` with each element
#'     providing the species (eventually multiple) for each sample. Can also
#'     be a `character` of `length(sample)` to assing a single species to each
#'     `sample`, or a `character(1)` of length one to assign the same species
#'     to every sample.
#'
#' @param tissue `list` with the tissue(s) of each sample. The same format
#'     as described for parameter `species` can be used.
#'
#' @param cell_type `list` with the cell type(s) of each sample. The same format
#'     as described for parameter `species` can be used.
#'
#' @param disease `list` with the disease(s) of each sample. The same format
#'     as described for parameter `species` can be used.
#'
#' @param description `character` of length equal to `length(sample)` with
#'     optional description of each sample.
#'
#' @return two column `character` `matrix` with the information formatted as
#'     sample section of the mzTab-M format.
#'
#' @seealso [MTD-export] for other functions defining metadata information
#'
#' @export
#'
#' @examples
#'
#' ## Example sample description data.frame for an experiment
#' pd <- data.frame(
#'     sample_name = c("ind_1", "ind_2", "ind_1", "ind_2"),
#'     sample_id = c("i1_t1", "i2_t2", "i1_t2", "i2_t2"),
#'     time_point = c(1, 2, 1, 2))
#'
#' ## Define a minimal sample information with just the sample names.
#' mtdSample(unique(pd$sample_name))
#'
#' ## Add also species information: each sample from the same species
#' mtdSample(
#'     sample = unique(pd$sample_name),
#'     species = "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]")
#'
#' ## Assume first sample is a mixture of two species
#' mtdSample(
#'     sample = unique(pd$sample_name),
#'     species = list(c("[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]",
#'                      "[NCBITaxon, NCBITaxon:39767, Human rhinovirus 11, ]"),
#'                    "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]")
#' )
#'
#' ## Add full information including tissue, cell type and disease
#' mtdSample(
#'     sample = unique(pd$sample_name),
#'     species = list(c("[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]",
#'                      "[NCBITaxon, NCBITaxon:39767, Human rhinovirus 11, ]"),
#'                    "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"),
#'     tissue = "[BTO, BTO:0000759, liver, ]",
#'     cell_type = "[CL, CL:0000182, hepatocyte, ]",
#'     disease = list(c("[DOID, DOID:684, hepatocellular carcinoma, ]",
#'                      "[DOID, DOID:9451, alcoholic fatty liver, ]"),
#'                    NULL)
#' )
#'
#' ## Add also additional custom variables
#' mtdSample(sample = c("A", "B"),
#'     c("[,,Extraction date, 2011-12-21]",
#'       "[,,Extraction date, 2011-12-22]"),
#'     c("[,,Extraction reason, liver biopsy]",
#'       "[,,Extraction reason, liver biopsy]"))
mtdSample <- function(..., sample = character(), species = list(),
                       tissue = list(), cell_type = list(), disease = list(),
                       description = character()) {
    l <- length(sample)
    if (!l)
        return(matrix(ncol = 2, nrow = 0, NA_character_))
    s <- seq_len(l)
    res <- cbind(mtdFields(sample, field_prefix = "sample"), order = s)
    if (length(species)) {
        if (length(species) != l)
            species <- rep(species[1], l)
        if (!is.list(species)) species <- as.list(species)
        res <- rbind(res, .mtd_multi_fields(species, "sample", "species"))
    }
    if (length(tissue)) {
        if (length(tissue) != l)
            tissue <- rep(tissue[1], l)
        if (!is.list(tissue)) tissue <- as.list(tissue)
        res <- rbind(res, .mtd_multi_fields(tissue, "sample", "tissue"))
    }
    if (length(cell_type)) {
        if (length(cell_type) != l)
            cell_type <- rep(cell_type[1], l)
        if (!is.list(cell_type)) cell_type <- as.list(cell_type)
        res <- rbind(res, .mtd_multi_fields(cell_type, "sample", "cell_type"))
    }
    if (length(disease)) {
        if (length(disease) != l)
            disease <- rep(disease[1], l)
        if (!is.list(disease)) disease <- as.list(disease)
        res <- rbind(res, .mtd_multi_fields(disease, "sample", "disease"))
    }
    if (length(description)) {
        if (length(description) != l)
            stop("If provided, 'description' has to be of length equal to the",
                 " number of samples", call. = FALSE)
        res <- rbind(res,
                     cbind(mtdFields(description = description,
                                      field_prefix = "sample"),
                           s))
    }
    ## optional fields ("custom") passed through `...`
    res <- rbind(res, .mtd_custom_fields(..., expected_length = l))
    res[order(res[, 3L]), 1:2, drop = FALSE]
}

#' @title msTab-M *ms_run* metadata fields
#'
#' @description
#'
#' The `mtdMsRun()` function allows to define and format the *ms_run* fields
#' of the mzTab-M metadata. The information is build on the actual data file
#' names along with optional additional parameters to characterize the MS
#' run(s).
#'
#' For details and expected input for the various parameter it is **strongly
#' suggested** to consult the [mzTab-M](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section) documentation.
#'
#' @param location `character` with the location (and file name) of the
#'     individual runs. Each element will be one run. This parameter is
#'     required, set to `"null"` if the location of the file(s) is not known.
#'
#' @param instrument_ref (optional) `integer()` with the index of the instrument
#'     the run was measured on.
#'
#' @param format (optional) `character` defining the format of the external MS
#'     data file. If specified, also `id_format` has be be provided. Can be of
#'     length 1 or equal to `length(location)`. For data file(s) in mzML format,
#'     `format = "[MS, MS:1000584, mzML file, ]"` can be used.
#'
#' @param id_format (optional) `character` defining the id format used in the
#'     external data file. If specified, also `format` needs to be defined.
#'     Can be of length 1 or equal to `length(location)`. For data file(s) in
#'     mzML format, `format = "[MS, MS:1000530, mzML unique identifier, ]"`
#'     can be used.
#'
#' @param fragmentation_method (optional) `list` of `character` defining the
#'     type(s) of fragmentation(s) used in a given ms run. Length must match
#'     length of `location` if provided. If no fragmentation was used for a
#'     specific file/run use `NULL` for that `list` element (position). As
#'     example, if two runs are included, the first does not have any
#'     fragmentation and for the second CID and HCD was used define
#'     `list(NULL, c("[MS, MS:1000133, CID, ]", "[MS, MS:1000422, HCD, ]"))`.
#'
#' @param scan_polarity `character` defining the polarity of a run. Can be
#'     either `"positive"` or `"negative"`. Can be of length 1 or equal to
#'     `length(location)`.
#'
#' @param hash (optional) `character` with the hash value of the corresponding
#'     external MS data file. If provided, also `hash_method` needs to be
#'     defined. The length of `hash` has to match the length of `location`.
#'
#' @param hash_method (optional) `character` with the hash method used to
#'     generate the value in `hash`. If provided, also `hash` needs to be
#'     defined. The length of `hash_method` has to match the length of `hash`.
#'
#' @param parameters (optional) `character` with additional parameters of the
#'     assays.
#'
#' @note
#'
#' At present only a single polarity per run/file is supported.
#'
#' @return two column `character` `matrix` with the *ms_run* metadata fields
#'     for a mzTab-M file.
#'
#' @author Johannes Rainer, Philippine Louail
#'
#' @seealso [MTD-export] for other functions defining metadata information
#'
#' @export
#'
#' @examples
#'
#' ## Build a very basic MTD ms_run section for two data files
#' fls <- c("file:///path/to/file/a.mzML", "file:///path/to/file/b.mzML")
#' mtdMsRun(location = fls, scan_polarity = "positive")
#'
#' ## Add also instrument reference information
#' mtdMsRun(location = fls, scan_polarity = "positive", instrument_ref = 1)
#'
#' ## Finally, add a fragmentation method used for the second file - no
#' ## fragmentation was used for the first file, thus `NULL` is specified.
#' ## Parameter `fragmentation_method` expects a `list` as input to support
#' ## also multiple fragmentation methods per MS run.
#' mtdMsRun(location = fls, scan_polarity = "positive",
#'     fragmentation_method = list(NULL, "[MS, MS:1000133, CID, ]"))
mtdMsRun <- function(location = character(),
                     instrument_ref = integer(),
                     format = character(),
                     id_format = character(),
                     fragmentation_method = vector("list", length(location)),
                     scan_polarity = character(),
                     hash = character(),
                     hash_method = character(),
                     parameters = character()) {
    l <- length(location)
    s <- seq_len(l)
    if (!l)
        stop("ms_run: parameter 'location' is required, even if it is \"null\"",
             call. = FALSE)
    if (!length(scan_polarity))
        stop("ms_run: parameter 'scan_polarity' is required", call. = FALSE)
    if ((length(format) | length(id_format)) &
        (length(format) != length(id_format)))
        stop("ms_run: either both 'format' and 'id_format' have to be ",
             "defined or none of the two.", call. = FALSE)
    if ((length(hash) | length(hash_method)) &
        (length(hash) != length(hash_method)))
        stop("ms_run: either both 'hash' and 'hash_method' have to be ",
             "defined or none of the two.", call. = FALSE)
    if (length(hash) && length(hash) != l)
        stop("ms_run: if provided, length of parameter 'hash' has to ",
             "match length of 'location'", call. = FALSE)
    if (length(fragmentation_method) != l)
        stop("ms_run: length of parameter 'fragment_method' has to match ",
             "length of 'location'", call. = FALSE)
    ## Build data
    res <- .ms_run_format(s, "location", location)
    if (l2 <- length(instrument_ref)) {
        if (l2 != l) instrument_ref <- rep(instrument_ref[1L], l)
        res <- rbind(
            res, .ms_run_format(s, "instrument_ref",
                                paste0("instrument[", instrument_ref, "]")))
    }
    if (l2 <- length(format)) {
        if (l2 != l) format <- rep(format[1L], l)
        res <- rbind(res, .ms_run_format(s, "format", format))
    }
    if (l2 <- length(id_format)) {
        if (l2 != l) id_format <- rep(id_format[1L], l)
        res <- rbind(res, .ms_run_format(s, "id_format", id_format))
    }
    ## fragmentation_method
    frag_mod <- lapply(seq_along(fragmentation_method), function(z) {
        vals <- fragmentation_method[[z]]
        if (lv <- length(vals)) {
            cbind(paste0("ms_run[", rep(z, lv), "]-fragmentation_method[",
                         seq_len(lv), "]"),
                  fragmentation_method[[z]],
                  order = .prefix_zero(rep(z, lv)))
        }
    })
    frag_mod <- do.call(rbind, frag_mod)
    if (length(frag_mod)) res <- rbind(res, frag_mod)
    if (length(scan_polarity) != l) scan_polarity <- rep(scan_polarity[1L], l)
    res <- rbind(res, .ms_run_format(s, "scan_polarity[1]",
                                     .ms_scan_polarity(scan_polarity)))
    if (length(hash)) res <- rbind(res, .ms_run_format(s, "hash", hash))
    if (length(hash_method))
        res <- rbind(res, .ms_run_format(s, "hash_method", hash_method))
    ## Paramters
    if (length(parameters)) {
        res <- rbind(res, .mtd_parameters_fields("ms_run", parameters, l))
    }
    res[order(res[, 3L]), 1:2, drop = FALSE]
}

#' @title mzTab-M *assay* metadata information
#'
#' @description
#'
#' The `mtdAssay()` function assists in compiling the *assay* information of
#' the metadata section. Each assay **must** be associated with at least one
#' entry of the *ms_run* section (see [mtdMsRun()]). This mapping can be
#' defined with the `ms_run_ref` parameter by providing the ID/name of the
#' run (e.g. `"ms_run[1]"`).
#'
#' **Important:** to support the optional additional parameters passed along
#' with `...` **all** parameters (such as `assay`, `sample_ref` etc) have to
#' be **fully** spelled out.
#'
#' For details and expected input for the various parameter it is **strongly
#' suggested** to consult the [mzTab-M](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section) documentation.
#'
#' @param ... optional additional (custom) parameters for each assay. If
#'     provided, the length of the `character` vector(s) have to match the
#'     length of parameter `assay`.
#'
#' @param assay `character` with the names of the assay(s). Each assay **must**
#'     be reported in the following sections (e.g. the SMF section).
#'
#' @param external_uri optional `character` with a reference to further
#'     information about the assay, for example via a reference to an object
#'     within an ISA-TAB file. Can be of length 1 (in which case the same
#'     reference is assigned to every assay) or length equal to the length
#'     of `assay`.
#'
#' @param sample_ref optional `character` with the ID/name of the sample for
#'     the assay (e.g. `"sample[1]"`). If provided, its length has to match
#'     the length of `assay`.
#'
#' @param ms_run_ref `character` with the ID of associated *ms_run*(s). For
#'     multiplexed assays, different assays can refer to the same run. To
#'     support pre-fractionated samples, it is also possible to provide a
#'     `list` of `character` with the runs the assay was measured in. See
#'     examples below for more details.
#'
#' @param protocol_ref optional `character` with the ID/name of the protocol for
#'     the assay (e.g. `"protocol[1]"`). If provided, its length has to match
#'     the length of `assay`.
#'
#' @param parameters optional `character` with additional parameters of the
#'     assay.
#'
#' @return two-column `character` `matrix` with the content for the assay
#'     metadata section.
#'
#' @author Johannes Rainer
#'
#' @seealso [MTD-export] for other functions defining metadata information
#'
#' @export
#'
#' @examples
#'
#' ## Minimal example with assay and ms_run_ref defined, each assay assigned
#' ## to its own MS run. Note that for **all** parameters the **full**
#' ## parameter name has to be used (e.g., `assay = `).
#' mtdAssay(assay = c("a1", "a2", "a3"),
#'     ms_run_ref = c("ms_run[1]", "ms_run[2]", "ms_run[3]"))
#'
#' ## Example for a multiplexed assay.
#' mtdAssay(assay = c("a1", "a2", "a3"),
#'     ms_run_ref = c("ms_run[1]", "ms_run[1]", "ms_run[1]"))
#'
#' ## Example for a pre-fractionated samples
#' mtdAssay(assay = c("a1", "a2", "a3"),
#'     ms_run_ref = list(c("ms_run[1]", "ms_run[2]"),
#'                       c("ms_run[3]", "ms_run[4]"),
#'                       c("ms_run[5]", "ms_run[6]")))
#'
#' ## Example adding also sample reference and an external_uri
#' mtdAssay(
#'     assay = c("a1", "a2", "a3"),
#'     external_uri = "https://www.ebi.ac.uk/metabolights/MTBLS517/files/i_Investigation.txt",
#'     sample_ref = c("sample[1]", "sample[1]", "sample[2]"),
#'     ms_run_ref = c("ms_run[1]", "ms_run[2]", "ms_run[3]"))
#'
#' ## Example adding also protocol reference
#' mtdAssay(
#'    assay = c("a1", "a2", "a3"),
#'    external_uri = "https://www.ebi.ac.uk/metabolights/MTBLS517/files/i_Investigation.txt",
#'    sample_ref = c("sample[1]", "sample[1]", "sample[2]"),
#'    ms_run_ref = c("ms_run[1]", "ms_run[2]", "ms_run[3]"),
#'    protocol_ref = c("protocol[1]", "protocol[1]", "protocol[1]|protocol[2]"))
#'
#' ## Providing additional, custom information for each assay. These can be
#' ## passed as `character` vectors (same length than `assay`!).
#' mtdAssay(assay = c("a1", "a2", "a3"),
#'     ms_run_ref = c("ms_run[1]", "ms_run[2]", "ms_run[3]"),
#'     c("[MS, , Assay operator, Fred Blogs]",
#'       "[MS, , Assay operator, Fred Blogs]",
#'       "[MS, , Assay operator, Frodo]"))
mtdAssay <- function(..., assay = character(), external_uri = character(),
                      sample_ref = character(), ms_run_ref = character(),
                      protocol_ref = character(), parameters = character()) {
    l <- length(assay)
    if (!length(assay))
        return(matrix(ncol = 2, nrow = 0, NA_character_))
    if (!length(ms_run_ref))
        stop("Parameter 'ms_run_ref' is required", call. = FALSE)
    if (l != length(ms_run_ref))
        stop("lengths of parameters 'assay' and 'ms_run_ref' have to match",
             call. = FALSE)
    s <- seq_len(l)
    res <- cbind(mtdFields(assay, field_prefix = "assay"), order = s)
    if (length(external_uri)) {
        if (length(external_uri) != l) external_uri <- rep(external_uri[1L], l)
        res <- rbind(res, cbind(mtdFields(external_uri = external_uri,
                                           field_prefix = "assay"), s))
    }
    if (length(sample_ref)) {
        if (length(sample_ref) != l)
            stop("Length of 'sample_ref' has to match the length of 'assay'",
                 call. = FALSE)
        res <- rbind(res, cbind(mtdFields(sample_ref = sample_ref,
                                           field_prefix = "assay"), s))
    }
    if (is.list(ms_run_ref)) {
        ls <- lengths(ms_run_ref)
        if (any(ls < 1))
            stop("At least one ms_run reference must be defined for each ",
                 "assay", call. = FALSE)
        res <- rbind(res, cbind(.mtd_multi_fields(
                              ms_run_ref, prefix = "assay",
                              suffix = "ms_run_ref")))
    } else
        res <- rbind(res, cbind(mtdFields(ms_run_ref = ms_run_ref,
                                           field_prefix = "assay"), s))
    if (length(protocol_ref)) {
        if (length(protocol_ref) != l)
            stop("Length of 'protocol_ref' has to match the length of 'assay'",
                 call. = FALSE)
        res <- rbind(res, cbind(mtdFields(protocol_ref = protocol_ref,
                                           field_prefix = "assay"), s))
    }
    ## Paramters
    if (length(parameters)) {
        res <- rbind(res, .mtd_parameters_fields("assay", parameters, l))
    }
    ## Optional "custom" fields passed through ...
    res <- rbind(
        res, .mtd_custom_fields(..., expected_length = l, prefix = "assay"))
    res[order(res[, 3L]), 1:2, drop = FALSE]
}

#' @title mzTab-M *study variables* metadata information
#'
#' @description
#'
#' mzTab-M (version >= 2.1) encodes the experimental design of a data set/study
#' using *study variable groups* and *study variables*. The study variable group
#' represents the phenotypic (or experimental) condition and the study variable
#' the actual *value* of a sample (or assay) for that study group.
#'
#' In R, the most common representation of an experimental design is a
#' `data.frame` where rows are individual samples (assays) and columns the
#' experimental or phenotypic conditions (variables). The
#' `mtdStudyVariables()` takes such a `data.frame` as input and encodes it
#' into the mzTab-M format. Additional parameters such as `group_description`,
#' and `group_type` allow to provide additional information for each study
#' variable group (phenotype) while parameters `average_function`,
#' `variation_function` and `description` can be used to provide properties for
#' the individual study variables. For most experiments the default values of
#' these parameters should suffice.
#'
#' @details
#'
#' Each study variable **must** be reported in the abundance tables.
#' Each assay of a data set must be referred to from at least one study
#' variable. Even if a data set has no experimental variables, a study variable
#' group and study variable with the name `"undefined"` **must** be reported.
#' Using `mtdStudyVariables()` without specifying parameter `group` will
#' create such a setup.
#'
#' The `mtdDefineStudyVariables()` function can be used to get the set
#' (and order) of study variables that would be generated from an input
#' `data.frame` depending on the parameter `groups`.
#'
#' @note
#'
#' Datatypes `"xsd:date"`, `"xsd:time"`, `"xsd:dateTime"` and `"xsd:anyURI"` are
#' currently mapped to `character` in R (and *vice versa*).
#'
#' At present study variables are mapped to *assays*, but not to *MS runs*.
#'
#' @param x `data.frame` with rows corresponding to individual *assays* and
#'     columns containing the experimental conditions/study variables. The
#'     number of rows is thus expected to be the same as the number of assays
#'     defined in the *assay* metadata section (using e.g., [mtdAssay()]) and
#'     the order of rows is expected to match the order of these.
#'
#' @param groups `character` with the names of the columns in `x` that should
#'     be considered as *study variable groups*. If not defined (the default)
#'     a single study variable group `"undefined"` and single study variable
#'     `"undefined"` will be used.
#'
#' @param group_description `character` with an optional description of each
#'     study variable group. If provided its length has to match the length
#'     of parameter `groups`.
#'
#' @param group_type `character` defining the type for each study variable
#'     group. If provided its length has to match the length of parameter
#'     `groups`. Supported values are
#'     `"[STATO, STATO:0000252, categorical variable, ]"`,
#'     `"[STATO, STATO:0000228, ordinal variable, ]"` and
#'     `"[STATO, STATO:0000251, continuous variable, ]"` for categorical,
#'     ordinal or numerical values, respectively. If not provided (the default)
#'     the study variable group type will be inferred from the data type of the
#'     respective columns in `x`.
#'
#' @param group_datatype optional `character` defining the data type of the
#'     values (i.e., study variables) for the study variable group. If provided,
#'     its length has to match the length of paramter `groups`.
#'     Supported values are `"xsd:string"`, `"xsd:integer"`, `"xsd:decimal"`,
#'     `"xsd:boolean"`, `"xsd:date"`, `"xsd:time"`, `"xsd:dateTime"`,
#'     `"xsd:anyURI"`, and `"Parameter"` (for *CV Parameters*). Date, time and
#'     dateTime values **must** be encoded in ISO 8601 format. If not provided
#'     the type is guessed by the data type of the respective column in `x`.
#'
#' @param group_unit optional `character` defining the unit of the group
#'     variable (for numeric data types). If provided, its length has to match
#'     the length of parameter `groups`. `NA` or `""` has to be provided for
#'     groups for which no unit should be reported. By default
#'     (`group_unit = character()`) no unit is reported for any group.
#'
#' @param average_function optional `character` defining the function used to
#'     calculate the study variable quantification value (reported in the
#'     following table(s)). Can be of length 1 or equal to the number of study
#'     variables (to allow defining a different function per variable). Use
#'     `mtdDefineStudyVariables()` to get the complete set of study
#'     variables for parameters `x` and `groups`. Defaults to the arithmetic
#'     mean (`average_function = "[MS, MS:1002962, mean, ]"`).
#'
#' @param variation_function optional `character` defining the function used to
#'     calculate the study variable quantification variation value (reported in
#'     the following table(s)). Can be of length 1 or equal to the number of
#'     study variables (to allow defining a different function per variable).
#'     Use `mtdDefineStudyVariables()` to get the complete set of study
#'     variables for parameters `x` and `groups`. Defaults
#'     to the coefficient of variation
#'     (`variation_function = "[MS, MS:1002963, variation coefficient, ]"`).
#'
#' @param description `character` with a textual description of the study
#'     variable. If provided, its length needs to be equal to the number of
#'     study variables. Use `mtdDefineStudyVariables()` to get the complete
#'     set of study variables for parameters `x` and `groups`.
#'     If not provided (the default) the values for the study variable group
#'     and study variable are reported.
#'
#' @return two-column `character` `matrix` with the content for the study
#'     variables metadata section.
#'
#' @author Philippine Louail, Johannes Rainer
#'
#' @seealso [MTD-export] for other functions defining metadata information
#'
#' @export
#'
#' @examples
#'
#' ## Example phenodata/sample data.frame. Each row is supposed to match
#' ## the measurement of one sample (for a certain condition/time point) from
#' ## one individual
#' x <- data.frame(
#'     name = c("I1_0", "I2_0", "I1_6", "I2_6", "I3_0"),
#'     individual = c("I1", "I2", "I1", "I2", "I3"),
#'     BMI = c(29.3, 31.4, 29.3, 31.4, 26.5),
#'     timepoint = c(0, 6, 0, 6, 0),
#'     T2D = c(TRUE, FALSE, TRUE, FALSE, FALSE)
#' )
#'
#' ## Study variable groups for this data set could be `"individual"`, `"BMI"`,
#' ## `"timepoint"` and `"T2D"`
#' mtdStudyVariables(x, groups = c("individual", "BMI", "timepoint", "T2D"))
#'
#' ## Specifying a different average and variation function and selecting
#' ## just two sample columns
#' mtdStudyVariables(x,
#'     groups = c("timepoint", "T2D"),
#'     average_function = "[MS, MS:1002883, median, ]",
#'     variation_function = "[MS, MS:1002885, standard error, ]")
#'
#' ## Creating a study variable section without defined study variable groups
#' mtdStudyVariables(x)
#'
#' ## Use `mtdDefineStudyVariables()` to get the definition of study
#' ## variables for a given `x` and `groups`
#' mtdDefineStudyVariables(x, c("T2D", "BMI", "individual"))
mtdStudyVariables <- function(x, groups = character(),
                                group_description = character(),
                                group_type = character(),
                                group_datatype = character(),
                                group_unit = character(),
                                average_function = "[MS, MS:1002962, mean, ]",
                                variation_function = "[MS, MS:1002963, variation coefficient, ]",
                                description = character()) {
    if (!length(groups)) {
        x <- data.frame(undefined = rep("undefined", nrow(x)))
        groups <- "undefined"
    }
    if (!all(groups %in% colnames(x)))
        stop("Not all column names defined with 'groups' are ",
             "present in 'x'", call. = FALSE)
    x <- as.data.frame(x[, groups, drop = FALSE])

    ## Add study variables
    svar_df <- .mztab_study_variables(x, groups)
    svars <- unique(svar_df)
    l <- nrow(svars)
    if (length(average_function) == 1L)
        average_function <- rep(average_function, l)
    if (length(variation_function) == 1L)
        variation_function <- rep(variation_function, l)
    if (length(average_function) != l)
        stop("Length of parameter 'average_function' has to be equal to ",
             "the number of study variables", call. = FALSE)
    if (length(variation_function) != l)
        stop("Length of parameter 'variation_function' has to be equal to ",
             "the number of study variables", call. = FALSE)
    if (!length(description))
        description <- paste0("Variable ", svars$study_variable_group,
                              ", value ", svars$study_variable)
    if (length(description) != l)
        stop("Length of parameter 'description' has to be equal to ",
             "the number of study variables", call. = FALSE)
    ## Add study variables
    res <- matrix(ncol = 2)
    for (i in seq_len(nrow(svars))) {
        current_svar <- svars$study_variable[i]
        current_grp <- svars$study_variable_group[i]

        res <- rbind(
            res,
            matrix(ncol = 2,
                   c(paste0("study_variable[", i, "]"),
                     paste0("study_variable[", i, "]-assay_refs"),
                     paste0("study_variable[", i, "]-average_function"),
                     paste0("study_variable[", i, "]-variation_function"),
                     paste0("study_variable[", i, "]-description"),
                     current_svar,
                     paste0("assay[", which(x[, current_grp] %in% current_svar),
                            "]", collapse = "|"),
                     average_function[i],
                     variation_function[i],
                     description[i])
                   )
        )
    }

    ## Convert non Cv groups to Cv parameters
    groups_cv <- groups
    if (any(i <- !isCvParameter(groups_cv)))
        groups_cv[i] <- paste0("[,,", groups_cv[i], ",]")

    svg <- c(groups_cv, .mtd_svar_group_description(x, group_description),
             .mtd_svar_group_type(x, group_type),
             .mtd_svar_group_datatype(x, group_datatype),
             .mtd_svar_group_unit(x, group_unit),
             .mtd_svar_group_variable_ref(svars))
    ## build study variable group content
    svar_g_df <- matrix(ncol = 2,
                        c(paste0("study_variable_group[",
                        rep(seq_along(groups_cv), each = 6L),
                        c("]", "]-description", "]-type",
                          "]-datatype", "]-unit", "]-study_variable_ref")),
                        unlist(svg[order(rep(seq_along(groups_cv), 6L))])))
    ## drop rows with empty unit
    svar_g_df <- svar_g_df[!(grepl("-unit$", svar_g_df[, 1L]) &
                            svar_g_df[, 2L] == ""), , drop = FALSE]
    rbind(svar_g_df, res[-1, ])
}

#' @rdname mtdStudyVariables
#'
#' @export
mtdDefineStudyVariables <- function(x = data.frame(), groups = character()) {
    if (!nrow(x))
        return(data.frame(study_variable = character(),
                          study_variable_group = character()))
    if (!length(groups))
        data.frame(study_variable = "undefined",
                   study_variable_group = "undefined")
    else unique(.mztab_study_variables(x, groups))
}

#' @title Sort rows in a MTD matrix to match the expected order
#'
#' @description
#'
#' Helper function to sort a mzTab-M *MTD* `matrix`, such as generated by
#' [mtdSkeleton()], into the correct order of the metadata fields.
#'
#' @param x two-column matrix with the first column containing the metadata
#'     field names.
#'
#' @return input parameter `x` sorted into the correct order.
#'
#' @author Johannes Rainer
#'
#' @seealso [MTD-export] for other functions defining metadata information
#'
#' @export
mtdSort <- function(x) {
    x[.sort_order(x[, 1L], .MTD_FIELD_ORDER), , drop = FALSE]
}

#' @title Create the mzTab-M MTD content from a sample data frame
#'
#' @description
#'
#' `mtdFromSampleData()` compiles the *sample*, *ms_run*, *assay* and
#' *study variable* content of the MTD section from a *sample data*
#' `data.frame`. Each row of this `data.frame` (parameter `x`) is expected to
#' represent on MS run (i.e., acquisition of a sample) of an experimen with
#' columns containing information on the individual MS run and the sample(s).
#'
#' The columns providing information on the MS run can be specified with
#' parameter `msRunCols`. Mandatory columns are *location* and *scan_polarity*.
#'
#' The columns providing information on the individual *assays* can be defined
#' with parameter `assayCols`. In most cases one assay represents one MS run.
#'
#' The columns from which sample information can be retrieved can be defined
#' with `sampleCols`. See notes below for more information.
#'
#' The columns containing experimental/phenotype information can be defined
#' with parameter `groups`.
#'
#' Arguments defining columns for MS runs, assays and samples are grouped with
#' parameters `msRunCols.`, `assayCols.` and `sampleCols,`. For each a helper
#' function is available providing defaults and assisting in defining the
#' arguments. See section *Defining columns with information on MS runs, assays
#' and samples*
#'
#' The MTD information is compiled from the sample data `x` as follows:
#'
#' - MS runs: each row in `x` is added as one MS run. The column in `x` with
#'   the respective file name needs to be defined through parameter
#'   `msRunCols.`.
#'
#' - samples: the unique set of rows based on the column(s) defined with
#'   `sampleCols.` are added as samples.
#'
#' - assay: each unique element in the column defined through `assayCols.`
#'   (`assay`) is added as one *assay* referencing to samples and MS runs.
#'   In most cases the number of MS runs will match the number of assays, i.e.,
#'   each row in `x` is one MS run as well as one assay. A 1:n mapping between
#'   assay and MS run is also possible.
#'
#' - study variables: each column defined with parameter `groups` is added as
#'   one *study variable group*.
#'
#' @section Defining columns with information on MS runs, assays and samples:
#'
#' - `msRunCols()`: function to create a named `character` defining the columns
#'   in `x` containinig information for the individual parameters. To change
#'   the default for the column containing the MS data file names (default
#'   `location = "location"`) to a column called e.g. `"mzml_file"`:
#'   `msRunCols(location = "mzml_file")`. Parameters `location` and
#'   `scan_polarity` have to be set to match the column names in `x` with the
#'   respective information. See examples for more information.
#'
#' - `assayCols()`: function to define columns containing information on assays.
#'   Parameter `assay` has to be adapted. Through `...` it is also possible
#'   to define additional columns with optional information on each assay.
#'
#' - `sampleCols()`: function to define columns containing sample information.
#'   Through `...` additional optional columns with sample information can be
#'   provided.
#'
#' @note
#'
#' The SML and SMF sections must report one column for each **assay**. Thus,
#' each row in the input sample data `x` is expected to be one assay.
#'
#' In mzTab-M a *sample* is the source of an biological sample. If in an
#' experiment e.g. multiple blood samples are taken at different time points
#' from the same individual, the individual is considered a single sample.
#' Information on the time points can be provided as study variables using the
#' `groups` parameter.
#'
#' @param x `data.frame` with information on samples, MS runs and assays. Each
#'     row is expected to represent one MS run (MS data file) and columns
#'     providing information on the measured sample(s) along with
#'     experimental and technical information.
#'
#' @param sampleCols. named `character` vector defining the columns in `x`
#'     containing information for the individual sample fields (with names
#'     being the name of the mzTab-M field and values the respective column
#'     name in `x`). The `sampleCols()` function can be used to define this
#'     parameter. See examples below and [mtdSample()] for more information.
#'
#' @param msRunCols. named `character` vector defining the columns in `x`
#'     containing information on the MS runs (with names being the name of the
#'     mzTab-M field and values the respective column name in `x`). Required
#'     fields/parameters are `location` and `scan_polarity`. The `msRunCols()`
#'     function can be used to define this parameter. See examples below and
#'     [mtdMsRun()] for more information.
#'
#' @param assayCols. named `character` vector defining the columns in `x`
#'     containing information for the individual assays fields (with names
#'     being the name of the mzTab-M field and values the respective column
#'     name in `x`). Parameter/field `assay` is required. The `assayCols()`
#'     function can be used to define this parameter. See examples below and
#'     [mtdAssay()] for more information.
#'
#' @inheritParams mtdSample
#'
#' @inheritParams mtdMsRun
#'
#' @inheritParams mtdAssay
#'
#' @inheritParams mtdDefineStudyVariables
#'
#' @return two column `character` `matrix`.
#'
#' @author Johannes Rainer
#'
#' @seealso [mtdToSampleData()] for the inverse function.
#'
#' @examples
#'
#' ## Defining an example sample data:
#' ## - file: the mzML file, i.e., the *MS run*.
#' ## - name: the name of the measurement. This is also the name of the sample:
#' ##         QC is the pool of all samples, s1 to s4 the ID of the individual.
#' ## - phenotype: defining the biological replicates, 2 for CVD, 2 for CTR.
#' ## - age: covariate, age of the individuals.
#' ## - injection_index: the order in which samples were measured.
#' sdata <- data.frame(
#'     file = c("1.mzML", "2.mzML", "3.mzML", "4.mzML", "5.mzML", "6.mzML"),
#'     name = c("QC", "s1", "s2", "QC", "s3", "s4"),
#'     phenotype = c(NA, "CVD", "CTR", NA, "CTR", "CVD"),
#'     age = c(NA, 35, 32, NA, 43, 32),
#'     injection_index = c(1, 2, 3, 4, 5, 6))
#' ## Add additional required columns:
#' sdata$polarity <- "positive"
#'
#' ## Add columns with optional, additional information to the individual
#' ## samples or assays.
#' sdata$organism <- "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"
#' sdata$assay_info <- c("run1", "run2", "run3", "run4", "run5", "run6")
#'
#' ## Define the columns in `sdata` that provide information on the individual
#' ## samples.
#' scols <- sampleCols(sample = "name", species = "organism")
#'
#' ## Define the columns in `sdata` that provide MS run information
#' mscols <- msRunCols(location = "file", scan_polarity = "polarity")
#'
#' ## Define the columns in `sdata` that provide assay information; we use
#' ## the MS run/file name also for the assay name and add an additional
#' ## column with optional content/information.
#' acols <- assayCols(assay = "file", assay_info = "assay_info")
#'
#' ## Create the MTD section from the `sdata` `data.frame`. Parameter `groups`
#' ## allows to define the columns in `sdata` that should be encoded as
#' ## *study variable groups*.
#' m <- mtdFromSampleData(sdata, sampleCols = scols, msRunCols = mscols,
#'     assayCols = acols, groups = c("phenotype", "age", "injection_index"))
#'
#' ## The sample to assay mapping:
#' ## The repeated injection (assay 1 and 4) of the QC sample are assigned
#' ## to the same sample (1).
#' getMtdField(m, "assay\\[\\d\\]-sample_ref")
#'
#' ## The study variable 2 represents a value of `"CVD"` for the *phenotype*
#' ## study variable group
#' getMtdField(m, "study_variable\\[2\\]$")
#'
#' ## and this study variable references the 2nd and 6th assay
#' getMtdField(m, "study_variable\\[2\\]-assay_refs")
#'
#'
#' ## It is also possible to create a MTD section without samples or
#' ## study variables
#' m <- mtdFromSampleData(
#'     sdata,
#'     msRunCols = c(location = "file", scan_polarity = "polarity"),
#'     assayCols = c(assay = "assay_info"))
#' m
#' @export
mtdFromSampleData <- function(x,
                              sampleCols. = sampleCols(),
                              msRunCols. = msRunCols(),
                              assayCols. = assayCols(),
                              groups = character(),
                              group_description = character(),
                              group_type = character(),
                              group_datatype = character(),
                              group_unit = character(),
                              average_function = "[MS, MS:1002962, mean, ]",
                              variation_function = "[MS, MS:1002963, variation coefficient, ]",
                              description = character()
                              ) {
    ## mtdSample: all is optional; have a 0-row matrix if not provided
    sampleCols. <- sampleCols.[sampleCols. %in% colnames(x)]
    xsample <- unique(x[, sampleCols., drop = FALSE])
    colnames(xsample) <- names(sampleCols.)
    s <- do.call(mtdSample, as.list(xsample))
    if (!nrow(s)) xsample <- data.frame()

    ## mtdMsRun: required columns are: `"location"` and `"scan_polarity"`
    if (!any(names(msRunCols.) == "location") ||
        !any(colnames(x) == msRunCols.["location"]))
        stop("Column \"", msRunCols.["location"], "\" not found in 'x'. This ",
             "column is mandatory and needs to provide the file name of each ",
             "MS run (or \"null\" if there are no files). Please provide the ",
             "respective column name with ",
             "'msRunCols. = msRunCols(location = <column name>, ...)'.",
             call. = FALSE)
    if (!any(names(msRunCols.) == "scan_polarity") ||
        !any(colnames(x) == msRunCols.["scan_polarity"]))
        stop("Column \"", msRunCols.["scan_polarity"], "\" not found in 'x'. ",
             "This column is mandatory and needs to provide the polarity of ",
             "each MS run. Please provide the respective column name with ",
             "'msRunCols. = msRunCols(scan_polarity = <column name>, ...)'.",
             call. = FALSE)
    msRunCols. <- msRunCols.[msRunCols. %in% colnames(x)]
    l <- as.list(x[, msRunCols., drop = FALSE])
    names(l) <- names(msRunCols.)
    m <- do.call(mtdMsRun, l)

    ## mtdAssay: required column: `"assay"`
    if (!any(names(assayCols.) == "assay") ||
        !any(colnames(x) == assayCols.["assay"]))
        stop("Column \"", assayCols.["assay"], "\" not found in 'x'. This ",
             "column is mandatory and needs to provide a name/identifier for ",
             "each *assay*. In most cases, assay will be the same as the MS ",
             "run. Please provide the respective column name with ",
             "'assayCols. = assayCols(assay = <column name>, ...)'.",
             call. = FALSE)
    if (anyDuplicated(x[, assayCols.["assay"]]))
        message("Relationship between assay and ms_run is 1:n. Please be ",
                "aware that the SMF and SML section are expected to contain ",
                "an abundance column for each assay, not ms_run.")
    assayCols. <- assayCols.[assayCols. %in% colnames(x)]
    l <- as.list(unique(x[, assayCols., drop = FALSE]))
    names(l) <- names(assayCols.)
    if (ncol(xsample) && !any(names(l) == "sample_ref")) {
        ## unique identifier for each sample
        sample_id <- apply(x[, sampleCols., drop = FALSE], MARGIN = 1,
                           paste0, collapse = "-")
        ## ref assay -> sample: based on unique sample and assay columns.
        assay_sample <- unique(cbind(x[, assayCols.["assay"]], sample_id))[, 2L]
        l$sample_ref <- paste0(
            "sample[", match(assay_sample, unique(assay_sample)), "]")
    }
    if (!any(names(l) == "ms_run_ref")) {
        ## ref assay -> ms_run: each row in `x` is assumed to be one ms_run: we
        ## expect/support only ms_run:assay = 1:n mapping
        idx <- match(x[, assayCols.["assay"]], unique(x[, assayCols.["assay"]]))
        l$ms_run_ref <- vapply(
            split(seq_along(idx), idx),
            function(z) paste0("ms_run[", z, "]", collapse = "|"),
            NA_character_)
    }
    a <- do.call(mtdAssay, l)

    ## mtdStudyVariables; arguments can not be extracted from `x`.
    ## If assay:ms_run is not 1:1: make x unique on groups and assay.
    if (length(l[[1L]]) != nrow(x)) {
        x <- unique(x[, c(assayCols., groups)])
        if (nrow(x) != length(l[[1L]]))
            stop("Study variable information (parameter 'group') and assays ",
                 "don't align.", call. = FALSE)
    }
    sv <- mtdStudyVariables(
        x, groups = groups, group_description = group_description,
        group_type = group_type, group_datatype = group_datatype,
        group_unit = group_unit, average_function = average_function,
        variation_function = variation_function, description = description)
    m <- rbind(m, s, a, sv)
    mtdSort(m)
}

#' @title Reconstruct a sample data frame from mzTab-M MTD content
#'
#' @description
#'
#' `mtdToSampleData()` is the inverse of [mtdFromSampleData()]: it takes an
#' MTD section and reconstructs a *sample data* `data.frame` with one row per
#' *ms_run*, analogous to the input expected by `mtdFromSampleData()`.
#'
#' @param mtd MTD section of the MzTabM object.
#'
#' @return `data.frame` with one row per `"ms_run"` and columns with information
#'     on `"ms_run"`, `"assay"`, `"sample"`, `"study_variables"`,
#'     `"instrument"`, `"protocol"` sections.
#'
#' @importFrom data.table setnames
#'
#' @author Gabriele Tomè
#'
#' @seealso [mtdFromSampleData()] for the inverse function.
#'
#' @examples
#'
#' ## Defining an example sample data:
#' ## - file: the mzML file, i.e., the *MS run*.
#' ## - name: the name of the measurement. This is also the name of the sample:
#' ##         QC is the pool of all samples, s1 to s4 the ID of the individual.
#' ## - phenotype: defining the biological replicates, 2 for CVD, 2 for CTR.
#' ## - age: covariate, age of the individuals.
#' ## - injection_index: the order in which samples were measured.
#' sdata <- data.frame(
#'     file = c("1.mzML", "2.mzML", "3.mzML", "4.mzML", "5.mzML", "6.mzML"),
#'     name = c("QC", "s1", "s2", "QC", "s3", "s4"),
#'     phenotype = c(NA, "CVD", "CTR", NA, "CTR", "CVD"),
#'     age = c(NA, 35, 32, NA, 43, 32),
#'     injection_index = c(1, 2, 3, 4, 5, 6))
#' ## Add additional required columns:
#' sdata$polarity <- "positive"
#'
#' ## Add columns with optional, additional information to the individual
#' ## samples or assays.
#' sdata$organism <- "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"
#' sdata$assay_info <- c("run1", "run2", "run3", "run4", "run5", "run6")
#'
#' ## Define the columns in `sdata` that provide information on the individual
#' ## samples.
#' scols <- sampleCols(sample = "name", species = "organism")
#'
#' ## Define the columns in `sdata` that provide MS run information
#' mscols <- msRunCols(location = "file", scan_polarity = "polarity")
#'
#' ## Define the columns in `sdata` that provide assay information; we use
#' ## the MS run/file name also for the assay name and add an additional
#' ## column with optional content/information.
#' acols <- assayCols(assay = "file", assay_info = "assay_info")
#'
#' ## Create the MTD section from the `sdata` `data.frame`. Parameter `groups`
#' ## allows to define the columns in `sdata` that should be encoded as
#' ## *study variable groups*.
#' m <- mtdFromSampleData(sdata, sampleCols = scols, msRunCols = mscols,
#'     assayCols = acols, groups = c("phenotype", "age", "injection_index"))
#'
#' ## Reconstruct the sample data from the MTD section. The column names might
#' ## differ from the original `sdata` `data.frame` if non-mzTabM names are
#' ## used in the original sdata, but the content is identical.
#' sdata2 <- mtdToSampleData(m)
#' sdata2
#'
#' @export
mtdToSampleData <- function(mtd) {
    fields <- mtd[, 1L]

    ## Extract Assay
    assay_absent <- is.na(.mtd_get_field(mtd, "^assay\\[([0-9]+)\\]$",
                                    exact = FALSE, fixed = FALSE)[[1]])
    if (all(assay_absent))
        stop("No 'assay' information found in 'mtd'.", call. = FALSE)

    assay_field <- mtd[grepl("^assay\\[([0-9]+)\\]", fields), ]
    res <- .mtd_long_to_wide(assay_field)
    setnames(res, "name", "assay")

    ## Extract protocol and merge by assay[i]-protocol_ref
    if ("protocol_ref" %in% colnames(res)) {
        protocol_field <- mtd[grepl("^protocol\\[([0-9]+)\\]", fields), ]
        protocol_w <- .mtd_long_to_wide(protocol_field)
        setnames(protocol_w, "name", "protocol")
        res <- merge(res, protocol_w, by.x = "protocol_ref", by.y = "id")
    }

    ## Extract ms_run and merge by assay[i]-ms_run_ref
    if ("ms_run_ref" %in% colnames(res)) {
        ms_run_field <- mtd[grepl("^ms_run\\[([0-9]+)\\]", fields), ]
        ms_run_w <- .mtd_long_to_wide(ms_run_field)

        if ("instrument_ref" %in% colnames(ms_run_w)) {
            instrument_field <- mtd[grepl("^instrument\\[([0-9]+)\\]",
                                          fields), ]
            instrument_w <- .mtd_long_to_wide(instrument_field)
            setnames(instrument_w, "name", "instrument")
            ms_run_w <- merge(ms_run_w, instrument_w,
                              by.x = "instrument_ref", by.y = "id")
        }

        res <- .separate_multi_links(res, "ms_run_ref")
        res <- merge(res, ms_run_w, by.x = "ms_run_ref", by.y = "id")
    }

    ## Extract sample and merge by assay[i]-sample_ref
    if ("sample_ref" %in% colnames(res)) {
        res <- .separate_multi_links(res, "sample_ref")
        sample_field <- mtd[grepl("^sample\\[([0-9]+)\\]", fields), ]
        sample_w <- .mtd_long_to_wide(sample_field)
        setnames(sample_w, "name", "sample")
        res <- merge(res, sample_w, by.x = "sample_ref", by.y = "id")
    }

    ## Exctract study variable and match with study_variable[i]-assay_refs
    if(any(grepl("^study_variable_group\\[([0-9]+)\\]", fields))) {
        study_var_grp_field <- mtd[grepl("^study_variable_group\\[([0-9]+)\\]",
                                        fields), ]
        study_var_grp_w <- .mtd_long_to_wide(study_var_grp_field)
        study_var_grp_w$group <- parseCvParameter(study_var_grp_w$name, 3)

        if (all(study_var_grp_w$group != "undefined")) {
            study_var_field <- mtd[grepl("^study_variable\\[([0-9]+)\\]",
                                            fields), ]
            cols <- c("name", "assay_refs", "group_ref")
            study_var_w <- .mtd_long_to_wide(study_var_field)[, cols]
            study_var_w <- .separate_multi_links(study_var_w, "assay_refs")

            study_l <- merge(study_var_w, study_var_grp_w[, c("id", "group")],
                                by.x = "group_ref", by.y = "id")
            cols_study <- c("assay_refs", "group", "name")
            study_w <- reshape(study_l[, cols_study], idvar = "assay_refs",
                                timevar = "group", direction = "wide")
            colnames(study_w) <- sub("^name\\.", "", colnames(study_w))

            res <- merge(res, study_w, by.x = "id", by.y = "assay_refs")
        }
    }

    data.frame(res, row.names = basename(res$location))
}

#' @export
#'
#' @rdname mtdFromSampleData
sampleCols <- function(sample = "sample", species = "species",
                       tissue = "tissue", cell_type = "cell_type",
                       disease = "disease", description = "description", ...) {
    dots <- list(...)
    opt_cn <- as.character(dots)
    names(opt_cn) <- names(dots)
    c(sample = sample, species = species, tissue = tissue,
      cell_type = cell_type, disease = disease, description = description,
      opt_cn)
}

#' @export
#'
#' @rdname mtdFromSampleData
msRunCols <- function(location = "location", instrument_ref = "instrument_ref",
                      format = "format", id_format = "id_format",
                      fragmentation_method = "fragmentation_method",
                      scan_polarity = "scan_polarity", hash = "hash",
                      hash_method = "hash_method") {
    c(location = location, instrument_ref = instrument_ref, format = format,
      id_format = id_format, fragmentation_method = fragmentation_method,
      scan_polarity = scan_polarity, hash = hash, hash_method = hash_method)
}

#' @export
#'
#' @rdname mtdFromSampleData
assayCols <- function(assay = "assay", external_uri = "external_uri",
                      sample_ref = "sample_ref", ms_run_ref = "ms_run_ref",
                      ...) {
    dots <- list(...)
    opt_cn <- as.character(dots)
    names(opt_cn) <- names(dots)
    c(assay = assay, external_uri = external_uri, sample_ref = sample_ref,
      ms_run_ref = ms_run_ref, opt_cn)
}

################################################################################
##    INTERNAL HELPER FUNCTIONS
################################################################################

#' @description
#'
#' Helper function to create the CV entrie(s) for an mzTab-M file.
#'
#' @note all paramters have to have the same length.
#'
#' @param label `character` with the label of the CV(s)
#'
#' @param full_name `character` with the name of the CV(s)
#'
#' @param version `character` with the version of the CV(s)
#'
#' @param uri `character`
#'
#' @return two column `character` `matrix`.
#'
#' @author Philippine Louail, Johannes Rainer
#'
#' @noRd
.cv <- function(label = character(), full_name = character(),
                version = character(), uri = character()) {
    if (!length(label)) return(matrix(NA_character_, ncol = 2, nrow = 0))
    mtdFields(label = label, full_name = full_name, version = version,
               uri = uri, field_prefix = "cv")
}

.database <- function(database = character(), prefix = character(),
                      version = character(), uri = character()) {
    if (!length(database)) return(matrix(NA_character_, ncol = 2, nrow = 0))
    mtdFields(database, prefix = prefix, version = version, uri = uri,
               field_prefix = "database")
}

#' Helper function to create `xxx[1]-custom[1]` fields for `character` vectors
#' passed through `...`. It is somewhat similar to the `.mtd_multi_fields()`,
#' but takes arbitrary many input variables, that have however all to have
#' the same length. Thus, it is expected that for each element exactly one
#' value is provided, while `.mtd_multi_fields()` supports a variable number
#' of values per element (and hence requires a `list` as input).
#'
#' @return `character` `matrix` with 3 columns (third column being the index)
#'     that could be used to order the rows later.
#'
#' @author Johannes Rainer
#'
#' @noRd
#'
#' @examples
#'
#' ## Single custom field
#' .mtd_custom_fields(c("a", "b", "c"), prefix = "sample", expected_length = 3)
#'
#' ## Two custom fields per sample
#' .mtd_custom_fields(c("a", "b", "c"), c("A", "B", "C"),
#'     prefix = "sample", expected_length = 3)
.mtd_custom_fields <- function(..., prefix = "sample", suffix = "custom",
                               expected_length = 0L) {
    dots <- list(...)
    s <- seq_len(expected_length)
    if (length(dots)) {
        do.call(rbind, lapply(seq_along(dots), function(i) {
            name_i <- names(dots)[i]
            z <- dots[[i]]
            if (length(z) != expected_length)
                stop("If optional custom information is provided the length ",
                     "has to match the length of '", prefix, "'", call. = FALSE)
            cbind(paste0(prefix, "[", s, "]-", suffix, "[", i, "]"),
                  paste0("[,,", name_i, ", ", z, "]"), s)
        }))
    } else matrix(ncol = 3, nrow = 0, NA_character_)
}

#' Helper function to create entries in the format `<prefix>[i]-<suffix>[j]`,
#' e.g. `"sample[1]-species[1]"` `"sample[1]-species[2]"`, i.e., fields with
#' multiple possible values. The information **must** be passed as a `list`,
#' each list element providing the information for one entity. A list element
#' can also be `NULL` if for one entity no value is defined.
#'
#' See also the `.mtd_custom_fields()` function for an alternative.
#'
#' @param x `list` with values per field `prefix`. The length of `x` defines
#'     the index `i`, while the length of each list element defines the index
#'     `j`.
#'
#' @param prefix `character(1)` with the suffix of the field.
#'
#' @param suffix `character(1)` with the name of the field.
#'
#' @return 3 column `character` `matrix`, the third column being the index along
#'     `x` which can be used to re-order the results.
#'
#' @noRd
#'
#' @author Johannes Rainer
#'
#' @examples
#'
#' ## 1:1 sample to species mapping, with no species defined for the 2nd sample
#' .mtd_multi_fields(
#'     list("[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]",
#'          NULL,
#'          "[NCBITaxon, NCBITaxon:39767, Human rhinovirus 11, ]"),
#'     prefix = "sample", suffix = "species")
#'
#' ## 2 species for the first sample, none for the second and one for the third
#' .mtd_multi_fields(
#'     list(c("[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]",
#'            "[NCBITaxon, NCBITaxon:39767, Human rhinovirus 11, ]"),
#'          NULL,
#'          "[NCBITaxon, NCBITaxon:39767, Human rhinovirus 11, ]"),
#'     prefix = "sample", suffix = "species")
.mtd_multi_fields <- function(x, prefix, suffix) {
    do.call(rbind, lapply(seq_along(x), function(i) {
        vals <- x[[i]]
        if (lv <- length(vals)) {
            cbind(paste0(prefix, "[", rep(i, lv), "]-",
                         suffix, "[", seq_len(lv), "]"),
                  vals,
                  order = .prefix_zero(rep(i, lv)))
        }
    }))
}

#' @param x would be sequence from 1 to number of runs
#'
#' @param name the name of the field
#'
#' @param values the actual values
#'
#' @return 3 column `matrix`
#'
#' @noRd
#'
#' @examples
#'
#' .ms_run_format(1:3, "format", rep("[MS, MS:1000584, mzML file, ]", 3))
.ms_run_format <- function(x, name, values) {
    cbind(paste0("ms_run[", x, "]-", name),
          values, order = .prefix_zero(x))
}

#' Helper to convert `"positive"` and `"negative"` polarity into the respective
#' terms from the MS ontology.
#'
#' @noRd
.ms_scan_polarity <- function(x) {
    if (!all(x %in% c("positive", "negative")))
        stop("'scan_polarity' has to be either \"positive\" or ",
             "\"negative\".", call. = FALSE)
    x[x == "positive"] <- "[MS, MS:1000130, positive scan, ]"
    x[x == "negative"] <- "[MS, MS:1000129, negative scan, ]"
    x
}

#' @description
#'
#' Creates a `data.frame` of study variables and their study variable groups.
#'
#' @param x `data.frame` with sample annotations. Each row being one assay.
#'
#' @param groups `character` with the names of the column(s)
#'     from which study variables should be defined.
#'
#' @return `data.frame` with all study variable (values) in one column and the
#'     associated study variable group (column) in the second.
#'
#' @noRd
#'
#' @author Philippine Louail
#'
#' @examples
#'
#' x <- data.frame(sex = c("male", "female", "female", "male", "male"),
#'                 group = c("case", "case", "control", "case", "control"))
#'
#' .mztab_study_variables(x, c("sex", "group"))
#'
#' .mztab_study_variables(x, "sex")
.mztab_study_variables <- function(x = data.frame(),
                                   groups = colnames(x)) {
    data.frame(
        study_variable = as.vector(unlist(lapply(x[, groups, drop = FALSE],
                                                 as.character))),
        study_variable_group = rep(groups, each = nrow(x)))
}

#' Helper to create the parameter fields for a given set of parameters.
#'
#' @param prefix `character(1)` with the prefix of the field, e.g. `"assay"`.
#'
#' @param parameters `character` with the parameter values.
#'
#' @param l `integer(1)` with the number of repetion.
#'
#' @return `character` `matrix` with the parameter fields.
#'
#' @noRd
.mtd_parameters_fields <- function(prefix = character(),
                                    parameters = character(), l = 0L) {
    if (length(parameters) != l)
        parameters <- rep(parameters[1], l)
    if (!is.list(parameters)) parameters <- as.list(parameters)
    param_mod <- lapply(seq_along(parameters), function(z) {
        vals <- parameters[[z]]
        if (lv <- length(vals)) {
            cbind(paste0(prefix, "[", rep(z, lv), "]-parameter[",
                        seq_len(lv), "]"),
                parameters[[z]],
                order = .prefix_zero(rep(z, lv)))
        }
    })
    do.call(rbind, param_mod)
}

#' Defines the order of the elements in MTD (pattern provided). This should
#' be used in a function that orders the MTD part of a mzTab-M file.
#'
#' @noRd
.MTD_FIELD_ORDER <- c(
    "^mzTab-version",
    "^mzTab-ID",
    "^title",
    "^description",
    "^sample_processing",
    "^instrument",
    "^software",
    "^publication",
    "^contact",
    "^uri",
    "^external_study",
    "^quantification",
    "^sample",
    "^ms_run",
    "^assay",
    "^study_variable_group",
    "^study_variable",
    "^protocol",
    "^custom",
    "^cv",
    "^database",
    "^derivatization",
    "^small_molecule-quantification",
    "^small_molecule_feature",
    "^small_molecule-identification",
    "^id_confidence",
    "^colunit-small_molecule$",
    "^colunit-small_molecule_feature",
    "^colunit-small_molecule_evidence"
)

.MTD_UNIQUE_FIELD <- c(
    "mzTab-version",
    "mzTab-ID",
    "title",
    "description",
    "quantification_method",
    "small_molecule-quantification",
    "small_molecule_feature",
    "small_molecule-identification",
    "colunit-small_molecule$",
    "colunit-small_molecule_feature",
    "colunit-small_molecule_evidence"
)

################################################################################
##    Parse MTD section
##
################################################################################

#' Helper to extract field values for provided field keys (names).
#'
#' @param x two column `data.frame` or `matrix` in the format created by
#'     `mtdSkeleton()`, first column being the field names, second the
#'     values.
#'
#' @param name `character` with the name(s) of the fields to extract.
#'
#' @param exact `logical(1)` whether the provided name has to be exactly
#'     matched or only partially (default `exact = TRUE)`. See details for more
#'     information.
#'
#' @param fixed `logical(1)` passed to `grep()` (only used for `exact = FALSE`).
#'
#' @param ... additional parameter passed to `grep()` (only used for
#'     `exact = FALSE`).
#'
#' @return `list()` of length equal to `length(name)` with the values of fields
#'     matching the provided names or `NA_character_` if the field was not
#'     found.
#'
#' @noRd
#'
#' @examples
#'
#' ## Defining a dummy metadata (MTD) matrix.
#' m <- cbind(c(
#'     "instrument[1]-name",
#'     "instrument[1]-source",
#'     "instrument[2]-name",
#'     "instrument[2]-source",
#'     "sample[1]",
#'     "sample[1]-species[1]",
#'     "sample[2]",
#'     "sample[2]-species[2]"),
#'     c(
#'     "instrument 1",
#'     "instrument 1 source",
#'     "instrument 2",
#'     "instrument 2 source",
#'     "first sample",
#'     "human",
#'     "second sample",
#'     "human"
#'     ))
#'
#' ## Get the value for the first instrument
#' .mtd_get_field(m, name = "instrument[1]-name")
#'
#' ## Get all fields for the first instrument
#' .mtd_get_field(m, name = "instrument[1]", fixed = FALSE)
#'
#' ## Get all fields for the
#'
#' ## If field is not present
#' .mtd_get_field(m, name = "missing")
.mtd_get_field <- function(x, name = character(), exact = TRUE,
                           fixed = TRUE, ...) {
    names(name) <- name
    lapply(name, function(z) {
        if (exact) {
            idx <- match(x[, 1L], z)
            idx <- idx[!is.na(idx)]
        } else
            idx <- grep(z, x[, 1L], fixed = fixed, ...)
        if (length(idx)) {
            res <- x[idx, 2L]
            names(res) <- x[idx, 1L]
            res
        }
        else NA_character_
    })
}

#' Helper function to check and define the study_variable_group_description.
#'
#' @param x `data.frame` with columns used as study_variable_group
#'
#' @return `character` of length equal to `ncol(x)` with the study variable
#'     group description.
#'
#' @noRd
.mtd_svar_group_description <- function(x, group_description = character()) {
    grp <- colnames(x)
    if (length(group_description)) {
        if (length(grp) != length(group_description))
            stop("Length of 'group_description' has to match length of ",
                 "'groups'.", call. = FALSE)
        group_description
    } else paste0("Sample matrix column ", grp)
}

#' Helper function to check or guess the (STATO) study variable group type
#' from the R data types of columns in the input `data.frame` `x`.
#'
#' @param x `data.frame` with columns being the study variable types
#'
#' @param group_type `character`, if provided, of length equal to `ncol(x)` with
#'     the data types to check for validity of the provided names. If not
#'     provided, the data type is guessed on the data type of the column.
#'
#' @return `character` with the param of the data type
#'
#' @noRd
.mtd_svar_group_type <- function(x, group_type = character()) {
    if (length(group_type)) {
        if (length(group_type) != ncol(x))
            stop("If provided, the length of 'group_type' has to match the ",
                 "number of study variable groups.", call. = FALSE)
        ## Check that it contains supported types.
        st <- parseCvParameter(group_type)
        idx <- match(st, parseCvParameter(.STUDY_VARIABLE_GROUP_TYPE$stato))
        if (anyNA(idx)) {
            stop("Group types ", paste0("\"", st[is.na(idx)], "\"",
                                        collapse = ", "),
                 " are not supported. See ?mtdStudyVariables for supported",
                 " study variable group types.", call. = FALSE)
        }
        .STUDY_VARIABLE_GROUP_TYPE$stato[idx]
    } else {
        dtype <- vapply(x, function(z) class(z)[1L], NA_character_)
        ## get FIRST match for each
        idx <- match(dtype, .STUDY_VARIABLE_GROUP_TYPE$r)
        if (anyNA(idx))
            stop("Group type(s) ", paste0(dtype[is.na(idx)], collapse = ", "),
                 " are not supported", call. = FALSE)
        .STUDY_VARIABLE_GROUP_TYPE$stato[idx]
    }
}

#' Mapping of study variable type to R data types.
#'
#' STATO:0000252: categorical
#' STATO:0000251: continuous
#' STATO:0000228: ordinal
#'
#' @noRd
.STUDY_VARIABLE_GROUP_TYPE <- data.frame(
    r = c("character", "factor", "logical", "numeric", "integer", "integer"),
    stato = c("[STATO, STATO:0000252, categorical variable, ]",
              "[STATO, STATO:0000252, categorical variable, ]",
              "[STATO, STATO:0000252, categorical variable, ]",
              "[STATO, STATO:0000251, continuous variable, ]",
              "[STATO, STATO:0000251, continuous variable, ]",
              "[STATO, STATO:0000228, ordinal variable, ]")
)

#' Helper function to check or define the datatype for study variable groups.
#'
#' @param x `data.frame` with columns being the study variable groups
#'
#' @param group_datatype `character` with the datatype for the groups (columns).
#'     If provided, it will be checked for valid entries, if not provided it
#'     will be guessed from the data type of the columns.
#'
#' @return `character` of length equal to `ncol(x)` with the datatype for each
#'     column.
#'
#' @noRd
.mtd_svar_group_datatype <- function(x, group_datatype = character()) {
    if (length(group_datatype)) {
        if (length(group_datatype) != ncol(x))
            stop("If provided, the length of 'group_datatype' has to match ",
                 "the number of study variable groups.", call. = FALSE)
        idx <- match(group_datatype, .STUDY_VARIABLE_GROUP_DATATYPE$xsd)
        if (anyNA(idx)) {
            stop("Group datatypes ",
                 paste0("\"", group_datatype[is.na(idx)], "\"",collapse = ", "),
                 " are not supported. See ?mtdStudyVariables for supported",
                 " study variable group datatypes.", call. = FALSE)
        }
        .STUDY_VARIABLE_GROUP_DATATYPE$xsd[idx]
    } else {
        dtype <- vapply(x, function(z) class(z)[1L], NA_character_)
        idx <- match(dtype, .STUDY_VARIABLE_GROUP_DATATYPE$r)
        if (anyNA(idx))
            stop("Group datatype(s) ", paste0(dtype[is.na(idx)],collapse =", "),
                 " are not supported", call. = FALSE)
        res <- .STUDY_VARIABLE_GROUP_DATATYPE$xsd[idx]
        is_cv <- vapply(x, function(z) {
            z <- z[!is.na(z)]
            z <- z[!z %in% c("", "null")]
            all(isCvParameter(z))
        },  NA)
        if (any(is_cv))
            res[is_cv] <- "Parameter"
        res
    }
}

#' Helper function to check that provided values are parameters, `""` or `NA`.
#'
#' @return throws an error or returns `group_unit`
#'
#' @noRd
.mtd_svar_group_unit <- function(x, group_unit = character()) {
    if (length(group_unit)) {
        if (length(group_unit) != ncol(x))
            stop("If provided, the length of 'group_unit' has to match the ",
                 "number of study variable groups. Use an empty string or NA ",
                 "for study variable groups (columns in x) for which you do ",
                 "**not** want to define a unit.", call. = FALSE)
        group_unit[is.na(group_unit)] <- ""
        idx <- which(nchar(group_unit) > 0)
        if (length(idx) && any(i <- !isCvParameter(group_unit[idx])))
            stop("Provided value(s) in 'group_unit': ",
                 paste0("\"", group_unit[idx][i], "\"", collapse = ", "),
                 " is/are not a CV parameter.", call. = FALSE)
        group_unit
    } else rep("", ncol(x))
}

#' Helper function to compute the linkage between `study_variable_group` and
#' `study_variable`.
#'
#' @return returns `study_variable_ref`
#'
#' @noRd
.mtd_svar_group_variable_ref <- function(svars) {
    svars$index <- seq_len(nrow(svars))
    variable_ref <- lapply(unique(svars$study_variable_group), function(g) {
        paste0("study_variable[",
                svars[svars$study_variable_group == g, "index"],
                "]", collapse = "|")
    })
    variable_ref
}

.STUDY_VARIABLE_GROUP_DATATYPE <- data.frame(
    r = c("character", "integer", "numeric", "logical", "factor",
          "character", "character", "character", "character", "character"),
    xsd = c("xsd:string", "xsd:integer", "xsd:decimal", "xsd:boolean",
            "xsd:string", "xsd:dateTime", "xsd:date", "xsd:time", "xsd:anyURI",
            "Parameter")
)


#' @title Add, update or get instrument metadata of an mzTab-M MTD section
#'
#' @name setMtdInstrument
#'
#' @aliases setMtdInstrument,dfmatrix-method setMtdInstrument,MzTabM-method
#'
#' @description
#'
#' `setMtdInstrument()` sets or updates instrument-related metadata fields
#' within an MTD (metadata) section. When instrument metadata already exists,
#' the function can either replace it entirely or append new values to the
#' existing ones.
#'
#' `getMtdInstrument()` returns the instrument information from an MTD section.
#'
#' @param x A MTD section that stores metadata fields. Can be a two-column
#'     `character` matrix, a two-column `data.frame` or a [MzTabM()] object.
#'     Defaults to `matrix()`. If all values are `NA`, the function returns `x`
#'     unchanged.
#'
#' @param name `character` with the name of the instrument used in the
#'     experiment. (e.g., `"[MS, MS:1000449, LTQ Orbitrap,]"`).
#'
#' @param source `character` with the instrument’s source used in the
#'     experiment. (e.g., `"[MS, MS:1000073, ESI,]"`).
#'
#' @param analyzer `character` with the instrument’s analyzer type(s) used in
#'     the experiment. **Must** be provided in the form
#'     `c("analyzer[1]" = "[MS, MS:1000291, linear ion trap,]")` for a single
#'     analyzer, or `c("analyzer[1]" = "<analyzer 1>", "analyzer[2] = ...")`
#'     for multiple analyzers.
#'
#' @param detector `character` with the instrument’s detector type used in the
#'     experiment. (e.g., `"[MS, MS:1000253, electron multiplier,]"`).
#'
#' @param replace `logical` flag controlling how pre-existing instrument
#'     metadata is handled:
#'     \itemize{
#'         \item `FALSE` (default): new values are appended to any existing
#'         values.
#'         \item `TRUE`: existing instrument metadata is discarded and
#'         replaced entirely by the supplied arguments.
#'     }
#'
#' @return
#'
#' - For `setMtdInstrument()`: the input object `x` updated to include the new
#'   or merged instrument metadata fields. If `x` is empty, the empty `x`.
#' - For `getMtdInstrument()`: a named `character` with the instrument
#'   information, names being the field names.
#'
#' @author Gabriele Tomè
#'
#' @examples
#'
#' x <- mtdSkeleton("001", software = "[MS, MS:1001582, xmcs, 4.0.0]")
#' ## Add instrument metadata to an existing mzTab object
#' mtd <- setMtdInstrument(x, name = "[MS, MS:1000449, LTQ Orbitrap,]",
#'           source = "[MS, MS:1000073, ESI,]",
#'           analyzer = c(`analyzer[1]` = "[MS, MS:1000291, linear ion trap,]"),
#'           detector = "[MS, MS:1000253, electron multiplier,]")
#'
#' ## Replace all existing instrument metadata
#' mtd <- setMtdInstrument(mtd, name = "[MS, MS:1000449, LTQ Orbitrap,]",
#'           source = "[MS, MS:1000073, ESI,]",
#'           analyzer = c(`analyzer[1]` = "[MS, MS:1000291, linear ion trap,]"),
#'           detector = "[MS, MS:1000253, electron multiplier,]",
#'           replace = TRUE)
#'
#' x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
#' mtd <- setMtdInstrument(x, name = "[MS, MS:1000449, LTQ Orbitrap,]",
#'           source = "[MS, MS:1000073, ESI,]",
#'           analyzer = c(`analyzer[1]` = "[MS, MS:1000291, linear ion trap,]"),
#'           detector = "[MS, MS:1000253, electron multiplier,]")
#'
#' getMtdInstrument(mtd)
#'
#' @exportMethod setMtdInstrument
setMethod("setMtdInstrument", "dfmatrix", function(x = matrix(),
                                                   name = character(),
                                                   source = character(),
                                                   analyzer = character(),
                                                   detector = character(),
                                                   replace = FALSE) {
    if (!all(is.na(x))) {
        if (!length(name))
            stop("Missing \"name\", provide a valid one.")
        if (!length(source))
            stop("Missing \"source\", provide a valid one.")
        if (!length(analyzer))
            stop("Missing \"analyzer\", provide a valid one.")
        if (!length(detector))
            stop("Missing \"detector\", provide a valid one.")
        instr <- .mtd_get_field(x, "^instrument\\[\\d+\\]", exact = FALSE,
                                fixed = FALSE)[[1]]
        list_param <- c(list(name = name, source = source), as.list(analyzer),
                        list(detector = detector))
        if (!all(is.na(instr))) {
            if (!replace) {
                list_param <- Map(function(f) {
                    c(instr[grep(f, names(instr), fixed = TRUE)],
                      list_param[[f]])},
                    names(list_param))
            }
            x <- x[!(x[, 1] %in% names(instr)), ]
        }
        new_instr <- do.call(mtdFields, c(list(field_prefix = "instrument"),
                                          list_param))
        x <- mtdSort(rbind(x, new_instr))
    }
    x
})

#' @rdname setMtdInstrument
#'
#' @export
getMtdInstrument <- function(x = matrix()) {
    if (inherits(x, "MzTabM")) x <- x@mtd
    .mtd_get_field(x, "^instrument\\[\\d+\\]", exact = FALSE,
                    fixed = FALSE)[[1]]
}

#' @title Add or Update Database Metadata of an mzTab-M MTD section
#'
#' @name setMtdDatabase
#'
#' @aliases setMtdDatabase,dfmatrix-method setMtdDatabase,MzTabM-method
#'
#' @description
#'
#' `setMtdDatabase()` sets or updates database-related metadata fields within
#' an MTD (metadata) section. When database metadata already exists, the
#' function can either replace it entirely or append new values to the existing
#' ones.
#'
#' `getMtdDatabase()` returns the database information from an MTD section.
#'
#' @param x A MTD section that stores metadata fields. Can be a two-column
#'     `character` matrix, a two-column `data.frame` or a [MzTabM()] object.
#'     Defaults to `matrix()`. If all values are `NA`, the function returns `x`
#'     unchanged.
#'
#' @param name `character` with the description of databases used. For cases,
#'     where a known database has not been used for identification.
#'     (e.g., `"[MIRIAM, MIR:00100079, HMDB, ]"`).
#'
#' @param prefix `character` with the prefix used in the “identifier” column of
#'     data tables. (e.g., `"hmdb"`).
#'
#' @param version `character` with the database version is mandatory where
#'     identification has been performed. This may be a formal version number
#'     (`"1.4.1"`), a date of access (`"2016-10-27"`) (ISO-8601 format) or
#'     (`"Unknown"`) if there is no suitable version that can be annotated.
#'
#' @param uri `character` with the URI to the database.
#'
#' @param replace `logical` flag controlling how pre-existing database
#'     metadata is handled:
#'     \itemize{
#'         \item `FALSE` (default): new values are appended to any existing
#'         values.
#'         \item `TRUE`: existing instrument metadata is discarded and
#'         replaced entirely by the supplied arguments.
#'     }
#'
#' @return
#'
#' - For `setMtdDatabase()`: the input object `x` updated to include the new
#'   or merged database metadata fields. If `x` is empty, the empty `x`.
#' - For `getMtdDatabase()`: a named `character` with the database information,
#'   names being the field names.
#'
#' @author Gabriele Tomè
#'
#' @examples
#'
#' x <- mtdSkeleton("001", software = "[MS, MS:1001582, xmcs, 4.0.0]")
#' ## Add database metadata to an existing mzTab object
#' mtd <- setMtdDatabase(x, name = "[MIRIAM, MIR:00100079, HMDB, ]",
#'           prefix = "hmdb",
#'           version = "3.6",
#'           uri = "http://www.hmdb.ca/")
#'
#' ## Replace all existing database metadata
#' mtd <- setMtdDatabase(mtd, name = "[MIRIAM, MIR:00100079, HMDB, ]",
#'           prefix = "hmdb",
#'           version = "3.6",
#'           uri = "http://www.hmdb.ca/",
#'           replace = TRUE)
#'
#' ## Get the database metadata
#' getMtdDatabase(mtd)
#'
#' @exportMethod setMtdDatabase
setMethod("setMtdDatabase", "dfmatrix", function(x = matrix(),
                                                 name = character(),
                                                 prefix = character(),
                                                 version = character(),
                                                 uri = character(),
                                                 replace = FALSE) {
    if(!all(is.na(x))) {
        if(!length(name))
            stop("Missing \"name\", provide a valid one.")

        if(!length(prefix))
            stop("Missing \"prefix\", provide a valid one.")

        if(!length(version))
            stop("Missing \"version\", provide a valid one.")

        if(!length(uri))
            stop("Missing \"uri\", provide a valid one.")

        db <- .mtd_get_field(x, "^database\\[\\d+\\]", exact = FALSE,
                                fixed = FALSE)[[1]]
        list_param <- list(name = name, prefix = prefix,
                            version = version, uri = uri)
        if (!all(is.na(db))) {
            if (!replace & db[1] != "[,, \"no database\", null ]") {
                list_param <- Map(function(f) {
                                if(f == "name") {
                                    c(db[grep("database\\[\\d+\\]$",
                                         names(db))],
                                      list_param[[f]])
                                } else {
                                    c(db[grep(f, names(db), fixed = TRUE)],
                                      list_param[[f]])
                                }},
                               names(list_param))
            }
            x <- x[!(x[, 1] %in% names(db)), ]
        }
        new_db <- .database(list_param$name, list_param$prefix,
                            list_param$version, list_param$uri)
        x <- mtdSort(rbind(x, new_db))
    }
    x
})

#' @rdname setMtdDatabase
#'
#' @export
getMtdDatabase <- function(x = matrix()) {
    if (inherits(x, "MzTabM")) x <- x@mtd
    .mtd_get_field(x, "^database\\[\\d+\\]", exact = FALSE, fixed = FALSE)[[1]]
}

#' @title Add or Update Controlled Vocabularies (CV) Metadata  of an mzTab-M
#'     MTD section
#'
#' @name setMtdCv
#'
#' @aliases setMtdCv,dfmatrix-method setMtdCv,MzTabM-method
#'
#' @description
#'
#' `setMtdCv()` sets or updates CV-related metadata fields within an MTD
#' (metadata) section. When CV metadata already exists, the function can either
#' replace it entirely or append new values to the existing ones.
#'
#' `getMtdCv()` returns the CV information from an MTD section.
#'
#' @param x A MTD section that stores metadata fields. Can be a two-column
#'     `character` matrix, a two-column `data.frame` or a [MzTabM()] object.
#'     Defaults to `matrix()`. If all values are `NA`, the function returns `x`
#'     unchanged.
#'
#' @param label `character` describing the labels of the controlled
#'     vocabularies/ontologies used in the *mzTab-M* file (e.g. `"MS"` for
#'     PSI-MS).
#'
#' @param full_name `character` describing the full names of the controlled
#'     vocabularies/ontologies used.
#'
#' @param version `character` describing the version of the controlled
#'     vocabularies/ontologies used. (e.g. `"4.1.11"`)
#'
#' @param uri `character` containing the URIs of the controlled vocabularies/
#'     ontologies used in the mzTab file. Note: For OBO ontologies, always use
#'     an OBO PURL rather than raw repository links to ensure long-term
#'     stability (e.g. `"https://purl.obolibrary.org/obo/ms.obo"`). For other
#'     ontology formats, please use the fully qualified PURL pointing to the
#'     ontology file.
#'
#' @param replace `logical` flag controlling how pre-existing CV
#'     metadata is handled:
#'     \itemize{
#'         \item `FALSE` (default): new values are appended to any existing
#'         values.
#'         \item `TRUE`: existing instrument metadata is discarded and
#'         replaced entirely by the supplied arguments.
#'     }
#'
#' @return
#'
#' - For `setMtdCv()`: the input object `x` updated to include the new or
#'   merged CV metadata fields. If `x` is empty, the empty `x`.
#' - For `getMtdCv()`: a named `character` with the CV information, names being
#'   the field names.
#'
#' @author Gabriele Tomè
#'
#' @examples
#'
#' x <- mtdSkeleton("001", software = "[MS, MS:1001582, xmcs, 4.0.0]")
#' ## Add CV metadata to an existing mzTab object
#' mtd <- setMtdCv(x, label = "MS",
#'           full_name = "PSI-MS controlled vocabulary",
#'           version = "4.1.11",
#'           uri = "https://purl.obolibrary.org/obo/ms.obo")
#'
#' ## Replace all existing CV metadata
#' mtd <- setMtdCv(mtd, label = "MS",
#'           full_name = "PSI-MS controlled vocabulary",
#'           version = "4.1.11",
#'           uri = "https://purl.obolibrary.org/obo/ms.obo",
#'           replace = TRUE)
#'
#' ## Get CV infrmation
#' getMtdCv(mtd)
#'
#' @exportMethod setMtdCv
setMethod("setMtdCv", "dfmatrix", function(x = matrix(), label = character(),
                                           full_name = character(),
                                           version = character(),
                                           uri = character(),
                                           replace = FALSE) {
    if(!all(is.na(x))) {
        if(!length(label))
            stop("Missing \"label\", provide a valid one.")

        if(!length(full_name))
            stop("Missing \"full_name\", provide a valid one.")

        if(!length(version))
            stop("Missing \"version\", provide a valid one.")

        if(!length(uri))
            stop("Missing \"uri\", provide a valid one.")

        cv <- .mtd_get_field(x, "^cv\\[\\d+\\]", exact = FALSE,
                                fixed = FALSE)[[1]]
        list_param <- list(label = label, full_name = full_name,
                            version = version, uri = uri)
        if (!all(is.na(cv))) {
            if (!replace) {
                list_param <- Map(function(f) {
                                c(cv[grep(f, names(cv), fixed = TRUE)],
                                  list_param[[f]])},
                               names(list_param))
            }
            x <- x[!(x[, 1] %in% names(cv)), ]
        }
        new_cv <- .cv(list_param$label, list_param$full_name,
                        list_param$version, list_param$uri)
        x <- mtdSort(rbind(x, new_cv))
    }
    x
})

#' @rdname setMtdCv
#'
#' @export
getMtdCv <- function(x = matrix()) {
    if (inherits(x, "MzTabM")) x <- x@mtd
    .mtd_get_field(x, "^cv\\[\\d+\\]", exact = FALSE, fixed = FALSE)[[1]]
}

#' @title Add or Update contact Metadata  of an mzTab-M MTD section
#'
#' @name setMtdContact
#'
#' @aliases setMtdContact,dfmatrix-method setMtdContact,MzTabM-method
#'
#' @description
#'
#' `setMtdContact()` sets or updates contact-related metadata fields within
#' an MTD (metadata) section. When contact metadata already exists, the
#' function can either replace it entirely or append new values to the existing
#' ones.
#'
#' `getMtdContact()` returns the contact information from an MTD section.
#'
#' @param x A MTD section that stores metadata fields. Can be a two-column
#'     `character` matrix, a two-column `data.frame` or a [MzTabM()] object.
#'     Defaults to `matrix()`. If all values are `NA`, the function returns `x`
#'     unchanged.
#'
#' @param name `character` contact’s name.
#'
#' @param affiliation `character` contact’s affiliation.
#'
#' @param email `character` contact’s e-mail address.
#'
#' @param orcid `character` contact’s ORCID identifier.
#'
#' @param replace `logical` flag controlling how pre-existing contact
#'     metadata is handled:
#'     \itemize{
#'         \item `FALSE` (default): new values are appended to any existing
#'         values.
#'         \item `TRUE`: existing instrument metadata is discarded and
#'         replaced entirely by the supplied arguments.
#'     }
#'
#' @return
#'
#' - For `setMtdContact()`: the input object `x` updated to include the new or
#'   merged contact metadata fields. If `x` is empty, the empty `x`.
#' - For `getMtdContact()`: a named `character` with the contact information,
#'   names being the field names.
#'
#' @author Gabriele Tomè
#'
#' @examples
#'
#' x <- mtdSkeleton("001", software = "[MS, MS:1001582, xmcs, 4.0.0]")
#' ## Add contact metadata to an existing mzTab object
#' mtd <- setMtdContact(x, name = "Name Surname",
#'           affiliation = "PSI-MS",
#'           email = "name.surname@mail.com", orcid = "0000-0002-1825-0097")
#'
#' ## Replace all existing contact metadata
#' mtd <- setMtdContact(mtd, name = "Name Surname",
#'           affiliation = "PSI-MS",
#'           email = "name.surname@mail.com",
#'           orcid = "0000-0002-1825-0097",
#'           replace = TRUE)
#'
#'
#' getMtdContact(mtd)
#'
#' @exportMethod setMtdContact
setMethod("setMtdContact", "dfmatrix", function(x = matrix(),
                                                name = character(),
                                                affiliation = character(),
                                                email = character(),
                                                orcid = character(),
                                                replace = FALSE) {
    if(!all(is.na(x))) {
        if(!length(name))
            stop("Missing \"name\", provide a valid one.")

        if(!length(affiliation))
            stop("Missing \"affiliation\", provide a valid one.")

        if(!length(email))
            stop("Missing \"email\", provide a valid one.")

        if(!length(orcid))
            stop("Missing \"orcid\", provide a valid one.")

        if (any(!grepl("^[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{3}[0-9X]$", orcid)))
            stop("Provided \"orcid\" is not valid. It should be in the format ",
                 "\"dddd-dddd-dddd-dddd\".")

        contact <- .mtd_get_field(x, "^contact\\[\\d+\\]", exact = FALSE,
                                    fixed = FALSE)[[1]]
        list_param <- list(name = name, affiliation = affiliation,
                            email = email, orcid = orcid)
        if (!all(is.na(contact))) {
            if (!replace) {
                list_param <- Map(function(f) {
                                c(contact[grep(f, names(contact), fixed = TRUE)],
                                  list_param[[f]])},
                               names(list_param))
            }
            x <- x[!(x[, 1] %in% names(contact)), ]
        }
        new_contact <- do.call(mtdFields, c(list(field_prefix = "contact"),
                                            list_param))
        x <- mtdSort(rbind(x, new_contact))
    }
    x
})

#' @rdname setMtdContact
#'
#' @export
getMtdContact <- function(x = matrix()) {
    if (inherits(x, "MzTabM")) x <- x@mtd
    .mtd_get_field(x, "^contact\\[\\d+\\]", exact = FALSE, fixed = FALSE)[[1]]
}

#' @title Add or Update protocol Metadata  of an mzTab-M MTD section
#'
#' @name setMtdProtocol
#'
#' @aliases setMtdProtocol,dfmatrix-method setMtdProtocol,MzTabM-method
#'
#' @description
#'
#' `setMtdProtocol()` sets or updates protocol-related metadata fields within
#' an MTD (metadata) section. When protocol metadata already exists, the
#' function can either replace it entirely or append new values to the existing
#' ones. Each protocol is referenced from an *assay* section (see [mtdAssay()]).
#'
#' `getMtdProtocol()` returns the protocol information from an MTD section.
#'
#' @param x A MTD section that stores metadata fields. Can be a two-column
#'     `character` matrix, a two-column `data.frame` or a [MzTabM()] object.
#'     Defaults to `matrix()`. If all values are `NA`, the function returns `x`
#'     unchanged.
#'
#' @param name `character` with protocol name describing one or more steps of
#'     an experimental procedure, such as sample preparation, data acquisition
#'     or data processing.
#'
#' @param type `character` with the protocol type, as defined by the parameter.
#'     Can be of length 1 or equal to `length(name)`.
#'
#' @param description optional `character` with the description of the protocol.
#'     Can be of length 1 or equal to `length(name)`.
#'
#' @param parameters optional `character` with additional parameters of the
#'     protocol
#'
#' @param replace `logical` flag controlling how pre-existing contact
#'     metadata is handled:
#'     \itemize{
#'         \item `FALSE` (default): new values are appended to any existing
#'         values.
#'         \item `TRUE`: existing instrument metadata is discarded and
#'         replaced entirely by the supplied arguments.
#'     }
#'
#' @return
#'
#' - For `setMtdProtocol()`: the input object `x` updated to include the new or
#'   merged protocol metadata fields. If `x` is empty, the empty `x`.
#' - For `getMtdProtocol()`: a named `character` with the protocol information,
#'   names being the field names.
#'
#' @author Gabriele Tomè
#'
#' @examples
#'
#' x <- mtdSkeleton("001", software = "[MS, MS:1001582, xmcs, 4.0.0]")
#' ## Minimal example with protocol.
#' mtd <- setMtdProtocol(x, name = c("Mass Spectrometry"),
#'        type = c("[CHMO, CHMO:0000470, mass spectrometry, ]"),
#'        description = c("Eluting compounds were detected ..."),
#'        parameters = paste0("[MS, MS:1000008, ionization type, ",
#'                            "[MS,MS:1000073, electrospray ionization, ]]"))
#'
#' ## Example with all the fields and replace the previous
#' mtd <- setMtdProtocol(mtd, name = c("Mass Spectrometry", "extraction"),
#'             type = c("[CHMO, CHMO:0000470, mass spectrometry, ]",
#'                      "[MSIO, MSIO:0000141, metabolite extraction,]"),
#'             description = c("Eluting compounds were detected ...",
#'                             "Extraction using 80% methanol"),
#'             parameters = list(c(paste0("[MS, MS:1000008, ionization type, ",
#'                               "[MS,MS:1000073, electrospray ionization, ]]"),
#'                               "param1.2"),
#'                               paste0("[MSIO, MSIO:0000107, quenching, ",
#'                                  "[MSIO, MSIO:0000109, liquid nitrogen,]]")),
#'             replace = TRUE)
#'
#' getMtdProtocol(mtd)
#'
#' @exportMethod setMtdProtocol
setMethod("setMtdProtocol", "dfmatrix", function(x = matrix(),
                                            name = character(),
                                            type = character(),
                                            description = character(),
                                            parameters = character(),
                                            replace = FALSE) {
    if (!all(is.na(x))) {
        if (!length(name))
            stop("Missing \"name\", provide a valid one.")
        if (!length(type))
            stop("Missing \"type\", provide a valid one.")
        if (!length(description))
            stop("Missing \"description\", provide a valid one.")
        if (!length(parameters))
            stop("Missing \"parameters\", provide a valid one.")
        if (!all(sapply(type, isCvParameter)))
            stop("All entries in parameter 'type' have to be valid CV ",
                 "parameters", call. = FALSE)
        prot <- .mtd_get_field(x, "^protocol\\[\\d+\\]", exact = FALSE,
                                fixed = FALSE)[[1]]
        list_param <- list(name = name, type = type,
                            description = description, parameter = parameters)
        if (!all(is.na(prot))) {
            if (!replace) {
                list_param <- Map(function(f) {
                    c(prot[grep(f, names(prot), fixed = TRUE)],
                      list_param[[f]])},
                    names(list_param))
            }
            x <- x[!(x[, 1] %in% names(prot)), ]
        }
        new_prot <- do.call(.mtdProtocol, c(list_param))
        x <- mtdSort(rbind(x, new_prot))
    }
    x
})

#' @rdname setMtdProtocol
#'
#' @export
getMtdProtocol <- function(x = matrix()) {
    if (inherits(x, "MzTabM")) x <- x@mtd
    .mtd_get_field(x, "^protocol\\[\\d+\\]", exact = FALSE, fixed = FALSE)[[1]]
}

#' The `mtdProtocol()` function assists in compiling the *protocol* information
#' of the metadata section.
#'
#' @param name `character` with protocol name describing one or more steps of
#'     an experimental procedure, such as sample preparation, data acquisition
#'     or data processing.
#'
#' @param type `character` with the protocol type, as defined by the parameter.
#'     Can be of length 1 or equal to `length(name)`.
#'
#' @param description optional `character` with the description of the protocol.
#'     Can be of length 1 or equal to `length(name)`.
#'
#' @param parameter optional `character` with additional parameters of the
#'     protocol
#'
#' @return two-column `character` `matrix` with the content for the protocol
#'     metadata section.
#'
#' @author Gabriele Tomè
#'
#' @noRd
.mtdProtocol <- function(name = character(), type = character(),
                        description = character(), parameter = character()) {
    if (!length(name))
        stop("Parameter 'name' is required", call. = FALSE)
    if (!length(type))
        stop("Parameter 'type' is required", call. = FALSE)
    if (!all(sapply(type, isCvParameter)))
        stop("All entries in parameter 'type' have to be valid CV parameters",
             call. = FALSE)
    l = length(name)
    s <- seq_len(l)
    res <- cbind(mtdFields(name = name, field_prefix = "protocol"), order = s)
    if (length(type)) {
        if (length(type) != l) type <- rep(type[1L], l)
        res <- rbind(res, cbind(mtdFields(type = type,
                                           field_prefix = "protocol"), s))
    }
    if (length(description)) {
        if (length(description) != l) description <- rep(description[1L], l)
        res <- rbind(res, cbind(mtdFields(description = description,
                                           field_prefix = "protocol"), s))
    }
    ## Paramters
    if (length(parameter)) {
        res <- rbind(res, .mtd_parameters_fields("protocol", parameter, l))
    }
    res[order(res[, 3L]), 1:2, drop = FALSE]
}


#' @title Add or Update a Metadata Field of an mzTab-M MTD section
#'
#' @name setMtdField
#'
#' @aliases setMtdField,dfmatrix-method setMtdField,MzTabM-method
#'
#' @description
#'
#' `setMtdField()` sets or updates metadata fields within an MTD (metadata)
#' section. When the field already exists, the function can either replace it
#' entirely or append new values to the existing ones.
#'
#' `getMtdField()` returns the information from an MTD section of the requested
#' field.
#'
#' @param x A MTD section that stores metadata fields. Can be a two-column
#'     `character` matrix, a two-column `data.frame` or a [MzTabM()] object.
#'     Defaults to `matrix()`. If all values are `NA`, the function returns `x`
#'     unchanged.
#'
#' @param field `character(1)` name of the metadata field to set or update.
#'     Must be a valid [MTD field name](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section). (e.g. `"publication"`)
#'
#' @param value `character` value(s) to assign to the field. (e.g.
#'     `"https://pubs.acs.org/doi/10.1021/acs.analchem.8b04310"`)
#'
#' @param replace `logical` flag controlling how pre-existing field
#'     metadata is handled. Valid only for indexed fields, unique fields are
#'     always replaced.
#'     \itemize{
#'         \item `FALSE` (default): new values are appended to any existing
#'         values.
#'         \item `TRUE`: existing instrument metadata is discarded and
#'         replaced entirely by the supplied arguments.
#'     }
#'
#' @return
#'
#' - For `setMtdField()`: the input object `x` updated to include the new or
#'   merged field metadata. If `x` is empty, the empty `x`.
#' - For `getMtdField()`: a named `character` with the requested information,
#'   names being the field names.
#'
#' @author Gabriele Tomè
#'
#' @examples
#'
#' x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
#' ## Add a metadata field to an existing mzTab object
#' mtd <- setMtdField(x, field = "publication",
#'           value = "pubmed:21063943|doi:10.1007/978-1-60761-987-1_6")
#'
#' ## Replace all existing values for a metadata field
#' mtd <- setMtdField(mtd, field = "custom",
#'           value = "[,,MS operator, Florian]",
#'           replace = TRUE)
#'
#' getMtdField(mtd, field = "mzTab-ID")
#'
#' @exportMethod setMtdField
setMethod("setMtdField", "dfmatrix", function(x = matrix(),
                                              field = character(),
                                              value = character(),
                                              replace = FALSE) {
    if(!all(is.na(x))) {
        if (length(field) != 1)
            stop("A single value should be submitted to 'field'")
        if (!any(grepl(field, .MTD_FIELD_ORDER)))
            stop("Provide a valid MTD field. \"", field, "\" not valid.")

        if (!length(value))
            stop("Provide at least 1 value to add.")

        if (any(grepl(field, .MTD_UNIQUE_FIELD))) {
            if (length(value) > 1)
                stop("The field '", field,
                     "' is unique. Provide a single \"value\"")

            existing_field <- .mtd_get_field(x, paste0("^", field),
                                            exact = FALSE, fixed = FALSE)[[1]]
            if (!all(is.na(existing_field))) {
                x <- x[!(x[, 1] %in% names(existing_field)), ]
            }
            new_field <- cbind(field, value)
        } else {
            existing_field <- .mtd_get_field(x, paste0("^", field,
                                                       "\\[\\d+\\]"),
                                            exact = FALSE, fixed = FALSE)[[1]]
            if (!all(is.na(existing_field))) {
                if (!replace) {
                    value <- c(existing_field, value)
                }
                x <- x[!(x[, 1] %in% names(existing_field)), ]
            }
            new_field <- mtdFields(value, field_prefix = field)
        }
        x <- mtdSort(rbind(x, new_field))
    }
    x
})

#' @rdname setMtdField
#'
#' @export
getMtdField <- function(x = matrix(), field = character()) {
    if(!length(field))
        stop("Parameter \"field\" is empty. Please provide a valid field.")

    if (inherits(x, "MzTabM")) x <- x@mtd
    .mtd_get_field(x, paste0("^", field), exact = FALSE, fixed = FALSE)[[1]]
}
