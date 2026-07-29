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
    expect_equal(res[[1L]](1:4), median(1:4))
    res <- .resolve_fun(c("MS:1002883", "MS:1002962"))
    expect_length(res, 2L)
    expect_true(is.list(res))
    expect_true(is.function(res[[1L]]))
    expect_equal(res[[1L]](1:20), median(1:20))
    expect_true(is.function(res[[2L]]))
    expect_equal(res[[2L]](1:17), mean(1:17))
})

test_that("parseCvParameter works", {
    x <- c("aaa", "[aaaa]")
    expect_error(parseCvParameter(x), "Unexpected CV")
    res <- parseCvParameter(c("[a,b,c,d]", "[e, f, g, h]"), 1L)
    expect_equal(res, c("a", "e"))
    res <- parseCvParameter(c("[a,b,c,d]", "[e, f, g, h]"), 2L)
    expect_equal(res, c("b", "f"))
    res <- parseCvParameter(c("[a,b,c,d]", "[e, f, g, h]"), 3L)
    expect_equal(res, c("c", "g"))
    res <- parseCvParameter(c("[a,b,c,d]", "[e, f, g, h]"), 4L)
    expect_equal(res, c("d", "h"))

    res <- parseCvParameter(c("[a, , , ]", "[b,,,]"), 1L)
    expect_equal(res, c("a", "b"))
    res <- parseCvParameter(c("[a, , , ]", "[b,,,]"), 2L)
    expect_equal(res, c(NA_character_, NA_character_))
    res <- parseCvParameter(c("[a, , , ]", "[b,,,]"), 3L)
    expect_equal(res, c(NA_character_, NA_character_))
    res <- parseCvParameter(c("[a, , , ]", "[b,,,]"), 4L)
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

test_that(".check_fill_column works", {
    res <- .check_fill_column(character(), 3)
    expect_equal(res, c("null", "null", "null"))
    res <- .check_fill_column(c(1, NA, 3), 3)
    expect_equal(res, c("1", "null", "3"))
    res <- .check_fill_column(1, 3)
    expect_equal(res, c("1", "1", "1"))
    expect_error(.check_fill_column(c(1, 2), 3), "does not match row count")
    ## lengths.
    res <- .check_fill_column(c("a", "b", "c"), lout = 3, lengths = c(1, 1, 1))
    expect_equal(res, c("a", "b", "c"))
    expect_error(
        .check_fill_column(c("a", "b", "c"), lout = 3, lengths = c(1, 2, 1)),
        "expected number of elements")
    res <- .check_fill_column(
        c("a|a2", "b", "c"), lout = 3, lengths = c(2, 1, 1))
    expect_equal(res, c("a|a2", "b", "c"))
    res <- .check_fill_column(
        c("a|a2", "null", "c"), lout = 3, lengths = c(2, 3, 1))
    expect_equal(res, c("a|a2", "null|null|null", "c"))
    res <- .check_fill_column(character(), lout = 3, lengths = c(1, 2, 3))
    expect_equal(res, c("null", "null|null", "null|null|null"))
})

test_that(".sort_order works", {
    eo <- c("b", "d", "a", "f")
    x <- c("a", "b", "c", "d", "e", "f", "g")
    res <- .sort_order(x, eo)
    expect_true(is.integer(res))
    expect_equal(length(res), 7)
    expect_equal(x[res], c("b", "d", "a", "f", "c", "e", "g"))
    res <- .sort_order(c("z", "y"), eo)
    expect_equal(res, c(1L, 2L))
    res <- .sort_order(c("z", "y", "d"), eo)
    expect_equal(res, c(3L, 1L, 2L))
})

test_that(".add_opt_cols works", {
    x <- data.frame(a = 1:3, b = "b")
    res <- .add_opt_cols(x = x)
    expect_equal(x, x)
    res <- .add_opt_cols(x = x, other = numeric())
    expect_equal(colnames(res), c("a", "b", "opt_global_other"))
    expect_equal(res$opt_global_other, c("null", "null", "null"))
    res <- .add_opt_cols(x = x, other = numeric(), bla = 1:3,
                         identifier = c("ms_run[1]", "ms_run[2]"))
    expect_equal(colnames(res),
                c("a", "b", "opt_ms_run[1]_other", "opt_ms_run[2]_bla"))
    expect_equal(res$`opt_ms_run[2]_bla`, as.character(1:3))
    expect_error(.add_opt_cols(x = x, other = numeric(), 1:4), "must be named")
    expect_error(.add_opt_cols(x = x, other = numeric(),
                                identifier = c("a", "b")),
                "must be either 1 or match the number of optional columns")
})

test_that("isCvParameter works", {
    vals <- c("", "[]", "[a]", "[a,a]", "[a,a,a]", "[a,a,a,a]", "[a,a,a,a,a]")
    expect_equal(isCvParameter(vals), c(FALSE, FALSE, FALSE, FALSE, FALSE,
                                        TRUE, FALSE))
})

test_that(".NAtonull works", {
  df <- data.frame(
    num = c(1, NA, 3),
    chr = c("a", "", "b")
  )
  result <- .NAtonull(df)
  expect_true(is.data.frame(result))
  expect_equal(result$num, c("1", "null", "3"))
  expect_equal(result$chr, c("a", "null", "b"))
  expect_named(result, c("num", "chr"))
})

test_that(".separate_multi_links works", {
    df <- data.frame(id = 1:2, assay_refs = c("a|b", "c"),
                      stringsAsFactors = FALSE)
    res <- .separate_multi_links(df, "assay_refs")
    expect_equal(nrow(res), 3)
    expect_equal(res$assay_refs, c("a", "b", "c"))
    expect_equal(res$id, c(1, 1, 2))

    expect_error(.separate_multi_links(df, "missing_col"), "not present")
})
