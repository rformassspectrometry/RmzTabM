# Defining and exporting the mzTab-M metadata table

The metadata section/table of the mzTab-M definition is comprehensive,
but also tricky to define. The *RmzTabM* package provides a variety of
utility functions that help defining this information. These might be
re-used for software package developers to export metabolomics results
from their respective software. Importantly, the helper functions listed
here only define the core elements for the MTD section, helping with
re-arranging and reformatting information available e.g. in `data.frame`
format into the respective fields in the MTD section. Additional
(optional) fields might need to be added manually depending on
availability for an experiment.

See also the [specification of the MTD
section](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section)
for details and more information, in particular on the format of the
mzTab-M and on mandatory or optional fields.

Generally, MTD data can be categorized into the following parts:

- *Core information*: general information on the experiment. A minimal
  set can be created using the
  [`mtd_skeleton()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_skeleton.md)
  function, which might be further expanded with additional fields. This
  section allows to describe the general experimental setup. Also, it
  should contain references to **all** controlled vocabulary (CV)
  ontologies used and refered to in the mzTab-M file.

- *Sample information*: optional information on individual samples that
  were measured with the various *assays*/*runs*. The
  [`mtd_sample()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_sample.md)
  function assists in compiling the information for this section.

- *MS run information*: information on the individual MS *runs*
  (measurements of the samples). Each data file is one run. Use the
  [`mtd_ms_run()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_ms_run.md)
  function to define this part of the metadata section.

- *Assay information*: the
  [`mtd_assay()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_assay.md)
  function assists in compiling the assay section of the metadata.
  Mandatory fields are the name (ID) of the assay and the reference to
  the *MS run* in which the assay was measured. Optional information on
  sample reference, external links or custom information can be provided
  too. In most cases (except multiplexed assays or pre-fractionated
  samples) one assay will link to one MS run. Each assay **must**
  represent one column in the following *abundance matrix* sections.

- *Study variable information*: the
  [`mtd_study_variables()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_study_variables.md)
  function allows to format study variable information from an
  experiment into the mzTab-M format. All study variables need to be
  assigned to at least one assay and must also be reported in the
  subsequent abundance matrices.

The helper function listed above can be used sequentially to create the
metadata information. See the examples below for a general approach how
to define the MTD section of an experiment.

In addition, various helper functions are available to assist in MTD
data generation:

- [`mtd_sort()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_sort.md):
  to sort the MTD `matrix` into the expected order.

