# Add or Update a Metadata Field of an mzTab-M MTD section

`setMtdField()` sets or updates metadata fields within an MTD (metadata)
section. When the field already exists, the function can either replace
it entirely or append new values to the existing ones.

`getMtdField()` returns the information from an MTD section of the
requested field.

## Usage

``` r
# S4 method for class 'dfmatrix'
setMtdField(
  x = matrix(),
  field = character(),
  value = character(),
  replace = FALSE
)

getMtdField(x = matrix(), field = character())
```

## Arguments

- x:

  A MTD section that stores metadata fields. Can be a two-column
  `character` matrix, a two-column `data.frame` or a
  [`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md)
  object. Defaults to [`matrix()`](https://rdrr.io/r/base/matrix.html).
  If all values are `NA`, the function returns `x` unchanged.

- field:

  `character(1)` name of the metadata field to set or update. Must be a
  valid [MTD field
  name](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section).
  (e.g. `"publication"`)

- value:

  `character` value(s) to assign to the field. (e.g.
  `"https://pubs.acs.org/doi/10.1021/acs.analchem.8b04310"`)

- replace:

  `logical` flag controlling how pre-existing field metadata is handled.
  Valid only for indexed fields, unique fields are always replaced.

  - `FALSE` (default): new values are appended to any existing values.

  - `TRUE`: existing instrument metadata is discarded and replaced
    entirely by the supplied arguments.

## Value

- For `setMtdField()`: the input object `x` updated to include the new
  or merged field metadata. If `x` is empty, the empty `x`.

- For `getMtdField()`: a named `character` with the requested
  information, names being the field names.

## Author

Gabriele Tomè

## Examples

``` r

x <- mtdSkeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
## Add a metadata field to an existing mzTab object
mtd <- setMtdField(x, field = "publication",
          value = "pubmed:21063943|doi:10.1007/978-1-60761-987-1_6")

## Replace all existing values for a metadata field
mtd <- setMtdField(mtd, field = "custom",
          value = "[,,MS operator, Florian]",
          replace = TRUE)

getMtdField(mtd, field = "mzTab-ID")
#> mzTab-ID 
#>    "001" 
```
