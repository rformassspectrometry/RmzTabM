test_that("sme_create works", {
    evidence_input_id = c("ms_run[1]:mass=700.525;rt=20·5",
                          "ms_run[2]:mass=452.278;rt=35.1",
                          "ms_run[3]:mass=882.621;rt=40.0")
    exp_mass_to_charge = c(700.525, 452.278, 882.621)
    charge = c(1, 1, 1)
    theoretical_mass_to_charge = c(700.528, 452.277, 882.622)
    spectra_ref = c("ms_run[1]:index=7646", "ms_run[2]:index=7640",
                    "ms_run[3]:index=7671|ms_run[3]:index=7725")
    identification_method = "[, , LipidDataAnalyzer, 2.11.1]"
    ms_level = "[MS, MS:1000511, ms level, 2]"

    mtd <- cbind(c("ms_run[1]-location", "ms_run[1]-format",
                   "ms_run[1]-id_format", "ms_run[1]-scan_polarity[1]",
                   "ms_run[2]-location", "ms_run[2]-format",
                   "ms_run[2]-id_format", "ms_run[2]-scan_polarity[1]",
                   "ms_run[3]-location", "ms_run[3]-format",
                   "ms_run[3]-id_format", "ms_run[3]-scan_polarity[1]",
                   "id_confidence_measure[1]", "id_confidence_measure[2]"),
                 c("1.mzML", "[MS, MS:1000584, mzML file, ]",
                   "[MS, MS:1000530, mzML unique identifier, ]",
                   "[MS, MS:1000130, positive scan, ]",
                   "2.mzML", "[MS, MS:1000584, mzML file, ]",
                   "[MS, MS:1000530, mzML unique identifier, ]",
                   "[MS, MS:1000130, positive scan, ]",
                   "3.mzML", "[MS, MS:1000584, mzML file, ]",
                   "[MS, MS:1000530, mzML unique identifier, ]",
                   "[MS, MS:1000130, positive scan, ]",
                   "[MS, MS:1002890, fragmentation score, ]",
                   "[MS, MS:1002890, fragmentation score, ]"))

    expect_error(sme_create(), "argument 'evidence_input_id' is mandatory")
    expect_error(sme_create(evidence_input_id = evidence_input_id),
                 "argument 'exp_mass_to_charge' is mandatory")
    expect_error(sme_create(evidence_input_id = evidence_input_id,
                    exp_mass_to_charge = exp_mass_to_charge),
                 "argument 'charge' is mandatory")
    expect_error(sme_create(evidence_input_id = evidence_input_id,
                    exp_mass_to_charge = exp_mass_to_charge,
                    charge = charge),
                 "argument 'theoretical_mass_to_charge' is mandatory")
    expect_error(sme_create(evidence_input_id = evidence_input_id,
                    exp_mass_to_charge = exp_mass_to_charge,
                    charge = charge,
                    theoretical_mass_to_charge = theoretical_mass_to_charge),
                 "argument 'spectra_ref' is mandatory")
    expect_error(sme_create(evidence_input_id = evidence_input_id,
                    exp_mass_to_charge = exp_mass_to_charge,
                    charge = charge,
                    theoretical_mass_to_charge = theoretical_mass_to_charge,
                    spectra_ref = spectra_ref),
                 "argument 'identification_method' is mandatory")
    expect_error(sme_create(evidence_input_id = evidence_input_id,
                    exp_mass_to_charge = exp_mass_to_charge,
                    charge = charge,
                    theoretical_mass_to_charge = theoretical_mass_to_charge,
                    spectra_ref = spectra_ref,
                    identification_method = identification_method),
                 "argument 'ms_level' is mandatory")
    expect_error(sme_create(evidence_input_id = evidence_input_id,
                    exp_mass_to_charge = exp_mass_to_charge,
                    charge = charge,
                    theoretical_mass_to_charge = theoretical_mass_to_charge,
                    spectra_ref = spectra_ref,
                    identification_method = identification_method,
                    ms_level = ms_level,
                    rank = NULL),
                 "argument 'rank' is mandatory")
    expect_error(sme_create(
        evidence_input_id = evidence_input_id,
        exp_mass_to_charge = exp_mass_to_charge,
        charge = charge,
        theoretical_mass_to_charge = theoretical_mass_to_charge,
        spectra_ref = spectra_ref,
        identification_method = identification_method,
        ms_level = ms_level,
    ), "provide a valid MTD section")

    res <- sme_create(evidence_input_id = evidence_input_id,
                    exp_mass_to_charge = exp_mass_to_charge,
                    charge = charge,
                    theoretical_mass_to_charge = theoretical_mass_to_charge,
                    spectra_ref = spectra_ref,
                    identification_method = identification_method,
                    ms_level = ms_level, mtd = mtd)
    expect_true(is.data.frame(res))
    expect_equal(res$SEH, c("SME", "SME", "SME"))
    expect_equal(res$evidence_input_id, c("ms_run[1]:mass=700.525;rt=20·5",
                          "ms_run[2]:mass=452.278;rt=35.1",
                          "ms_run[3]:mass=882.621;rt=40.0"))
    expect_equal(res$exp_mass_to_charge, c("700.525", "452.278", "882.621"))
    expect_equal(res$charge, c("1", "1", "1"))
    expect_equal(res$theoretical_mass_to_charge, c("700.528", "452.277",
                                                    "882.622"))
    expect_equal(res$spectra_ref, c("ms_run[1]:index=7646",
                                "ms_run[2]:index=7640",
                                "ms_run[3]:index=7671|ms_run[3]:index=7725"))
    expect_equal(res$identification_method, c("[, , LipidDataAnalyzer, 2.11.1]",
                                            "[, , LipidDataAnalyzer, 2.11.1]",
                                            "[, , LipidDataAnalyzer, 2.11.1]"))
    expect_equal(res$ms_level, c("[MS, MS:1000511, ms level, 2]",
                                "[MS, MS:1000511, ms level, 2]",
                                "[MS, MS:1000511, ms level, 2]"))
    expect_equal(res$rank, c("1", "1", "1"))

    expect_equal(colnames(res), c("SEH", "SME_ID", "evidence_input_id",
                "database_identifier", "chemical_formula", "smiles", "inchi",
                "chemical_name", "uri", "derivatized_form", "adduct_ions",
                "exp_mass_to_charge", "charge", "theoretical_mass_to_charge",
                "spectra_ref", "identification_method", "ms_level", "rank" ))

    ## Test id_confidence_measure
    id_confidence_measure_mat <- matrix(c(1, 1.4, 1.2, 0.8, 1, 0.5), ncol = 2)
    expect_error(sme_create(
        evidence_input_id = evidence_input_id,
        exp_mass_to_charge = exp_mass_to_charge,
        charge = charge,
        theoretical_mass_to_charge = theoretical_mass_to_charge,
        spectra_ref = spectra_ref,
        identification_method = identification_method,
        ms_level = ms_level,
        id_confidence_measure = id_confidence_measure_mat
    ), "provide a valid MTD section")

    res <- sme_create(
        evidence_input_id = evidence_input_id,
        exp_mass_to_charge = exp_mass_to_charge,
        charge = charge,
        theoretical_mass_to_charge = theoretical_mass_to_charge,
        spectra_ref = spectra_ref,
        identification_method = identification_method,
        ms_level = ms_level,
        id_confidence_measure = id_confidence_measure_mat, mtd = mtd
    )
    expect_true("id_confidence_measure[1]" %in% colnames(res))
    expect_true("id_confidence_measure[2]" %in% colnames(res))

    res <- sme_create(
        evidence_input_id = evidence_input_id,
        exp_mass_to_charge = exp_mass_to_charge,
        charge = charge,
        theoretical_mass_to_charge = theoretical_mass_to_charge,
        spectra_ref = spectra_ref,
        identification_method = identification_method,
        ms_level = ms_level, mtd = mtd,
        global_custom = c("A", "B", "C")
    )
    expect_true("opt_global_custom" %in% colnames(res))
    expect_equal(res$opt_global_custom, c("A", "B", "C"))

    expect_error(sme_create(c("bad", "arg"),
                    evidence_input_id = evidence_input_id,
                    exp_mass_to_charge = exp_mass_to_charge,
                    charge = charge,
                    theoretical_mass_to_charge = theoretical_mass_to_charge,
                    spectra_ref = spectra_ref,
                    identification_method = identification_method,
                    ms_level = ms_level, mtd = mtd),
                 "must be named")
    expect_error(sme_create(
                    evidence_input_id = evidence_input_id,
                    exp_mass_to_charge = c(700.525,452.278),
                    charge = charge,
                    theoretical_mass_to_charge = theoretical_mass_to_charge,
                    spectra_ref = spectra_ref,
                    identification_method = identification_method,
                    ms_level = ms_level, mtd = mtd),
                 "does not match row count")
    expect_error(sme_create(evidence_input_id = evidence_input_id,
                        exp_mass_to_charge = exp_mass_to_charge,
                        charge = charge,
                        theoretical_mass_to_charge = theoretical_mass_to_charge,
                        spectra_ref = spectra_ref,
                        identification_method = identification_method,
                        ms_level = ms_level, mtd = mtd,
                        my_col = c(1, 2)),
                 "does not match row count")
})

