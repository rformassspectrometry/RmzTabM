# Create a skeleton MTD section with general information

This *core* MTD section allows to describe the general experimental
setup and provides general information of the data set. It should
contain references to **all** controlled vocabulary (CV) ontologies used
and refered to in the mzTab-M file. The `mtd_skeleton()` function
creates a two-column `matrix` with the basic mzTab-M *MTD* section based
on the provided data. The returned result contains only minimal
information. It should be expanded, corrected and completed with
additional fields and information (i.e., the *skeleton* returned by this
function should be completed with *flesh*).

For details and expected input for the various parameter it is
**strongly suggested** to consult the
[mzTab-M](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section)
documentation.

## Usage

``` r
mtd_skeleton(
  id = character(),
  software = character(),
  quantification_method = "[MS, MS:1001834, LC-MS label-free quantitation analysis, ]",
  cv_label = c("MS", "PRIDE"),
  cv_full_name = c("PSI-MS controlled vocabulary",
    "PRIDE PRoteomics IDEntifications (PRIDE) database controlled vocabulary"),
  cv_version = c("4.1.138", "16:10:2023 11:38"),
  cv_uri = c("https://raw.githubusercontent.com/HUPO-PSI/psi-ms-CV/master/psi-ms.obo",
    "https://www.ebi.ac.uk/ols/ontologies/pride"),
  database = c("[,, \"no database\", null ]"),
  database_prefix = c("null"),
  database_version = c("Unknown"),
  database_uri = c("null"),
  small_molecule_quantification_unit =
    "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]",
  small_molecule_feature_quantification_unit =
    "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]",
  small_molecule_identification_reliability =
    "[MS, MS:1002896, compound identification confidence level, ]",
  mztab_version = "2.0.0-M"
)
```

## Arguments

- id:

  `character(1)` (**mandatory**) with the ID of the data set.

- software:

  `character` (**mandatory**) with the software(s) used. Can be of
  length \> 1 if multiple softwares were used. Software should be
  provided in the order in which they were used.

- quantification_method:

  `character(1)` defining the quantification method used in the
  experiment.

- cv_label:

  `character` describing the labels of the controlled
  vocabularies/ontologies used in the mzTab file as a short-hand, e.g.
  `cv_label = "MS"` for PSI-MS.

- cv_full_name:

  `character` with the full names of the controlled
  vocabularies/ontologies used in the mzTab file.

- cv_version:

  `character` with the version of the used vocabularies/ontologies.

- cv_uri:

  `character` with the URIs of the vocabularies/ontologies.

- database:

  `character` defining the database used for annotation. If no
  annotation/identification was performed then
  `"[,, no database, null]"` should be used.

- database_prefix:

  `character` defining the prefix used in the *identifier* column of
  data tables. For *no database*, `"null"` must be used.

- database_version:

  `character` with the database version used.

- database_uri:

  `character` with the URI to the database(s). For *no database*
  `"null"` must be used.

- small_molecule_quantification_unit:

  `character(1)` defines the type of units are reported in the small
  molecule summary quantification/ abundance fields.

- small_molecule_feature_quantification_unit:

  `character(1)` defines what type of units are reported in the small
  molecule feature quantification / abundance fields.

- small_molecule_identification_reliability:

  `character(1)` defines the system used for giving reliability /
  confidence codes to small molecule identifications MUST be specified
  if not using the default codes.

- mztab_version:

  `character(1)` defining the mzTab-M version of the file.

## Value

