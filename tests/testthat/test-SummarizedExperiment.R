library(SummarizedExperiment)
data(se)

test_that("RmzTabM,SummarizedExperiment works", {
    expect_error(MzTabM(se), "Parameter 'id'")
    msr <- msRunCols(location = "derived_spectra_data_file",
                     scan_polarity = "polarity")
    ac <- assayCols(assay = "derived_spectra_data_file")
    expect_error(MzTabM(se, id = "123", msRunCols. = msr, assayCols. = ac,
                        smfCols. = smfCols(exp_mass_to_charge = "aaa")),
                 "\"aaa\" not found")
    sc <- smfCols(exp_mass_to_charge = "mzmed")
    ## Minimalistic
    res <- MzTabM(se, id = "123", msRunCols. = msr,
                  assayCols. = ac, smfCols. = sc)
    expect_s4_class(res, "MzTabM")
    a <- as.matrix(res@smf[, grep("abundance_", colnames(res@smf)), ])
    b <- assay(se)
    rownames(a) <- NULL
    rownames(b) <- NULL
    colnames(a) <- NULL
    colnames(b) <- NULL
    expect_equal(a, b)
    expect_equal(res@smf$exp_mass_to_charge, as.character(rowData(se)$mzmed))
    expect_true(all(res@smf$retention_time_in_seconds == "null"))
    ## Additional columns
    sc <- smfCols(exp_mass_to_charge = "mzmed",
                  retention_time_in_seconds = "rtmed", rtmin = "rtmin")
    res <- MzTabM(se, id = "123", msRunCols. = msr,
                  assayCols. = ac, smfCols. = sc)
    expect_equal(res@smf$exp_mass_to_charge, as.character(rowData(se)$mzmed))
    expect_equal(res@smf$retention_time_in_seconds,
                 as.character(rowData(se)$rtmed))
    expect_equal(res@smf$opt_global_rtmin, as.character(rowData(se)$rtmin))
})

test_that("smfCols works", {
    res <- smfCols()
    expect_equal(
        res, c(exp_mass_to_charge = "exp_mass_to_charge",
               retention_time_in_seconds = "retention_time_in_seconds",
               retention_time_in_seconds_start = "retention_time_in_seconds_start",
               retention_time_in_seconds_end = "retention_time_in_seconds_end",
               SME_ID_REFS = "SME_ID_REFS",
               SME_ID_REF_ambiguity_code = "SME_ID_REF_ambiguity_code",
               charge = "charge", adduct_ion = "adduct_ion",
               isotopomer = "isotopomer", opt_identifier = "global"))
    res <- smfCols(exp_mass_to_charge = "mzmed",
                   retention_time_in_seconds = "rtmed",
                   retention_time_in_seconds_start = "rtmin",
                   retention_time_in_seconds_end = "rtmax",
                   adduct_ion = "adduct",
                   min_mass_to_charge = "mzmin",
                   max_mass_to_charge = "mzmax")
    expect_equal(
        res, c(exp_mass_to_charge = "mzmed",
               retention_time_in_seconds = "rtmed",
               retention_time_in_seconds_start = "rtmin",
               retention_time_in_seconds_end = "rtmax",
               SME_ID_REFS = "SME_ID_REFS",
               SME_ID_REF_ambiguity_code = "SME_ID_REF_ambiguity_code",
               charge = "charge", adduct_ion = "adduct",
               isotopomer = "isotopomer", opt_identifier = "global",
               min_mass_to_charge = "mzmin",
               max_mass_to_charge = "mzmax"))
})

test_that("smf,SummarizedExperiment works", {
    a <- SummarizedExperiment()
    expect_error(smf(a, assayName = 1L), "not found in ")
    res <- smf(se, smfCols. = smfCols(exp_mass_to_charge = "mzmed"))
    expect_true(is.data.frame(res))
    expect_true(all(res$SME_ID_REFS == "null"))
    expect_true(all(res$retention_time_in_seconds == "null"))
    expect_equal(res$exp_mass_to_charge, as.character(rowData(se)$mzmed))
    a <- as.matrix(res[, grep("abundance_", colnames(res))])
    b <- assay(se)
    rownames(a) <- NULL
    rownames(b) <- NULL
    colnames(a) <- NULL
    colnames(b) <- NULL
    expect_equal(a, b)
})

test_that(".smf_from_summarized_experiment works", {
    expect_error(.smf_from_summarized_experiment(se), "\"exp_mass_to_charge\"")
    cols <- smfCols(exp_mass_to_charge = "mzmed")
    res <- .smf_from_summarized_experiment(se, smfCols. = cols)
    expect_true(is.data.frame(res))
    a <- as.matrix(res[, grep("abundance_", colnames(res))])
    b <- as.matrix(assay(se))
    rownames(a) <- NULL
    rownames(b) <- NULL
    colnames(a) <- NULL
    colnames(b) <- NULL
    expect_equal(a, b)
    expect_true(all(res$retention_time_in_seconds == "null"))

    cols <- smfCols(exp_mass_to_charge = "mzmed",
                    retention_time_in_seconds = "rtmed")
    res <- .smf_from_summarized_experiment(se, smfCols. = cols,
                                           assayName = "raw_filled")
    expect_equal(res$retention_time_in_seconds, as.character(rowData(se)$rtmed))
    a <- as.matrix(res[, grep("abundance_", colnames(res))])
    b <- as.matrix(assay(se, "raw_filled"))
    rownames(a) <- NULL
    rownames(b) <- NULL
    colnames(a) <- NULL
    colnames(b) <- NULL
    expect_equal(a, b)

    expect_error(.smf_from_summarized_experiment(se, smfCols = cols,
                                                 assayName = "other"),
                 "not found. Please use one of the assay")
})