test_that("sme_sort works and keeps all columns", {
    df <- data.frame(SME_ID = 1:2,
                     opt_custom = c("A", "B"),
                     SEH = c("SME", "SME"),
                     exp_mass_to_charge = c(700.5255, 452.2782),
                     charge = c(1, 1),
                     evidence_input_id = c("ms_run[1]:mass=700.5255;rt=20·5",
                                           "ms_run[2]:mass=452.2782;rt=35.1")
                     )
    res <- sme_sort(df)
    expect_true(is.data.frame(res))
    expect_equal(dim(res), dim(df))
    expect_equal(colnames(res),
                 c("SEH", "SME_ID", "evidence_input_id", "exp_mass_to_charge",
                   "charge", "opt_custom"))
    expect_equal(res$SEH, c("SME", "SME"))
    expect_equal(res$SME_ID, 1:2)
    expect_equal(res$opt_custom, c("A", "B"))
})

test_that("sme_id_confidence_measure works", {
    id_confidence_measure_vec <- c(1, 1.4, 1.2)
    mtd <- cbind(c("id_confidence_measure[1]"),
                 c("[MS, MS:1002890, fragmentation score, ]"))

    res <- sme_id_confidence_measure(id_confidence_measure_vec, mtd, nr = 3)
    expect_true(is.matrix(res))
    expect_true("id_confidence_measure[1]" %in% colnames(res))
    expect_true(nrow(res) == 3)

    expect_error(sme_id_confidence_measure(id_confidence_measure_vec, mtd,
                                            nr = 2),
                "Number row in parameter")

    mtd_error = cbind(c("id_confidence_measure[1]", "id_confidence_measure[2]"),
                      c("[MS, MS:1002890, fragmentation score, ]",
                        "[MS, MS:1002890, fragmentation score, ]"))
    expect_error(sme_id_confidence_measure(id_confidence_measure_vec, mtd_error,
                                            nr = 3),
                "Number column in parameter")

})


