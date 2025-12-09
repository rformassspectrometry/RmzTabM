# mzTab-M *assay* metadata information

The `mtd_assay()` function assists in compiling the *assay* information
of the metadata section. Each assay **must** be associated with at least
one entry of the *ms_run* section (see
[`mtd_ms_run()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_ms_run.md)).
This mapping can be defined with the `ms_run_ref` parameter by providing
the ID/name of the run (e.g. `"ms_run[1]"`).

**Important:** to support the optional additional parameters passed
along with `...` **all** parameters (such as `assay`, `sample_ref` etc)
have to be **fully** spelled out.

For details and expected input for the various parameter it is
**strongly suggested** to consult the
[mzTab-M](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section)
documentation.

## Usage

``` r
mtd_assay(
  ...,
  assay = character(),
  external_uri = character(),
  sample_ref = character(),
  ms_run_ref = character()
)
```

## Arguments

- ...:

  optional additional (custom) parameters for each assay. If provided,
  the length of the `character` vector(s) have to match the length of
  parameter `assay`.

- assay:

  `character` with the names of the assay(s). Each assay **must** be
  reported in the following sections (e.g. the SMF section).

- external_uri:

  optional `character` with a reference to further information about the
  assay, for example via a reference to an object within an ISA-TAB
  file. Can be of length 1 (in which case the same reference is assigned
  to every assay) or length equal to the length of `assay`.

- sample_ref:

  optional `character` with the ID/name of the sample for the assay
  (e.g. `"sample[1]"`). If provided, its length has to match the length
  of `assay`.

- ms_run_ref:

  `character` with the ID of associated *ms_run*(s). For multiplexed
  assays, different assays can refer to the same run. To support
  pre-fractionated samples, it is also possible to provide a `list` of
  `character` with the runs the assay was measured in. See examples
  below for more details.

## Value

two-column `character` `matrix` with the content for the assay metadata
section.

## See also

[MTD-export](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-export.md)
for other functions defining metadata information

## Author

Johannes Rainer

## Examples

``` r

## Minimal example with assay and ms_run_ref defined, each assay assigned
## to its own MS run. Note that for **all** parameters the **full**
## parameter name has to be used (e.g., `assay = `).
mtd_assay(assay = c("a1", "a2", "a3"),
    ms_run_ref = c("ms_run[1]", "ms_run[2]", "ms_run[3]"))
#> 0
#>                                       
#> [1,] "assay[1]"            "a1"       
#> [2,] "assay[1]-ms_run_ref" "ms_run[1]"
#> [3,] "assay[2]"            "a2"       
#> [4,] "assay[2]-ms_run_ref" "ms_run[2]"
#> [5,] "assay[3]"            "a3"       
#> [6,] "assay[3]-ms_run_ref" "ms_run[3]"

## Example for a multiplexed assay.
mtd_assay(assay = c("a1", "a2", "a3"),
    ms_run_ref = c("ms_run[1]", "ms_run[1]", "ms_run[1]"))
#> 0
#>                                       
#> [1,] "assay[1]"            "a1"       
#> [2,] "assay[1]-ms_run_ref" "ms_run[1]"
#> [3,] "assay[2]"            "a2"       
#> [4,] "assay[2]-ms_run_ref" "ms_run[1]"
#> [5,] "assay[3]"            "a3"       
#> [6,] "assay[3]-ms_run_ref" "ms_run[1]"

## Example for a pre-fractionated samples
mtd_assay(assay = c("a1", "a2", "a3"),
    ms_run_ref = list(c("ms_run[1]", "ms_run[2]"),
                      c("ms_run[3]", "ms_run[4]"),
                      c("ms_run[5]", "ms_run[6]")))
#> 0
#>                                           
#>  [1,] "assay[1]"               "a1"       
#>  [2,] "assay[1]-ms_run_ref[1]" "ms_run[1]"
#>  [3,] "assay[1]-ms_run_ref[2]" "ms_run[2]"
#>  [4,] "assay[2]"               "a2"       
#>  [5,] "assay[2]-ms_run_ref[1]" "ms_run[3]"
#>  [6,] "assay[2]-ms_run_ref[2]" "ms_run[4]"
#>  [7,] "assay[3]"               "a3"       
#>  [8,] "assay[3]-ms_run_ref[1]" "ms_run[5]"
#>  [9,] "assay[3]-ms_run_ref[2]" "ms_run[6]"

## Example adding also sample reference and an external_uri
mtd_assay(
    assay = c("a1", "a2", "a3"),
    external_uri = "https://www.ebi.ac.uk/metabolights/MTBLS517/files/i_Investigation.txt",
    sample_ref = c("sample[1]", "sample[1]", "sample[2]"),
    ms_run_ref = c("ms_run[1]", "ms_run[2]", "ms_run[3]"))
#> 0
#>                              
#>  [1,] "assay[1]"             
#>  [2,] "assay[1]-external_uri"
#>  [3,] "assay[1]-sample_ref"  
#>  [4,] "assay[1]-ms_run_ref"  
#>  [5,] "assay[2]"             
#>  [6,] "assay[2]-external_uri"
#>  [7,] "assay[2]-sample_ref"  
#>  [8,] "assay[2]-ms_run_ref"  
#>  [9,] "assay[3]"             
#> [10,] "assay[3]-external_uri"
#> [11,] "assay[3]-sample_ref"  
#> [12,] "assay[3]-ms_run_ref"  
#>                                                                              
#>  [1,] "a1"                                                                   
#>  [2,] "https://www.ebi.ac.uk/metabolights/MTBLS517/files/i_Investigation.txt"
#>  [3,] "sample[1]"                                                            
#>  [4,] "ms_run[1]"                                                            
#>  [5,] "a2"                                                                   
#>  [6,] "https://www.ebi.ac.uk/metabolights/MTBLS517/files/i_Investigation.txt"
#>  [7,] "sample[1]"                                                            
#>  [8,] "ms_run[2]"                                                            
#>  [9,] "a3"                                                                   
#> [10,] "https://www.ebi.ac.uk/metabolights/MTBLS517/files/i_Investigation.txt"
#> [11,] "sample[2]"                                                            
#> [12,] "ms_run[3]"                                                            

## Providing additional, custom information for each assay. These can be
## passed as `character` vectors (same length than `assay`!).
mtd_assay(assay = c("a1", "a2", "a3"),
    ms_run_ref = c("ms_run[1]", "ms_run[2]", "ms_run[3]"),
    c("[MS, , Assay operator, Fred Blogs]",
      "[MS, , Assay operator, Fred Blogs]",
      "[MS, , Assay operator, Frodo]"))
#> 1
#>                                                                 
#>  [1,] "assay[1]"            "a1"                                
#>  [2,] "assay[1]-ms_run_ref" "ms_run[1]"                         
#>  [3,] "assay[1]-custom[1]"  "[MS, , Assay operator, Fred Blogs]"
#>  [4,] "assay[2]"            "a2"                                
#>  [5,] "assay[2]-ms_run_ref" "ms_run[2]"                         
#>  [6,] "assay[2]-custom[1]"  "[MS, , Assay operator, Fred Blogs]"
#>  [7,] "assay[3]"            "a3"                                
#>  [8,] "assay[3]-ms_run_ref" "ms_run[3]"                         
#>  [9,] "assay[3]-custom[1]"  "[MS, , Assay operator, Frodo]"     
```
