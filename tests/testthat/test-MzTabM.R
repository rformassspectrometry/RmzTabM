test_that("MzTabM class, constructor, show and validation works", {
    a <- new("MzTabM")
    expect_s4_class(a, "MzTabM")
    expect_true(validObject(a))

    a@mtd <- matrix(1:3, ncol = 3)
    expect_match(.mztab_validate_slots(a), "with two columns")
    expect_error(validObject(a), "with two columns")
    a@mtd <- matrix(ncol = 2, nrow = 0)
    a@sme <- matrix(NA_character_, ncol = 8, nrow = 3)
    res <- .mztab_validate_slots(a)
    expect_match(res[1L], "can not be empty")
    expect_match(res[2L], "SMF section needs to be defined")

    res <- capture.output(show(a))
    expect_match(res[2L], "SME section with 3 rows")

    a <- MzTabM()
    expect_s4_class(a, "MzTabM")
    res <- capture.output(show(a))
    expect_match(res[2L], "2.1.0-M")

    a <- MzTabM(mtd = mtdSkeleton(id = "001", software = "[,,RmzTabM,]"),
                smf = matrix(NA_character_, ncol = 4, nrow = 3),
                sml = matrix(NA_character_, ncol = 8, nrow = 2),
                sme = matrix(NA_character_, ncol = 7, nrow = 5))
    res <- capture.output(show(a))
    expect_match(res[3L], "23 rows")
    expect_match(res[4L], "2 rows and 8 columns")
    expect_match(res[5L], "3 rows and 4 columns")
    expect_match(res[6L], "5 rows and 7 columns")
})
