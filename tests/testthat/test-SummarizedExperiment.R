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

test_that("makeSummarizedExperimentFromMzTabM works", {
    msr <- msRunCols(location = "derived_spectra_data_file",
                     scan_polarity = "polarity")
    ac <- assayCols(assay = "derived_spectra_data_file")
    sc <- smfCols(exp_mass_to_charge = "mzmed")
    ## Only MTD object
    res <- MzTabM(se, id = "123", msRunCols. = msr, assayCols. = ac)

    se_rec <- makeSummarizedExperimentFromMzTabM(res)
    expect_equal(as.data.frame(rowData(se_rec)), data.frame())
    expect_null(assayNames(se_rec))
    colData <- colData(se)
    colData <- colData[order(colData$derived_spectra_data_file), ]
    colData_rec <- colData(se_rec)
    colData_rec <- colData_rec[order(colData_rec$location), ]
    expect_equal(colData$derived_spectra_data_file, colData_rec$location)
    expect_equal(.ms_scan_polarity(colData$polarity),
                colData_rec$scan_polarity.1.)

    ## Complete example
    scols <- sampleCols(sample = "sample_name", species = "species",
                        tissue = "tissue", sample_type = "sample_type")
    mscols <- msRunCols(location = "derived_spectra_data_file",
                        instrument_ref = "instrument",
                        scan_polarity = "polarity")
    acols <- assayCols(assay = "derived_spectra_data_file")
    rowData(se)$feature_id <- rownames(se)
    smf_cols <- smfCols(exp_mass_to_charge = "mzmed",
                        retention_time_in_seconds = "rtmed",
                        feature_id = "feature_id")
    mzt <- MzTabM(se, id = "MTBLS8735", sampleCols = scols,
                msRunCols = mscols, assayCols = acols,
                groups = c("age", "phenotype", "blood_sample_type"),
                smfCols. = smf_cols, assayName = "raw_filled")
    mzt <- setMtdInstrument(
        mzt, name = "[MS, MS:1002584, AB Sciex TripleTOF 5600+, ]",
        source = "[MS, MS:1000073, ESI, ]",
        analyzer = c(`analyzer[1]` =
                    "[MS, MS:1003763, quadrupole time-of-flight instrument, ]"),
        detector = "[,,null,null]")

    se_rec <- makeSummarizedExperimentFromMzTabM(mzt, assayName = "raw_filled",
                        rowIdCol = "opt_global_feature_id", smfCols. = smf_cols)
    expect_equal(assayNames(se_rec), "raw_filled")
    rowData <- rowData(se)
    rowData_rec <- rowData(se_rec)
    expect_equal(nrow(rowData), nrow(rowData_rec))
    expect_equal(rowData$feature_id, rowData_rec$opt_global_feature_id)
    expect_equal(rowData$rtmed, as.numeric(rowData_rec$rtmed))
    expect_equal(rowData$mzmed, as.numeric(rowData_rec$mzmed))

    colData <- colData(se)
    colData <- colData[order(colData$derived_spectra_data_file), ]
    colData_rec <- colData(se_rec)
    colData_rec <- colData_rec[order(colData_rec$location), ]
    expect_equal(colData$derived_spectra_data_file, colData_rec$location)
    expect_equal(.ms_scan_polarity(colData$polarity),
                colData_rec$scan_polarity.1.)
    expect_equal(colData$sample_name, colData_rec$sample)
    expect_equal(colData$species, colData_rec$species.1.)
    expect_equal(colData$tissue, colData_rec$tissue.1.)
    build_custom_col <- .mtd_custom_fields(sample_type = colData$sample_type,
                                            expected_length = 10)[, 2]
    expect_equal(build_custom_col, colData_rec$custom.1.)
    expect_equal(as.character(colData$age), colData_rec$age)
    expect_equal(colData$phenotype, colData_rec$phenotype)
    expect_equal(colData$blood_sample_type, colData_rec$blood_sample_type)
    expect_all_equal(colData_rec$instrument,
                    "[MS, MS:1002584, AB Sciex TripleTOF 5600+, ]")
    expect_all_equal(colData_rec$source,
                    "[MS, MS:1000073, ESI, ]")
    expect_all_equal(colData_rec$detector,
                    "[,,null,null]")
    expect_all_equal(colData_rec$analyzer.1.,
                    "[MS, MS:1003763, quadrupole time-of-flight instrument, ]")
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

test_that(".mtd_long_to_wide works", {
    mtd_sub <- data.frame(
        col1 = c("sample[1]", "sample[1]-type",
                 "sample[2]", "sample[2]-type"),
        col2 = c("SampleA", "typeA", "SampleB", "typeB"))

    res <- .mtd_long_to_wide(mtd_sub)

    expect_equal(nrow(res), 2)
    expect_equal(colnames(res), c("id", "name", "type"))
    expect_equal(res$id, c("sample[1]", "sample[2]"))
    expect_equal(res$name, c("SampleA", "SampleB"))
    expect_equal(res$type, c("typeA", "typeB"))

    ## MTD with different number of fields for each sample
    mtd_sub <- data.frame(
        col1 = c("sample[1]", "sample[1]-tissue[1]", "sample[1]-tissue[2]",
                 "sample[2]", "sample[2]-tissue[1]"),
        col2 = c("SampleA", "tissueA", "tissueB", "SampleB", "tissueA"))
    res <- .mtd_long_to_wide(mtd_sub)
    expect_equal(nrow(res), 2)
    expect_equal(colnames(res), c("id", "name", "tissue[1]", "tissue[2]"))
    expect_equal(res$id, c("sample[1]", "sample[2]"))
    expect_equal(res$name, c("SampleA", "SampleB"))
    expect_equal(res$`tissue[1]`, c("tissueA", "tissueA"))
    expect_equal(res$`tissue[2]`, c("tissueB", NA))

})

test_that(".smfToFeatureData works", {
    smf <- data.frame(
        SMF_ID = c("1", "2"),
        colA = c("x", "y"),
        colAllNull = c("null", "null"),
        `abundance_assay[1]` = c("1", "2"),
        check.names = FALSE)

    res <- .smfToFeatureData(smf)
    expect_equal(colnames(res), c("SMF_ID", "colA"))
    expect_equal(res$colA, c("x", "y"))

    smfCols. <- c(colA = "renamedA")
    res <- .smfToFeatureData(smf, smfCols. = smfCols.)
    expect_equal(colnames(res), c("SMF_ID", "renamedA"))
    expect_equal(res$renamedA, c("x", "y"))
})

test_that(".smfToAssayData works", {
    smf <- data.frame(
        SMF_ID = c("1", "2"),
        colA = c("x", "y"),
        `abundance_assay[1]` = c("1", "2"),
        `abundance_assay[2]` = c("null", "3"),
        check.names = FALSE
    )

    sampleData <- data.frame(
        id = c("assay[1]", "assay[2]"),
        row.names = c("Sample1", "Sample2")
    )

    res <- .smfToAssayData(smf, sampleData)

    expect_equal(colnames(res), c("Sample1", "Sample2"))
    expect_equal(res[, "Sample1"], c(1, 2))
    expect_equal(res[, "Sample2"], c(NA, 3))
})
