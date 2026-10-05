
#' @title Validate an mzTab-M file using the jmztabm-validator
#'
#' @name mzTabMValidator
#'
#' @description
#' It validates the mzTab-M file using the jmztabm-validator, which is a
#' Java-based tool that checks the compliance of mzTab-M files with the
#' mzTab-M 2.1 specification. The function captures the output of the validator
#' and parses it to determine if the validation was successful, and to extract
#' any validation messages (errors, warnings, info).
#'
#' @param mztab_file `character(1)` with the path to the mzTab-M file to
#'     validate.
#'
#' @return A `list` with the validation results, including whether the
#'     validation finished successfully, the total number of messages, the
#'     number of errors and warnings, and a data frame with the details of each
#'     validation message.
#'
#' @author Gabriele Tomè
#'
#' @importFrom utils capture.output
#'
#' @seealso [mzTabMValidator_download] to determine the path of the cached
#'     jmztabm-validator binary.
#'
#' @export
mzTabMValidator <- function(mztab_file) {
    if (!file.exists(mztab_file))
        stop("The file does not exist.")

    ## Get path validator if not already cached
    validator_path <- mzTabMValidator_download()

    ## Capture stdout/stderr of the execution.
    raw_output <- system2(command = validator_path,
                          args = c("-c", mztab_file),
                          stdout = TRUE, stderr = TRUE)
    result <- parse_validation_output(raw_output)

    if (result$n_errors)
        stop("mzTab validation failed: ", result$n_errors, " error(s) found.\n",
             paste(result$messages$text[grepl("error", result$messages$level,
                                              ignore.case = TRUE)],
                   collapse = "\n"))
    if (result$n_warnings)
        warning("mzTab validation: ", result$n_warnings, " warning(s) found.")

    message("Validation finished successfully: ", result$total_messages,
                 " message(s) found, including:")
    message("\t- Info(s): ", result$n_info)
    message("\t- Warning(s): ", result$n_warnings)
    message("\t- Error(s): ", result$n_errors)

    if (nrow(result$messages)) {
        message("\nValidation messages:")
        message(paste0(capture.output(result$messages), collapse = "\n"))
    }
    result
}

#' @title Internal helper to parse the output of the mzTab-M validator
#'
#' @param validator_output A `character` vector containing the lines of output
#'     from the mzTab-M validator.
#'
#' @return A `list` with the parsed validation results.
#'
#' @author Gabriele Tomè
#'
#' @noRd
parse_validation_output <- function(validator_output) {
    ## Extract validation messages [Info/Warn/Error-NNNN]
    msg_pattern <- paste0("^\\[(Info|Warn|Error)-(\\d+)\\]\\s+line\\s+(-?\\d+)",
                          ":\\s+(.+)$")
    msg_lines   <- validator_output[grepl(msg_pattern, validator_output,
                                          ignore.case = TRUE)]

    messages <- data.frame(level = character(), code = integer(),
                           line_no = integer(), text = character())
    if (length(msg_lines)) {
        messages <- data.frame(
            level = sub(msg_pattern, "\\1", msg_lines, ignore.case = TRUE),
            code = sub(msg_pattern, "\\2", msg_lines, ignore.case = TRUE),
            line_no = sub(msg_pattern, "\\3", msg_lines, ignore.case = TRUE),
            text = sub(msg_pattern, "\\4", msg_lines, ignore.case = TRUE))
    }

    ## Check if validation finish
    finished <- any(grepl("Finished validation", validator_output))

    total_messages <- NA
    total_issues <- NA
    if (finished) {
        ## Extract the summary line
        if(nrow(messages)){
            summary_pattern <- paste0("There were (\\d+) validation messages ",
                                    "including (\\d+) warnings or errors")
        } else {
            summary_pattern <- paste0("There were (\\d+) validation messages ",
                                    "during validation of your file!")
        }
        summary_line <- validator_output[grepl(summary_pattern,
                                               validator_output)]

        if (length(summary_line)) {
            total_messages <- as.integer(sub(paste0(".*", summary_pattern,
                                                    ".*"), "\\1", summary_line))
            total_issues <- as.integer(sub(paste0(".*", summary_pattern, ".*"),
                                           "\\2", summary_line))
        }
    }

    ## Counts from structured messages
    if (nrow(messages)) {
        n_errors <- sum(tolower(messages$level) == "error")
        n_warnings <- sum(tolower(messages$level) == "warn")
        n_info <- sum(tolower(messages$level) == "info")
    } else {
        n_errors <- sum(grepl("ERROR", validator_output))
        ## Subtract logback config warning
        n_warnings <- sum(grepl("WARN", validator_output)) -
                        sum(grepl("logback", validator_output) &
                            grepl("WARN", validator_output))
        n_info <- 0
    }

    list(finished = finished, total_messages = total_messages,
         total_issues = total_issues, n_errors = n_errors,
         n_warnings = n_warnings, n_info = n_info, messages = messages)
}


#' @title Download the jmztabm-validator binary
#'
#' @name mzTabMValidator_download
#'
#' @description
#' This function downloads the jmztabm-validator binary for the current
#' platform (*Linux*, *macOS*, or *Windows*) from the GitHub releases of the
#' [jmztabm-validator repository](https://github.com/lifs-tools/jmzTab-m/releases).
#' It caches the downloaded binary using *BiocFileCache* to avoid repeated downloads.
#'
#' @param tag `character(1)` specifying the release tag to download. Defaults
#'     `"dev-latest"`.
#'
#' @param force `logical(1)` indicating whether to force re-download of the
#'     binary even if a cached copy exists.
#'
#' @return `character(1)` with the path of the jmztabm-validator.
#'
#' @importFrom BiocFileCache BiocFileCache bfcquery bfcneedsupdate
#'
#' @importFrom BiocFileCache bfcremove bfcrpath bfcpath
#'
#' @importFrom jsonlite fromJSON
#'
#' @importFrom cli hash_file_sha256
#'
#' @author Gabriele Tomè
#'
#' @examples
#'
#' mzTabMValidator_download()
#'
#' @export
mzTabMValidator_download <- function(tag = "dev-latest", force = FALSE) {
    sys <- Sys.info()[["sysname"]]
    asset <- switch(sys,
                    Linux = "jmztabm-validator-amd64-linux",
                    Darwin = "jmztabm-validator-aarch64-macos",
                    Windows = "jmztabm-validator-amd64-windows.exe",
                    stop("Unsupported platform: ", sys))

    rname <- paste(tag, asset, sep = "_")
    bfc <- BiocFileCache()
    cached <- bfcquery(bfc, rname, exact = TRUE)

    if(force | !nrow(cached)){
        ## Remote metadata (size + sha256) for the requested release
        rel <- fromJSON(paste0(
        "https://api.github.com/repos/lifs-tools/jmzTab-m/releases/tags/", tag))
        a <- rel$assets[rel$assets$name == asset, ]
        if (!nrow(a))
            stop("Asset '", asset, "' not found in release '", tag, "'")

        to_update <- force || !nrow(cached) ||
                is.null(a$digest) || is.na(a$digest) ||
                hash_file_sha256(bfcpath(bfc, cached$rid[1])) !=
                    sub("^sha256:", "", a$digest)

        if (to_update) {
            if (nrow(cached))
                bfcremove(bfc, cached$rid)

            path <- bfcrpath(bfc, rnames = rname,
                            fpath = a$browser_download_url, exact = TRUE)

            if (sys != "Windows")
                Sys.chmod(path, "755")  ## make executable
        }
    } else
        path <- bfcpath(bfc, cached$rid[1])

    path
}
