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
  [`mtdSkeleton()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdSkeleton.md)
  function, which might be further expanded with additional fields. This
  section allows to describe the general experimental setup. Also, it
  should contain references to **all** controlled vocabulary (CV)
  ontologies used and refered to in the mzTab-M file.

- *Sample information*: optional information on individual samples that
  were measured with the various *assays*/*runs*. The
  [`mtdSample()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdSample.md)
  function assists in compiling the information for this section.

- *MS run information*: information on the individual MS *runs*
  (measurements of the samples). Each data file is one run. Use the
  [`mtdMsRun()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdMsRun.md)
  function to define this part of the metadata section.

- *Assay information*: the
  [`mtdAssay()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdAssay.md)
  function assists in compiling the assay section of the metadata.
  Mandatory fields are the name (ID) of the assay and the reference to
  the *MS run* in which the assay was measured. Optional information on
  sample reference, external links or custom information can be provided
  too. In most cases (except multiplexed assays or pre-fractionated
  samples) one assay will link to one MS run. Each assay **must**
  represent one column in the following *abundance matrix* sections.

- *Study variable information*: the
  [`mtdStudyVariables()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdStudyVariables.md)
  function allows to format study variable information from an
  experiment into the mzTab-M format. All study variables need to be
  assigned to at least one assay and must also be reported in the
  subsequent abundance matrices.

The helper function listed above can be used sequentially to create the
metadata information. See the examples below for a general approach how
to define the MTD section of an experiment.

In addition, various helper functions are available to assist in MTD
data generation:

- [`mtdSort()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdSort.md):
  to sort the MTD `matrix` into the expected order.

