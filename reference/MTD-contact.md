# Add or Update contact Metadata in an MTD section

Sets or updates contact-related metadata fields within an MTD (metadata)
in a MTD section. When contact metadata already exists, the function can
either replace it entirely or append new values to the existing ones.

Get the Contact fields within an MTD (metadata) section.

## Usage

``` r
setMtdContact(
  x = matrix(),
  name = character(),
  affiliation = character(),
  email = character(),
  replace = FALSE
)

getMtdContact(x = matrix())
```

## Arguments

- x:

  A MTD section that stores metadata fields. Defaults to
  [`matrix()`](https://rdrr.io/r/base/matrix.html).

- name:

  `character` contact’s name.

- affiliation:

  `character` contact’s affiliation.

- email:

  `character` contact’s e-mail address.

- replace:

  `logical` flag controlling how pre-existing contact metadata is
  handled:

  - `FALSE` (default): new values are appended to any existing values.

  - `TRUE`: existing instrument metadata is discarded and replaced
    entirely by the supplied arguments.

## Value

The input object `x` updated to include the new or merged contact
metadata fields. If `x` is empty, the empty `x`.

`character` with the contacts.

## Author

Gabriele Tomè

## Examples

``` r

x <- mtd_skeleton("001", software = "[MS, MS:1001582, xmcs, 4.0.0]")
## Add contact metadata to an existing mzTab object
mtd <- setMtdContact(x, name = "Name Surname",
          affiliation = "PSI-MS",
          email = "name.surname@mail.com")

## Replace all existing contact metadata
mtd <- setMtdContact(mtd, name = "Name Surname",
          affiliation = "PSI-MS",
          email = "name.surname@mail.com",
          replace = TRUE)


x <- mtd_skeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
mtd <- setMtdContact(x, name = "Name Surname",
          affiliation = "PSI-MS",
          email = "name.surname@mail.com")

getMtdContact(x)
#> [1] NA
```
