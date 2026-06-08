# Add or Update contact Metadata of an mzTab-M MTD section

`setMtdContact()` sets or updates contact-related metadata fields within
an MTD (metadata) section. When contact metadata already exists, the
function can either replace it entirely or append new values to the
existing ones.

`getMtdContact()` returns the contact information from an MTD section.

## Usage

``` r
# S4 method for class 'dfmatrix'
setMtdContact(
  x = matrix(),
  name = character(),
  affiliation = character(),
  email = character(),
  orcid = character(),
  replace = FALSE
)

getMtdContact(x = matrix())
```

## Arguments

- x:

  A MTD section that stores metadata fields. Can be a two-column
  `character` matrix, a two-column `data.frame` or a
  [`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md)
  object. Defaults to [`matrix()`](https://rdrr.io/r/base/matrix.html).
  If all values are `NA`, the function returns `x` unchanged.

- name:

  `character` contact’s name.

- affiliation:

  `character` contact’s affiliation.

- email:

  `character` contact’s e-mail address.

- orcid:

  `character` contact’s ORCID identifier.

- replace:

  `logical` flag controlling how pre-existing contact metadata is
  handled:

  - `FALSE` (default): new values are appended to any existing values.

  - `TRUE`: existing instrument metadata is discarded and replaced
    entirely by the supplied arguments.

## Value

- For `setMtdContact()`: the input object `x` updated to include the new
  or merged contact metadata fields. If `x` is empty, the empty `x`.

- For `getMtdContact()`: a named `character` with the contact
  information, names being the field names.

## Author

Gabriele Tomè

## Examples

``` r

x <- mtdSkeleton("001", software = "[MS, MS:1001582, xmcs, 4.0.0]")
## Add contact metadata to an existing mzTab object
mtd <- setMtdContact(x, name = "Name Surname",
          affiliation = "PSI-MS",
          email = "name.surname@mail.com", orcid = "0000-0002-1825-0097")

## Replace all existing contact metadata
mtd <- setMtdContact(mtd, name = "Name Surname",
          affiliation = "PSI-MS",
          email = "name.surname@mail.com",
          orcid = "0000-0002-1825-0097",
          replace = TRUE)


getMtdContact(mtd)
#>         contact[1]-name  contact[1]-affiliation        contact[1]-email 
#>          "Name Surname"                "PSI-MS" "name.surname@mail.com" 
#>        contact[1]-orcid 
#>   "0000-0002-1825-0097" 
```
