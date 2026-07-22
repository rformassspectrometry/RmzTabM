test_that(".cv works", {
    res <- .cv()
    expect_true(is.matrix(res))
    expect_true(is.character(res))
    expect_true(nrow(res) == 0)

    expect_error(.cv("a"), "elements must match")

    res <- .cv(c("a", "b", "c"), c("A", "B", "C"), 1:3, 1:3)
    expect_true(is.matrix(res))
    expect_true(is.character(res))
    expect_true(nrow(res) == 12)
    expect_equal(
        res[, 1],
        c("cv[1]-label", "cv[1]-full_name", "cv[1]-version", "cv[1]-uri",
          "cv[2]-label", "cv[2]-full_name", "cv[2]-version", "cv[2]-uri",
          "cv[3]-label", "cv[3]-full_name", "cv[3]-version", "cv[3]-uri"))
    expect_equal(res[, 2], c("a", "A", "1", "1",
                             "b", "B", "2", "2",
                             "c", "C", "3", "3"))
})

test_that(".database works", {
    res <- .database()
    expect_true(is.matrix(res))
    expect_true(is.character(res))
    expect_true(nrow(res) == 0)

    expect_error(.database("a"), "elements must match")
    res <- .database(c("a", "b"), c("ap", "bp"),
                     version = c(1, "null"), uri = c("A", "B"))
    expect_equal(res[, 1L], c("database[1]",
                              "database[1]-prefix",
                              "database[1]-version",
                              "database[1]-uri",
                              "database[2]",
                              "database[2]-prefix",
                              "database[2]-version",
                              "database[2]-uri"))
    expect_equal(res[, 2L], c("a", "ap", "1", "A", "b", "bp", "null", "B"))
})

test_that("mtdSkeleton works", {
    expect_error(mtdSkeleton(), "'id' is required")
    expect_error(mtdSkeleton(id = "1"), "'software' is required")
    res <- mtdSkeleton(id = "1", software = "Fancy software")
    expect_true(is.matrix(res))
    expect_true(is.character(res))
})

test_that("mtdSort works", {
    ref <- mtdSkeleton(id = "a", software = "Excel")
    res <- mtdSort(ref)
    expect_equal(ref, res)

    ref <- ref[1:23, ]
    res <- mtdSort(ref[c(5:16, 1, 3, 17:20, 2, 4, 22, 23, 21), ])
    expect_equal(ref, res)
})

test_that(".ms_run_format works", {
    res <- .ms_run_format(1:4, "test", c("A", "B", "C", "D"))
    expect_true(is.matrix(res))
    expect_true(is.character(res))
    expect_equal(nrow(res), 4)
    expect_equal(ncol(res), 3)
    expect_equal(res[, 1L], c("ms_run[1]-test", "ms_run[2]-test",
                              "ms_run[3]-test", "ms_run[4]-test"))
    expect_equal(res[, 2L], c("A", "B", "C", "D"))
    expect_equal(res[, 3L], as.character(1:4))
})

test_that(".ms_scan_polarity works", {
    expect_error(.ms_scan_polarity(c("positive", "other")), "has to be")
    res <- .ms_scan_polarity(c("positive", "negative"))
    expect_equal(res, c("[MS, MS:1000130, positive scan, ]",
                        "[MS, MS:1000129, negative scan, ]"))
})

test_that("mtdMsRun works", {
    expect_error(mtdMsRun(), "'location' is required")
    expect_error(mtdMsRun(location = "null", "'scan_polarity' is required"))
    expect_error(mtdMsRun(location = c("null", "other"),
                            scan_polarity = c("positive", "negative"),
                            format = "a"), "have to be defined")
    expect_error(mtdMsRun(location = c("null", "other"),
                            scan_polarity = c("positive", "negative"),
                            format = "a", id_format = 1:2),
                 "have to be defined")
    expect_error(mtdMsRun(location = c("null", "other"),
                            scan_polarity = c("positive", "negative"),
                            hash = "a"), "have to be defined")
    expect_error(mtdMsRun(location = c("null", "other"),
                            scan_polarity = c("positive", "negative"),
                            hash = "a", hash_method = "a"), "match length")
    expect_error(mtdMsRun(location = c("null", "other"),
                            scan_polarity = c("positive", "negative"),
                            fragmentation_method = list(3)), "match length")
    res <- mtdMsRun(location = c("null", "other"),
                      scan_polarity = c("positive", "negative"))
    expect_true(is.matrix(res))
    expect_true(is.character(res))
    expect_equal(res[, 1L], c("ms_run[1]-location",
                              "ms_run[1]-scan_polarity[1]",
                              "ms_run[2]-location",
                              "ms_run[2]-scan_polarity[1]"))
    expect_equal(res[, 2L], c("null",
                              "[MS, MS:1000130, positive scan, ]",
                              "other",
                              "[MS, MS:1000129, negative scan, ]"))
    ## instrument_ref
    res <- mtdMsRun(location = c("null", "other"),
                      scan_polarity = c("positive", "negative"),
                      instrument_ref = 1)
    expect_true(nrow(res) == 6)
    expect_equal(res[, 1L], c("ms_run[1]-location",
                              "ms_run[1]-instrument_ref",
                              "ms_run[1]-scan_polarity[1]",
                              "ms_run[2]-location",
                              "ms_run[2]-instrument_ref",
                              "ms_run[2]-scan_polarity[1]"))
    expect_equal(res[, 2L], c("null",
                              "instrument[1]",
                              "[MS, MS:1000130, positive scan, ]",
                              "other",
                              "instrument[1]",
                              "[MS, MS:1000129, negative scan, ]"))
    ## format
    res <- mtdMsRun(location = c("null", "other"),
                      scan_polarity = c("positive", "negative"),
                      format = "[MS, MS:1000584, mzML file, ]",
                      id_format = "[MS, MS:1000530, mzML unique identifier, ]")
    expect_equal(res[, 1L], c("ms_run[1]-location",
                              "ms_run[1]-format",
                              "ms_run[1]-id_format",
                              "ms_run[1]-scan_polarity[1]",
                              "ms_run[2]-location",
                              "ms_run[2]-format",
                              "ms_run[2]-id_format",
                              "ms_run[2]-scan_polarity[1]"))
    expect_equal(res[, 2L], c("null",
                              "[MS, MS:1000584, mzML file, ]",
                              "[MS, MS:1000530, mzML unique identifier, ]",
                              "[MS, MS:1000130, positive scan, ]",
                              "other",
                              "[MS, MS:1000584, mzML file, ]",
                              "[MS, MS:1000530, mzML unique identifier, ]",
                              "[MS, MS:1000129, negative scan, ]"))
    ## hash
    res <- mtdMsRun(location = c("null", "other"),
                      scan_polarity = c("positive", "negative"),
                      hash = c("a", "b"),
                      hash_method = c("[MS, MS:1000569, SHA-1, ]",
                                      "[MS, MS:1000569, SHA-1, ]"))
    expect_equal(res[, 1L], c("ms_run[1]-location",
                              "ms_run[1]-scan_polarity[1]",
                              "ms_run[1]-hash",
                              "ms_run[1]-hash_method",
                              "ms_run[2]-location",
                              "ms_run[2]-scan_polarity[1]",
                              "ms_run[2]-hash",
                              "ms_run[2]-hash_method"))
    expect_equal(res[, 2L], c("null",
                              "[MS, MS:1000130, positive scan, ]",
                              "a",
                              "[MS, MS:1000569, SHA-1, ]",
                              "other",
                              "[MS, MS:1000129, negative scan, ]",
                              "b",
                              "[MS, MS:1000569, SHA-1, ]"))
    ## fragmentation_method
    res <- mtdMsRun(location = c("null", "other"),
                      scan_polarity = c("positive", "negative"),
                      fragmentation_method = list(NULL,
                                                  c("[MS, MS:1000133, CID, ]",
                                                    "[MS, MS:1000422, HCD, ]")))
    expect_equal(res[, 1L], c("ms_run[1]-location",
                              "ms_run[1]-scan_polarity[1]",
                              "ms_run[2]-location",
                              "ms_run[2]-fragmentation_method[1]",
                              "ms_run[2]-fragmentation_method[2]",
                              "ms_run[2]-scan_polarity[1]"))
    expect_equal(res[, 2L], c("null",
                              "[MS, MS:1000130, positive scan, ]",
                              "other",
                              "[MS, MS:1000133, CID, ]",
                              "[MS, MS:1000422, HCD, ]",
                              "[MS, MS:1000129, negative scan, ]"))
    ## Repeat polarity
    res <- mtdMsRun(location = c("null", "other"),
                      scan_polarity = c("positive"),
                      fragmentation_method = list(NULL,
                                                  c("[MS, MS:1000133, CID, ]",
                                                    "[MS, MS:1000422, HCD, ]")))
    expect_equal(res[, 1L], c("ms_run[1]-location",
                              "ms_run[1]-scan_polarity[1]",
                              "ms_run[2]-location",
                              "ms_run[2]-fragmentation_method[1]",
                              "ms_run[2]-fragmentation_method[2]",
                              "ms_run[2]-scan_polarity[1]"))
    expect_equal(res[, 2L], c("null",
                              "[MS, MS:1000130, positive scan, ]",
                              "other",
                              "[MS, MS:1000133, CID, ]",
                              "[MS, MS:1000422, HCD, ]",
                              "[MS, MS:1000130, positive scan, ]"))
    ## parameters
    res <- mtdMsRun(location = c("null", "other"),
                      scan_polarity = c("positive", "negative"),
                      parameters = c("[MS, MS:1000031, instrument model, [MS, MS:1000449, LTQ Orbitrap,]]"))
    expect_equal(res[, 1L], c("ms_run[1]-location",
                              "ms_run[1]-scan_polarity[1]",
                              "ms_run[1]-parameter[1]",
                              "ms_run[2]-location",
                              "ms_run[2]-scan_polarity[1]",
                              "ms_run[2]-parameter[1]"))
    expect_equal(res[, 2L], c("null",
        "[MS, MS:1000130, positive scan, ]",
        "[MS, MS:1000031, instrument model, [MS, MS:1000449, LTQ Orbitrap,]]",
        "other",
        "[MS, MS:1000129, negative scan, ]",
        "[MS, MS:1000031, instrument model, [MS, MS:1000449, LTQ Orbitrap,]]"))


    res <- mtdMsRun(location = c("null", "other"),
        scan_polarity = c("positive", "negative"),
        parameters = list(c("[MS, MS:1000031, instrument model, [MS, MS:1000449, LTQ Orbitrap,]]", "[MS, MS:1000031, instrument model, [MS, MS:1000449, LTQ Orbitrap,]]"), NULL))
    expect_equal(res[, 1L], c("ms_run[1]-location",
                              "ms_run[1]-scan_polarity[1]",
                              "ms_run[1]-parameter[1]",
                              "ms_run[1]-parameter[2]",
                              "ms_run[2]-location",
                              "ms_run[2]-scan_polarity[1]"))
    expect_equal(res[, 2L], c("null",
        "[MS, MS:1000130, positive scan, ]",
        "[MS, MS:1000031, instrument model, [MS, MS:1000449, LTQ Orbitrap,]]",
        "[MS, MS:1000031, instrument model, [MS, MS:1000449, LTQ Orbitrap,]]",
        "other",
        "[MS, MS:1000129, negative scan, ]"))

})