- [`mtdFields()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdFields.md):
  helps formatting values into the mzTab-M-specific format.

- [`setMtdInstrument()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdInstrument.md)/[`getMtdInstrument()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdInstrument.md):
  set/get Instrument Metadata in an MTD section.

- [`setMtdDatabase()`](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-database.md)/[`getMtdDatabase()`](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-database.md):
  set/get Database Metadata in an MTD section.

- [`setMtdCv()`](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-CV.md)/[`getMtdCv()`](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-CV.md):
  set/get Controlled Vocabularies (CV) Metadata in an MTD section.

- [`setMtdContact()`](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-contact.md)/[`getMtdContact()`](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-contact.md):
  set/get contact Metadata in an MTD section.

- [`setMtdField()`](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-field.md)/[`getMtdField()`](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-field.md):
  set/get a Metadata Field in an MTD section.

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

[`setMtdInstrument()`](https://rformassspectrometry.github.io/RmzTabM/reference/setMtdInstrument.md),
[MTD-database](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-database.md),
[MTD-CV](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-CV.md),
[MTD-contact](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-contact.md)
and
[MTD-field](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-field.md).

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
mtd <- mtdSkeleton(
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
#>  [3,] "[,,[MS, MS:1001582], xcms, 4.0.0,]"                                     
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

## We can add additional content to this *skeleton* MTD information with
## any of the `setMtd*` functions.
## We next add a title and description for the experiment.
mtd <- setMtdField(mtd, field = "title",
    value = "Experiment 1 preprocessed data")
mtd <- setMtdField(mtd, field = "description",
    value = "The preprocessed data of experiment 1 samples.")

## We also add information on the MS instrumentation used
mtd <- setMtdInstrument(mtd,
    name = "[MS, MS:1000449, LTQ Orbitrap,]",
    source = "[MS, MS:1000073, ESI,]",
    analyzer = c("analyzer[1]" = "[MS, MS:1000291, linear ion trap,]"),
    detector = "[MS, MS:1000253, electron multiplier,]",
)

## We can also add contact information
mtd <- setMtdContact(mtd, name = c("frodo", "sauron"),
    affiliation = c("fellowship of the ring", "the dark side"),
    email = c("frodo@shire.net", "sauron@mordor.net"),
    orcid = c("0000-0001-2345-6789", "0000-0001-2345-678X"))

mtd
#>       field                                       
#>  [1,] "mzTab-version"                             
#>  [2,] "mzTab-ID"                                  
#>  [3,] "title"                                     
#>  [4,] "description"                               
#>  [5,] "instrument[1]-name"                        
#>  [6,] "instrument[1]-source"                      
#>  [7,] "instrument[1]-detector"                    
#>  [8,] "instrument[1]-analyzer[1]"                 
#>  [9,] "software[1]"                               
#> [10,] "contact[1]-name"                           
#> [11,] "contact[1]-affiliation"                    
#> [12,] "contact[1]-email"                          
#> [13,] "contact[1]-orcid"                          
#> [14,] "contact[2]-name"                           
#> [15,] "contact[2]-affiliation"                    
#> [16,] "contact[2]-email"                          
#> [17,] "contact[2]-orcid"                          
#> [18,] "quantification_method"                     
#> [19,] "cv[1]-label"                               
#> [20,] "cv[1]-full_name"                           
#> [21,] "cv[1]-version"                             
#> [22,] "cv[1]-uri"                                 
#> [23,] "cv[2]-label"                               
#> [24,] "cv[2]-full_name"                           
#> [25,] "cv[2]-version"                             
#> [26,] "cv[2]-uri"                                 
#> [27,] "cv[3]-label"                               
#> [28,] "cv[3]-full_name"                           
#> [29,] "cv[3]-version"                             
#> [30,] "cv[3]-uri"                                 
#> [31,] "database[1]"                               
#> [32,] "database[1]-prefix"                        
#> [33,] "database[1]-version"                       
#> [34,] "database[1]-uri"                           
#> [35,] "small_molecule-quantification_unit"        
#> [36,] "small_molecule_feature-quantification_unit"
#> [37,] "small_molecule-identification_reliability" 
#>       value                                                                    
#>  [1,] "2.1.0-M"                                                                
#>  [2,] "EXP_001"                                                                
#>  [3,] "Experiment 1 preprocessed data"                                         
#>  [4,] "The preprocessed data of experiment 1 samples."                         
#>  [5,] "[MS, MS:1000449, LTQ Orbitrap,]"                                        
#>  [6,] "[MS, MS:1000073, ESI,]"                                                 
#>  [7,] "[MS, MS:1000253, electron multiplier,]"                                 
#>  [8,] "[MS, MS:1000291, linear ion trap,]"                                     
#>  [9,] "[,,[MS, MS:1001582], xcms, 4.0.0,]"                                     
#> [10,] "frodo"                                                                  
#> [11,] "fellowship of the ring"                                                 
#> [12,] "frodo@shire.net"                                                        
#> [13,] "0000-0001-2345-6789"                                                    
#> [14,] "sauron"                                                                 
#> [15,] "the dark side"                                                          
#> [16,] "sauron@mordor.net"                                                      
#> [17,] "0000-0001-2345-678X"                                                    
#> [18,] "[MS, MS:1001834, LC-MS label-free quantitation analysis, ]"             
#> [19,] "MS"                                                                     
#> [20,] "PSI-MS controlled vocabulary"                                           
#> [21,] "4.1.138"                                                                
#> [22,] "https://raw.githubusercontent.com/HUPO-PSI/psi-ms-CV/master/psi-ms.obo" 
#> [23,] "PRIDE"                                                                  
#> [24,] "PRIDE PRoteomics IDEntifications (PRIDE) database controlled vocabulary"
#> [25,] "16:10:2023 11:38"                                                       
#> [26,] "https://www.ebi.ac.uk/ols/ontologies/pride"                             
#> [27,] "STATO"                                                                  
#> [28,] "General purpose STATistics Ontology"                                    
#> [29,] "2026-04-20"                                                             
#> [30,] "https://www.ebi.ac.uk/ols4/ontologies/stato"                            
#> [31,] "[,, \"no database\", null ]"                                            
#> [32,] "null"                                                                   
#> [33,] "Unknown"                                                                
#> [34,] "null"                                                                   
#> [35,] "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]"                
#> [36,] "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]"                
#> [37,] "[MS, MS:1002896, compound identification confidence level, ]"           

## Other information, such as employed sample processing methods could be
## added in a similar way.


#############################################################################
## Sample information

## We next add sample information to the metadata. In addition to the
## specific sample properties that can be defined using the function's
## parameters, arbitrary custom fields can be defined too. Below we add
## information on sample extraction as custom information.
mtd_s <- mtdSample(
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
mtd_msr <- mtdMsRun(
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
a <- mtdAssay(
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
svar <- mtdStudyVariables(
    exp, groups = c("time_point", "genotype", "cell_count", "operator"))
svar
#>        [,1]                                   
#>   [1,] "study_variable_group[1]"              
#>   [2,] "study_variable_group[1]-description"  
#>   [3,] "study_variable_group[1]-type"         
#>   [4,] "study_variable_group[1]-datatype"     
#>   [5,] "study_variable_group[2]"              
#>   [6,] "study_variable_group[2]-description"  
#>   [7,] "study_variable_group[2]-type"         
#>   [8,] "study_variable_group[2]-datatype"     
#>   [9,] "study_variable_group[3]"              
#>  [10,] "study_variable_group[3]-description"  
#>  [11,] "study_variable_group[3]-type"         
#>  [12,] "study_variable_group[3]-datatype"     
#>  [13,] "study_variable_group[4]"              
#>  [14,] "study_variable_group[4]-description"  
#>  [15,] "study_variable_group[4]-type"         
#>  [16,] "study_variable_group[4]-datatype"     
#>  [17,] "study_variable[1]"                    
#>  [18,] "study_variable[1]-assay_refs"         
#>  [19,] "study_variable[1]-average_function"   
#>  [20,] "study_variable[1]-variation_function" 
#>  [21,] "study_variable[1]-ms_run_ref"         
#>  [22,] "study_variable[1]-description"        
#>  [23,] "study_variable[1]-group_ref"          
#>  [24,] "study_variable[2]"                    
#>  [25,] "study_variable[2]-assay_refs"         
#>  [26,] "study_variable[2]-average_function"   
#>  [27,] "study_variable[2]-variation_function" 
#>  [28,] "study_variable[2]-ms_run_ref"         
#>  [29,] "study_variable[2]-description"        
#>  [30,] "study_variable[2]-group_ref"          
#>  [31,] "study_variable[3]"                    
#>  [32,] "study_variable[3]-assay_refs"         
#>  [33,] "study_variable[3]-average_function"   
#>  [34,] "study_variable[3]-variation_function" 
#>  [35,] "study_variable[3]-ms_run_ref"         
#>  [36,] "study_variable[3]-description"        
#>  [37,] "study_variable[3]-group_ref"          
#>  [38,] "study_variable[4]"                    
#>  [39,] "study_variable[4]-assay_refs"         
#>  [40,] "study_variable[4]-average_function"   
#>  [41,] "study_variable[4]-variation_function" 
#>  [42,] "study_variable[4]-ms_run_ref"         
#>  [43,] "study_variable[4]-description"        
#>  [44,] "study_variable[4]-group_ref"          
#>  [45,] "study_variable[5]"                    
#>  [46,] "study_variable[5]-assay_refs"         
#>  [47,] "study_variable[5]-average_function"   
#>  [48,] "study_variable[5]-variation_function" 
#>  [49,] "study_variable[5]-ms_run_ref"         
#>  [50,] "study_variable[5]-description"        
#>  [51,] "study_variable[5]-group_ref"          
#>  [52,] "study_variable[6]"                    
#>  [53,] "study_variable[6]-assay_refs"         
#>  [54,] "study_variable[6]-average_function"   
#>  [55,] "study_variable[6]-variation_function" 
#>  [56,] "study_variable[6]-ms_run_ref"         
#>  [57,] "study_variable[6]-description"        
#>  [58,] "study_variable[6]-group_ref"          
#>  [59,] "study_variable[7]"                    
#>  [60,] "study_variable[7]-assay_refs"         
#>  [61,] "study_variable[7]-average_function"   
#>  [62,] "study_variable[7]-variation_function" 
#>  [63,] "study_variable[7]-ms_run_ref"         
#>  [64,] "study_variable[7]-description"        
#>  [65,] "study_variable[7]-group_ref"          
#>  [66,] "study_variable[8]"                    
#>  [67,] "study_variable[8]-assay_refs"         
#>  [68,] "study_variable[8]-average_function"   
#>  [69,] "study_variable[8]-variation_function" 
#>  [70,] "study_variable[8]-ms_run_ref"         
#>  [71,] "study_variable[8]-description"        
#>  [72,] "study_variable[8]-group_ref"          
#>  [73,] "study_variable[9]"                    
#>  [74,] "study_variable[9]-assay_refs"         
#>  [75,] "study_variable[9]-average_function"   
#>  [76,] "study_variable[9]-variation_function" 
#>  [77,] "study_variable[9]-ms_run_ref"         
#>  [78,] "study_variable[9]-description"        
#>  [79,] "study_variable[9]-group_ref"          
#>  [80,] "study_variable[10]"                   
#>  [81,] "study_variable[10]-assay_refs"        
#>  [82,] "study_variable[10]-average_function"  
#>  [83,] "study_variable[10]-variation_function"
#>  [84,] "study_variable[10]-ms_run_ref"        
#>  [85,] "study_variable[10]-description"       
#>  [86,] "study_variable[10]-group_ref"         
#>  [87,] "study_variable[11]"                   
#>  [88,] "study_variable[11]-assay_refs"        
#>  [89,] "study_variable[11]-average_function"  
#>  [90,] "study_variable[11]-variation_function"
#>  [91,] "study_variable[11]-ms_run_ref"        
#>  [92,] "study_variable[11]-description"       
#>  [93,] "study_variable[11]-group_ref"         
#>  [94,] "study_variable[12]"                   
#>  [95,] "study_variable[12]-assay_refs"        
#>  [96,] "study_variable[12]-average_function"  
#>  [97,] "study_variable[12]-variation_function"
#>  [98,] "study_variable[12]-ms_run_ref"        
#>  [99,] "study_variable[12]-description"       
#> [100,] "study_variable[12]-group_ref"         
#>        [,2]                                            
#>   [1,] "[,,time_point,]"                               
#>   [2,] "Sample matrix column time_point"               
#>   [3,] "[STATO, STATO:0000251, continuous variable, ]" 
#>   [4,] "xsd:decimal"                                   
#>   [5,] "[,,genotype,]"                                 
#>   [6,] "Sample matrix column genotype"                 
#>   [7,] "[STATO, STATO:0000252, categorical variable, ]"
#>   [8,] "xsd:string"                                    
#>   [9,] "[,,cell_count,]"                               
#>  [10,] "Sample matrix column cell_count"               
#>  [11,] "[STATO, STATO:0000251, continuous variable, ]" 
#>  [12,] "xsd:decimal"                                   
#>  [13,] "[,,operator,]"                                 
#>  [14,] "Sample matrix column operator"                 
#>  [15,] "[STATO, STATO:0000252, categorical variable, ]"
#>  [16,] "xsd:string"                                    
#>  [17,] "0"                                             
#>  [18,] "assay[1]|assay[3]|assay[5]"                    
#>  [19,] "[MS, MS:1002962, mean, ]"                      
#>  [20,] "[MS, MS:1002963, variation coefficient, ]"     
#>  [21,] "ms_run[1]|ms_run[3]|ms_run[5]"                 
#>  [22,] "Variable time_point, value 0"                  
#>  [23,] "study_variable_group[1]"                       
#>  [24,] "6"                                             
#>  [25,] "assay[2]|assay[4]|assay[6]"                    
#>  [26,] "[MS, MS:1002962, mean, ]"                      
#>  [27,] "[MS, MS:1002963, variation coefficient, ]"     
#>  [28,] "ms_run[2]|ms_run[4]|ms_run[6]"                 
#>  [29,] "Variable time_point, value 6"                  
#>  [30,] "study_variable_group[1]"                       
#>  [31,] "WT"                                            
#>  [32,] "assay[1]|assay[2]"                             
#>  [33,] "[MS, MS:1002962, mean, ]"                      
#>  [34,] "[MS, MS:1002963, variation coefficient, ]"     
#>  [35,] "ms_run[1]|ms_run[2]"                           
#>  [36,] "Variable genotype, value WT"                   
#>  [37,] "study_variable_group[2]"                       
#>  [38,] "KO"                                            
#>  [39,] "assay[3]|assay[4]|assay[5]|assay[6]"           
#>  [40,] "[MS, MS:1002962, mean, ]"                      
#>  [41,] "[MS, MS:1002963, variation coefficient, ]"     
#>  [42,] "ms_run[3]|ms_run[4]|ms_run[5]|ms_run[6]"       
#>  [43,] "Variable genotype, value KO"                   
#>  [44,] "study_variable_group[2]"                       
#>  [45,] "13000"                                         
#>  [46,] "assay[1]"                                      
#>  [47,] "[MS, MS:1002962, mean, ]"                      
#>  [48,] "[MS, MS:1002963, variation coefficient, ]"     
#>  [49,] "ms_run[1]"                                     
#>  [50,] "Variable cell_count, value 13000"              
#>  [51,] "study_variable_group[3]"                       
#>  [52,] "8700"                                          
#>  [53,] "assay[2]"                                      
#>  [54,] "[MS, MS:1002962, mean, ]"                      
#>  [55,] "[MS, MS:1002963, variation coefficient, ]"     
#>  [56,] "ms_run[2]"                                     
#>  [57,] "Variable cell_count, value 8700"               
#>  [58,] "study_variable_group[3]"                       
#>  [59,] "10100"                                         
#>  [60,] "assay[3]"                                      
#>  [61,] "[MS, MS:1002962, mean, ]"                      
#>  [62,] "[MS, MS:1002963, variation coefficient, ]"     
#>  [63,] "ms_run[3]"                                     
#>  [64,] "Variable cell_count, value 10100"              
#>  [65,] "study_variable_group[3]"                       
#>  [66,] "6000"                                          
#>  [67,] "assay[4]"                                      
#>  [68,] "[MS, MS:1002962, mean, ]"                      
#>  [69,] "[MS, MS:1002963, variation coefficient, ]"     
#>  [70,] "ms_run[4]"                                     
#>  [71,] "Variable cell_count, value 6000"               
#>  [72,] "study_variable_group[3]"                       
#>  [73,] "14000"                                         
#>  [74,] "assay[5]"                                      
#>  [75,] "[MS, MS:1002962, mean, ]"                      
#>  [76,] "[MS, MS:1002963, variation coefficient, ]"     
#>  [77,] "ms_run[5]"                                     
#>  [78,] "Variable cell_count, value 14000"              
#>  [79,] "study_variable_group[3]"                       
#>  [80,] "4500"                                          
#>  [81,] "assay[6]"                                      
#>  [82,] "[MS, MS:1002962, mean, ]"                      
#>  [83,] "[MS, MS:1002963, variation coefficient, ]"     
#>  [84,] "ms_run[6]"                                     
#>  [85,] "Variable cell_count, value 4500"               
#>  [86,] "study_variable_group[3]"                       
#>  [87,] "BB"                                            
#>  [88,] "assay[1]|assay[2]|assay[3]|assay[4]"           
#>  [89,] "[MS, MS:1002962, mean, ]"                      
#>  [90,] "[MS, MS:1002963, variation coefficient, ]"     
#>  [91,] "ms_run[1]|ms_run[2]|ms_run[3]|ms_run[4]"       
#>  [92,] "Variable operator, value BB"                   
#>  [93,] "study_variable_group[4]"                       
#>  [94,] "FB"                                            
#>  [95,] "assay[5]|assay[6]"                             
#>  [96,] "[MS, MS:1002962, mean, ]"                      
#>  [97,] "[MS, MS:1002963, variation coefficient, ]"     
#>  [98,] "ms_run[5]|ms_run[6]"                           
#>  [99,] "Variable operator, value FB"                   
#> [100,] "study_variable_group[4]"                       

## The individual columns got encoded to a `"study_variable_group"` with a
## defined (statistical) type and a datatype. Both are inferred
## automatically from the columns of the provided `data.frame`, but could
## also be manually provided through the respective function arguments.

mtd <- rbind(mtd, svar)

## Finally, the `mtdSort()` function can be used to sort the generated
## two-column matrix in the expected order.
mtd <- mtdSort(mtd)

## This metadata information can next be exported manually, or using the
## dedicated export helper functions to an mzTab-M file.
```
