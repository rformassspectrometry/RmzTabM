# Add or Update protocol Metadata of an mzTab-M MTD section

`setMtdProtocol()` sets or updates protocol-related metadata fields
within an MTD (metadata) section. When protocol metadata already exists,
the function can either replace it entirely or append new values to the
existing ones. Each protocol is referenced from an *assay* section (see
[`mtdAssay()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdAssay.md)).

`getMtdProtocol()` returns the protocol information from an MTD section.

## Usage

``` r
# S4 method for class 'dfmatrix'
setMtdProtocol(
  x = matrix(),
  name = character(),
  type = character(),
  description = character(),
  parameters = character(),
  replace = FALSE
)

getMtdProtocol(x = matrix())
```

## Arguments

- x:

  A MTD section that stores metadata fields. Can be a two-column
  `character` matrix, a two-column `data.frame` or a
  [`MzTabM()`](https://rformassspectrometry.github.io/RmzTabM/reference/MzTabM.md)
  object. Defaults to [`matrix()`](https://rdrr.io/r/base/matrix.html).
  If all values are `NA`, the function returns `x` unchanged.

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

- replace:

  `logical` flag controlling how pre-existing contact metadata is
  handled:

  - `FALSE` (default): new values are appended to any existing values.

  - `TRUE`: existing instrument metadata is discarded and replaced
    entirely by the supplied arguments.

## Value

- For `setMtdProtocol()`: the input object `x` updated to include the
  new or merged protocol metadata fields. If `x` is empty, the empty
  `x`.

- For `getMtdProtocol()`: a named `character` with the protocol
  information, names being the field names.

## Author

Gabriele Tomè

## Examples

``` r

x <- mtdSkeleton("001", software = "[MS, MS:1001582, xmcs, 4.0.0]")
## Minimal example with protocol.
mtd <- setMtdProtocol(x, name = c("Mass Spectrometry"),
       type = c("[CHMO, CHMO:0000470, mass spectrometry, ]"),
       description = c("Eluting compounds were detected ..."),
       parameters = paste0("[MS, MS:1000008, ionization type, ",
                           "[MS,MS:1000073, electrospray ionization, ]]"))

## Example with all the fields and replace the previous
mtd <- setMtdProtocol(mtd, name = c("Mass Spectrometry", "extraction"),
            type = c("[CHMO, CHMO:0000470, mass spectrometry, ]",
                     "[MSIO, MSIO:0000141, metabolite extraction,]"),
            description = c("Eluting compounds were detected ...",
                            "Extraction using 80% methanol"),
            parameters = list(c(paste0("[MS, MS:1000008, ionization type, ",
                              "[MS,MS:1000073, electrospray ionization, ]]"),
                              "param1.2"),
                              paste0("[MSIO, MSIO:0000107, quenching, ",
                                 "[MSIO, MSIO:0000109, liquid nitrogen,]]")),
            replace = TRUE)

getMtdProtocol(mtd)
#>                                                                protocol[1]-name 
#>                                                             "Mass Spectrometry" 
#>                                                                protocol[1]-type 
#>                                     "[CHMO, CHMO:0000470, mass spectrometry, ]" 
#>                                                         protocol[1]-description 
#>                                           "Eluting compounds were detected ..." 
#>                                                        protocol[1]-parameter[1] 
#> "[MS, MS:1000008, ionization type, [MS,MS:1000073, electrospray ionization, ]]" 
#>                                                        protocol[1]-parameter[2] 
#>                                                                      "param1.2" 
#>                                                                protocol[2]-name 
#>                                                                    "extraction" 
#>                                                                protocol[2]-type 
#>                                  "[MSIO, MSIO:0000141, metabolite extraction,]" 
#>                                                         protocol[2]-description 
#>                                                 "Extraction using 80% methanol" 
#>                                                        protocol[2]-parameter[1] 
#>       "[MSIO, MSIO:0000107, quenching, [MSIO, MSIO:0000109, liquid nitrogen,]]" 
```
