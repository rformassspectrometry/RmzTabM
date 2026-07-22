# Create the mzTab-M MTD content from a sample data frame

`mtdFromSampleData()` compiles the *sample*, *ms_run*, *assay* and
*study variable* content of the MTD section from a *sample data*
`data.frame`. Each row of this `data.frame` (parameter `x`) is expected
to represent on MS run (i.e., acquisition of a sample) of an experimen
with columns containing information on the individual MS run and the
sample(s).

The columns providing information on the MS run can be specified with
parameter `msRunCols`. Mandatory columns are *location* and
*scan_polarity*.

The columns providing information on the individual *assays* can be
defined with parameter `assayCols`. In most cases one assay represents
one MS run.

The columns from which sample information can be retrieved can be
defined with `sampleCols`. See notes below for more information.

The columns containing experimental/phenotype information can be defined
with parameter `groups`.

Arguments defining columns for MS runs, assays and samples are grouped
with parameters `msRunCols.`, `assayCols.` and `sampleCols,`. For each a
helper function is available providing defaults and assisting in
defining the arguments. See section *Defining columns with information
on MS runs, assays and samples*

The MTD information is compiled from the sample data `x` as follows:

- MS runs: each row in `x` is added as one MS run. The column in `x`
  with the respective file name needs to be defined through parameter
  `msRunCols.`.

- samples: the unique set of rows based on the column(s) defined with
  `sampleCols.` are added as samples.

- assay: each unique element in the column defined through `assayCols.`
  (`assay`) is added as one *assay* referencing to samples and MS runs.
  In most cases the number of MS runs will match the number of assays,
  i.e., each row in `x` is one MS run as well as one assay. A 1:n
  mapping between assay and MS run is also possible.

- study variables: each column defined with parameter `groups` is added
  as one *study variable group*.

## Usage

``` r
mtdFromSampleData(
  x,
  sampleCols. = sampleCols(),
  msRunCols. = msRunCols(),
  assayCols. = assayCols(),
  groups = character(),
  group_description = character(),
  group_type = character(),
  group_datatype = character(),
  group_unit = character(),
  average_function = "[MS, MS:1002962, mean, ]",
  variation_function = "[MS, MS:1002963, variation coefficient, ]",
  description = character()
)

sampleCols(
  sample = "sample",
  species = "species",
  tissue = "tissue",
  cell_type = "cell_type",
  disease = "disease",
  description = "description",
  ...
)

msRunCols(
  location = "location",
  instrument_ref = "instrument_ref",
  format = "format",
  id_format = "id_format",
  fragmentation_method = "fragmentation_method",
  scan_polarity = "scan_polarity",
  hash = "hash",
  hash_method = "hash_method"
)

assayCols(
  assay = "assay",
  external_uri = "external_uri",
  sample_ref = "sample_ref",
  ms_run_ref = "ms_run_ref",
  ...
)
```

## Arguments

- x:

  `data.frame` with information on samples, MS runs and assays. Each row
  is expected to represent one MS run (MS data file) and columns
  providing information on the measured sample(s) along with
  experimental and technical information.

- sampleCols.:

  named `character` vector defining the columns in `x` containing
  information for the individual sample fields (with names being the
  name of the mzTab-M field and values the respective column name in
  `x`). The `sampleCols()` function can be used to define this
  parameter. See examples below and
  [`mtdSample()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdSample.md)
  for more information.

- msRunCols.:

  named `character` vector defining the columns in `x` containing
  information on the MS runs (with names being the name of the mzTab-M
  field and values the respective column name in `x`). Required
  fields/parameters are `location` and `scan_polarity`. The
  `msRunCols()` function can be used to define this parameter. See
  examples below and
  [`mtdMsRun()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdMsRun.md)
  for more information.

- assayCols.:

  named `character` vector defining the columns in `x` containing
  information for the individual assays fields (with names being the
  name of the mzTab-M field and values the respective column name in
  `x`). Parameter/field `assay` is required. The `assayCols()` function
  can be used to define this parameter. See examples below and
  [`mtdAssay()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdAssay.md)
  for more information.

- groups:

  `character` with the names of the columns in `x` that should be
  considered as *study variable groups*. If not defined (the default) a
  single study variable group `"undefined"` and single study variable
  `"undefined"` will be used.

- group_description:

  `character` with an optional description of each study variable group.
  If provided its length has to match the length of parameter `groups`.

- group_type:

  `character` defining the type for each study variable group. If
  provided its length has to match the length of parameter `groups`.
  Supported values are
  `"[STATO, STATO:0000252, categorical variable, ]"`,
  `"[STATO, STATO:0000228, ordinal variable, ]"` and
  `"[STATO, STATO:0000251, continuous variable, ]"` for categorical,
  ordinal or numerical values, respectively. If not provided (the
  default) the study variable group type will be inferred from the data
  type of the respective columns in `x`.

- group_datatype:

  optional `character` defining the data type of the values (i.e., study
  variables) for the study variable group. If provided, its length has
  to match the length of paramter `groups`. Supported values are
  `"xsd:string"`, `"xsd:integer"`, `"xsd:decimal"`, `"xsd:boolean"`,
  `"xsd:date"`, `"xsd:time"`, `"xsd:dateTime"`, `"xsd:anyURI"`, and
  `"Parameter"` (for *CV Parameters*). Date, time and dateTime values
  **must** be encoded in ISO 8601 format. If not provided the type is
  guessed by the data type of the respective column in `x`.

- group_unit:

  optional `character` defining the unit of the group variable (for
  numeric data types). If provided, its length has to match the length
  of parameter `groups`. `NA` or `""` has to be provided for groups for
  which no unit should be reported. By default
  (`group_unit = character()`) no unit is reported for any group.

- average_function:

  optional `character` defining the function used to calculate the study
  variable quantification value (reported in the following table(s)).
  Can be of length 1 or equal to the number of study variables (to allow
  defining a different function per variable). Use
  [`mtdDefineStudyVariables()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdStudyVariables.md)
  to get the complete set of study variables for parameters `x` and
  `groups`. Defaults to the arithmetic mean
  (`average_function = "[MS, MS:1002962, mean, ]"`).

