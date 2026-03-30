test_that("sml_create works", {
    amat <- matrix(abs(rnorm(8)), nrow = 4)
    expect_error(
        sml_create(x = amat, database_identifier = c("a", "b|c", "d", "e"),
                   smiles = c("A", "B", "C", "D"), other = 1:4),
        "expected number of elements")
    res <- sml_create(x = amat, database_identifier = c("a", "b|c", "d", "e"),
                      smiles = c("A", "B|Z", "C", "D"), other = 1:4)
    expect_equal(colnames(res), c("SMH", "SML_ID", "SMF_ID_REFS",
                                  "database_identifier", "chemical_formula",
                                  "smiles", "inchi", "chemical_name", "uri",
                                  "theoretical_neutral_mass", "adduct_ions",
                                  "reliability", "best_id_confidence_measure",
                                  "best_id_confidence_value",
                                  "abundance_assay[1]", "abundance_assay[2]",
                                  "opt_other"))
    expect_equal(res$opt_other, as.character(1:4))
})

test_that("sml_sort works", {
    x <- data.frame(SML_ID = "a", adduct_ions = "b", smiles = "c",
                    opt_something = "d", opt_someother = "e",
                    `abundance_assay[1]` = "f",
                    `abundance_study_variable[1]` = "g",
                    `abundance_assay[2]` = "h", check.names = FALSE)
    res <- sml_sort(x)
    ## ensure -average_function and -variation_function are AFTER abundance
    ## but BEFORE opt_
    expect_equal(colnames(res), c("SML_ID", "smiles", "adduct_ions",
                                  "abundance_assay[1]", "abundance_assay[2]",
                                  "abundance_study_variable[1]",
                                  "opt_something", "opt_someother"))
})

test_that("sml_add_study_variable_columns works", {
    ## prepare test data.
    x <- matrix(1:10, ncol = 5, nrow = 2)
    colnames(x) <- c(paste0("abundance_assay[", 1:5, "]"))
    m <- cbind(
        c("study_variable[1]",
          "study_variable[1]-assay_refs",
          "study_variable[1]-average_function",
          "study_variable[1]-variation_function",
          "study_variable[1]-description",
          "study_variable[2]",
          "study_variable[2]-assay_refs",
          "study_variable[2]-average_function",
          "study_variable[2]-variation_function",
          "study_variable[2]-description"),
        c("a",
          "assay[1]|assay[2]|assay[5]",
          "[MS, MS:1002962, mean, ]",
          "[MS, MS:1002963, variation coefficient, ]",
          "aa",
          "b",
          "assay[3]|assay[4]",
          "[MS, MS:1002962, mean, ]",
          "[MS, MS:1002963, variation coefficient, ]",
          "bb")
    )
    ## works
    res <- sml_add_study_variable_columns(x, m)
    expect_true(is.matrix(res))
    expect_equal(res[, colnames(x)], x)
    expect_equal(res[, "abundance_study_variable[1]"],
                 c(mean(c(1, 3, 9)), mean(c(2, 4, 10))))
    vfun <- function(x) sd(x) / mean(x)
    expect_equal(res[, "abundance_variation_study_variable[1]"],
                 c(vfun(c(1, 3, 9)), vfun(c(2, 4, 10))))
    expect_equal(res[, "abundance_study_variable[2]"],
                 c(mean(c(5, 7)), mean(c(6, 8))))
    expect_equal(res[, "abundance_variation_study_variable[2]"],
                 c(vfun(c(5, 7)), vfun(c(6, 8))))
    res <- sml_add_study_variable_columns(as.data.frame(x), m)
    expect_true(is.data.frame(res))
    expect_equal(res[, colnames(x)], as.data.frame(x))
    expect_equal(res[, "abundance_study_variable[1]"],
                 c(mean(c(1, 3, 9)), mean(c(2, 4, 10))))
    expect_equal(res[, "abundance_variation_study_variable[1]"],
                 c(vfun(c(1, 3, 9)), vfun(c(2, 4, 10))))
    expect_equal(res[, "abundance_study_variable[2]"],
                 c(mean(c(5, 7)), mean(c(6, 8))))
    expect_equal(res[, "abundance_variation_study_variable[2]"],
                 c(vfun(c(5, 7)), vfun(c(6, 8))))

    ## errors.
    m2 <- m
    m2 <- m2[-7, ]
    expect_error(sml_add_study_variable_columns(x, m2), "missing in")
    m2 <- m
    m2[7, 2] <- "assay[3|other]"
    expect_error(sml_add_study_variable_columns(x, m2), "not found in")
    m2 <- m
    m2 <- m2[-3, ]
    expect_error(sml_add_study_variable_columns(x, m2), "average_function")
    m2 <- m
    m2 <- m2[-9, ]
    expect_error(sml_add_study_variable_columns(x, m2), "variation_function")
    m2 <- m
    m2[3, 2] <- "[, , , ,]"
    expect_error(sml_add_study_variable_columns(x, m2), "CV term")
    m2 <- m
    m2[9, 2] <- "[, , , ,]"
    expect_error(sml_add_study_variable_columns(x, m2), "CV term")
})
