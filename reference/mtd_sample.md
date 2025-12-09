# msTab-M *sample* metadata information

The `mtd_samples()` function aids in creating and formatting the
(optional) sample information from the mzTab-M metadata section. If
defined, the sample information **must** be correctly linked to from the
*assay* section. In particular, the assays need to link to the index of
the samples defined in this section. One entry for each originating
sample should be defined (without information on experimental
properties). For each sample one or more additional characteristics
(such as `species`, `tissue`, `cell_type` or `disease`) can be provided.
Thus, these parameters expect the input be provided as a `list`. In
addition, if a single value needs to be assigned to each sample, a
`character(1)` of length 1 can be provided with the respective input
parameter.

**Important:** to support the optional additional parameters passed
along with `...` **all** parameters (such as `sample`, `species` etc)
have to be **fully** spelled out.

For details and expected input for the various parameter it is
**strongly suggested** to consult the
[mzTab-M](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section)
documentation.

## Usage

``` r
mtd_sample(
  ...,
  sample = character(),
  species = list(),
  tissue = list(),
  cell_type = list(),
  disease = list(),
  description = character()
)
```

## Arguments

- ...:

  optional *custom* information for each individual sample. Each custom
  variable is expected to be provided as a `character` of length equal
  to the length of parameter `sample`.

- sample:

  `character` with the labels/names of the individual samples.

- species:

  `list` of length equal to `length(sample)` with each element providing
  the species (eventually multiple) for each sample. Can also be a
  `character` of `length(sample)` to assing a single species to each
  `sample`, or a `character(1)` of length one to assign the same species
  to every sample.

- tissue:

  `list` with the tissue(s) of each sample. The same format as described
  for parameter `species` can be used.

- cell_type:

  `list` with the cell type(s) of each sample. The same format as
  described for parameter `species` can be used.

- disease:

  `list` with the disease(s) of each sample. The same format as
  described for parameter `species` can be used.

- description:

  `character` of length equal to `length(sample)` with optional
  description of each sample.

## Value

two column `character` `matrix` with the information formatted as sample
section of the mzTab-M format.

## See also

[MTD-export](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-export.md)
for other functions defining metadata information

## Examples

``` r

## Example sample description data.frame for an experiment
pd <- data.frame(
    sample_name = c("ind_1", "ind_2", "ind_1", "ind_2"),
    sample_id = c("i1_t1", "i2_t2", "i1_t2", "i2_t2"),
    time_point = c(1, 2, 1, 2))

## Define a minimal sample information with just the sample names.
mtd_sample(unique(pd$sample_name))
#>      [,1] [,2]

## Add also species information: each sample from the same species
mtd_sample(
    sample = unique(pd$sample_name),
    species = "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]")
#> 0
#>                                                                          
#> [1,] "sample[1]"            "ind_1"                                      
#> [2,] "sample[1]-species[1]" "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"
#> [3,] "sample[2]"            "ind_2"                                      
#> [4,] "sample[2]-species[1]" "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"

## Assume first sample is a mixture of two species
mtd_sample(
    sample = unique(pd$sample_name),
    species = list(c("[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]",
                     "[NCBITaxon, NCBITaxon:39767, Human rhinovirus 11, ]"),
                   "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]")
)
#> 0
#>                            
#> [1,] "sample[1]"           
#> [2,] "sample[1]-species[1]"
#> [3,] "sample[1]-species[2]"
#> [4,] "sample[2]"           
#> [5,] "sample[2]-species[1]"
#>                                                           
#> [1,] "ind_1"                                              
#> [2,] "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"        
#> [3,] "[NCBITaxon, NCBITaxon:39767, Human rhinovirus 11, ]"
#> [4,] "ind_2"                                              
#> [5,] "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"        

## Add full information including tissue, cell type and disease
mtd_sample(
    sample = unique(pd$sample_name),
    species = list(c("[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]",
                     "[NCBITaxon, NCBITaxon:39767, Human rhinovirus 11, ]"),
                   "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"),
    tissue = "[BTO, BTO:0000759, liver, ]",
    cell_type = "[CL, CL:0000182, hepatocyte, ]",
    disease = list(c("[DOID, DOID:684, hepatocellular carcinoma, ]",
                     "[DOID, DOID:9451, alcoholic fatty liver, ]"),
                   NULL)
)
#> 0
#>                               
#>  [1,] "sample[1]"             
#>  [2,] "sample[1]-species[1]"  
#>  [3,] "sample[1]-species[2]"  
#>  [4,] "sample[1]-tissue[1]"   
#>  [5,] "sample[1]-cell_type[1]"
#>  [6,] "sample[1]-disease[1]"  
#>  [7,] "sample[1]-disease[2]"  
#>  [8,] "sample[2]"             
#>  [9,] "sample[2]-species[1]"  
#> [10,] "sample[2]-tissue[1]"   
#> [11,] "sample[2]-cell_type[1]"
#>                                                            
#>  [1,] "ind_1"                                              
#>  [2,] "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"        
#>  [3,] "[NCBITaxon, NCBITaxon:39767, Human rhinovirus 11, ]"
#>  [4,] "[BTO, BTO:0000759, liver, ]"                        
#>  [5,] "[CL, CL:0000182, hepatocyte, ]"                     
#>  [6,] "[DOID, DOID:684, hepatocellular carcinoma, ]"       
#>  [7,] "[DOID, DOID:9451, alcoholic fatty liver, ]"         
#>  [8,] "ind_2"                                              
#>  [9,] "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"        
#> [10,] "[BTO, BTO:0000759, liver, ]"                        
#> [11,] "[CL, CL:0000182, hepatocyte, ]"                     

## Add also additional custom variables
mtd_sample(sample = c("A", "B"),
    c("[,,Extraction date, 2011-12-21]",
      "[,,Extraction date, 2011-12-22]"),
    c("[,,Extraction reason, liver biopsy]",
      "[,,Extraction reason, liver biopsy]"))
#> 2
#>                                                                 
#> [1,] "sample[1]"           "A"                                  
#> [2,] "sample[1]-custom[1]" "[,,Extraction date, 2011-12-21]"    
#> [3,] "sample[1]-custom[2]" "[,,Extraction reason, liver biopsy]"
#> [4,] "sample[2]"           "B"                                  
#> [5,] "sample[2]-custom[1]" "[,,Extraction date, 2011-12-22]"    
#> [6,] "sample[2]-custom[2]" "[,,Extraction reason, liver biopsy]"
```
