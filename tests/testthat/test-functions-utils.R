test_that(".prefix_zero works", {
    expect_equal(.prefix_zero(54), "54")
    expect_equal(.prefix_zero(c(1, 100)), c("001", "100"))
})

test_that(".resolve_fun works", {
    expect_error(.resolve_fun(NA), "Can not")
    expect_error(.resolve_fun(c("other")), "Can not")
    expect_error(.resolve_fun(c("MS:1002883", "other")), "Can not")
    res <- .resolve_fun("MS:1002883")
    expect_length(res, 1L)
    expect_true(is.list(res))
    expect_true(is.function(res[[1L]]))
    expect_equal(res[[1L]], median)
    res <- .resolve_fun(c("MS:1002883", "MS:1002962"))
    expect_length(res, 2L)
    expect_true(is.list(res))
    expect_true(is.function(res[[1L]]))
    expect_equal(res[[1L]], median)
    expect_true(is.function(res[[2L]]))
    expect_equal(res[[2L]], mean)
})

test_that("parse_cv_parameter works", {
    x <- c("aaa", "[aaaa]")
    expect_error(parse_cv_parameter(x), "Unexpected CV")
    res <- parse_cv_parameter(c("[a,b,c,d]", "[e, f, g, h]"), 1L)
    expect_equal(res, c("a", "e"))
    res <- parse_cv_parameter(c("[a,b,c,d]", "[e, f, g, h]"), 2L)
    expect_equal(res, c("b", "f"))
    res <- parse_cv_parameter(c("[a,b,c,d]", "[e, f, g, h]"), 3L)
    expect_equal(res, c("c", "g"))
    res <- parse_cv_parameter(c("[a,b,c,d]", "[e, f, g, h]"), 4L)
    expect_equal(res, c("d", "h"))

    res <- parse_cv_parameter(c("[a, , , ]", "[b,,,]"), 1L)
    expect_equal(res, c("a", "b"))
    res <- parse_cv_parameter(c("[a, , , ]", "[b,,,]"), 2L)
    expect_equal(res, c(NA_character_, NA_character_))
    res <- parse_cv_parameter(c("[a, , , ]", "[b,,,]"), 3L)
    expect_equal(res, c(NA_character_, NA_character_))
    res <- parse_cv_parameter(c("[a, , , ]", "[b,,,]"), 4L)
    expect_equal(res, c(NA_character_, NA_character_))
})

test_that(".abundance_matrix works", {
    expect_error(.abundance_matrix("a"), "must be a")
    expect_error(.abundance_matrix(list(a = 1)), "must be a")
    expect_error(.abundance_matrix(), "must be provided")
    mat <- matrix(c(10.1, 20.2, 30.3, 40.4), nrow = 2, byrow = TRUE)
    res <- .abundance_matrix(mat)

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
    res <- .abundance_matrix(df)
    expect_equal(
        colnames(res),
        c("SMF_ID", "abundance_assay[1]", "abundance_assay[2]")
    )
})