test_that("sme_spectra_ref_validator validate", {
    expect_error(sme_spectra_ref_validator(character(), matrix()),
                "Provide a vector of \"spectra_ref\"")

    spectra_ref = c("ms_run[1]:index=7646", "ms_run[2]:index=7640",
                    "ms_run[3]:index=7671|ms_run[3]:index=7725")

    expect_error(sme_spectra_ref_validator(spectra_ref, NULL),
                "Provide a MTD section")
    expect_error(sme_spectra_ref_validator(spectra_ref, matrix()),
                "No \"ms_run\" detected in MTD section")

    mtd_error <- cbind(c("ms_run[1]-location", "ms_run[1]-format",
                        "ms_run[1]-id_format", "ms_run[1]-scan_polarity[1]"),
                        c("1.mzML", "[MS, MS:1000584, mzML file, ]",
                        "[MS, MS:1000530, mzML unique identifier, ]",
                        "[MS, MS:1000130, positive scan, ]"))
    expect_error(sme_spectra_ref_validator(spectra_ref, mtd_error),
                "Invalid \"ms_run\" index at position: 2, 3")


    mtd <- cbind(c("ms_run[1]-location", "ms_run[1]-format",
                   "ms_run[1]-id_format", "ms_run[1]-scan_polarity[1]",
                   "ms_run[2]-location", "ms_run[2]-format",
                   "ms_run[2]-id_format", "ms_run[2]-scan_polarity[1]",
                   "ms_run[3]-location", "ms_run[3]-format",
                   "ms_run[3]-id_format", "ms_run[3]-scan_polarity[1]"),
                 c("1.mzML", "[MS, MS:1000584, mzML file, ]",
                   "[MS, MS:1000530, mzML unique identifier, ]",
                   "[MS, MS:1000130, positive scan, ]",
                   "2.mzML", "[MS, MS:1000584, mzML file, ]",
                   "[MS, MS:1000530, mzML unique identifier, ]",
                   "[MS, MS:1000130, positive scan, ]",
                   "3.mzML", "[MS, MS:1000584, mzML file, ]",
                   "[MS, MS:1000530, mzML unique identifier, ]",
                   "[MS, MS:1000130, positive scan, ]"))
    res <- sme_spectra_ref_validator(spectra_ref, mtd)
    expect_equal(res, spectra_ref)
})
