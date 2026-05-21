# mzTab-M *protocol* metadata information

The `mtdProtocol()` function assists in compiling the *protocol*
information of the metadata section. Each protocol is referenced from an
*assay* section (see
[`mtdAssay()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdAssay.md)).

For details and expected input for the various parameter it is
**strongly suggested** to consult the
[mzTab-M](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section)
documentation.

## Usage

``` r
mtdProtocol(
  name = character(),
  type = character(),
  description = character(),
  parameters = character()
)
```

## Arguments

- name:

  `character` with protocol name describing one or more steps of an
  experimental procedure, such as sample preparation, data acquisition
  or data processing.

- type:

  `character` with the protocol type, as defined by the parameter. Can
  be of length 1 or equal to `length(name)`.

- description:

  optional `character` with the description of the protocol. Can be of
  length 1 or equal to `length(name)`.

- parameters:

  optional `character` with additional parameters of the protocol

## Value

two-column `character` `matrix` with the content for the protocol
metadata section.

## See also

[MTD-export](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-export.md)
for other functions defining metadata information

## Author

Gabriele Tomè

## Examples

``` r

## Minimal example with protocol.
mtdProtocol(name = c("protocol1", "protocol2", "protocol3"),
            type = c("[,,,type1]", "[,,,type2]", "[,,,type3]"))
#>                                     
#> [1,] "protocol[1]-name" "protocol1" 
#> [2,] "protocol[1]-type" "[,,,type1]"
#> [3,] "protocol[2]-name" "protocol2" 
#> [4,] "protocol[2]-type" "[,,,type2]"
#> [5,] "protocol[3]-name" "protocol3" 
#> [6,] "protocol[3]-type" "[,,,type3]"

## Example with all the fields
mtdProtocol(name = c("protocol1", "protocol2", "protocol3"),
            type = c("[,,,type]", "[,,,type2]", "[,,,type3]"),
            description = c("description1", "description2", "description3"),
            parameters = list(c("param1.1", "param1.2"), "param2", "param3"))
#>                                                
#>  [1,] "protocol[1]-name"         "protocol1"   
#>  [2,] "protocol[1]-type"         "[,,,type]"   
#>  [3,] "protocol[1]-description"  "description1"
#>  [4,] "protocol[1]-parameter[1]" "param1.1"    
#>  [5,] "protocol[1]-parameter[2]" "param1.2"    
#>  [6,] "protocol[2]-name"         "protocol2"   
#>  [7,] "protocol[2]-type"         "[,,,type2]"  
#>  [8,] "protocol[2]-description"  "description2"
#>  [9,] "protocol[2]-parameter[1]" "param2"      
#> [10,] "protocol[3]-name"         "protocol3"   
#> [11,] "protocol[3]-type"         "[,,,type3]"  
#> [12,] "protocol[3]-description"  "description3"
#> [13,] "protocol[3]-parameter[1]" "param3"      
```