test_that("mtdDefineStudyVariables works", {
    expect_equal(mtdDefineStudyVariables(),
                 data.frame(study_variable = character(),
                            study_variable_group = character()))
    x <- data.frame(sex = c("male", "female", "female", "male", "male"),
                    group = c("case", "case", "control", "case", "control"))
    expect_equal(mtdDefineStudyVariables(x),
                 data.frame(study_variable = "undefined",
                            study_variable_group = "undefined"))
    res <- mtdDefineStudyVariables(x, c("sex", "group"))
    expect_equal(res,
                 unique(data.frame(
                     study_variable = c(x$sex, x$group),
                     study_variable_group = rep(colnames(x), each = nrow(x)))))
    res <- mtdDefineStudyVariables(x, c("sex"))
    expect_equal(res, data.frame(study_variable = c("male", "female"),
                                 study_variable_group = "sex"))
})

test_that(".mtd_multi_fields works", {
    res <- .mtd_multi_fields(as.list(c("homo_sapiens", "mus_musculus")),
                             prefix = "sample", suffix = "species")
    expect_equal(res[, 1L], c("sample[1]-species[1]", "sample[2]-species[1]"))
    expect_equal(res[, 2L], c("homo_sapiens", "mus_musculus"))

    res <- .mtd_multi_fields(list(c("mus_musculus", "homo_sapiens"), NULL,
                                  "rattus_norvegicus"),
                             prefix = "sample", suffix = "species")
    expect_equal(res[, 1L], c("sample[1]-species[1]", "sample[1]-species[2]",
                              "sample[3]-species[1]"))
    expect_equal(res[, 2L], c("mus_musculus", "homo_sapiens",
                              "rattus_norvegicus"))
    expect_equal(res[, 3L], c("1", "1", "3"))
})

test_that("mtdSample works", {
    res <- mtdSample(sample = character())
    expect_true(is.matrix(res))
    expect_true(nrow(res) == 0)
    expect_true(ncol(res) == 2)
    res <- mtdSample(sample = c("a", "b", "c"))
    expect_equal(res[, 1L], c("sample[1]", "sample[2]", "sample[3]"))
    expect_equal(res[, 2L], c("a", "b", "c"))

    ## species
    res <- mtdSample(sample = c("a", "b", "c"), species = "b")
    expect_equal(res[, 1L], c("sample[1]", "sample[1]-species[1]",
                              "sample[2]", "sample[2]-species[1]",
                              "sample[3]", "sample[3]-species[1]"))
    expect_equal(res[, 2L], c("a", "b", "b", "b", "c", "b"))
    res <- mtdSample(sample = c("a", "b", "c"),
                      species = list(c("A", "B"), NULL, 3))
    expect_equal(res[, 1L], c("sample[1]", "sample[1]-species[1]",
                              "sample[1]-species[2]", "sample[2]",
                              "sample[3]", "sample[3]-species[1]"))
    expect_equal(res[, 2L], c("a", "A", "B", "b", "c", "3"))
    ## tissue
    res <- mtdSample(sample = c("a", "b", "c"), tissue = "A")
    expect_equal(res[, 1L], c("sample[1]", "sample[1]-tissue[1]",
                              "sample[2]", "sample[2]-tissue[1]",
                              "sample[3]", "sample[3]-tissue[1]"))
    res <- mtdSample(sample = c("a", "b", "c"),
                      tissue = list(c("B"), NULL, 3:5))
    expect_equal(res[, 1L], c("sample[1]", "sample[1]-tissue[1]",
                              "sample[2]", "sample[3]",
                              "sample[3]-tissue[1]", "sample[3]-tissue[2]",
                              "sample[3]-tissue[3]"))
    expect_equal(res[, 2L], c("a", "B", "b", "c", "3", "4", "5"))
    ## cell_type
    res <- mtdSample(sample = c("a", "b", "c"), cell_type = "A")
    expect_equal(res[, 1L], c("sample[1]", "sample[1]-cell_type[1]",
                              "sample[2]", "sample[2]-cell_type[1]",
                              "sample[3]", "sample[3]-cell_type[1]"))
    res <- mtdSample(sample = c("a", "b", "c"),
                      cell_type = list(c("B"), NULL, 3:5))
    expect_equal(res[, 1L], c("sample[1]", "sample[1]-cell_type[1]",
                              "sample[2]", "sample[3]",
                              "sample[3]-cell_type[1]", "sample[3]-cell_type[2]",
                              "sample[3]-cell_type[3]"))
    expect_equal(res[, 2L], c("a", "B", "b", "c", "3", "4", "5"))

    ## disease
    res <- mtdSample(sample = c("a", "b", "c"), disease = "A")
    expect_equal(res[, 1L], c("sample[1]", "sample[1]-disease[1]",
                              "sample[2]", "sample[2]-disease[1]",
                              "sample[3]", "sample[3]-disease[1]"))
    res <- mtdSample(sample = c("a", "b", "c"),
                      disease = list(c("B"), NULL, 3:5))
    expect_equal(res[, 1L], c("sample[1]", "sample[1]-disease[1]",
                              "sample[2]", "sample[3]",
                              "sample[3]-disease[1]", "sample[3]-disease[2]",
                              "sample[3]-disease[3]"))
    expect_equal(res[, 2L], c("a", "B", "b", "c", "3", "4", "5"))

    ## description
    expect_error(mtdSample(sample = c("a", "b", "c"), description = "A"),
                 "length equal to")
    res <- mtdSample(sample = c("a", "b", "c"), description = 1:3)
    expect_equal(res[, 1L], c("sample[1]", "sample[1]-description",
                              "sample[2]", "sample[2]-description",
                              "sample[3]", "sample[3]-description"))
    expect_equal(res[, 2L], c("a", "1", "b", "2", "c", "3"))

    ## ...
    expect_error(mtdSample(sample = c("a", "b", "c"), "A"),
                 "length has to match")
    res <- mtdSample(sample = c("a", "b", "c"), description = 1:3,
                      c("custom 1", "custom 2", "custom 3"),
                      c("other 1", "other 2", "other 3"))
    expect_equal(res[, 1L], c("sample[1]", "sample[1]-description",
                              "sample[1]-custom[1]", "sample[1]-custom[2]",
                              "sample[2]", "sample[2]-description",
                              "sample[2]-custom[1]", "sample[2]-custom[2]",
                              "sample[3]", "sample[3]-description",
                              "sample[3]-custom[1]", "sample[3]-custom[2]"))
    expect_equal(res[, 2L], c("a", "1", "[,,, custom 1]", "[,,, other 1]",
                              "b", "2", "[,,, custom 2]", "[,,, other 2]",
                              "c", "3", "[,,, custom 3]", "[,,, other 3]"))
})

