
test_that("parse_validation_output works", {
    ## Clean output: no messages, validation finished
    clean_output <- c(
        "11:04:17.780 [main] INFO  o.l.mztab2.cli.MZTabCommandLine -- Validator set to default level 'Info'",
        "11:04:17.780 [main] INFO  o.l.mztab2.cli.MZTabCommandLine -- Beginning validation of mztab file: mztabm/out/xcms_mzTab-M_2-1_v2_onlyMTD.mzTab",
        "10:00:00.002 [main] INFO  o.l.mztab2.cli.MZTabCommandLine -- There were 0 validation messages during validation of your file!",
        "11:04:17.783 [main] INFO  o.l.mztab2.cli.MZTabCommandLine -- mztabm/out/xcms_mzTab-M_2-1_v2_onlyMTD.mzTab",
        "11:04:17.783 [main] INFO  o.l.mztab2.cli.MZTabCommandLine -- Finished validation!"
    )
    res_clean <- parse_validation_output(clean_output)
    expect_true(res_clean$finished)
    expect_equal(res_clean$n_errors, 0L)
    expect_equal(res_clean$n_warnings, 0L)
    expect_equal(res_clean$n_info, 0L)
    expect_equal(nrow(res_clean$messages), 0L)
    expect_equal(res_clean$total_messages, 0L)
    expect_true(is.na(res_clean$total_issues))

    ## Info-only output
    info_output <- c(
        "11:04:17.780 [main] INFO  o.l.mztab2.cli.MZTabCommandLine -- Validator set to default level 'Info'",
        "11:04:17.780 [main] INFO  o.l.mztab2.cli.MZTabCommandLine -- Beginning validation of mztab file: mztabm/out/xcms_mzTab-M_2-1_v2_onlyMTD.mzTab",
        "[Info-2036] line -1: The mzTab file must contain a small molecule summary section.",
        "11:04:17.783 [main] ERROR o.l.mztab2.cli.MZTabCommandLine -- There were 1 validation messages including 0 warnings or errors during validation of your file, please check the output for details!",
        "11:04:17.783 [main] INFO  o.l.mztab2.cli.MZTabCommandLine -- mztabm/out/xcms_mzTab-M_2-1_v2_onlyMTD.mzTab",
        "11:04:17.783 [main] INFO  o.l.mztab2.cli.MZTabCommandLine -- Finished validation!"
    )
    res_info <- parse_validation_output(info_output)
    expect_true(res_info$finished)
    expect_equal(res_info$n_info, 1L)
    expect_equal(res_info$n_warnings, 0L)
    expect_equal(res_info$n_errors, 0L)
    expect_equal(nrow(res_info$messages), 1L)
    expect_equal(tolower(res_info$messages$level), "info")
    expect_equal(res_info$messages$code, "2036")
    expect_equal(res_info$messages$line_no, "-1")
    expect_match(res_info$messages$text, "small molecule summary section")
    expect_equal(res_info$total_messages, 1L)
    expect_equal(res_info$total_issues, 0L)

    ## Warning-only output
    warn_output <- c(
        "[Warn-1001] line 5: Some optional field is missing.",
        "10:00:00.002 [main] ERROR o.l.mztab2.cli.MZTabCommandLine -- There were 1 validation messages including 1 warnings or errors during validation of your file, please check the output for details!",
        "10:00:00.003 [main] INFO  o.l.mztab2.cli.MZTabCommandLine -- Finished validation!"
    )

    res_warn <- parse_validation_output(warn_output)
    expect_true(res_warn$finished)
    expect_equal(res_warn$n_warnings, 1L)
    expect_equal(res_warn$n_errors, 0L)
    expect_equal(res_warn$n_info, 0L)
    expect_equal(nrow(res_warn$messages), 1L)
    expect_equal(tolower(res_warn$messages$level), "warn")
    expect_equal(res_warn$messages$code, "1001")
    expect_equal(res_warn$messages$line_no, "5")
    expect_equal(res_warn$total_messages, 1L)
    expect_equal(res_warn$total_issues, 1L)

    ## Error-only output
    error_output <- c(
        "08:38:41.935 [main] INFO  o.l.mztab2.cli.MZTabCommandLine -- Validator set to default level 'Info'",
        "08:38:41.937 [main] INFO  o.l.mztab2.cli.MZTabCommandLine -- Beginning validation of mztab file: mztabm/out/riken-lipidomics-r-mtd-sml.mztab",
        "[Error-1009] line 95: Metadata define label \"study_variable-group_refs\" can not be recognized.",
        "uk.ac.ebi.pride.jmztab2.utils.errors.MZTabException: [Error-1009] line 95: Metadata define label \"study_variable-group_refs\" can not be recognized.",
            "    at uk.ac.ebi.pride.jmztab2.utils.parser.MTDLineParser.checkProperty(MTDLineParser.java:165)",
            "    at uk.ac.ebi.pride.jmztab2.utils.parser.MTDLineParser.handleStudyVariable(MTDLineParser.java:497)",
            "    at uk.ac.ebi.pride.jmztab2.utils.parser.MTDLineParser.parseNormalMetadata(MTDLineParser.java:383)",
            "    at uk.ac.ebi.pride.jmztab2.utils.parser.MTDLineParser.parse(MTDLineParser.java:116)",
            "    at org.lifstools.mztab2.io.MzTabFileParser.check(MzTabFileParser.java:341)",
            "    at org.lifstools.mztab2.io.MzTabFileParser.parse(MzTabFileParser.java:139)",
            "    at org.lifstools.mztab2.io.MzTabFileParser.parse(MzTabFileParser.java:180)",
            "    at org.lifstools.mztab2.cli.MZTabCommandLine.handleValidation(MZTabCommandLine.java:352)"
    )
    res_err <- parse_validation_output(error_output)
    expect_false(res_err$finished)
    expect_equal(res_err$n_errors, 1L)
    expect_equal(res_err$n_warnings, 0L)
    expect_equal(res_err$n_info, 0L)
    expect_equal(nrow(res_err$messages), 1L)
    expect_equal(tolower(res_err$messages$level), "error")
    expect_equal(res_err$messages$code, "1009")
    expect_equal(res_err$messages$line_no, "95")
    expect_match(res_err$messages$text, "study_variable-group_refs")
    expect_true(is.na(res_err$total_messages))
    expect_true(is.na(res_err$total_issues))

    ## Crashed/unfinished validator
    crashed_output <- c(
        "10:00:00.000 [main] INFO  o.l.mztab2.cli.MZTabCommandLine -- Running jmztabm-cli",
        "Exception in thread \"main\" java.lang.NullPointerException"
    )
    res_crash <- parse_validation_output(crashed_output)
    expect_false(res_crash$finished)
    expect_true(is.na(res_crash$total_messages))
    expect_true(is.na(res_crash$total_issues))
    expect_equal(nrow(res_crash$messages), 0L)

    ## Logback noise is NOT counted as warnings
    logback_noise_output <- c(
        "11:04:17,753 |-WARN in ch.qos.logback.classic.util.DefaultJoranConfigurator@1717a215 - Resource [logback-test.xml] occurs at [resource:/logback-test.xml#1]",
        "11:04:17,753 |-WARN in ch.qos.logback.classic.util.DefaultJoranConfigurator@1717a215 - Resource [logback-test.xml] occurs at [resource:/logback-test.xml]",
        "11:04:17,769 |-INFO in ch.qos.logback.classic.model.processor.ConfigurationModelHandlerFull - Scan attribute set to true. Will scan for configuration file changes.",
        "11:04:17,769 |-INFO in ch.qos.logback.core.joran.spi.ConfigurationWatchList@5b6e2837 - URL [resource:/logback-test.xml] is not of type file",
        "11:04:17,769 [main] INFO  o.l.mztab2.cli.MZTabCommandLine -- There were 0 validation messages during validation of your file!",
        "11:04:17.783 [main] INFO  o.l.mztab2.cli.MZTabCommandLine -- mztabm/out/xcms_mzTab-M_2-1_v2_onlyMTD.mzTab",
        "11:04:17.783 [main] INFO  o.l.mztab2.cli.MZTabCommandLine -- Finished validation!"
    )
    res_noise <- parse_validation_output(logback_noise_output)
    expect_true(res_noise$finished)
    expect_equal(res_noise$n_warnings, 0L)
    expect_equal(res_noise$n_errors, 0L)

    ## Return type contract
    expect_type(res_clean, "list")
    expect_named(res_clean, c("finished", "total_messages", "total_issues",
                               "n_errors", "n_warnings", "n_info", "messages"))
    expect_s3_class(res_clean$messages, "data.frame")
    expect_named(res_clean$messages, c("level", "code", "line_no", "text"))
    expect_true(is.logical(res_clean$finished))
})


