# Add or Update Database Metadata in an MTD section

Sets or updates database-related metadata fields within an MTD
(metadata) section. When database metadata already exists, the function
can either replace it entirely or append new values to the existing
ones.

Get the databse fields within an MTD (metadata) section.

## Usage

``` r
setMtdDatabase(
  x = matrix(),
  name = character(),
  prefix = character(),
  version = character(),
  uri = character(),
  replace = FALSE
)

getMtdDatabase(x = matrix())
```

## Arguments

- x:

  A MTD section that stores metadata fields. Defaults to
  [`matrix()`](https://rdrr.io/r/base/matrix.html).

- name:

  `character` with the description of databases used. For cases, where a
  known database has not been used for identification. (e.g.,
  `"[MIRIAM, MIR:00100079, HMDB, ]"`).

- prefix:

  `character` with the prefix used in the “identifier” column of data
  tables. (e.g., `"hmdb"`).

- version:

  `character` with the database version is mandatory where
  identification has been performed. This may be a formal version number
  (`"1.4.1"`), a date of access (`"2016-10-27"`) (ISO-8601 format) or
  (`"Unknown"`) if there is no suitable version that can be annotated.

- uri:

  `character` with the URI to the database.

- replace:

  `logical` flag controlling how pre-existing database metadata is
  handled:

  - `FALSE` (default): new values are appended to any existing values.

  - `TRUE`: existing instrument metadata is discarded and replaced
    entirely by the supplied arguments.

## Value

The input object `x` updated to include the new or merged database
metadata fields. If `x` is empty, the empty `x`.

`character` with the database.

## Author

Gabriele Tomè

## Examples

``` r

x <- mtd_skeleton("001", software = "[MS, MS:1001582, xmcs, 4.0.0]")
## Add database metadata to an existing mzTab object
mtd <- setMtdDatabase(x, name = "[MIRIAM, MIR:00100079, HMDB, ]",
          prefix = "hmdb",
          version = "3.6",
          uri = "http://www.hmdb.ca/")

## Replace all existing database metadata
mtd <- setMtdDatabase(mtd, name = "[MIRIAM, MIR:00100079, HMDB, ]",
          prefix = "hmdb",
          version = "3.6",
          uri = "http://www.hmdb.ca/",
          replace = TRUE)


x <- mtd_skeleton("001", software = "[MS, MS:1001582, xcms, 4.0.0]")
mtd <- setMtdDatabase(x, name = "[MIRIAM, MIR:00100079, HMDB, ]",
          prefix = "hmdb",
          version = "3.6",
          uri = "http://www.hmdb.ca/")

getMtdDatabase(x)
#>                   database[1]            database[1]-prefix 
#> "[,, \"no database\", null ]"                        "null" 
#>           database[1]-version               database[1]-uri 
#>                     "Unknown"                        "null" 
```