- [`mtd_fields()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_fields.md):
  helps formatting values into the mzTab-M-specific format.

## Note

The general relationship between *ms_run*, *assay* and *sample*:

- one *ms_run* is the measurement of one assay.

- one assay can be measured by several MS runs (if fractionated) or
  multiple assays can be measured in the same MS run (if multiplexed).

- one assay is (generally) one sample, but the same sample can be
  measured with multiple assays.

## See also

[SMF-export](https://rformassspectrometry.github.io/RmzTabM/reference/SMF-export.md)
and
[SML-export](https://rformassspectrometry.github.io/RmzTabM/reference/SML-export.md)
for creating and formatting the small molecule feature (SMF) and small
molecule (SML) sections.

## Author

Philippine Louail, Johannes Rainer

## Examples

``` r

## Building the mzTab-M metadata information from a `data.frame` with sample
## information of an experiment. Each row in that `data.frame` is one
## measurement of one sample (i.e., represents one *ms_run*). Columns in
## that `data.frame` provide the phenotypic and experimental variables of
## each sample. The example below represents a simple experiment in which
## 3 samples (e.g. cell lines) were measured. Columns *time_point and
## *cell_count* provide the time point (in hours) when samples were
## collected and the number of cells per sample. In addition, one
## sample has the genotype *WT* and two *KO*. Column `"operator"` contains
## the initials of the researcher extracting the samples
exp <- data.frame(
    sample_name = c("S1_T1", "S1_T2", "S2_T1", "S2_T2", "S3_T1", "S3_T2"),
    sample_id = c("S1", "S1", "S2", "S2", "S3", "S3"),
    time_point = c(0, 6, 0, 6, 0, 6),
    cell_count = c(13000, 8700, 10100, 6000, 14000, 4500),
    genotype = c("WT", "WT", "KO", "KO", "KO", "KO"),
    operator = c("BB", "BB", "BB", "BB", "FB", "FB"),
    file_name = c("s1-t1.mzML", "s1-t2.mzML", "s2-t1.mzML", "s2-t2.mzML",
                  "s3-t1.mzML", "s3-t2.mzML")
)
exp
#>   sample_name sample_id time_point cell_count genotype operator  file_name
#> 1       S1_T1        S1          0      13000       WT       BB s1-t1.mzML
#> 2       S1_T2        S1          6       8700       WT       BB s1-t2.mzML
#> 3       S2_T1        S2          0      10100       KO       BB s2-t1.mzML
#> 4       S2_T2        S2          6       6000       KO       BB s2-t2.mzML
#> 5       S3_T1        S3          0      14000       KO       FB s3-t1.mzML
#> 6       S3_T2        S3          6       4500       KO       FB s3-t2.mzML


#############################################################################
## Core metadata information

## We first compile the general metadata information. For the present
## example we assume that we performed only preprocessing of the raw MS
## data using *xcms*, thus we don't specify annotation databases used for
## the compound identification/annotation. These could be provided through
## the `database*` parameters. Also, the quantification method and unit(s)
## could be specified using respective parameters of the function.
mtd <- mtd_skeleton(
    id = "EXP_001",
    software = "[MS, MS:1001582], xcms, 4.0.0")
mtd
#>       [,1]                                        
#>  [1,] "mzTab-version"                             
#>  [2,] "mzTab-ID"                                  
#>  [3,] "software[1]"                               
#>  [4,] "quantification_method"                     
#>  [5,] "cv[1]-label"                               
#>  [6,] "cv[1]-full_name"                           
#>  [7,] "cv[1]-version"                             
#>  [8,] "cv[1]-uri"                                 
#>  [9,] "cv[2]-label"                               
#> [10,] "cv[2]-full_name"                           
#> [11,] "cv[2]-version"                             
#> [12,] "cv[2]-uri"                                 
#> [13,] "cv[3]-label"                               
#> [14,] "cv[3]-full_name"                           
#> [15,] "cv[3]-version"                             
#> [16,] "cv[3]-uri"                                 
#> [17,] "database[1]"                               
#> [18,] "database[1]-prefix"                        
#> [19,] "database[1]-version"                       
#> [20,] "database[1]-uri"                           
#> [21,] "small_molecule-quantification_unit"        
#> [22,] "small_molecule_feature-quantification_unit"
#> [23,] "small_molecule-identification_reliability" 
#>       [,2]                                                                     
#>  [1,] "2.1.0-M"                                                                
#>  [2,] "EXP_001"                                                                
#>  [3,] "[MS, MS:1001582], xcms, 4.0.0"                                          
#>  [4,] "[MS, MS:1001834, LC-MS label-free quantitation analysis, ]"             
#>  [5,] "MS"                                                                     
#>  [6,] "PSI-MS controlled vocabulary"                                           
#>  [7,] "4.1.138"                                                                
#>  [8,] "https://raw.githubusercontent.com/HUPO-PSI/psi-ms-CV/master/psi-ms.obo" 
#>  [9,] "PRIDE"                                                                  
#> [10,] "PRIDE PRoteomics IDEntifications (PRIDE) database controlled vocabulary"
#> [11,] "16:10:2023 11:38"                                                       
#> [12,] "https://www.ebi.ac.uk/ols/ontologies/pride"                             
#> [13,] "STATO"                                                                  
#> [14,] "General purpose STATistics Ontology"                                    
#> [15,] "2026-04-20"                                                             
#> [16,] "https://www.ebi.ac.uk/ols4/ontologies/stato"                            
#> [17,] "[,, \"no database\", null ]"                                            
#> [18,] "null"                                                                   
#> [19,] "Unknown"                                                                
#> [20,] "null"                                                                   
#> [21,] "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]"                
#> [22,] "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]"                
#> [23,] "[MS, MS:1002896, compound identification confidence level, ]"           

## We next manually add a title and description for the experiment.
mtd <- rbind(
    mtd,
    c("title", "Experiment 1 preprocessed data"),
    c("description", "The preprocessed data of the experiment 1 samples."))

## We also add information on the MS instrumentation used
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

## Other information, such as employed sample processing methods could be
## added in a similar way.


#############################################################################
## Sample information

## We next add sample information to the metadata. In addition to the
## specific sample properties that can be defined using the function's
## parameters, arbitrary custom fields can be defined too. Below we add
## information on sample extraction as custom information.
mtd_s <- mtd_sample(
    sample = unique(exp$sample_id),
    species = "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]",
    tissue = "[BTO, BTO:0000759, liver, ]",
    cell_type = "[CL, CL:0000182, hepatocyte, ]",
    c("[,,Extraction date, 2011-12-21]",
      "[,,Extraction date, 2011-12-22]",
      "[,,Extraction date, 2011-12-23]")
    )
#> 1
mtd_s
#>                                                                             
#>  [1,] "sample[1]"              "S1"                                         
#>  [2,] "sample[1]-species[1]"   "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"
#>  [3,] "sample[1]-tissue[1]"    "[BTO, BTO:0000759, liver, ]"                
#>  [4,] "sample[1]-cell_type[1]" "[CL, CL:0000182, hepatocyte, ]"             
#>  [5,] "sample[1]-custom[1]"    "[,,Extraction date, 2011-12-21]"            
#>  [6,] "sample[2]"              "S2"                                         
#>  [7,] "sample[2]-species[1]"   "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"
#>  [8,] "sample[2]-tissue[1]"    "[BTO, BTO:0000759, liver, ]"                
#>  [9,] "sample[2]-cell_type[1]" "[CL, CL:0000182, hepatocyte, ]"             
#> [10,] "sample[2]-custom[1]"    "[,,Extraction date, 2011-12-22]"            
#> [11,] "sample[3]"              "S3"                                         
#> [12,] "sample[3]-species[1]"   "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"
#> [13,] "sample[3]-tissue[1]"    "[BTO, BTO:0000759, liver, ]"                
#> [14,] "sample[3]-cell_type[1]" "[CL, CL:0000182, hepatocyte, ]"             
#> [15,] "sample[3]-custom[1]"    "[,,Extraction date, 2011-12-23]"            

mtd <- rbind(mtd, mtd_s)


#############################################################################
## MS run information

## The MS run information should capture information of each individual
## measurement run on an MS instrument. For this, the original data file
## names and location should be provided as well as the format of the
## data files as well as polarity etc.
mtd_msr <- mtd_ms_run(
    location = exp$file_name,
    format = "[MS, MS:1000584, mzML file, ]",
    id_format = "[MS, MS:1000530, mzML unique identifier, ]",
    scan_polarity = "positive")

mtd <- rbind(mtd, mtd_msr)


#############################################################################
## Assay information

## Each measurement should be associated to (at least) one assay. For our
## simple example, each row in the `data.frame` represents one assay, with
## each assay being measured in one MS run.
a <- mtd_assay(
    assay = exp$sample_name,
    sample_ref = c("sample[1]", "sample[1]", "sample[2]", "sample[2]",
                   "sample[3]", "sample[3]"),
    ms_run_ref = paste0("ms_run[", seq_len(nrow(exp)), "]")
)
#> 0
a
#>                                        
#>  [1,] "assay[1]"            "S1_T1"    
#>  [2,] "assay[1]-sample_ref" "sample[1]"
#>  [3,] "assay[1]-ms_run_ref" "ms_run[1]"
#>  [4,] "assay[2]"            "S1_T2"    
#>  [5,] "assay[2]-sample_ref" "sample[1]"
#>  [6,] "assay[2]-ms_run_ref" "ms_run[2]"
#>  [7,] "assay[3]"            "S2_T1"    
#>  [8,] "assay[3]-sample_ref" "sample[2]"
#>  [9,] "assay[3]-ms_run_ref" "ms_run[3]"
#> [10,] "assay[4]"            "S2_T2"    
#> [11,] "assay[4]-sample_ref" "sample[2]"
#> [12,] "assay[4]-ms_run_ref" "ms_run[4]"
#> [13,] "assay[5]"            "S3_T1"    
#> [14,] "assay[5]-sample_ref" "sample[3]"
#> [15,] "assay[5]-ms_run_ref" "ms_run[5]"
#> [16,] "assay[6]"            "S3_T2"    
#> [17,] "assay[6]-sample_ref" "sample[3]"
#> [18,] "assay[6]-ms_run_ref" "ms_run[6]"

mtd <- rbind(mtd, a)


#############################################################################
## Study variable information

## Study variables can be defined directly from the experiment `data.frame`.
## In our example we use the columns (information on) `"time_point"`,
## `"genotype"`, `"cell_count"` and `"operator"`. Importantly, the row-order
## of the provided `data.frame` has to match the order of the assays (and
## MS runs).
svar <- mtd_study_variables(
    exp, groups = c("time_point", "genotype", "cell_count", "operator"))
svar
#>       [,1]                                   
#>  [1,] "study_variable_group[1]"              
#>  [2,] "study_variable_group[1]-description"  
#>  [3,] "study_variable_group[1]-type"         
#>  [4,] "study_variable_group[1]-datatype"     
#>  [5,] "study_variable_group[2]"              
#>  [6,] "study_variable_group[2]-description"  
#>  [7,] "study_variable_group[2]-type"         
#>  [8,] "study_variable_group[2]-datatype"     
#>  [9,] "study_variable_group[3]"              
#> [10,] "study_variable_group[3]-description"  
#> [11,] "study_variable_group[3]-type"         
#> [12,] "study_variable_group[3]-datatype"     
#> [13,] "study_variable_group[4]"              
#> [14,] "study_variable_group[4]-description"  
#> [15,] "study_variable_group[4]-type"         
#> [16,] "study_variable_group[4]-datatype"     
#> [17,] "study_variable[1]"                    
#> [18,] "study_variable[1]-assay_refs"         
#> [19,] "study_variable[1]-average_function"   
#> [20,] "study_variable[1]-variation_function" 
#> [21,] "study_variable[1]-description"        
#> [22,] "study_variable[1]-group_refs"         
#> [23,] "study_variable[2]"                    
#> [24,] "study_variable[2]-assay_refs"         
#> [25,] "study_variable[2]-average_function"   
#> [26,] "study_variable[2]-variation_function" 
#> [27,] "study_variable[2]-description"        
#> [28,] "study_variable[2]-group_refs"         
#> [29,] "study_variable[3]"                    
#> [30,] "study_variable[3]-assay_refs"         
#> [31,] "study_variable[3]-average_function"   
#> [32,] "study_variable[3]-variation_function" 
#> [33,] "study_variable[3]-description"        
#> [34,] "study_variable[3]-group_refs"         
#> [35,] "study_variable[4]"                    
#> [36,] "study_variable[4]-assay_refs"         
#> [37,] "study_variable[4]-average_function"   
#> [38,] "study_variable[4]-variation_function" 
#> [39,] "study_variable[4]-description"        
#> [40,] "study_variable[4]-group_refs"         
#> [41,] "study_variable[5]"                    
#> [42,] "study_variable[5]-assay_refs"         
#> [43,] "study_variable[5]-average_function"   
#> [44,] "study_variable[5]-variation_function" 
#> [45,] "study_variable[5]-description"        
#> [46,] "study_variable[5]-group_refs"         
#> [47,] "study_variable[6]"                    
#> [48,] "study_variable[6]-assay_refs"         
#> [49,] "study_variable[6]-average_function"   
#> [50,] "study_variable[6]-variation_function" 
#> [51,] "study_variable[6]-description"        
#> [52,] "study_variable[6]-group_refs"         
#> [53,] "study_variable[7]"                    
#> [54,] "study_variable[7]-assay_refs"         
#> [55,] "study_variable[7]-average_function"   
#> [56,] "study_variable[7]-variation_function" 
#> [57,] "study_variable[7]-description"        
#> [58,] "study_variable[7]-group_refs"         
#> [59,] "study_variable[8]"                    
#> [60,] "study_variable[8]-assay_refs"         
#> [61,] "study_variable[8]-average_function"   
#> [62,] "study_variable[8]-variation_function" 
#> [63,] "study_variable[8]-description"        
#> [64,] "study_variable[8]-group_refs"         
#> [65,] "study_variable[9]"                    
#> [66,] "study_variable[9]-assay_refs"         
#> [67,] "study_variable[9]-average_function"   
#> [68,] "study_variable[9]-variation_function" 
#> [69,] "study_variable[9]-description"        
#> [70,] "study_variable[9]-group_refs"         
#> [71,] "study_variable[10]"                   
#> [72,] "study_variable[10]-assay_refs"        
#> [73,] "study_variable[10]-average_function"  
#> [74,] "study_variable[10]-variation_function"
#> [75,] "study_variable[10]-description"       
#> [76,] "study_variable[10]-group_refs"        
#> [77,] "study_variable[11]"                   
#> [78,] "study_variable[11]-assay_refs"        
#> [79,] "study_variable[11]-average_function"  
#> [80,] "study_variable[11]-variation_function"
#> [81,] "study_variable[11]-description"       
#> [82,] "study_variable[11]-group_refs"        
#> [83,] "study_variable[12]"                   
#> [84,] "study_variable[12]-assay_refs"        
#> [85,] "study_variable[12]-average_function"  
#> [86,] "study_variable[12]-variation_function"
#> [87,] "study_variable[12]-description"       
#> [88,] "study_variable[12]-group_refs"        
#>       [,2]                                            
#>  [1,] "time_point"                                    
#>  [2,] "Sample matrix column time_point"               
#>  [3,] "[STATO, STATO:0000251, continuous variable, ]" 
#>  [4,] "xsd:decimal"                                   
#>  [5,] "genotype"                                      
#>  [6,] "Sample matrix column genotype"                 
#>  [7,] "[STATO, STATO:0000252, categorical variable, ]"
#>  [8,] "xsd:string"                                    
#>  [9,] "cell_count"                                    
#> [10,] "Sample matrix column cell_count"               
#> [11,] "[STATO, STATO:0000251, continuous variable, ]" 
#> [12,] "xsd:decimal"                                   
#> [13,] "operator"                                      
#> [14,] "Sample matrix column operator"                 
#> [15,] "[STATO, STATO:0000252, categorical variable, ]"
#> [16,] "xsd:string"                                    
#> [17,] "0"                                             
#> [18,] "assay[1]|assay[3]|assay[5]"                    
#> [19,] "[MS, MS:1002962, mean, ]"                      
#> [20,] "[MS, MS:1002963, variation coefficient, ]"     
#> [21,] "Variable time_point, value 0"                  
#> [22,] "study_variable_group[1]"                       
#> [23,] "6"                                             
#> [24,] "assay[2]|assay[4]|assay[6]"                    
#> [25,] "[MS, MS:1002962, mean, ]"                      
#> [26,] "[MS, MS:1002963, variation coefficient, ]"     
#> [27,] "Variable time_point, value 6"                  
#> [28,] "study_variable_group[1]"                       
#> [29,] "WT"                                            
#> [30,] "assay[1]|assay[2]"                             
#> [31,] "[MS, MS:1002962, mean, ]"                      
#> [32,] "[MS, MS:1002963, variation coefficient, ]"     
#> [33,] "Variable genotype, value WT"                   
#> [34,] "study_variable_group[2]"                       
#> [35,] "KO"                                            
#> [36,] "assay[3]|assay[4]|assay[5]|assay[6]"           
#> [37,] "[MS, MS:1002962, mean, ]"                      
#> [38,] "[MS, MS:1002963, variation coefficient, ]"     
#> [39,] "Variable genotype, value KO"                   
#> [40,] "study_variable_group[2]"                       
#> [41,] "13000"                                         
#> [42,] "assay[1]"                                      
#> [43,] "[MS, MS:1002962, mean, ]"                      
#> [44,] "[MS, MS:1002963, variation coefficient, ]"     
#> [45,] "Variable cell_count, value 13000"              
#> [46,] "study_variable_group[3]"                       
#> [47,] "8700"                                          
#> [48,] "assay[2]"                                      
#> [49,] "[MS, MS:1002962, mean, ]"                      
#> [50,] "[MS, MS:1002963, variation coefficient, ]"     
#> [51,] "Variable cell_count, value 8700"               
#> [52,] "study_variable_group[3]"                       
#> [53,] "10100"                                         
#> [54,] "assay[3]"                                      
#> [55,] "[MS, MS:1002962, mean, ]"                      
#> [56,] "[MS, MS:1002963, variation coefficient, ]"     
#> [57,] "Variable cell_count, value 10100"              
#> [58,] "study_variable_group[3]"                       
#> [59,] "6000"                                          
#> [60,] "assay[4]"                                      
#> [61,] "[MS, MS:1002962, mean, ]"                      
#> [62,] "[MS, MS:1002963, variation coefficient, ]"     
#> [63,] "Variable cell_count, value 6000"               
#> [64,] "study_variable_group[3]"                       
#> [65,] "14000"                                         
#> [66,] "assay[5]"                                      
#> [67,] "[MS, MS:1002962, mean, ]"                      
#> [68,] "[MS, MS:1002963, variation coefficient, ]"     
#> [69,] "Variable cell_count, value 14000"              
#> [70,] "study_variable_group[3]"                       
#> [71,] "4500"                                          
#> [72,] "assay[6]"                                      
#> [73,] "[MS, MS:1002962, mean, ]"                      
#> [74,] "[MS, MS:1002963, variation coefficient, ]"     
#> [75,] "Variable cell_count, value 4500"               
#> [76,] "study_variable_group[3]"                       
#> [77,] "BB"                                            
#> [78,] "assay[1]|assay[2]|assay[3]|assay[4]"           
#> [79,] "[MS, MS:1002962, mean, ]"                      
#> [80,] "[MS, MS:1002963, variation coefficient, ]"     
#> [81,] "Variable operator, value BB"                   
#> [82,] "study_variable_group[4]"                       
#> [83,] "FB"                                            
#> [84,] "assay[5]|assay[6]"                             
#> [85,] "[MS, MS:1002962, mean, ]"                      
#> [86,] "[MS, MS:1002963, variation coefficient, ]"     
#> [87,] "Variable operator, value FB"                   
#> [88,] "study_variable_group[4]"                       

## The individual columns got encoded to a `"study_variable_group"` with a
## defined (statistical) type and a datatype. Both are inferred
## automatically from the columns of the provided `data.frame`, but could
## also be manually provided through the respective function arguments.

mtd <- rbind(mtd, svar)

## Finally, the `mtd_sort()` function can be used to sort the generated
## two-column matrix in the expected order.
mtd <- mtd_sort(mtd)

## This metadata information can next be exported manually, or using the
## dedicated export helper functions to an mzTab-M file.
```
