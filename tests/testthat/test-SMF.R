test_that(".smf_abundance_matrix works", {
    expect_error(.smf_abundance_matrix("a"), "Input must be a matrix")
    expect_error(.smf_abundance_matrix(list(a = 1)), "Input must be a matrix")
    mat <- matrix(c(10.1, 20.2, 30.3, 40.4), nrow = 2, byrow = TRUE)
    res <- .smf_abundance_matrix(mat)

    expect_true(is.data.frame(res))
    expect_equal(nrow(res), 2)
    expect_equal(ncol(res), 3) # ID + 2 assays
    expect_equal(
        colnames(res),
        c("SMF_ID", "abundance_assay[1]", "abundance_assay[2]")
    )
    expect_equal(res$SMF_ID, c(1, 2))
    expect_equal(res[, 2], c(10.1, 30.3))
    df <- data.frame(a = c(1, 2), b = c(3, 4))
    res <- .smf_abundance_matrix(df)
    expect_equal(
        colnames(res),
        c("SMF_ID", "abundance_assay[1]", "abundance_assay[2]")
    )
})

test_that(".fill_column works", {
    res <- .fill_column(NULL, 3)
    expect_equal(res, c("null", "null", "null"))
    res <- .fill_column(c(1, NA, 3), 3)
    expect_equal(res, c("1", "null", "3"))
    res <- .fill_column(1, 3)
    expect_equal(res, c("1", "1", "1"))
    expect_error(.fill_column(c(1, 2), 3), "does not match row count")
})

test_that("smf_create works", {
    mat <- matrix(1:4, nrow = 2)
    expect_error(smf_create(mat), "argument 'exp_mass_to_charge' is mandatory")
    res <- smf_create(smf_df = mat, exp_mass_to_charge = c(100.1, 100.2))
    expect_true(is.data.frame(res))
    expect_equal(res$SFH, c("SMF", "SMF"))
    expect_equal(res$exp_mass_to_charge, c("100.1", "100.2"))
    expect_equal(res$retention_time_in_seconds, c("null", "null"))
    expect_equal(res$charge, c("null", "null"))

    expect_equal(colnames(res)[1:3], c("SFH", "SMF_ID", "SME_ID_REFS"))
    res <- smf_create(
        smf_df = mat,
        exp_mass_to_charge = c(100.1, 100.2),
        global_custom = c("A", "B")
    )
    expect_true("opt_global_custom" %in% colnames(res))
    expect_equal(res$opt_global_custom, c("A", "B"))
    res <- smf_create(
        smf_df = mat,
        exp_mass_to_charge = c(100.1, 100.2),
        opt_existing = c("X", "Y")
    )
    expect_true("opt_existing" %in% colnames(res))
    expect_false("opt_opt_existing" %in% colnames(res))

    expect_error(
        smf_create(c("bad", "arg"), smf_df = mat,
         exp_mass_to_charge = c(100.1, 100.2)),
        "must be named"
    )
    expect_error(
        smf_create(
            smf_df = mat,
            exp_mass_to_charge = c(100.1, 100.2),
            charge = c(1, 2, 3)
        ),
        "does not match row count"
    )

    expect_error(
        smf_create(
            smf_df = mat,
            exp_mass_to_charge = c(100.1, 100.2),
            my_col = c(1, 2, 3)
        ),
        "does not match row count"
    )
})