test_that("mtdAssay works", {
    res <- mtdAssay()
    expect_true(is.matrix(res))
    expect_true(is.character(res))
    expect_true(nrow(res) == 0)

    expect_error(mtdAssay(assay = c("first")), "is required")
    expect_error(mtdAssay(assay = c("first", "second"),
                           ms_run_ref = "ms_run[1]"), "have to match")

    res <- mtdAssay(assay = c("a", "b", "c"),
                     ms_run_ref = c("ms_run[1]", "ms_run[1]", "ms_run[2]"))
    expect_equal(
        res[, 1L],
        c("assay[1]", "assay[1]-ms_run_ref",
          "assay[2]", "assay[2]-ms_run_ref",
          "assay[3]", "assay[3]-ms_run_ref"))
    expect_equal(
        res[, 2L],
        c("a", "ms_run[1]",
          "b", "ms_run[1]",
          "c", "ms_run[2]"))

    res <- mtdAssay(assay = c("a", "b", "c"),
                     external_uri = c("B"),
                     ms_run_ref = c("ms_run[1]", "ms_run[1]", "ms_run[2]"))
    expect_equal(
        res[, 1L],
        c("assay[1]", "assay[1]-external_uri", "assay[1]-ms_run_ref",
          "assay[2]", "assay[2]-external_uri", "assay[2]-ms_run_ref",
          "assay[3]", "assay[3]-external_uri", "assay[3]-ms_run_ref"))
    expect_equal(
        res[, 2L],
        c("a", "B", "ms_run[1]",
          "b", "B", "ms_run[1]",
          "c", "B", "ms_run[2]"))

    expect_error(mtdAssay(assay = c("a", "b"),
                           sample_ref = c("sample[1]"),
                           ms_run_ref = c("ms_run[1]", "b")),
                 "has to match")
    res <- mtdAssay(assay = "a", ms_run_ref = "b", sample_ref = "B")
    expect_equal(res[, 1L],
                 c("assay[1]", "assay[1]-sample_ref", "assay[1]-ms_run_ref"))
    expect_equal(res[, 2L], c("a", "B", "b"))

    res <- mtdAssay(assay = c("a", "b"), ms_run_ref = c("1", "2"),
                     a = 1:2, b = 3:4)
    expect_equal(
        res[, 1L],
        c("assay[1]", "assay[1]-ms_run_ref",
          "assay[1]-custom[1]", "assay[1]-custom[2]",
          "assay[2]", "assay[2]-ms_run_ref",
          "assay[2]-custom[1]", "assay[2]-custom[2]"))
    expect_equal(
        res[, 2L],
        c("a", "1", "[,,a, 1]", "[,,b, 3]", "b", "2", "[,,a, 2]", "[,,b, 4]"))

    ## multi assignment assay->ms_run
    expect_error(mtdAssay(assay = c("a", "b"), ms_run_ref = list(1:2, NULL)),
                 "At least one")
    res <- mtdAssay(assay = c("a", "b"), ms_run_ref = list(1:2, 3))
    expect_equal(
        res[, 1L],
        c("assay[1]", "assay[1]-ms_run_ref[1]", "assay[1]-ms_run_ref[2]",
          "assay[2]", "assay[2]-ms_run_ref[1]"))
    expect_equal(res[, 2L], c("a", "1", "2", "b", "3"))

    expect_error(mtdAssay(assay = c("a", "b"),
                          ms_run_ref = c("ms_run[1]", "b"),
                          protocol_ref = c("protocol[1]")),
                 "has to match")
    res <- mtdAssay(assay = "a", ms_run_ref = "b", protocol_ref = "P")
    expect_equal(res[, 1L],
                 c("assay[1]", "assay[1]-ms_run_ref", "assay[1]-protocol_ref"))
    expect_equal(res[, 2L], c("a", "b", "P"))

    ## parameters
    res <- mtdAssay(assay = c("a", "b"),
                    ms_run_ref = c("ms_run[1]", "ms_run[2]"),
                    parameters = c("[MS, MS:1000031, instrument model, [MS, MS:1000449, LTQ Orbitrap,]]"))
    expect_equal(res[, 1L], c("assay[1]",
                              "assay[1]-ms_run_ref",
                              "assay[1]-parameter[1]",
                              "assay[2]",
                              "assay[2]-ms_run_ref",
                              "assay[2]-parameter[1]"))
    expect_equal(res[, 2L], c("a",
        "ms_run[1]",
        "[MS, MS:1000031, instrument model, [MS, MS:1000449, LTQ Orbitrap,]]",
        "b",
        "ms_run[2]",
        "[MS, MS:1000031, instrument model, [MS, MS:1000449, LTQ Orbitrap,]]"))


    res <- mtdAssay(assay = c("a", "b"),
        ms_run_ref = c("ms_run[1]", "ms_run[2]"),
        parameters = list(c("[MS, MS:1000031, instrument model, [MS, MS:1000449, LTQ Orbitrap,]]", "[MS, MS:1000031, instrument model, [MS, MS:1000449, LTQ Orbitrap,]]"), NULL))
    expect_equal(res[, 1L], c("assay[1]",
                              "assay[1]-ms_run_ref",
                              "assay[1]-parameter[1]",
                              "assay[1]-parameter[2]",
                              "assay[2]",
                              "assay[2]-ms_run_ref"))
    expect_equal(res[, 2L], c("a",
        "ms_run[1]",
        "[MS, MS:1000031, instrument model, [MS, MS:1000449, LTQ Orbitrap,]]",
        "[MS, MS:1000031, instrument model, [MS, MS:1000449, LTQ Orbitrap,]]",
        "b",
        "ms_run[2]"))
})

test_that(".mtd_custom_fields works", {
    res <- .mtd_custom_fields()
    expect_true(is.matrix(res))
    expect_true(is.character(res))
    expect_true(nrow(res) == 0)

    expect_error(.mtd_custom_fields(1:3, c("a", "b"), expected_length = 3L),
                 "length has to match the length")

    res <- .mtd_custom_fields(1:3, c("a", "b", "c"), expected_length = 3L)
    expect_equal(
        res[, 1L],
        c("sample[1]-custom[1]", "sample[2]-custom[1]", "sample[3]-custom[1]",
          "sample[1]-custom[2]", "sample[2]-custom[2]", "sample[3]-custom[2]"))
    expect_equal(res[, 2L], c("[,,, 1]", "[,,, 2]", "[,,, 3]",
                              "[,,, a]", "[,,, b]", "[,,, c]"))
    expect_equal(res[, 3L], c("1", "2", "3", "1", "2", "3"))
})

