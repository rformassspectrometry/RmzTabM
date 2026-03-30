test_that("smf_create works", {
    mat <- matrix(1:4, nrow = 2)
    expect_error(smf_create(mat), "argument 'exp_mass_to_charge' is mandatory")
    res <- smf_create(x = mat, exp_mass_to_charge = c(100.1, 100.2))
    expect_true(is.data.frame(res))
    expect_equal(res$SFH, c("SMF", "SMF"))
    expect_equal(res$exp_mass_to_charge, c("100.1", "100.2"))
    expect_equal(res$retention_time_in_seconds, c("null", "null"))
    expect_equal(res$charge, c("null", "null"))

    expect_equal(colnames(res)[1:3], c("SFH", "SMF_ID", "SME_ID_REFS"))
    res <- smf_create(
        x = mat,
        exp_mass_to_charge = c(100.1, 100.2),
        global_custom = c("A", "B")
    )
    expect_true("opt_global_custom" %in% colnames(res))
    expect_equal(res$opt_global_custom, c("A", "B"))
    res <- smf_create(
        x = mat,
        exp_mass_to_charge = c(100.1, 100.2),
        opt_existing = c("X", "Y")
    )
    expect_true("opt_existing" %in% colnames(res))
    expect_false("opt_opt_existing" %in% colnames(res))

    expect_error(smf_create(c("bad", "arg"), x = mat,
                            exp_mass_to_charge = c(100.1, 100.2)),
                 "must be named")
    expect_error(smf_create(x = mat, charge = c(1, 2, 3),
                            exp_mass_to_charge = c(100.1, 100.2)),
                 "does not match row count")
    expect_error(smf_create(x = mat, exp_mass_to_charge = c(100.1, 100.2),
                            my_col = c(1, 2, 3)),
                 "does not match row count")
})

test_that("smf_sort works and keeps all columns", {
    df <- data.frame(SMF_ID = 1:2,
                     opt_custom = c("A", "B"),
                     SFH = c("SMF", "SMF"),
                     exp_mass_to_charge = c(100.1, 100.2),
                     charge = c(1, 2),
                     retention_time_in_seconds = c(30, 60)
                     )
    res <- smf_sort(df)
    expect_true(is.data.frame(res))
    expect_equal(dim(res), dim(df))
    expect_equal(colnames(res),
                 c("SFH", "SMF_ID", "exp_mass_to_charge", "charge",
                   "retention_time_in_seconds", "opt_custom"))
    expect_equal(res$SFH, c("SMF", "SMF"))
    expect_equal(res$SMF_ID, 1:2)
    expect_equal(res$opt_custom, c("A", "B"))
})
