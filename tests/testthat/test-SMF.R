test_that("create_basic_smf works", {
    expect_error(create_basic_smf("a"), "Input must be a matrix")
    expect_error(create_basic_smf(list(a = 1)), "Input must be a matrix")
    mat <- matrix(c(10.1, 20.2, 30.3, 40.4), nrow = 2, byrow = TRUE)
    res <- create_basic_smf(mat)

    expect_true(is.data.frame(res))
    expect_equal(nrow(res), 2)
    expect_equal(ncol(res), 3) # ID + 2 assays
    expect_equal(colnames(res), c("SMF_ID", "abundance_assay[1]", "abundance_assay[2]"))
    expect_equal(res$SMF_ID, c(1, 2))
    expect_equal(res[, 2], c(10.1, 30.3))

    df <- data.frame(a = c(1, 2), b = c(3, 4))
    res <- create_basic_smf(df)
    expect_equal(colnames(res), c("SMF_ID", "abundance_assay[1]", "abundance_assay[2]"))
})

test_that("finalize_smf works", {
    mat <- matrix(1:4, nrow = 2)
    base <- create_basic_smf(mat)

    res <- finalize_smf(base)

    expect_true(is.data.frame(res))
    expect_equal(res$SFH, c("SMF", "SMF"))
    expect_equal(res$exp_mass_to_charge, c("null", "null"))
    expect_equal(res$retention_time_in_seconds, c("null", "null"))
    expect_equal(colnames(res)[1:3], c("SFH", "SMF_ID", "SME_ID_REFS"))

    res <- finalize_smf(base,
                        exp_mass_to_charge = c(100.1, 200.2),
                        charge = 1) # Recycle charge

    expect_equal(res$exp_mass_to_charge, c("100.1", "200.2"))
    expect_equal(res$charge, c("1", "1"))
    expect_equal(res$adduct_ion, c("null", "null"))

    base$opt_global_test <- c("A", "B")
    res <- finalize_smf(base)
    expect_true("opt_global_test" %in% colnames(res))
    expect_equal(tail(colnames(res), 1), "opt_global_test")

    expect_warning(finalize_smf(base, charge = c(1, 2, 3)), "does not match")
})