test_that("mtdStudyVariables works", {
    x <- data.frame(
        name = c("I1_0", "I2_0", "I1_6", "I2_6", "I3_0"),
        individual = c("I1", "I2", "I1", "I2", "I3"),
        timepoint = c(0, 6, 0, 6, 0),
        T2D = c(TRUE, FALSE, TRUE, FALSE, FALSE)
    )
    ## errors
    expect_error(mtdStudyVariables(x, groups = c("name", "other")),
                 "Not all column")
    expect_error(mtdStudyVariables(x, groups = c("name", "T2D"),
                                     average_function = c("a", "b", "c")),
                 "equal to the number")
    expect_error(mtdStudyVariables(x, groups = c("name", "T2D"),
                                     variation_function = c("a", "b", "c")),
                 "equal to the number")
    expect_error(mtdStudyVariables(x, groups = c("name", "T2D"),
                                     description = c("a", "b", "c")),
                 "equal to the number")
    expect_error(mtdStudyVariables(x, average_function = character(),
                                     variation_function = "B"),
                 "'average_function'")
    expect_error(mtdStudyVariables(x, average_function = "A",
                                     variation_function = NULL),
                 "'variation_function'")
    expect_error(mtdStudyVariables(x, groups = c("T2D", "timepoint"),
                                     average_function = "A",
                                     variation_function = "B",
                                     description = 1:2), "'description'")
    expect_error(mtdStudyVariables(x, groups = colnames(x), group_unit = "a"),
                 "match the number")
    expect_error(mtdStudyVariables(x, groups = c("T2D", "timepoint"),
                                     group_unit = c(NA, "[a,b,c,d,e]")),
                 "not a CV parameter")
    ## Without study variable groups
    res <- mtdStudyVariables(x)
    expect_equal(res[res[, 1L] == "study_variable_group[1]", 2L],
                 "[,,undefined,]")
    expect_equal(res[res[, 1L] == "study_variable[1]", 2L], "undefined")
    expect_false(any(res[, 1L] == "study_variable_group[2]"))
    expect_false(any(res[, 1L] == "study_variable[2]"))
    expect_equal(res[res[, 1L] == "study_variable[1]-assay_refs", 2L],
                 "assay[1]|assay[2]|assay[3]|assay[4]|assay[5]")
    ## With a single study variable group
    res <- mtdStudyVariables(x, groups = "T2D", group_datatype = "xsd:string")
    expect_false(any(res[, 1L] == "study_variable_group[2]"))
    expect_equal(res[res[, 1L] == "study_variable_group[1]", 2L], "[,,T2D,]")
    expect_match(res[res[, 1L] == "study_variable_group[1]-type", 2L], "cate")
    expect_equal(res[res[, 1L] == "study_variable_group[1]-datatype", 2L],
                 "xsd:string")
    expect_equal(res[res[, 1L] == "study_variable[1]", 2L], "TRUE")
    expect_equal(res[, 1L],
                 c("study_variable_group[1]",
                   "study_variable_group[1]-description",
                   "study_variable_group[1]-type",
                   "study_variable_group[1]-datatype",
                   "study_variable_group[1]-study_variable_ref",
                   "study_variable[1]",
                   "study_variable[1]-assay_refs",
                   "study_variable[1]-average_function",
                   "study_variable[1]-variation_function",
                   "study_variable[1]-description",
                   "study_variable[2]",
                   "study_variable[2]-assay_refs",
                   "study_variable[2]-average_function",
                   "study_variable[2]-variation_function",
                   "study_variable[2]-description"
                   ))
    expect_equal(res[, 2L],
                 c("[,,T2D,]",
                   "Sample matrix column T2D",
                   "[STATO, STATO:0000252, categorical variable, ]",
                   "xsd:string",
                   "study_variable[1]|study_variable[2]",
                   "TRUE",
                   "assay[1]|assay[3]",
                   "[MS, MS:1002962, mean, ]",
                   "[MS, MS:1002963, variation coefficient, ]",
                   "Variable T2D, value TRUE",
                   "FALSE",
                   "assay[2]|assay[4]|assay[5]",
                   "[MS, MS:1002962, mean, ]",
                   "[MS, MS:1002963, variation coefficient, ]",
                   "Variable T2D, value FALSE"
                   ))
    ## Two groups and providing group_unit
    res <- mtdStudyVariables(x, groups = c("T2D", "timepoint"),
                               group_unit = c("", "[,,hours,]"))
    expect_equal(res[, 1L],
                 c("study_variable_group[1]",
                   "study_variable_group[1]-description",
                   "study_variable_group[1]-type",
                   "study_variable_group[1]-datatype",
                   "study_variable_group[1]-study_variable_ref",
                   "study_variable_group[2]",
                   "study_variable_group[2]-description",
                   "study_variable_group[2]-type",
                   "study_variable_group[2]-datatype",
                   "study_variable_group[2]-unit",
                   "study_variable_group[2]-study_variable_ref",
                   "study_variable[1]",
                   "study_variable[1]-assay_refs",
                   "study_variable[1]-average_function",
                   "study_variable[1]-variation_function",
                   "study_variable[1]-description",
                   "study_variable[2]",
                   "study_variable[2]-assay_refs",
                   "study_variable[2]-average_function",
                   "study_variable[2]-variation_function",
                   "study_variable[2]-description",
                   "study_variable[3]",
                   "study_variable[3]-assay_refs",
                   "study_variable[3]-average_function",
                   "study_variable[3]-variation_function",
                   "study_variable[3]-description",
                   "study_variable[4]",
                   "study_variable[4]-assay_refs",
                   "study_variable[4]-average_function",
                   "study_variable[4]-variation_function",
                   "study_variable[4]-description"
                   ))
    expect_equal(res[, 2L],
                 c("[,,T2D,]",
                   "Sample matrix column T2D",
                   "[STATO, STATO:0000252, categorical variable, ]",
                   "xsd:boolean",
                   "study_variable[1]|study_variable[2]",
                   "[,,timepoint,]",
                   "Sample matrix column timepoint",
                   "[STATO, STATO:0000251, continuous variable, ]",
                   "xsd:decimal",
                   "[,,hours,]",
                   "study_variable[3]|study_variable[4]",
                   "TRUE",
                   "assay[1]|assay[3]",
                   "[MS, MS:1002962, mean, ]",
                   "[MS, MS:1002963, variation coefficient, ]",
                   "Variable T2D, value TRUE",
                   "FALSE",
                   "assay[2]|assay[4]|assay[5]",
                   "[MS, MS:1002962, mean, ]",
                   "[MS, MS:1002963, variation coefficient, ]",
                   "Variable T2D, value FALSE",
                   "0",
                   "assay[1]|assay[3]|assay[5]",
                   "[MS, MS:1002962, mean, ]",
                   "[MS, MS:1002963, variation coefficient, ]",
                   "Variable timepoint, value 0",
                   "6",
                   "assay[2]|assay[4]",
                   "[MS, MS:1002962, mean, ]",
                   "[MS, MS:1002963, variation coefficient, ]",
                   "Variable timepoint, value 6"
                   ))
    ## No study variable group, full result
    res <- mtdStudyVariables(x, average_function = "A",
                               variation_function = "B")
    expect_equal(res[, 1L], c("study_variable_group[1]",
                              "study_variable_group[1]-description",
                              "study_variable_group[1]-type",
                              "study_variable_group[1]-datatype",
                              "study_variable_group[1]-study_variable_ref",
                              "study_variable[1]",
                              "study_variable[1]-assay_refs",
                              "study_variable[1]-average_function",
                              "study_variable[1]-variation_function",
                              "study_variable[1]-description"))
    expect_equal(res[, 2L], c("[,,undefined,]",
                            "Sample matrix column undefined",
                            "[STATO, STATO:0000252, categorical variable, ]",
                            "xsd:string",
                            "study_variable[1]",
                            "undefined",
                            "assay[1]|assay[2]|assay[3]|assay[4]|assay[5]",
                            "A",
                            "B",
                            "Variable undefined, value undefined"))

    res <- mtdStudyVariables(x, groups = c("T2D", "timepoint", "individual"))
    expect_equal(res[res[, 1L] == "study_variable_group[1]", 2L], "[,,T2D,]")
    expect_equal(res[res[, 1L] == "study_variable_group[2]", 2L],
                 "[,,timepoint,]")
    expect_equal(res[res[, 1L] == "study_variable_group[3]", 2L],
                 "[,,individual,]")
    expect_match(res[res[, 1L] == "study_variable_group[1]-type", 2L], "cate")
    expect_match(res[res[, 1L] == "study_variable_group[2]-type", 2L], "conti")
    expect_match(res[res[, 1L] == "study_variable_group[3]-type", 2L], "cate")
    expect_equal(res[res[, 1L] == "study_variable_group[1]-study_variable_ref",
                     2L],
                 "study_variable[1]|study_variable[2]")
    expect_equal(res[res[, 1L] == "study_variable_group[2]-study_variable_ref",
                    2L],
                 "study_variable[3]|study_variable[4]")
    expect_equal(res[res[, 1L] == "study_variable_group[3]-study_variable_ref",
                     2L],
                 "study_variable[5]|study_variable[6]|study_variable[7]")
    expect_equal(res[res[, 1L] == "study_variable[1]", 2L], "TRUE")
    expect_equal(res[res[, 1L] == "study_variable[2]", 2L], "FALSE")
    expect_equal(res[res[, 1L] == "study_variable[1]-assay_refs", 2L],
                 "assay[1]|assay[3]")
    expect_equal(res[res[, 1L] == "study_variable[2]-assay_refs", 2L],
                 "assay[2]|assay[4]|assay[5]")

    expect_equal(res[res[, 1L] == "study_variable[3]", 2L], "0")
    expect_equal(res[res[, 1L] == "study_variable[4]", 2L], "6")
    expect_equal(res[res[, 1L] == "study_variable[3]-assay_refs", 2L],
                 "assay[1]|assay[3]|assay[5]")
    expect_equal(res[res[, 1L] == "study_variable[4]-assay_refs", 2L],
                 "assay[2]|assay[4]")

    expect_equal(res[res[, 1L] == "study_variable[5]", 2L], "I1")
    expect_equal(res[res[, 1L] == "study_variable[6]", 2L], "I2")
    expect_equal(res[res[, 1L] == "study_variable[7]", 2L], "I3")
    expect_equal(res[res[, 1L] == "study_variable[5]-assay_refs", 2L],
                 "assay[1]|assay[3]")
    expect_equal(res[res[, 1L] == "study_variable[6]-assay_refs", 2L],
                 "assay[2]|assay[4]")
    expect_equal(res[res[, 1L] == "study_variable[7]-assay_refs", 2L],
                 "assay[5]")

    ## NA values in input:
    x <- data.frame(a = c("a", "b", NA, "d"), time = c(NA, 0, 6, NA))
    res <- mtdStudyVariables(x, groups = c("a", "time"))
    expect_equal(unname(getMtdField(res, "study_variable\\[3\\]$")),
                 NA_character_)
    expect_equal(unname(getMtdField(res, "study_variable\\[3\\]-assay_refs")),
                 "assay[3]")
    expect_equal(unname(getMtdField(res, "study_variable\\[5\\]$")),
                 NA_character_)
    expect_equal(unname(getMtdField(res, "study_variable\\[5\\]-assay_refs")),
                 "assay[1]|assay[4]")
})

test_that(".mtd_get_field works", {
    x <- cbind(
        c("instrument[1]-name",
          "instrument[1]-source",
          "instrument[2]-name",
          "instrument[2]-source",
          "sample[1]",
          "sample[1]-species[1]",
          "sample[2]",
          "sample[2]-species[1]"),
        c("1", "2", "3", "4", "5", "6", "7", "8"))
    res <- .mtd_get_field(x, "other")
    expect_true(is.list(res))
    expect_equal(names(res), "other")
    expect_true(is.na(res[[1L]]))
    res <- .mtd_get_field(x, "instrument[2]", exact = TRUE)
    expect_true(is.list(res))
    expect_equal(names(res), "instrument[2]")
    expect_true(is.na(res[[1L]]))
    res <- .mtd_get_field(x, "instrument[2]", exact = FALSE)
    expect_true(is.list(res))
    expect_equal(names(res), "instrument[2]")
    expect_equal(res[[1L]], c(`instrument[2]-name` = "3",
                              `instrument[2]-source` = "4"))
    res <- .mtd_get_field(
        x, c("instrument[2]", "other", "instrument[1]-name"), exact = FALSE)
    expect_true(is.list(res))
    expect_equal(names(res), c("instrument[2]", "other", "instrument[1]-name"))
    expect_equal(res[[1L]], c(`instrument[2]-name` = "3",
                              `instrument[2]-source` = "4"))
    expect_equal(res[[2L]], NA_character_)
    expect_equal(res[[3L]], c(`instrument[1]-name` = "1"))
    res <- .mtd_get_field(
        x, c("instrument[2]", "other", "instrument[1]-name"), exact = TRUE)
    expect_true(is.list(res))
    expect_equal(names(res), c("instrument[2]", "other", "instrument[1]-name"))
    expect_equal(res[[1L]], NA_character_)
    expect_equal(res[[2L]], NA_character_)
    expect_equal(res[[3L]], c(`instrument[1]-name` = "1"))

    ## fixed = FALSE
    res <- .mtd_get_field(x, c("instrument[2]"), fixed = FALSE, exact = FALSE)
    expect_equal(res[[1L]], NA_character_)
    res <- .mtd_get_field(x, c("instrument\\[\\d.*\\]-name"),
                          fixed = FALSE, exact = FALSE)
    expect_equal(res[[1L]], c(`instrument[1]-name` = "1",
                              `instrument[2]-name` = "3"))
})