test_that("mzTabMValidator works", {
    expect_error(mzTabMValidator("non_existing_file.mzTab"),
                 "The file does not exist")

    mztab_file <- system.file("mztabm/out","riken-lipidomics-r-mtd-sml.mztab",
                                package = "RmzTabM")
    with_mocked_bindings(Sys.which = function(...) "", .package = "base",
        expect_error(mzTabMValidator(mztab_file), "Java is required"))

    ## Validation with errors -> error
    expect_error(suppressWarnings(mzTabMValidator(mztab_file)),
                 "validation failed")

    ## Validation with warnings -> warning (no error)
    warn_output <- c(
        "[Warn-1001] line 5: Some optional field is missing.",
        "10:00:00.002 [main] ERROR o.l.mztab2.cli.MZTabCommandLine -- There were 1 validation messages including 1 warnings or errors during validation of your file, please check the output for details!",
        "10:00:00.003 [main] INFO  o.l.mztab2.cli.MZTabCommandLine -- Finished validation!"
    )
    with_mocked_bindings(system2 = function(...) warn_output, .package = "base",
        expect_warning(mzTabMValidator(mztab_file), "1 warning"))

    mztab_file <- system.file("mztabm/in","LDA_v2.11.1_MTBLS396_short.mzTab",
                                package = "RmzTabM")
    expect_equal(mzTabMValidator(mztab_file),
                list(finished = TRUE, total_messages = 0L,
                    total_issues = NA_integer_,
                    n_errors = 0L, n_warnings = 0L, n_info = 0L,
                    messages = data.frame(level = character(), code = integer(),
                                          line_no = integer(),
                                          text = character())
                ))
})