two-column `character` `matrix` that should be expanded with additional
fields (such as *title*, *description* etc) and information (with the
help from the
[`mtd_fields()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_fields.md)
function).

## See also

[MTD-export](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-export.md)
for other functions defining metadata information

## Author

Philippine Louail, Johannes Rainer

## Examples

``` r

## Define a minimal mzTab-M metadata information
mtd <- mtd_skeleton(id = "001", software = "[MS, MS:1001582, xmcs, 4.0.0]")

## Column 1 has the field names
mtd[, 1]
#>  [1] "mzTab-version"                             
#>  [2] "mzTab-ID"                                  
#>  [3] "software[1]"                               
#>  [4] "quantification_method"                     
#>  [5] "cv[1]-label"                               
#>  [6] "cv[1]-full_name"                           
#>  [7] "cv[1]-version"                             
#>  [8] "cv[1]-uri"                                 
#>  [9] "cv[2]-label"                               
#> [10] "cv[2]-full_name"                           
#> [11] "cv[2]-version"                             
#> [12] "cv[2]-uri"                                 
#> [13] "database[1]"                               
#> [14] "database[1]-prefix"                        
#> [15] "database[1]-version"                       
#> [16] "database[1]-uri"                           
#> [17] "small_molecule-quantification_unit"        
#> [18] "small_molecule_feature-quantification_unit"
#> [19] "small_molecule-identification_reliability" 

## Column 2 the respective values
mtd[, 2]
#>  [1] "2.0.0-M"                                                                
#>  [2] "id"                                                                     
#>  [3] "[MS, MS:1001582, xmcs, 4.0.0]"                                          
#>  [4] "[MS, MS:1001834, LC-MS label-free quantitation analysis, ]"             
#>  [5] "MS"                                                                     
#>  [6] "PSI-MS controlled vocabulary"                                           
#>  [7] "4.1.138"                                                                
#>  [8] "https://raw.githubusercontent.com/HUPO-PSI/psi-ms-CV/master/psi-ms.obo" 
#>  [9] "PRIDE"                                                                  
#> [10] "PRIDE PRoteomics IDEntifications (PRIDE) database controlled vocabulary"
#> [11] "16:10:2023 11:38"                                                       
#> [12] "https://www.ebi.ac.uk/ols/ontologies/pride"                             
#> [13] "[,, \"no database\", null ]"                                            
#> [14] "null"                                                                   
#> [15] "Unknown"                                                                
#> [16] "null"                                                                   
#> [17] "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]"                
#> [18] "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]"                
#> [19] "[MS, MS:1002896, compound identification confidence level, ]"           

## Add additional fields as defined in the mzTab-M definition
mtd <- rbind(
    mtd,
    c("title", "My simple xcms preprocessed data"),
    c("description", "A simple example xcms preprocessing."))

tail(mtd)
#>       [,1]                                        
#> [16,] "database[1]-uri"                           
#> [17,] "small_molecule-quantification_unit"        
#> [18,] "small_molecule_feature-quantification_unit"
#> [19,] "small_molecule-identification_reliability" 
#> [20,] "title"                                     
#> [21,] "description"                               
#>       [,2]                                                          
#> [16,] "null"                                                        
#> [17,] "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]"     
#> [18,] "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]"     
#> [19,] "[MS, MS:1002896, compound identification confidence level, ]"
#> [20,] "My simple xcms preprocessed data"                            
#> [21,] "A simple example xcms preprocessing."                        

## Add instrument information
instr <- mtd_fields(
    name = "[MS, MS:1000449, LTQ Orbitrap,]",
    source = "[MS, MS:1000073, ESI,]",
    `analyzer[1]` = "[MS, MS:1000291, linear ion trap,]",
    detector = "[MS, MS:1000253, electron multiplier,]",
    field_prefix = "instrument"
)
instr
#>      [,1]                        [,2]                                    
#> [1,] "instrument[1]-name"        "[MS, MS:1000449, LTQ Orbitrap,]"       
#> [2,] "instrument[1]-source"      "[MS, MS:1000073, ESI,]"                
#> [3,] "instrument[1]-analyzer[1]" "[MS, MS:1000291, linear ion trap,]"    
#> [4,] "instrument[1]-detector"    "[MS, MS:1000253, electron multiplier,]"

## Add this information to the metadata
mtd <- rbind(mtd, instr)

## Define sample processing fields using the mtd_fields function
sp <- mtd_fields(
    c("[MSIO, MSIO:0000146, centrifugation,]",
      "[MSIO, MSIO:0000141, metabolite extraction,]",
      "[MSIO, MSIO:0000141, silylation,]"),
    field_prefix = "sample_processing")
sp
#>      [,1]                   [,2]                                          
#> [1,] "sample_processing[1]" "[MSIO, MSIO:0000146, centrifugation,]"       
#> [2,] "sample_processing[2]" "[MSIO, MSIO:0000141, metabolite extraction,]"
#> [3,] "sample_processing[3]" "[MSIO, MSIO:0000141, silylation,]"           

## Add this information to the metadata
mtd <- rbind(mtd, sp)

## Since a new ontology was used for the sample processing, we need also to
## add that to the metadata. We manually define the fields to add using
## `"cv[3]"` because there are already 2 CVs defined in the MTD skeleton.
cv2 <- rbind(
    c("cv[3]-label", "MSIO"),
    c("cv[3]-full_name", "Metabolomics Standards Initiative Ontology"),
    c("cv[3]-version", "1.0.1"),
    c("cv[3]-uri", "http://purl.obolibrary.org/obo/msio.owl")
)

## Add this information to the metadata
mtd <- rbind(mtd, cv2)

## Finally sort the metadata fields according to the expected order
mtd <- mtd_sort(mtd)
mtd
#>       [,1]                                        
#>  [1,] "mzTab-version"                             
#>  [2,] "mzTab-ID"                                  
#>  [3,] "title"                                     
#>  [4,] "description"                               
#>  [5,] "instrument[1]-name"                        
#>  [6,] "instrument[1]-source"                      
#>  [7,] "instrument[1]-analyzer[1]"                 
#>  [8,] "instrument[1]-detector"                    
#>  [9,] "software[1]"                               
#> [10,] "quantification_method"                     
#> [11,] "sample_processing[1]"                      
#> [12,] "sample_processing[2]"                      
#> [13,] "sample_processing[3]"                      
#> [14,] "cv[1]-label"                               
#> [15,] "cv[1]-full_name"                           
#> [16,] "cv[1]-version"                             
#> [17,] "cv[1]-uri"                                 
#> [18,] "cv[2]-label"                               
#> [19,] "cv[2]-full_name"                           
#> [20,] "cv[2]-version"                             
#> [21,] "cv[2]-uri"                                 
#> [22,] "cv[3]-label"                               
#> [23,] "cv[3]-full_name"                           
#> [24,] "cv[3]-version"                             
#> [25,] "cv[3]-uri"                                 
#> [26,] "database[1]"                               
#> [27,] "database[1]-prefix"                        
#> [28,] "database[1]-version"                       
#> [29,] "database[1]-uri"                           
#> [30,] "small_molecule-quantification_unit"        
#> [31,] "small_molecule_feature-quantification_unit"
#> [32,] "small_molecule-identification_reliability" 
#>       [,2]                                                                     
#>  [1,] "2.0.0-M"                                                                
#>  [2,] "id"                                                                     
#>  [3,] "My simple xcms preprocessed data"                                       
#>  [4,] "A simple example xcms preprocessing."                                   
#>  [5,] "[MS, MS:1000449, LTQ Orbitrap,]"                                        
#>  [6,] "[MS, MS:1000073, ESI,]"                                                 
#>  [7,] "[MS, MS:1000291, linear ion trap,]"                                     
#>  [8,] "[MS, MS:1000253, electron multiplier,]"                                 
#>  [9,] "[MS, MS:1001582, xmcs, 4.0.0]"                                          
#> [10,] "[MS, MS:1001834, LC-MS label-free quantitation analysis, ]"             
#> [11,] "[MSIO, MSIO:0000146, centrifugation,]"                                  
#> [12,] "[MSIO, MSIO:0000141, metabolite extraction,]"                           
#> [13,] "[MSIO, MSIO:0000141, silylation,]"                                      
#> [14,] "MS"                                                                     
#> [15,] "PSI-MS controlled vocabulary"                                           
#> [16,] "4.1.138"                                                                
#> [17,] "https://raw.githubusercontent.com/HUPO-PSI/psi-ms-CV/master/psi-ms.obo" 
#> [18,] "PRIDE"                                                                  
#> [19,] "PRIDE PRoteomics IDEntifications (PRIDE) database controlled vocabulary"
#> [20,] "16:10:2023 11:38"                                                       
#> [21,] "https://www.ebi.ac.uk/ols/ontologies/pride"                             
#> [22,] "MSIO"                                                                   
#> [23,] "Metabolomics Standards Initiative Ontology"                             
#> [24,] "1.0.1"                                                                  
#> [25,] "http://purl.obolibrary.org/obo/msio.owl"                                
#> [26,] "[,, \"no database\", null ]"                                            
#> [27,] "null"                                                                   
#> [28,] "Unknown"                                                                
#> [29,] "null"                                                                   
#> [30,] "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]"                
#> [31,] "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]"                
#> [32,] "[MS, MS:1002896, compound identification confidence level, ]"           
```