test_that(".mtd_parameters_fields works", {
    res <- .mtd_parameters_fields("assay", c("parameter1"), 2)
    expect_equal(res[, 1L], c("assay[1]-parameter[1]", "assay[2]-parameter[1]"))
    expect_equal(res[, 2L], c("parameter1", "parameter1"))

    res <- .mtd_parameters_fields("ms_run", c("parameter1", "parameter2"), 2)
    expect_equal(res[, 1L],
                 c("ms_run[1]-parameter[1]", "ms_run[2]-parameter[1]"))
    expect_equal(res[, 2L], c("parameter1", "parameter2"))

    res <- .mtd_parameters_fields("ms_run",
                                  list(c("parameter1", "parameter2"), NULL), 2)
    expect_equal(res[, 1L],
                 c("ms_run[1]-parameter[1]", "ms_run[1]-parameter[2]"))
    expect_equal(res[, 2L], c("parameter1", "parameter2"))

})

test_that(".mtd_svar_group_description works", {
    x <- data.frame(a = 1:3, b = "b")
    res <- .mtd_svar_group_description(x)
    expect_equal(res, c("Sample matrix column a", "Sample matrix column b"))
    expect_error(.mtd_svar_group_description(x, c("b")), "match length")
    expect_equal(.mtd_svar_group_description(x, c("b", "d")), c("b", "d"))
})

test_that(".mtd_svar_group_type works", {
    x <- data.frame(sex = factor(c("M", "F", "M")),
                    age = c(54.2, 24.1, 43.1),
                    CKM = c(1L, 1L, 2L))
    expect_error(.mtd_svar_group_type(x, c("[a]", "[b]")), "match the number")
    expect_error(
        .mtd_svar_group_type(
            x, c("[a]","[b]","[STATO, STATO:0000252, categorical variable, ]")),
        "not supported")
    res <- .mtd_svar_group_type(x)
    expect_equal(res, c("[STATO, STATO:0000252, categorical variable, ]",
                        "[STATO, STATO:0000251, continuous variable, ]",
                        "[STATO, STATO:0000251, continuous variable, ]"))

    res <- .mtd_svar_group_type(x, c("[, STATO:0000252, , ]",
                                     "[, STATO:0000251,, ]",
                                     "[, STATO:0000228,, ]"))
    expect_equal(res, c("[STATO, STATO:0000252, categorical variable, ]",
                        "[STATO, STATO:0000251, continuous variable, ]",
                        "[STATO, STATO:0000228, ordinal variable, ]"))
})

test_that(".mtd_svar_group_datatype works", {
    x <- data.frame(sex = factor(c("M", "F", "M")),
                    age = c(54.2, 24.1, 43.1),
                    CKM = c(1L, 1L, 2L),
                    name = c("a", "b", "c"))
    expect_error(.mtd_svar_group_datatype(x, c("a", "b")), "match the number")
    expect_error(.mtd_svar_group_datatype(x, c("a", "b", "c", "d")),
                 "not supported")
    res <- .mtd_svar_group_datatype(x, c("xsd:string", "xsd:decimal",
                                         "xsd:integer", "xsd:string"))
    expect_equal(res, c("xsd:string", "xsd:decimal","xsd:integer","xsd:string"))
    res <- .mtd_svar_group_datatype(x)
    expect_equal(res, c("xsd:string", "xsd:decimal","xsd:integer","xsd:string"))

    x$cv <- c("[a,b,c,d]", NA, "[a,b, c, d]")
    res <- .mtd_svar_group_datatype(x, c("xsd:string", "xsd:decimal",
                                         "xsd:integer", "xsd:string",
                                         "Parameter"))
    expect_equal(res, c("xsd:string", "xsd:decimal","xsd:integer",
                        "xsd:string", "Parameter"))
    res <- .mtd_svar_group_datatype(x)
    expect_equal(res, c("xsd:string", "xsd:decimal","xsd:integer",
                        "xsd:string", "Parameter"))
})

test_that(".mztab_study_variables works", {
    x <- data.frame(T2D = c(TRUE, FALSE, FALSE), BMI = c(43.1, 32.1, 31.3),
                    name = c("a", "b", "c"))
    res <- .mztab_study_variables(x)
    expect_true(is.data.frame(res))
    expect_true(is.character(res[, 1L]))
    expect_true(is.character(res[, 2L]))
    expect_equal(colnames(res), c("study_variable", "study_variable_group"))
    res <- .mztab_study_variables(x, c("T2D", "BMI"))
    expect_true(is.data.frame(res))
    expect_true(is.character(res[, 1L]))
    expect_true(is.character(res[, 2L]))
    expect_equal(colnames(res), c("study_variable", "study_variable_group"))
    expect_equal(res$study_variable,c(as.character(x$T2D), as.character(x$BMI)))
    expect_equal(res$study_variable_group, rep(c("T2D", "BMI"), each = 3))
})

test_that(".mtd_svar_group_unit works", {
    x <- data.frame(T2D = c(TRUE, FALSE, FALSE), BMI = c(43.1, 32.1, 31.3),
                    name = c("a", "b", "c"))
    expect_equal(.mtd_svar_group_unit(x), c("", "", ""))
    expect_equal(.mtd_svar_group_unit(x, c("", NA, "")), c("", "", ""))
    expect_equal(.mtd_svar_group_unit(x, c("[a ,b,c,d]", NA, "")),
                 c("[a ,b,c,d]", "", ""))
    expect_error(.mtd_svar_group_unit(x, c("a", "", "")), "not a CV")
    expect_error(.mtd_svar_group_unit(x, c("a", "")), "has to match")
})

test_that("setMtdInstrument works", {
    x <- matrix()
    res <- setMtdInstrument(x)
    expect_equal(res, x)

    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    res <- setMtdInstrument(x, name = "[MS, MS:1000449, LTQ Orbitrap,]",
        source = "[MS, MS:1000073, ESI,]",
        analyzer = c(`analyzer[1]` = "[MS, MS:1000291, linear ion trap,]"),
        detector = "[MS, MS:1000253, electron multiplier,]"
    )
    expect_true(any(grepl("instrument\\[1\\]-name", res[, 1])))
    expect_true(any(grepl("instrument\\[1\\]-source", res[, 1])))
    expect_true(any(grepl("instrument\\[1\\]-analyzer\\[1\\]", res[, 1])))
    expect_true(any(grepl("instrument\\[1\\]-detector", res[, 1])))
    expect_true(any(grepl("[MS, MS:1000449, LTQ Orbitrap,]", res[, 2])))
    expect_true(any(grepl("[MS, MS:1000073, ESI,]", res[, 2])))
    expect_true(any(grepl("[MS, MS:1000291, linear ion trap,]", res[, 2])))
    expect_true(any(grepl("[MS, MS:1000253, electron multiplier,]", res[, 2])))

    ## Missing paramenters
    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    expect_error(setMtdInstrument(x), "name")
    expect_error(setMtdInstrument(x, name = "[MS, MS:1000449, LTQ Orbitrap,]"),
        "source"
    )
    expect_error(setMtdInstrument(x, name = "[MS, MS:1000449, LTQ Orbitrap,]",
                               source = "[MS, MS:1000073, ESI,]"),
                 "analyzer"
    )
    expect_error(setMtdInstrument(x, name = "[MS, MS:1000449, LTQ Orbitrap,]",
            source = "[MS, MS:1000073, ESI,]",
            analyzer = c(`analyzer[1]` = "[MS, MS:1000291, linear ion trap,]")),
        "detector"
    )

    ## Append instrument
    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    mtd <- setMtdInstrument(x, name = "[MS, MS:1000449, LTQ Orbitrap,]",
        source = "[MS, MS:1000073, ESI,]",
        analyzer = c(`analyzer[1]` = "[MS, MS:1000291, linear ion trap,]"),
        detector = "[MS, MS:1000253, electron multiplier,]"
    )
    mtd2 <- setMtdInstrument(mtd, name = "[MS, MS:1000031, instrument model,]",
        source = "[MS, MS:1000008, ionization type,]",
        analyzer = c(`analyzer[1]` = "[MS, MS:1000291, linear ion trap,]"),
        detector = "[MS, MS:1000253, electron multiplier,]",
        replace = FALSE
    )
    name_rows <- mtd2[grepl("instrument.*name", mtd2[, 1]), , drop = FALSE]
    expect_equal(nrow(name_rows), 2L)

    ## Replace instrument
    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    mtd <- setMtdInstrument(x, name = "[MS, MS:1000449, LTQ Orbitrap,]",
        source = "[MS, MS:1000073, ESI,]",
        analyzer = c(`analyzer[1]` = "[MS, MS:1000291, linear ion trap,]"),
        detector = "[MS, MS:1000253, electron multiplier,]"
    )
    mtd2 <- setMtdInstrument(mtd, name = "[MS, MS:1000031, instrument model,]",
        source = "[MS, MS:1000008, ionization type,]",
        analyzer = c(`analyzer[1]` = "[MS, MS:1000291, linear ion trap,]"),
        detector = "[MS, MS:1000253, electron multiplier,]",
        replace = TRUE
    )
    name_rows <- mtd2[grepl("instrument.*name", mtd2[, 1]), , drop = FALSE]
    expect_equal(nrow(name_rows), 1L)
    expect_equal(mtd2[grepl("instrument.*name", mtd2[, 1]), 2],
                 "[MS, MS:1000031, instrument model,]")
})

