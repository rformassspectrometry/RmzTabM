# RmzTabM version 0.98

## Changes in version 0.98.0

- First version of general read function `readMzTabM()`
- Add example and tests.
- Fix bug related `study_variable[1-n]-group_ref`
- Change type `study_variable_group[1-n]` to CV param

## Changes in version 0.97.9

- Support `"Parameter"` as study variable group datatype.
- Automatic datatype definition for study variable group supports `"Parameter"`.

## Changes in version 0.97.8

- Add functions `setMtdInstrument()`, `setMtdDatabase()`, `setMtdCv()`, `setMtdContact()`,
  `setMtdField()` and `updateMtdContent()` for MTD section
- Add examples and tests.

## Changes in version 0.97.7

- Add SME section code.
- Add scripts to test export of mzTab-M 2.1 files.

## Changes in version 0.97.6

- MTD: add *study_variable_group* support (mzTab-M >= 2.1).
- MTD: add STATO as one of the default CV ontologies.

## Changes in version 0.97.5

- Add functionality to create/format the SML section: `sml_create()`,
  `sml_sort()`, `sml_add_study_variable_columns()`.

## Changes in version 0.97.4

- Restructure helper functions to be usable across SMF and SML functionality.

## Changes in version 0.97.3

- Add utility function `parse_cv_param()`.

## Changes in version 0.97.2

- Add vignette.

## Changes in version 0.97.1

- Addition of SMF related functions to the package.

## Changes in version 0.97.0

- Move code for metadata creation and formatting from the *lifs-tools/rmzTabM*
  repository.
