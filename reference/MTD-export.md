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

## Author

Philippine Louail, Johannes Rainer

## Examples

``` r

## Building the mzTab-M metadata information from a `data.frame` with sample
## information of an experiment. Each row in that `data.frame` is one
## measurement of one sample (i.e., represents one *ms_run*). Columns in
## that `data.frame` provide the phenotypic and experimental variables of
## each sample. The example below represents a simple experiment in which
## 3 samples (e.g. cell lines) were measured, each at two different time
## points (0 and 6 hours). In addition, one sample has the genotype *WT* and
## two *KO*. Column `"operator"` contains the initials of the researcher
## extracting the samples
exp <- data.frame(
    sample_name = c("S1_T1", "S1_T2", "S2_T1", "S2_T2", "S3_T1", "S3_T2"),
    sample_id = c("S1", "S1", "S2", "S2", "S3", "S3"),
    timepoint = c("0h", "6h", "0h", "6h", "0h", "6h"),
    genotype = c("WT", "WT", "KO", "KO", "KO", "KO"),
    operator = c("BB", "BB", "BB", "BB", "FB", "FB"),
    file_name = c("s1-t1.mzML", "s1-t2.mzML", "s2-t1.mzML", "s2-t2.mzML",
                  "s3-t1.mzML", "s3-t2.mzML")
)
exp
#>   sample_name sample_id timepoint genotype operator  file_name
#> 1       S1_T1        S1        0h       WT       BB s1-t1.mzML
#> 2       S1_T2        S1        6h       WT       BB s1-t2.mzML
#> 3       S2_T1        S2        0h       KO       BB s2-t1.mzML
#> 4       S2_T2        S2        6h       KO       BB s2-t2.mzML
#> 5       S3_T1        S3        0h       KO       FB s3-t1.mzML
#> 6       S3_T2        S3        6h       KO       FB s3-t2.mzML


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
#> [13,] "database[1]"                               
#> [14,] "database[1]-prefix"                        
#> [15,] "database[1]-version"                       
#> [16,] "database[1]-uri"                           
#> [17,] "small_molecule-quantification_unit"        
#> [18,] "small_molecule_feature-quantification_unit"
#> [19,] "small_molecule-identification_reliability" 
#>       [,2]                                                                     
#>  [1,] "2.0.0-M"                                                                
#>  [2,] "id"                                                                     
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
#> [13,] "[,, \"no database\", null ]"                                            
#> [14,] "null"                                                                   
#> [15,] "Unknown"                                                                
#> [16,] "null"                                                                   
#> [17,] "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]"                
#> [18,] "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]"                
#> [19,] "[MS, MS:1002896, compound identification confidence level, ]"           

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
## In our example we use the columns (information on) `"timepoint"`,
## `"genotype"` and `"operator"`. Importantly, the order of the provided
## `data.frame` has to match the order of the assays (and MS runs).
svar <- mtd_study_variables(
    exp,
    study_variable_columns = c("timepoint", "genotype", "operator"))
svar
#>       [,1]                                  
#>  [1,] "study_variable[1]"                   
#>  [2,] "study_variable[1]-assay_refs"        
#>  [3,] "study_variable[1]-average_function"  
#>  [4,] "study_variable[1]-variation_function"
#>  [5,] "study_variable[1]-description"       
#>  [6,] "study_variable[2]"                   
#>  [7,] "study_variable[2]-assay_refs"        
#>  [8,] "study_variable[2]-average_function"  
#>  [9,] "study_variable[2]-variation_function"
#> [10,] "study_variable[2]-description"       
#> [11,] "study_variable[3]"                   
#> [12,] "study_variable[3]-assay_refs"        
#> [13,] "study_variable[3]-average_function"  
#> [14,] "study_variable[3]-variation_function"
#> [15,] "study_variable[3]-description"       
#> [16,] "study_variable[4]"                   
#> [17,] "study_variable[4]-assay_refs"        
#> [18,] "study_variable[4]-average_function"  
#> [19,] "study_variable[4]-variation_function"
#> [20,] "study_variable[4]-description"       
#> [21,] "study_variable[5]"                   
#> [22,] "study_variable[5]-assay_refs"        
#> [23,] "study_variable[5]-average_function"  
#> [24,] "study_variable[5]-variation_function"
#> [25,] "study_variable[5]-description"       
#> [26,] "study_variable[6]"                   
#> [27,] "study_variable[6]-assay_refs"        
#> [28,] "study_variable[6]-average_function"  
#> [29,] "study_variable[6]-variation_function"
#> [30,] "study_variable[6]-description"       
#>       [,2]                                       
#>  [1,] "timepoint:0h"                             
#>  [2,] "assay[1]|assay[3]|assay[5]"               
#>  [3,] "[MS, MS:1002962, mean, ]"                 
#>  [4,] "[MS, MS:1002963, variation coefficient, ]"
#>  [5,] "Column: timepoint, value: 0h"             
#>  [6,] "timepoint:6h"                             
#>  [7,] "assay[2]|assay[4]|assay[6]"               
#>  [8,] "[MS, MS:1002962, mean, ]"                 
#>  [9,] "[MS, MS:1002963, variation coefficient, ]"
#> [10,] "Column: timepoint, value: 6h"             
#> [11,] "genotype:WT"                              
#> [12,] "assay[1]|assay[2]"                        
#> [13,] "[MS, MS:1002962, mean, ]"                 
#> [14,] "[MS, MS:1002963, variation coefficient, ]"
#> [15,] "Column: genotype, value: WT"              
#> [16,] "genotype:KO"                              
#> [17,] "assay[3]|assay[4]|assay[5]|assay[6]"      
#> [18,] "[MS, MS:1002962, mean, ]"                 
#> [19,] "[MS, MS:1002963, variation coefficient, ]"
#> [20,] "Column: genotype, value: KO"              
#> [21,] "operator:BB"                              
#> [22,] "assay[1]|assay[2]|assay[3]|assay[4]"      
#> [23,] "[MS, MS:1002962, mean, ]"                 
#> [24,] "[MS, MS:1002963, variation coefficient, ]"
#> [25,] "Column: operator, value: BB"              
#> [26,] "operator:FB"                              
#> [27,] "assay[5]|assay[6]"                        
#> [28,] "[MS, MS:1002962, mean, ]"                 
#> [29,] "[MS, MS:1002963, variation coefficient, ]"
#> [30,] "Column: operator, value: FB"              

mtd <- rbind(mtd, svar)

## Finally, the `mtd_sort()` function can be used to sort the generated
## two-column matrix in the expected order.
mtd <- mtd_sort(mtd)

## This metadata information can next be exported manually, or using the
## dedicated export helper functions to an mzTab-M file.
```