test_that("getMtdInstrument works", {
    res <- getMtdInstrument()
    expect_true(is.na(res))

    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    res <- getMtdInstrument(x)
    expect_true(is.na(res))

    x <- setMtdInstrument(x, name = "[MS, MS:1000449, LTQ Orbitrap,]",
        source = "[MS, MS:1000073, ESI,]",
        analyzer = c(`analyzer[1]` = "[MS, MS:1000291, linear ion trap,]"),
        detector = "[MS, MS:1000253, electron multiplier,]"
    )
    res <- getMtdInstrument(x)
    expect_equal(length(res), 4)
    expect_equal(res[["instrument[1]-name"]], "[MS, MS:1000449, LTQ Orbitrap,]")
    expect_equal(res[["instrument[1]-source"]], "[MS, MS:1000073, ESI,]")
    expect_equal(res[["instrument[1]-detector"]],
                 "[MS, MS:1000253, electron multiplier,]")
    expect_equal(res[["instrument[1]-analyzer[1]"]],
                 "[MS, MS:1000291, linear ion trap,]")
})

test_that("setMtdDatabase works", {
    x <- matrix()
    res <- setMtdDatabase(x)
    expect_equal(res, x)

    ##setMtdDatabase errors when parameter is missing
    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    expect_error(setMtdDatabase(x), "name")
    expect_error(setMtdDatabase(x, name = "[MIRIAM, MIR:00100079, HMDB, ]"),
                 "prefix")
    expect_error(setMtdDatabase(x, name = "[MIRIAM, MIR:00100079, HMDB, ]",
                             prefix = "hmdb"),
                 "version")
    expect_error(setMtdDatabase(x, name = "[MIRIAM, MIR:00100079, HMDB, ]",
                             prefix = "hmdb", version = "3.6"),
                 "uri")

    ##setMtdDatabase adds database metadata fields to a valid MTD section
    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    res <- setMtdDatabase(x, name = "[MIRIAM, MIR:00100079, HMDB, ]",
                        prefix = "hmdb", version = "3.6",
                        uri = "http://www.hmdb.ca/")
    expect_true(any(grepl("database\\[1\\]", res[, 1])))
    expect_true(any(grepl("database\\[1\\]-prefix", res[, 1])))
    expect_true(any(grepl("database\\[1\\]-version", res[, 1])))
    expect_true(any(grepl("database\\[1\\]-uri", res[, 1])))
    expect_true(any(grepl("[MIRIAM, MIR:00100079, HMDB, ]", res[, 2])))
    expect_true(any(grepl("hmdb", res[, 2])))
    expect_true(any(grepl("3.6", res[, 2])))
    expect_true(any(grepl("http://www.hmdb.ca/", res[, 2])))

    ##setMtdDatabase appends new database metadata when replace = FALSE
    mtd2 <- setMtdDatabase(res, name = "[MIRIAM, MIR:00100030, ChEBI, ]",
                        prefix = "chebi", version = "2023",
                        uri = "https://www.ebi.ac.uk/chebi/", replace = FALSE)
    name_rows <- mtd2[grepl("database\\[\\d+\\]$", mtd2[, 1]), , drop = FALSE]
    expect_equal(nrow(name_rows), 2L)

    ##setMtdDatabase replaces existing database metadata when replace = TRUE
    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    mtd <- setMtdDatabase(x, name = "[MIRIAM, MIR:00100079, HMDB, ]",
                        prefix = "hmdb", version = "3.6",
                        uri = "http://www.hmdb.ca/")
    mtd2 <- setMtdDatabase(mtd, name = "[MIRIAM, MIR:00100030, ChEBI, ]",
                        prefix = "chebi", version = "2023",
                        uri = "https://www.ebi.ac.uk/chebi/", replace = TRUE)
    name_rows <- mtd2[grepl("database\\[\\d+\\]$", mtd2[, 1]), , drop = FALSE]
    expect_equal(nrow(name_rows), 1L)
    expect_equal(mtd2[grepl("database\\[\\d+\\]$", mtd2[, 1]), 2],
                 "[MIRIAM, MIR:00100030, ChEBI, ]")
})

test_that("getMtdDatabase works", {
    res <- getMtdDatabase()
    expect_true(is.na(res))

    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    res <- getMtdDatabase(x)
    expect_equal(length(res), 4)
    expect_equal(res[["database[1]"]], "[,, \"no database\", null ]")
    expect_equal(res[["database[1]-prefix"]], "null")
    expect_equal(res[["database[1]-version"]], "Unknown")
    expect_equal(res[["database[1]-uri"]], "null")

    x <- setMtdDatabase(x, name = "[MIRIAM, MIR:00100079, HMDB, ]",
                        prefix = "hmdb", version = "3.6",
                        uri = "http://www.hmdb.ca/")
    res <- getMtdDatabase(x)
    expect_equal(length(res), 4)
    expect_equal(res[["database[1]"]], "[MIRIAM, MIR:00100079, HMDB, ]")
    expect_equal(res[["database[1]-prefix"]], "hmdb")
    expect_equal(res[["database[1]-version"]], "3.6")
    expect_equal(res[["database[1]-uri"]], "http://www.hmdb.ca/")
})

test_that("setMtdCv works", {
    x <- matrix()
    res <- setMtdCv(x)
    expect_equal(res, x)

    ##setMtdCv errors when parametr is missing
    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    expect_error(setMtdCv(x), "label")
    expect_error(setMtdCv(x, label = "MS"), "full_name")
    expect_error(setMtdCv(x, label = "MS",
                       full_name = "PSI-MS controlled vocabulary"),
                 "version")
    expect_error(setMtdCv(x, label = "MS",
                       full_name = "PSI-MS controlled vocabulary",
                       version = "4.1.11"),
                 "uri")

    ##setMtdCv adds CV metadata fields to a valid MTD section when replace = FALSE
    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    result <- setMtdCv(x, label = "MS",
                    full_name = "PSI-MS controlled vocabulary",
                    version = "4.1.11",
                    uri = "https://purl.obolibrary.org/obo/ms.obo",
                    replace = FALSE)
    expect_true(any(grepl("cv\\[1\\]-label", result[, 1])))
    expect_true(any(grepl("cv\\[1\\]-full_name", result[, 1])))
    expect_true(any(grepl("cv\\[1\\]-version", result[, 1])))
    expect_true(any(grepl("cv\\[1\\]-uri", result[, 1])))
    expect_true(any(grepl("MS", result[, 2])))
    expect_true(any(grepl("PSI-MS controlled vocabulary", result[, 2])))
    expect_true(any(grepl("4.1.11", result[, 2])))
    expect_true(any(grepl("https://purl.obolibrary.org/obo/ms.obo",
                          result[, 2])))
    label_rows <- result[grepl("cv.*label$", result[, 1]), , drop = FALSE]
    expect_equal(nrow(label_rows), 4L)

    ##setMtdCv replaces existing CV metadata when replace = TRUE
    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    mtd <- setMtdCv(x, label = "MS", full_name = "PSI-MS controlled vocabulary",
                 version = "4.1.11",
                 uri = "https://purl.obolibrary.org/obo/ms.obo",
                 replace = TRUE)
    label_rows <- mtd[grepl("cv.*label$", mtd[, 1]), , drop = FALSE]
    expect_equal(nrow(label_rows), 1L)
    expect_equal(mtd[grepl("cv.*label$", mtd[, 1]), 2], "MS")
})

test_that("getMtdCv works", {
    res <- getMtdCv()
    expect_true(is.na(res))

    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    res <- getMtdCv(x)
    expect_equal(length(res), 12)
    expect_equal(res[["cv[1]-label"]], "MS")
    expect_equal(res[["cv[1]-full_name"]], "PSI-MS controlled vocabulary")
    expect_equal(res[["cv[1]-version"]], "4.1.138")
    expect_equal(res[["cv[1]-uri"]],
       "https://raw.githubusercontent.com/HUPO-PSI/psi-ms-CV/master/psi-ms.obo")

    x <- setMtdCv(x, label = "MS", full_name = "PSI-MS controlled vocabulary",
                 version = "4.1.11",
                 uri = "https://purl.obolibrary.org/obo/ms.obo",
                 replace = TRUE)
    res <- getMtdCv(x)
    expect_equal(length(res), 4)
    expect_equal(res[["cv[1]-label"]], "MS")
    expect_equal(res[["cv[1]-full_name"]], "PSI-MS controlled vocabulary")
    expect_equal(res[["cv[1]-version"]], "4.1.11")
    expect_equal(res[["cv[1]-uri"]], "https://purl.obolibrary.org/obo/ms.obo")
})

