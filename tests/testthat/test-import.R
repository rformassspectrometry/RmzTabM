
test_that("readMzTabM works", {
    mtd_block <- c("MTD\tmzTab-version\t2.1.0-M",
                    "MTD\tmzTab-ID\txcms_mzTab-M_2-1_v2",
                    "MTD\tsoftware[1]\t[MS, MS:1001582, xcms, 4.8.0]",
                    "MTD\tpublication[1]\ttest pub",
                    "MTD\tcontact[1]-name\tauthor_1",
                    "MTD\tcontact[1]-affiliation\tEURAC",
                    "MTD\tcontact[1]-email\tauthor_1@mail.com"
    )

    SML_block <- c(
    "SMH\tSML_ID\tSMF_ID_REFS\tdatabase_identifier\tchemical_formula\tsmiles\tinchi\tchemical_name\turi\ttheoretical_neutral_mass\tadduct_ions\treliability\tbest_id_confidence_measure\tbest_id_confidence_value\tabundance_assay[1]\tabundance_study_variable[1]\tabundance_variation_study_variable[1]",
    "SML\t1\tnull\tnull\tnull\tnull\tnull\tnull\tnull\tnull\tnull\t4\tnull\tnull\tnull\tnull\tnull"
    )

    SMF_block <- c(
    "SFH\tSMF_ID\tSME_ID_REFS\tSME_ID_REF_ambiguity_code\tadduct_ion\tisotopomer\texp_mass_to_charge\tcharge\tretention_time_in_seconds\tretention_time_in_seconds_start\tretention_time_in_seconds_end\tabundance_assay[1]\topt_global_feature_id",
    "SMF\t1\tnull\tnull\tnull\tnull\t200.100006103516\tnull\t2902.63382922675\t2882.60316302447\t2922.66449542903\t135162.428407749\tFT001"
    )

    SME_block <- c(
    "SEH\tSME_ID\tevidence_input_id\tdatabase_identifier\tchemical_formula\tsmiles\tinchi\tchemical_name\turi\tderivatized_form\tadduct_ions\texp_mass_to_charge\tcharge\ttheoretical_mass_to_charge\tspectra_ref\tidentification_method\tms_level\trank",
    "SME\t1\tms_run[1]:mass=700.525;rt=20·5\tnull\tnull\tnull\tnull\tnull\tnull\tnull\tnull\t700.525\t1\t700.528\tms_run[1]:index=7646\t[, , LipidDataAnalyzer, 2.11.1]\t[MS, MS:1000511, ms level, 2]\t1"
    )

    write_tmp <- function(...) {
        f <- tempfile(fileext = ".mztab")
        writeLines(c(...), f)
        f
    }

    f <- tempfile(fileext = ".mztab")
    writeLines(character(0), f)
    expect_error(readMzTabM(f), "empty")

    ## file with only blank lines is considered empty
    f <- write_tmp("", "   ", "\t")
    expect_error(readMzTabM(f), "empty")

    ## file without MTD section throws informative error
    f <- write_tmp(
        "SMH\tSML_ID\tidentifier",
        "SML\t1\tHMDB:HMDB0000001"
    )
    expect_error(readMzTabM(f), "MTD")

    ## SME section without SFH/SMF section throws informative error
    f <- write_tmp(
        mtd_block,
        "\n",
        SME_block   # SEH present but SFH absent
    )
    expect_error(readMzTabM(f), "SFH")
    ## non-existent file path throws an error
    expect_error(readMzTabM("/this/path/does/not/exist.mztab"), "not exist")

    ## MTD-only file returns a list with exactly one element named MTD
    f <- write_tmp(mtd_block)
    res <- readMzTabM(f)
    expect_type(res, "list")
    expect_identical(names(res), "MTD")
    expect_true(is.matrix(res[["MTD"]]))
    expect_equal(ncol(res[["MTD"]]), 2L)
    expect_equal(nrow(res[["MTD"]]), length(mtd_block))
    expect_equal(as.character(res[["MTD"]][1, 1]), "mzTab-version")
    expect_equal(as.character(res[["MTD"]][1, 2]), "2.1.0-M")

    ## SML section is present and is a matrix when SMH is in file
    f <- write_tmp(mtd_block, "\n", SML_block)
    res <- readMzTabM(f)
    expect_true(!is.null(res[["SML"]]))
    expect_true(is.matrix(res[["SML"]]))
    expected_cols <- strsplit(SML_block[1], "\t")[[1]]
    expect_identical(colnames(res[["SML"]]), expected_cols)
    expect_equal(nrow(res[["SML"]]), 1)
    expect_equal(as.character(res[["SML"]][1, "SML_ID"]), "1")

    ## SMF section is present and is a matrix when SFH is in file
    f <- write_tmp(mtd_block, "\n", SML_block, "\n", SMF_block)
    res <- readMzTabM(f)
    expect_true(!is.null(res[["SMF"]]))
    expect_true(is.matrix(res[["SMF"]]))
    expected_cols <- strsplit(SMF_block[1], "\t")[[1]]
    expect_identical(colnames(res[["SMF"]]), expected_cols)
    expect_equal(nrow(res[["SMF"]]), 1)
    expect_equal(as.character(res[["SMF"]][1, "SMF_ID"]), "1")
    expect_equal(as.character(res[["SMF"]][1, "exp_mass_to_charge"]), "200.1")

    ## SME section is present when both SFH and SEH are in file
    f <- write_tmp(mtd_block, "\n", SML_block, "\n", SMF_block, "\n", SME_block)
    res <- readMzTabM(f)
    expect_true(!is.null(res[["SME"]]))
    expect_true(is.matrix(res[["SME"]]))
    expected_cols <- strsplit(SME_block[1], "\t")[[1]]
    expect_identical(colnames(res[["SME"]]), expected_cols)
    expect_equal(nrow(res[["SME"]]), 1)
    expect_equal(as.character(res[["SME"]][1, "SME_ID"]), "1")
    expect_equal(as.character(res[["SME"]][1, "exp_mass_to_charge"]), "700.525")

    ## full file returns all four sections in correct order
    expect_identical(names(res), c("MTD", "SML", "SMF", "SME"))

    ## Error if sections are not in the correct order
    ## TODO: call the validator on the file
    ## f <- write_tmp(mtd_block, SMF_block, SML_block)
    ## res <- readMzTabM(f)
    ## expect_error(...)

    ## blank lines interspersed in file do not break parsing
    f <- write_tmp(
        mtd_block[1], "",
        mtd_block[2:7], "",
        SML_block
    )
    res <- readMzTabM(f)
    expect_identical(names(res), c("MTD", "SML"))
    expect_equal(nrow(res[["MTD"]]), length(mtd_block))

    ## extra fread arguments via ... are accepted without error
    f <- write_tmp(mtd_block, SML_block)
    # nThread is a valid fread argument; if ... forwarding is broken this errors
    expect_no_error(readMzTabM(f, nThread = 1L))
})
