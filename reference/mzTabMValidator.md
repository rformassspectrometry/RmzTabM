# Validate an mzTab-M file using the jmztabm-validator

`mzTabMValidator()` validates the mzTab-M file using the
jmztabm-validator, which is a Java-based tool that checks the compliance
of mzTab-M files with the mzTab-M 2.1 specification. The function
captures the output of the validator and parses it to determine if the
validation was successful, and to extract any validation messages
(errors, warnings, info). If the validation fails due to errors the
function stop and generate an error.

## Usage

``` r
mzTabMValidator(mztab_file = character())
```

## Arguments

- mztab_file:

  `character(1)` with the path to the mzTab-M file to validate.

## Value

A `list` with the validation results, including whether the validation
finished successfully, the total number of messages, the number of
errors and warnings, and a data frame with the details of each
validation message. If the validation fails it return a error.

## See also

[mzTabMValidator_download](https://rformassspectrometry.github.io/RmzTabM/reference/mzTabMValidator_download.md)
to determine the path of the cached jmztabm-validator binary.

## Author

Gabriele Tomè
