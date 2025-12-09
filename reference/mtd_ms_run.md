# msTab-M *ms_run* metadata fields

The `mtd_ms_run()` function allows to define and format the *ms_run*
fields of the mzTab-M metadata. The information is build on the actual
data file names along with optional additional parameters to
characterize the MS run(s).

For details and expected input for the various parameter it is
**strongly suggested** to consult the
[mzTab-M](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section)
documentation.

## Usage

``` r
mtd_ms_run(
  location = character(),
  instrument_ref = integer(),
  format = character(),
  id_format = character(),
  fragmentation_method = vector("list", length(location)),
  scan_polarity = character(),
  hash = character(),
  hash_method = character()
)
```

## Arguments

- location:

  `character` with the location (and file name) of the individual runs.
  Each element will be one run. This parameter is required, set to
  `"null"` if the location of the file(s) is not known.

- instrument_ref:

  (optional) [`integer()`](https://rdrr.io/r/base/integer.html) with the
  index of the instrument the run was measured on.

- format:

  (optional) `character` defining the format of the external MS data
  file. If specified, also `id_format` has be be provided. Can be of
  length 1 or equal to `length(location)`. For data file(s) in mzML
  format, `format = "[MS, MS:1000584, mzML file, ]"` can be used.

- id_format:

  (optional) `character` defining the id format used in the external
  data file. If specified, also `format` needs to be defined. Can be of
  length 1 or equal to `length(location)`. For data file(s) in mzML
  format, `format = "[MS, MS:1000530, mzML unique identifier, ]"` can be
  used.

- fragmentation_method:

  (optional) `list` of `character` defining the type(s) of
  fragmentation(s) used in a given ms run. Length must match length of
  `location` if provided. If no fragmentation was used for a specific
  file/run use `NULL` for that `list` element (position). As example, if
  two runs are included, the first does not have any fragmentation and
  for the second CID and HCD was used define
  `list(NULL, c("[MS, MS:1000133, CID, ]", "[MS, MS:1000422, HCD, ]"))`.

- scan_polarity:

  `character` defining the polarity of a run. Can be either `"positive"`
  or `"negative"`. Can be of length 1 or equal to `length(location)`.

- hash:

  (optional) `character` with the hash value of the corresponding
  external MS data file. If provided, also `hash_method` needs to be
  defined. The length of `hash` has to match the length of `location`.

- hash_method:

  (optional) `character` with the hash method used to generate the value
  in `hash`. If provided, also `hash` needs to be defined. The length of
  `hash_method` has to match the length of `hash`.

## Value

two column `character` `matrix` with the *ms_run* metadata fields for a
mzTab-M file.

## Note

At present only a single polarity per run/file is supported.

## See also

[MTD-export](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-export.md)
for other functions defining metadata information

## Author

Johannes Rainer, Philippine Louail

## Examples

``` r

## Build a very basic MTD ms_run section for two data files
fls <- c("file:///path/to/file/a.mzML", "file:///path/to/file/b.mzML")
mtd_ms_run(location = fls, scan_polarity = "positive")
#>                                   values                             
#> [1,] "ms_run[1]-location"         "file:///path/to/file/a.mzML"      
#> [2,] "ms_run[1]-scan_polarity[1]" "[MS, MS:1000130, positive scan, ]"
#> [3,] "ms_run[2]-location"         "file:///path/to/file/b.mzML"      
#> [4,] "ms_run[2]-scan_polarity[1]" "[MS, MS:1000130, positive scan, ]"

## Add also instrument reference information
mtd_ms_run(location = fls, scan_polarity = "positive", instrument_ref = 1)
#>                                   values                             
#> [1,] "ms_run[1]-location"         "file:///path/to/file/a.mzML"      
#> [2,] "ms_run[1]-instrument_ref"   "instrument[1]"                    
#> [3,] "ms_run[1]-scan_polarity[1]" "[MS, MS:1000130, positive scan, ]"
#> [4,] "ms_run[2]-location"         "file:///path/to/file/b.mzML"      
#> [5,] "ms_run[2]-instrument_ref"   "instrument[1]"                    
#> [6,] "ms_run[2]-scan_polarity[1]" "[MS, MS:1000130, positive scan, ]"

## Finally, add a fragmentation method used for the second file - no
## fragmentation was used for the first file, thus `NULL` is specified.
## Parameter `fragmentation_method` expects a `list` as input to support
## also multiple fragmentation methods per MS run.
mtd_ms_run(location = fls, scan_polarity = "positive",
    fragmentation_method = list(NULL, "[MS, MS:1000133, CID, ]"))
#>                                          values                             
#> [1,] "ms_run[1]-location"                "file:///path/to/file/a.mzML"      
#> [2,] "ms_run[1]-scan_polarity[1]"        "[MS, MS:1000130, positive scan, ]"
#> [3,] "ms_run[2]-location"                "file:///path/to/file/b.mzML"      
#> [4,] "ms_run[2]-fragmentation_method[1]" "[MS, MS:1000133, CID, ]"          
#> [5,] "ms_run[2]-scan_polarity[1]"        "[MS, MS:1000130, positive scan, ]"
```