test_that("setMtdContact works", {
    x <- matrix()
    result <- setMtdContact(x)
    expect_equal(result, x)

    ## setMtdContact errors when parameter is missing
    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    expect_error(setMtdContact(x), "name")
    expect_error(setMtdContact(x, name = "Name Surname"), "affiliation")
    expect_error(setMtdContact(x, name = "Name Surname",
                               affiliation = "PSI-MS"),
                 "email")
    expect_error(setMtdContact(x, name = "Name Surname", affiliation = "PSI-MS",
                             email = "name.surname@mail.com"), "orcid")
    expect_error(setMtdContact(x, name = "Name Surname", affiliation = "PSI-MS",
                             email = "name.surname@mail.com",
                             orcid = "error_orcid"), "\"orcid\" is not valid")

    ## setMtdContact adds contact metadata fields to a valid MTD section
    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    result <- setMtdContact(x, name = "Name Surname", affiliation = "PSI-MS",
                         email = "name.surname@mail.com",
                         orcid = "0000-0001-2345-6789")
    expect_true(any(grepl("contact\\[1\\]-name", result[, 1])))
    expect_true(any(grepl("contact\\[1\\]-affiliation", result[, 1])))
    expect_true(any(grepl("contact\\[1\\]-email", result[, 1])))
    expect_true(any(grepl("Name Surname", result[, 2])))
    expect_true(any(grepl("PSI-MS", result[, 2])))
    expect_true(any(grepl("name.surname@mail.com", result[, 2])))
    expect_true(any(grepl("0000-0001-2345-6789", result[, 2])))

    ## setMtdContact appends new contact metadata when replace = FALSE
    mtd2 <- setMtdContact(result, name = "Person 2", affiliation = "Lab B",
        email = "person2@mail.com", orcid = "0000-0001-2345-6789",
        replace = FALSE)
    name_rows <- mtd2[grepl("contact.*name$", mtd2[, 1]), , drop = FALSE]
    expect_equal(nrow(name_rows), 2L)

    ## setMtdContact replaces existing contact metadata when replace = TRUE
    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    mtd <- setMtdContact(x, name = "Name Surname", affiliation = "PSI-MS",
                        email = "name.surname@mail.com",
                        orcid = "0000-0001-2345-6789")
    mtd2 <- setMtdContact(mtd, name = "Person 2", affiliation = "Lab B",
                    email = "person2@mail.com", orcid = "0000-0001-2345-678X",
                    replace = TRUE)
    name_rows <- mtd2[grepl("contact.*name$", mtd2[, 1]), , drop = FALSE]
    expect_equal(nrow(name_rows), 1L)
    expect_equal(mtd2[grepl("contact.*name$", mtd2[, 1]), 2], "Person 2")
})

test_that("getMtdContact works", {
    res <- getMtdContact()
    expect_true(is.na(res))

    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    res <- getMtdContact(x)
    expect_true(is.na(res))

    x <- setMtdContact(x, name = "Name Surname", affiliation = "PSI-MS",
                      email = "name.surname@mail.com",
                      orcid = "0000-0001-2345-6789")
    res <- getMtdContact(x)
    expect_equal(length(res), 4)
    expect_equal(res[["contact[1]-name"]], "Name Surname")
    expect_equal(res[["contact[1]-affiliation"]], "PSI-MS")
    expect_equal(res[["contact[1]-email"]], "name.surname@mail.com")
    expect_equal(res[["contact[1]-orcid"]], "0000-0001-2345-6789")
})

test_that("setMtdProtocol works", {
    x <- matrix()
    result <- setMtdProtocol(x)
    expect_equal(result, x)

    ## setMtdProtocol errors when parameter is missing
    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    expect_error(setMtdProtocol(x), "name")
    expect_error(setMtdProtocol(x, name = "Mass Spectrometry"), "type")
    expect_error(setMtdProtocol(x, name = "Mass Spectrometry",
                    type = c("[CHMO, CHMO:0000470, mass spectrometry, ]")),
                 "description")
    expect_error(setMtdProtocol(x, name = "Mass Spectrometry",
                    type = c("[CHMO, CHMO:0000470, mass spectrometry, ]"),
                    description = c("Eluting compounds were detected ...")),
                    "parameters")
    expect_error(setMtdProtocol(x, name = "Mass Spectrometry",
                    type = c("not_CV"),
                    description = c("Eluting compounds were detected ..."),
                    parameters = c("[MS, MS:1000008, ionization type, [MS,MS:1000073, electrospray ionization, ]]")), "valid CV")

    ## setMtdProtocol adds contact metadata fields to a valid MTD section
    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    result <- setMtdProtocol(x, name = "Mass Spectrometry",
                    type = c("[CHMO, CHMO:0000470, mass spectrometry, ]"),
                    description = c("Eluting compounds were detected ..."),
                    parameters = c("[MS, MS:1000008, ionization type, [MS,MS:1000073, electrospray ionization, ]]"))
    expect_true(any(grepl("protocol\\[1\\]-name", result[, 1])))
    expect_true(any(grepl("protocol\\[1\\]-type", result[, 1])))
    expect_true(any(grepl("protocol\\[1\\]-description", result[, 1])))
    expect_true(any(grepl("protocol\\[1\\]-parameter\\[1\\]", result[, 1])))
    expect_true(any(grepl("Mass Spectrometry", result[, 2])))
    expect_true(any(grepl("[CHMO, CHMO:0000470, mass spectrometry, ]",
                          result[, 2])))
    expect_true(any(grepl("Eluting compounds were detected ...", result[, 2])))
    expect_true(any(grepl("[MS, MS:1000008, ionization type, [MS,MS:1000073, electrospray ionization, ]]",
                          result[, 2])))

    ## setMtdProtocol appends new contact metadata when replace = FALSE
    mtd2 <- setMtdProtocol(result, name = c("extraction"),
             type = c("[MSIO, MSIO:0000141, metabolite extraction,]"),
             description = c("Extraction using 80% methanol"),
             parameters = list("[MSIO, MSIO:0000107, quenching, [MSIO, MSIO:0000109, liquid nitrogen,]]"),
             replace = FALSE)
    name_rows <- mtd2[grepl("protocol.*name$", mtd2[, 1]), , drop = FALSE]
    expect_equal(nrow(name_rows), 2L)

    ## setMtdProtocol replaces existing contact metadata when replace = TRUE
    mtd3 <- setMtdProtocol(mtd2, name = "Test replace",
             type = "[, , null, null]",
             description = "Test description",
             parameters = "[ , , null, null]", replace = TRUE)
    name_rows <- mtd3[grepl("protocol.*name$", mtd3[, 1]), , drop = FALSE]
    expect_equal(nrow(name_rows), 1L)
    expect_equal(mtd3[grepl("protocol.*name$", mtd3[, 1]), 2][[1]],
                "Test replace")
})

test_that("getMtdProtocol works", {
    res <- getMtdProtocol()
    expect_true(is.na(res))

    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    res <- getMtdProtocol(x)
    expect_true(is.na(res))

    x <- setMtdProtocol(x, name = "Mass Spectrometry",
                    type = c("[CHMO, CHMO:0000470, mass spectrometry, ]"),
                    description = c("Eluting compounds were detected ..."),
                    parameters = c("[MS, MS:1000008, ionization type, [MS,MS:1000073, electrospray ionization, ]]"))
    res <- getMtdProtocol(x)
    expect_equal(length(res), 4)
    expect_equal(res[["protocol[1]-name"]], "Mass Spectrometry")
    expect_equal(res[["protocol[1]-type"]],
                "[CHMO, CHMO:0000470, mass spectrometry, ]")
    expect_equal(res[["protocol[1]-description"]],
                "Eluting compounds were detected ...")
    expect_equal(res[["protocol[1]-parameter[1]"]],
                "[MS, MS:1000008, ionization type, [MS,MS:1000073, electrospray ionization, ]]")
})

test_that("setMtdField works", {
    x <- matrix()
    result <- setMtdField(x, field = "publication",
                            value = "https://doi.org/123")
    expect_equal(result, x)

    ## setMtdField errors on invalid field name
    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    expect_error(setMtdField(x, field = "not_a_valid_field",
                             value = "some_value"),
                "Provide a valid MTD field")
    expect_error(setMtdField(x, field = "custom"),
                "Provide at least 1 value")
    expect_error(setMtdField(x, field = c("a", "b"), value = c("2", "3")),
                 "A single value")

    ## setMtdField adds a new metadata field to a valid MTD section
    result <- setMtdField(x, field = "publication",
                value = "https://pubs.acs.org/doi/10.1021/acs.analchem.8b04310")
    expect_true(any(grepl("publication\\[1\\]", result[, 1])))
    expect_equal(result[grepl("publication\\[1\\]", result[, 1]), 2],
                "https://pubs.acs.org/doi/10.1021/acs.analchem.8b04310")

    ## setMtdField appends new values when replace = FALSE
    mtd <- setMtdField(result, field = "publication",
                    value = "https://doi.org/second", replace = FALSE)
    pub_rows <- mtd[grepl("publication\\[\\d+\\]", mtd[, 1]), , drop = FALSE]
    expect_equal(nrow(pub_rows), 2L)

    ## setMtdField replaces existing field values when replace = TRUE
    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    mtd <- setMtdField(x, field = "publication",
                value = "https://pubs.acs.org/doi/10.1021/acs.analchem.8b04310")
    mtd2 <- setMtdField(mtd, field = "publication",
                    value = "https://doi.org/second", replace = TRUE)
    pub_rows <- mtd2[grepl("publication\\[\\d+\\]", mtd2[, 1]), , drop = FALSE]
    expect_equal(nrow(pub_rows), 1L)
    expect_equal(pub_rows[1, 2], "https://doi.org/second")

    ## Add new single field
    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    result <- setMtdField(x, field = "title", value = "Title 1")
    expect_true(any(grepl("title", result[, 1])))
    expect_equal(result[grepl("title", result[, 1]), 2][[1]], "Title 1")

    result <- setMtdField(x, field = "title", value = "Title 2")
    expect_true(any(grepl("title", result[, 1])))
    expect_equal(result[grepl("title", result[, 1]), 2][[1]], "Title 2")

    expect_error(setMtdField(x, field = "title",
                             value = c("Title 1", "Title 2")),
                 "The field 'title' is unique.")

})