- variation_function:

  optional `character` defining the function used to calculate the study
  variable quantification variation value (reported in the following
  table(s)). Can be of length 1 or equal to the number of study
  variables (to allow defining a different function per variable). Use
  [`mtdDefineStudyVariables()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdStudyVariables.md)
  to get the complete set of study variables for parameters `x` and
  `groups`. Defaults to the coefficient of variation
  (`variation_function = "[MS, MS:1002963, variation coefficient, ]"`).

- description:

  `character` of length equal to `length(sample)` with optional
  description of each sample.

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

- ...:

  named `character` vectors of length equal to the length of parameter
  `sample` with optional *custom* information for each individual
  sample.

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

two column `character` `matrix`.

## Note

The SML and SMF sections must report one column for each **assay**.
Thus, each row in the input sample data `x` is expected to be one assay.

In mzTab-M a *sample* is the source of an biological sample. If in an
experiment e.g. multiple blood samples are taken at different time
points from the same individual, the individual is considered a single
sample. Information on the time points can be provided as study
variables using the `groups` parameter.

## Defining columns with information on MS runs, assays and samples

- `msRunCols()`: function to create a named `character` defining the
  columns in `x` containinig information for the individual parameters.
  To change the default for the column containing the MS data file names
  (default `location = "location"`) to a column called e.g.
  `"mzml_file"`: `msRunCols(location = "mzml_file")`. Parameters
  `location` and `scan_polarity` have to be set to match the column
  names in `x` with the respective information. See examples for more
  information.

- `assayCols()`: function to define columns containing information on
  assays. Parameter `assay` has to be adapted. Through `...` it is also
  possible to define additional columns with optional information on
  each assay.

- `sampleCols()`: function to define columns containing sample
  information. Through `...` additional optional columns with sample
  information can be provided.

## See also

[`mtdToSampleData()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtdToSampleData.md)
for the inverse function.

## Author

Johannes Rainer

## Examples

