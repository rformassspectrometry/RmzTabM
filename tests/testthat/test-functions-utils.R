test_that(".prefix_zero works", {
    expect_equal(.prefix_zero(54), "54")
    expect_equal(.prefix_zero(c(1, 100)), c("001", "100"))
})

test_that(".fill_column works", {
    res <- .fill_column(NULL, 3)
    expect_equal(res, c("null", "null", "null"))

    res <- .fill_column(c(1, NA, 3), 3)
    expect_equal(res, c("1", "null", "3"))

    res <- .fill_column(1, 3)
    expect_equal(res, c("1", "1", "1"))

    expect_warning(.fill_column(c(1, 2), 3), "does not match row count")
})