test_that("getMtdField works", {
    expect_error(getMtdField(), "Parameter \"field\" is empty")

    x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
    expect_error(getMtdField(x), "Parameter \"field\" is empty")

    x <- setMtdField(x, field = "publication",
                value = "pubmed:21063943|doi:10.1007/978-1-60761-987-1_6")
    res <- getMtdField(x, field = "publication")
    expect_equal(length(res), 1)
    expect_equal(res[["publication[1]"]],
                 "pubmed:21063943|doi:10.1007/978-1-60761-987-1_6")

    x <- setMtdField(x, field = "publication",
                value = "pubmed:21063943|doi:10.1007/978-1-60761-987-1_6")
    res <- getMtdField(x, field = "publication")
    expect_equal(length(res), 2)
    expect_equal(res[["publication[1]"]],
                 "pubmed:21063943|doi:10.1007/978-1-60761-987-1_6")
    expect_equal(res[["publication[2]"]],
                 "pubmed:21063943|doi:10.1007/978-1-60761-987-1_6")

    x <- setMtdField(x, field = "title", value = "Title 1")
    res <- getMtdField(x, field = "title")
    expect_equal(length(res), 1)
    expect_equal(res[["title"]], "Title 1")

})

test_that("mtdFromSampleData and mtdToSampleData works", {
    sd <- data.frame(
        fname = c("a.mzML", "b.mzML", "c.mzML", "d.mzML", "e.mzML"),
        sname = c("QC", "A", "A", "B", "QC"),
        sid = c("a", "b", "c", "d", "e"),
        inj_idx = c(1, 2, 3, 4, 5),
        sex = c(NA_character_, "F", "F", "M", NA_character_),
        time = c(NA_integer_, 0, 6, 0, NA_integer_),
        species = c(NA, "HSapiens", "HSapiens", "HSapiens", NA))
    sd$polarity <- "positive"
    ## mtdFromSampleData: no samples
    m <- mtdFromSampleData(sd, sampleCols = character(),
                           msRunCols = msRunCols(location = "fname",
                                                 scan_polarity = "polarity"),
                           assayCols = c(assay = "fname"))
    expect_true(all(is.na(getMtdField(m, "sample"))))
    expect_true(all(is.na(getMtdField(m, "assay\\[\\d\\]-sample_ref"))))
    expect_equal(length(getMtdField(m, "study_variable_group\\[\\d\\]$")), 1L)
    expect_equal(length(getMtdField(m, "study_variable\\[\\d\\]$")), 1L)
    res <- getMtdField(m, "ms_run\\[\\d\\]-location")
    expect_equal(unname(res), sd$fname)

    ## mtdToSampleData: no samples
    sd_rec <- mtdToSampleData(m)
    expect_equal(nrow(sd_rec), nrow(sd))
    expect_equal(sd$fname, sd_rec$assay)
    expect_equal(.ms_scan_polarity(sd$polarity), sd_rec$scan_polarity.1.)

    ## mtdFromSampleData: each row one sample
    m <- mtdFromSampleData(sd, sampleCols = sampleCols(sample = "sid"),
                           msRunCols = c(location = "fname",
                                         scan_polarity = "polarity"),
                           assayCols = assayCols(assay = "fname"))
    res <- getMtdField(m, "sample\\[\\d\\]$")
    expect_equal(unname(res), sd$sid)
    res <- getMtdField(m, "assay\\[\\d\\]-sample_ref")
    expect_equal(unname(res), paste0("sample[", 1:5, "]"))
    res <- getMtdField(m, "assay\\[\\d\\]-ms_run_ref")
    expect_equal(unname(res), paste0("ms_run[", 1:5, "]"))

    ## mtdToSampleData: each row one sample
    sd_rec <- mtdToSampleData(m)
    expect_equal(nrow(sd_rec), nrow(sd))
    expect_equal(sd$fname, sd_rec$assay)
    expect_equal(.ms_scan_polarity(sd$polarity), sd_rec$scan_polarity.1.)
    expect_equal(sd$sid, sd_rec$sample)
    expect_equal(sd$species, sd_rec$species.1.)

    ## mtdFromSampleData: unique samples
    m <- mtdFromSampleData(sd, sampleCols = c(sample = "sname"),
                           msRunCols = c(location = "fname",
                                         scan_polarity = "polarity"),
                           assayCols = assayCols(assay = "fname"))
    res <- getMtdField(m, "sample\\[\\d\\]$")
    expect_equal(unname(res), c("QC", "A", "B"))
    res <- getMtdField(m, "assay\\[\\d\\]-sample_ref")
    expect_equal(unname(res), c("sample[1]", "sample[2]", "sample[2]",
                                "sample[3]", "sample[1]"))
    res <- getMtdField(m, "assay\\[\\d\\]-ms_run_ref")
    expect_equal(unname(res), paste0("ms_run[", 1:5, "]"))

    ## mtdToSampleData: unique samples
    sd_rec <- mtdToSampleData(m)
    sd_rec <- sd_rec[order(sd_rec$location), ]
    expect_equal(nrow(sd_rec), nrow(sd))
    expect_equal(sd$fname, sd_rec$assay)
    expect_equal(.ms_scan_polarity(sd$polarity), sd_rec$scan_polarity.1.)
    expect_equal(sd$sname, sd_rec$sample)

    ## mtdFromSampleData: collapse only technical replicates into a sample
    m <- mtdFromSampleData(sd, sampleCols = sampleCols(sample = "sname",
                                                       time = "time"),
                           msRunCols = c(location = "fname",
                                         scan_polarity = "polarity"),
                           assayCols = assayCols(assay = "fname"))
    res <- getMtdField(m, "sample\\[\\d\\]$")
    expect_equal(unname(res), c("QC", "A", "A", "B"))
    res <- getMtdField(m, "assay\\[\\d\\]-sample_ref")
    expect_equal(unname(res), c("sample[1]", "sample[2]", "sample[3]",
                                "sample[4]", "sample[1]"))
    res <- getMtdField(m, "assay\\[\\d\\]-ms_run_ref")
    expect_equal(unname(res), paste0("ms_run[", 1:5, "]"))

    ## mtdToSampleData: collapse only technical replicates into a sample
    sd_rec <- mtdToSampleData(m)
    sd_rec <- sd_rec[order(sd_rec$location), ]
    expect_equal(nrow(sd_rec), nrow(sd))
    expect_equal(sd$fname, sd_rec$assay)
    expect_equal(.ms_scan_polarity(sd$polarity), sd_rec$scan_polarity.1.)
    expect_equal(sd$sname, sd_rec$sample)
    expect_equal(sd$species, sd_rec$species.1.)
    build_custom_col <- .mtd_custom_fields(time = sd$time,
                                            expected_length = 5)[, 2]
    expect_equal(build_custom_col, sd_rec$custom.1.)

    ## mtdFromSampleData: With study variables too
    m <- mtdFromSampleData(sd, sampleCols = sampleCols(sample = "sname"),
                           msRunCols = c(location = "fname",
                                         scan_polarity = "polarity"),
                           assayCols = assayCols(assay = "fname"),
                           groups = c("sex", "time"))
    res <- getMtdField(m, "study_variable_group\\[\\d\\]$")
    expect_true(length(res) == 2)
    expect_equal(unname(getMtdField(m, "study_variable\\[1\\]-assay_refs")),
                 "assay[1]|assay[5]")

    ## mtdToSampleData: With study variables too
    sd_rec <- mtdToSampleData(m)
    expect_equal(nrow(sd_rec), nrow(sd))
    expect_equal(sd$fname, sd_rec$assay)
    expect_equal(.ms_scan_polarity(sd$polarity), sd_rec$scan_polarity.1.)
    expect_equal(sd$sname, sd_rec$sample)
    expect_equal(sd$species, sd_rec$species.1.)
    expect_equal(as.character(sd$time), as.character(sd_rec$time))
    expect_equal(sd$sex, sd_rec$sex)

    ## mtdFromSampleData: ERRORS
    expect_error(mtdFromSampleData(sd), "location = <column")
    expect_error(mtdFromSampleData(sd, msRunCols. = c(location = "aaa")),
                 "location = <column")
    expect_error(mtdFromSampleData(sd, msRunCols. = c(location = "fname")),
                 "scan_polarity = <column")
    expect_error(mtdFromSampleData(sd, msRunCols. = c(location = "fname",
                                                      scan_polarity = "z")),
                 "scan_polarity = <column")
    expect_error(mtdFromSampleData(
        sd, msRunCols. = c(location = "fname", scan_polarity = "polarity")),
                 "assay = <column")

    expect_error(mtdFromSampleData(
        sd, msRunCols. = c(location = "fname", scan_polarity = "polarity"),
        assayCols. = c(assay = "sname"), sampleCols. = c(sample = "sname"),
        groups = c("sex", "time")), "don't align")

    ## mtdToSampleData: ERRORS
    m_noAssay <- m[!grepl("^assay", m[, 1]), ]
    expect_error(mtdToSampleData(m_noAssay), "No 'assay' information")

    ## mtdFromSampleData: MESSAGES
    expect_message(m <- mtdFromSampleData(
        sd, msRunCols. = c(location = "fname", scan_polarity = "polarity"),
        assayCols. = c(assay = "sname"), sampleCols. = c(sample = "sname"),
        groups = c("sex")), "Relationship between assay and ms_run is")
    res <- getMtdField(m, "assay\\[\\d\\]$")
    expect_equal(unname(res), c("QC", "A", "B"))
    res <- getMtdField(m, "study_variable\\[\\d\\]-assay_refs")
    expect_equal(unname(res), c("assay[1]", "assay[2]", "assay[3]"))
})