``` r

## Defining an example sample data:
## - file: the mzML file, i.e., the *MS run*.
## - name: the name of the measurement. This is also the name of the sample:
##         QC is the pool of all samples, s1 to s4 the ID of the individual.
## - phenotype: defining the biological replicates, 2 for CVD, 2 for CTR.
## - age: covariate, age of the individuals.
## - injection_index: the order in which samples were measured.
sdata <- data.frame(
    file = c("1.mzML", "2.mzML", "3.mzML", "4.mzML", "5.mzML", "6.mzML"),
    name = c("QC", "s1", "s2", "QC", "s3", "s4"),
    phenotype = c(NA, "CVD", "CTR", NA, "CTR", "CVD"),
    age = c(NA, 35, 32, NA, 43, 32),
    injection_index = c(1, 2, 3, 4, 5, 6))
## Add additional required columns:
sdata$polarity <- "positive"

## Add columns with optional, additional information to the individual
## samples or assays.
sdata$organism <- "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"
sdata$assay_info <- c("run1", "run2", "run3", "run4", "run5", "run6")

## Define the columns in `sdata` that provide information on the individual
## samples.
scols <- sampleCols(sample = "name", species = "organism")

## Define the columns in `sdata` that provide MS run information
mscols <- msRunCols(location = "file", scan_polarity = "polarity")

## Define the columns in `sdata` that provide assay information; we use
## the MS run/file name also for the assay name and add an additional
## column with optional content/information.
acols <- assayCols(assay = "file", assay_info = "assay_info")

## Create the MTD section from the `sdata` `data.frame`. Parameter `groups`
## allows to define the columns in `sdata` that should be encoded as
## *study variable groups*.
m <- mtdFromSampleData(sdata, sampleCols = scols, msRunCols = mscols,
    assayCols = acols, groups = c("phenotype", "age", "injection_index"))

## The sample to assay mapping:
## The repeated injection (assay 1 and 4) of the QC sample are assigned
## to the same sample (1).
getMtdField(m, "assay\\[\\d\\]-sample_ref")
#> assay[1]-sample_ref assay[2]-sample_ref assay[3]-sample_ref assay[4]-sample_ref 
#>         "sample[1]"         "sample[2]"         "sample[3]"         "sample[1]" 
#> assay[5]-sample_ref assay[6]-sample_ref 
#>         "sample[4]"         "sample[5]" 

## The study variable 2 represents a value of `"CVD"` for the *phenotype*
## study variable group
getMtdField(m, "study_variable\\[2\\]$")
#> study_variable[2] 
#>             "CVD" 

## and this study variable references the 2nd and 6th assay
getMtdField(m, "study_variable\\[2\\]-assay_refs")
#> study_variable[2]-assay_refs 
#>          "assay[2]|assay[6]" 


## It is also possible to create a MTD section without samples or
## study variables
m <- mtdFromSampleData(
    sdata,
    msRunCols = c(location = "file", scan_polarity = "polarity"),
    assayCols = c(assay = "assay_info"))
m
#>                                                   
#>  [1,] "ms_run[1]-location"                        
#>  [2,] "ms_run[1]-scan_polarity[1]"                
#>  [3,] "ms_run[2]-location"                        
#>  [4,] "ms_run[2]-scan_polarity[1]"                
#>  [5,] "ms_run[3]-location"                        
#>  [6,] "ms_run[3]-scan_polarity[1]"                
#>  [7,] "ms_run[4]-location"                        
#>  [8,] "ms_run[4]-scan_polarity[1]"                
#>  [9,] "ms_run[5]-location"                        
#> [10,] "ms_run[5]-scan_polarity[1]"                
#> [11,] "ms_run[6]-location"                        
#> [12,] "ms_run[6]-scan_polarity[1]"                
#> [13,] "assay[1]"                                  
#> [14,] "assay[1]-ms_run_ref"                       
#> [15,] "assay[2]"                                  
#> [16,] "assay[2]-ms_run_ref"                       
#> [17,] "assay[3]"                                  
#> [18,] "assay[3]-ms_run_ref"                       
#> [19,] "assay[4]"                                  
#> [20,] "assay[4]-ms_run_ref"                       
#> [21,] "assay[5]"                                  
#> [22,] "assay[5]-ms_run_ref"                       
#> [23,] "assay[6]"                                  
#> [24,] "assay[6]-ms_run_ref"                       
#> [25,] "study_variable_group[1]"                   
#> [26,] "study_variable_group[1]-description"       
#> [27,] "study_variable_group[1]-type"              
#> [28,] "study_variable_group[1]-datatype"          
#> [29,] "study_variable_group[1]-study_variable_ref"
#> [30,] "study_variable[1]"                         
#> [31,] "study_variable[1]-assay_refs"              
#> [32,] "study_variable[1]-average_function"        
#> [33,] "study_variable[1]-variation_function"      
#> [34,] "study_variable[1]-description"             
#>       values                                                 
#>  [1,] "1.mzML"                                               
#>  [2,] "[MS, MS:1000130, positive scan, ]"                    
#>  [3,] "2.mzML"                                               
#>  [4,] "[MS, MS:1000130, positive scan, ]"                    
#>  [5,] "3.mzML"                                               
#>  [6,] "[MS, MS:1000130, positive scan, ]"                    
#>  [7,] "4.mzML"                                               
#>  [8,] "[MS, MS:1000130, positive scan, ]"                    
#>  [9,] "5.mzML"                                               
#> [10,] "[MS, MS:1000130, positive scan, ]"                    
#> [11,] "6.mzML"                                               
#> [12,] "[MS, MS:1000130, positive scan, ]"                    
#> [13,] "run1"                                                 
#> [14,] "ms_run[1]"                                            
#> [15,] "run2"                                                 
#> [16,] "ms_run[2]"                                            
#> [17,] "run3"                                                 
#> [18,] "ms_run[3]"                                            
#> [19,] "run4"                                                 
#> [20,] "ms_run[4]"                                            
#> [21,] "run5"                                                 
#> [22,] "ms_run[5]"                                            
#> [23,] "run6"                                                 
#> [24,] "ms_run[6]"                                            
#> [25,] "[,,undefined,]"                                       
#> [26,] "Sample matrix column undefined"                       
#> [27,] "[STATO, STATO:0000252, categorical variable, ]"       
#> [28,] "xsd:string"                                           
#> [29,] "study_variable[1]"                                    
#> [30,] "undefined"                                            
#> [31,] "assay[1]|assay[2]|assay[3]|assay[4]|assay[5]|assay[6]"
#> [32,] "[MS, MS:1002962, mean, ]"                             
#> [33,] "[MS, MS:1002963, variation coefficient, ]"            
#> [34,] "Variable undefined, value undefined"                  
```
