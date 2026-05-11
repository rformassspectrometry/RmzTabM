
test_that("exportMztabm works", {
    mtd_block <- data.frame(
        c("mzTab-version", "mzTab-ID", "software[1]", "publication[1]",
          "contact[1]-name", "contact[1]-affiliation", "contact[1]-email"),
        c("2.1.0-M", "xcms_mzTab-M_2-1_v2", "[MS, MS:1001582, xcms, 4.8.0]",
          "test pub", "author_1", "EURAC", "author_1@mail.com"))

    SML_block <- data.frame("SMH" = "SML", "SML_ID" = "1",
        "SMF_ID_REFS" = "null", "database_identifier" = "null",
        "chemical_formula" = "null", "smiles" = "null", "inchi" = "null",
        "chemical_name" = "null", "uri" = "null",
        "theoretical_neutral_mass" = "null", "adduct_ions" = "null",
        "reliability" = "4", "best_id_confidence_measure" = "null",
        "best_id_confidence_value" = "null", "abundance_assay[1]" = "null",
        "abundance_study_variable[1]" = "null",
        "abundance_variation_study_variable[1]" = "null")

    SMF_block <- data.frame("SFH" = "SMF", "SMF_ID" = "1",
        "SME_ID_REFS" = "null", "SME_ID_REF_ambiguity_code" = "null",
        "adduct_ion" = "null", "isotopomer" = "null",
        "exp_mass_to_charge" = "200.100006103516", "charge" = "null",
        "retention_time_in_seconds" = "2902.63382922675",
        "retention_time_in_seconds_start" = "2882.60316302447",
        "retention_time_in_seconds_end" = "2922.66449542903",
        "abundance_assay[1]" = "135162.428407749",
        "opt_global_feature_id" = "FT001")

    SME_block <- data.frame("SEH" = "SME", "SME_ID" = "1",
        "evidence_input_id" = "ms_run[1]:mass=700.525;rt=20·5",
        "database_identifier" = "null", "chemical_formula" = "null",
        "smiles" = "null", "inchi" = "null", "chemical_name" = "null",
        "uri" = "null", "derivatized_form" = "null", "adduct_ions" = "null",
        "exp_mass_to_charge" = "700.525", "charge" = "1",
        "theoretical_mass_to_charge" = "700.525",
        "spectra_ref" = "ms_run[1]:index=7646",
        "identification_method" = "[, , LipidDataAnalyzer, 2.11.1]",
        "ms_level" = "[MS, MS:1000511, ms level, 2]", "rank" = "1")

    f <- tempfile(fileext = ".mztab")

    expect_error(exportMztabm(), "argument \"x\" is missing")

    x <- list("MTD" = mtd_block)
    expect_error(exportMztabm(x), "argument \"path\" is missing")

    expect_error(exportMztabm("not_a_list", path = f), "x must be a list")
    expect_error(exportMztabm(x = list(), path = f), "MTD section")
    x <- list("MTD" = mtd_block, "SME" = SME_block)
    expect_error(exportMztabm(x, path = f), "Missing \"SFH\" section")

    ## Test save only MTD in a pregenerated file
    x <- list("MTD" = mtd_block)
    expect_no_error(exportMztabm(x, path = f))
    ## Test save MTD+SML in a pregenerated file
    x <- list("MTD" = mtd_block, "SML" = SML_block)
    expect_no_error(exportMztabm(x, path = f))
    ## Test save MTD+SML+SMF in a pregenerated file
    x <- list("MTD" = mtd_block, "SML" = SML_block, "SMF" = SMF_block)
    expect_no_error(exportMztabm(x, path = f))
    ## Test save MTD+SML+SMF+SME in a pregenerated file
    x <- list("MTD" = mtd_block, "SML" = SML_block, "SMF" = SMF_block,
              "SME" = SME_block)
    expect_no_error(exportMztabm(x, path = f))
    ## Test save MTD+SMF in a pregenerated file
    x <- list("MTD" = mtd_block, "SMF" = SMF_block)
    expect_no_error(exportMztabm(x, path = f))
    ## Test save MTD+SMF+SME in a pregenerated file
    x <- list("MTD" = mtd_block, "SMF" = SMF_block, "SME" = SME_block)
    expect_no_error(exportMztabm(x, path = f))

    ## Test comments
    x <- list("MTD" = mtd_block, "SML" = SML_block)
    expect_no_error(exportMztabm(x, path = f, comments = "Comment 1"))
    expect_no_error(exportMztabm(x, path = f,
                                 comments = c("Comment 1", "Comment 2")))

    ## Test save only MTD in a not-existing directory
    f <- file.path(tempdir(), "not_existing_dir", "example.mztab")
    x <- list("MTD" = mtd_block)
    expect_no_error(exportMztabm(x, path = f))

    ## Test save only MTD in a not-existing directory without extension
    f <- file.path(tempdir(), "not_existing_dir_2", "example_no_ext")
    x <- list("MTD" = mtd_block)
    expect_no_error(exportMztabm(x, path = f))

    ## Test save only MTD in a not-existing directory without filename
    f <- file.path(tempdir(), "not_existing_dir_2/")
    x <- list("MTD" = mtd_block)
    expect_no_error(exportMztabm(x, path = f))
})
