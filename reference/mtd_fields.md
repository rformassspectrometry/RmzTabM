# Prepare and format information for the mzTab-M metadata section

This function assists in creating and formatting information for the
mzTab-M metadata section (MTD). It combines and formats the provided
input values for a specific field.

See [mzTab-M
documentation](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section)
for more information, examples and expected format.

## Usage

``` r
mtd_fields(..., field_prefix = "")
```

## Arguments

- ...:

  `character` vector(s), each having the same length, with the values
  for the field(s). Parameter `field_prefix` defines the name of the
  field (e.g., `"cv"`). If names are provided (e.g.
  `label = "my label"`), these are appended to the `field_prefix` (e.g.,
  for `field_prefix = "cv"`, the returned field's name is combined to
  `"cv[1]-label"`).

- field_prefix:

  `character(1)` defining the prefix to be used (e.g., `prefix = "cv"`).
  This is the prefix/first part of the field's name.

## Value

two column `character` `matrix` with the formatted elements.

## See also

[MTD-export](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-export.md)
for other functions defining metadata information

## Author

Johannes Rainer, Philippine Louail

## Examples

``` r

## Define the CV element with 3 CV terms:
mtd_fields(
    label = c("a", "b", "c"),
    full_name = c("A", "B", "C"),
    version = c(1, 2, 3),
    uri = c("u1", "u2", "u3"),
    field_prefix = "cv")
#>       [,1]              [,2]
#>  [1,] "cv[1]-label"     "a" 
#>  [2,] "cv[1]-full_name" "A" 
#>  [3,] "cv[1]-version"   "1" 
#>  [4,] "cv[1]-uri"       "u1"
#>  [5,] "cv[2]-label"     "b" 
#>  [6,] "cv[2]-full_name" "B" 
#>  [7,] "cv[2]-version"   "2" 
#>  [8,] "cv[2]-uri"       "u2"
#>  [9,] "cv[3]-label"     "c" 
#> [10,] "cv[3]-full_name" "C" 
#> [11,] "cv[3]-version"   "3" 
#> [12,] "cv[3]-uri"       "u3"

## Define a single software:
mtd_fields("[MS, MS:1002879, Progenesis QI, 3.0]", field_prefix = "software")
#>      [,1]          [,2]                                  
#> [1,] "software[1]" "[MS, MS:1002879, Progenesis QI, 3.0]"

## Define two softwares:
mtd_fields(c("[MS, MS:1002879, Progenesis QI, 3.0]", "[a, b, c, d]"),
    field_prefix = "software")
#>      [,1]          [,2]                                  
#> [1,] "software[1]" "[MS, MS:1002879, Progenesis QI, 3.0]"
#> [2,] "software[2]" "[a, b, c, d]"                        

## Define a software with the optional setting
mtd_fields(c("[MS, MS:1002879, Progenesis QI, 3.0]", "[a, b, c, d]"),
    `setting[1]` = c("my cool settings", "none"),
    `setting[2]` = c("other setting", "none"),
    field_prefix = "software")
#>      [,1]                     [,2]                                  
#> [1,] "software[1]"            "[MS, MS:1002879, Progenesis QI, 3.0]"
#> [2,] "software[1]-setting[1]" "my cool settings"                    
#> [3,] "software[1]-setting[2]" "other setting"                       
#> [4,] "software[2]"            "[a, b, c, d]"                        
#> [5,] "software[2]-setting[1]" "none"                                
#> [6,] "software[2]-setting[2]" "none"                                

## Define database fields
mtd_fields(
   c("[MITIAM, MRI:00100079, HMDB, ]", "[,, de novo, ]"),
   prefix = c("hmdb", "dn"),
   version = c("3.6", "Unknown"),
   uri = c("http://www.hmdb.ca", "null"),
   field_prefix = "database"
)
#>      [,1]                  [,2]                            
#> [1,] "database[1]"         "[MITIAM, MRI:00100079, HMDB, ]"
#> [2,] "database[1]-prefix"  "hmdb"                          
#> [3,] "database[1]-version" "3.6"                           
#> [4,] "database[1]-uri"     "http://www.hmdb.ca"            
#> [5,] "database[2]"         "[,, de novo, ]"                
#> [6,] "database[2]-prefix"  "dn"                            
#> [7,] "database[2]-version" "Unknown"                       
#> [8,] "database[2]-uri"     "null"                          
```
