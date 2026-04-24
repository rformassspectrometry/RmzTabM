# mzTab-M *study variables* metadata information

mzTab-M (version \>= 2.1) encodes the experimental design of a data
set/study using *study variable groups* and *study variables*. The study
variable group represents the phenotypic (or experimental) condition and
the study variable the actual *value* of a sample (or assay) for that
study group.

In R, the most common representation of an experimental design is a
`data.frame` where rows are individual samples (assays) and columns the
experimental or phenotypic conditions (variables). The
`mtb_study_variables()` takes such a `data.frame` as input and encodes
it into the mzTab-M format. Additional parameters such as
`group_description`, and `group_type` allow to provide additional
information for each study variable group (phenotype) while parameters
`average_function`, `variation_function` and `description` can be used
to provide properties for the individual study variables. For most
experiments the default values of these parameters should suffice.

## Usage

``` r
mtd_study_variables(
  x,
  groups = character(),
  group_description = character(),
  group_type = character(),
  group_datatype = character(),
  group_unit = character(),
  average_function = "[MS, MS:1002962, mean, ]",
  variation_function = "[MS, MS:1002963, variation coefficient, ]",
  description = character()
)

mtd_define_study_variables(x = data.frame(), groups = character())
```

## Arguments

- x:

  `data.frame` with rows corresponding to individual *assays* and
  columns containing the experimental conditions/study variables. The
  number of rows is thus expected to be the same as the number of assays
  defined in the *assay* metadata section (using e.g.,
  [`mtd_assay()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_assay.md))
  and the order of rows is expected to match the order of these.

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
  `"xsd:date"`, `"xsd:time"`, `"xsd:dateTime"`, and `"xsd:anyURI"`.
  Date,l time and dateTime values **must** be encoded in ISO 8601
  format. If not provided the type is guessed by the data type of the
  respective column in `x`.

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
  `mtd_define_study_variables()` to get the complete set of study
  variables for parameters `x` and `groups`. Defaults to the arithmetic
  mean (`average_function = "[MS, MS:1002962, mean, ]"`).

- variation_function:

  optional `character` defining the function used to calculate the study
  variable quantification variation value (reported in the following
  table(s)). Can be of length 1 or equal to the number of study
  variables (to allow defining a different function per variable). Use
  `mtd_define_study_variables()` to get the complete set of study
  variables for parameters `x` and `groups`. Defaults to the coefficient
  of variation
  (`variation_function = "[MS, MS:1002963, variation coefficient, ]"`).

- description:

  `character` with a textual description of the study variable. If
  provided, its length needs to be equal to the number of study
  variables. Use `mtd_define_study_variables()` to get the complete set
  of study variables for parameters `x` and `groups`. If not provided
  (the default) the values for the study variable group and study
  variable are reported.

## Value

two-column `character` `matrix` with the content for the study variables
metadata section.

## Details

Each study variable **must** be reported in the abundance tables. Each
assay of a data set must be referred to from at least one study
variable. Even if a data set has no experimental variables, a study
variable group and study variable with the name `"undefined"` **must**
be reported. Using `mtb_study_variables()` without specifying parameter
`group` will create such a setup.

The `mtd_define_study_variables()` function can be used to get the set
(and order) of study variables that would be generated from an input
`data.frame` depending on the parameter `groups`.

## Note

Datatypes `"xsd:date"`, `"xsd:time"`, `"xsd:dateTime"` and
`"xsd:anyURI"` are currently mapped to `character` in R (and *vice
versa*).

## See also

[MTD-export](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-export.md)
for other functions defining metadata information

## Author

Philippine Louail, Johannes Rainer

## Examples

``` r

## Example phenodata/sample data.frame. Each row is supposed to match
## the measurement of one sample (for a certain condition/time point) from
## one individual
x <- data.frame(
    name = c("I1_0", "I2_0", "I1_6", "I2_6", "I3_0"),
    individual = c("I1", "I2", "I1", "I2", "I3"),
    BMI = c(29.3, 31.4, 29.3, 31.4, 26.5),
    timepoint = c(0, 6, 0, 6, 0),
    T2D = c(TRUE, FALSE, TRUE, FALSE, FALSE)
)

## Study variable groups for this data set could be `"individual"`, `"BMI"`,
## `"timepoint"` and `"T2D"`
mtd_study_variables(x, groups = c("individual", "BMI", "timepoint", "T2D"))
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
#>       [,2]                                            
#>  [1,] "individual"                                    
#>  [2,] "Sample matrix column individual"               
#>  [3,] "[STATO, STATO:0000252, categorical variable, ]"
#>  [4,] "xsd:string"                                    
#>  [5,] "BMI"                                           
#>  [6,] "Sample matrix column BMI"                      
#>  [7,] "[STATO, STATO:0000251, continuous variable, ]" 
#>  [8,] "xsd:decimal"                                   
#>  [9,] "timepoint"                                     
#> [10,] "Sample matrix column timepoint"                
#> [11,] "[STATO, STATO:0000251, continuous variable, ]" 
#> [12,] "xsd:decimal"                                   
#> [13,] "T2D"                                           
#> [14,] "Sample matrix column T2D"                      
#> [15,] "[STATO, STATO:0000252, categorical variable, ]"
#> [16,] "xsd:boolean"                                   
#> [17,] "I1"                                            
#> [18,] "assay[1]|assay[3]"                             
#> [19,] "[MS, MS:1002962, mean, ]"                      
#> [20,] "[MS, MS:1002963, variation coefficient, ]"     
#> [21,] "Variable individual, value I1"                 
#> [22,] "study_variable_group[1]"                       
#> [23,] "I2"                                            
#> [24,] "assay[2]|assay[4]"                             
#> [25,] "[MS, MS:1002962, mean, ]"                      
#> [26,] "[MS, MS:1002963, variation coefficient, ]"     
#> [27,] "Variable individual, value I2"                 
#> [28,] "study_variable_group[1]"                       
#> [29,] "I3"                                            
#> [30,] "assay[5]"                                      
#> [31,] "[MS, MS:1002962, mean, ]"                      
#> [32,] "[MS, MS:1002963, variation coefficient, ]"     
#> [33,] "Variable individual, value I3"                 
#> [34,] "study_variable_group[1]"                       
#> [35,] "29.3"                                          
#> [36,] "assay[1]|assay[3]"                             
#> [37,] "[MS, MS:1002962, mean, ]"                      
#> [38,] "[MS, MS:1002963, variation coefficient, ]"     
#> [39,] "Variable BMI, value 29.3"                      
#> [40,] "study_variable_group[2]"                       
#> [41,] "31.4"                                          
#> [42,] "assay[2]|assay[4]"                             
#> [43,] "[MS, MS:1002962, mean, ]"                      
#> [44,] "[MS, MS:1002963, variation coefficient, ]"     
#> [45,] "Variable BMI, value 31.4"                      
#> [46,] "study_variable_group[2]"                       
#> [47,] "26.5"                                          
#> [48,] "assay[5]"                                      
#> [49,] "[MS, MS:1002962, mean, ]"                      
#> [50,] "[MS, MS:1002963, variation coefficient, ]"     
#> [51,] "Variable BMI, value 26.5"                      
#> [52,] "study_variable_group[2]"                       
#> [53,] "0"                                             
#> [54,] "assay[1]|assay[3]|assay[5]"                    
#> [55,] "[MS, MS:1002962, mean, ]"                      
#> [56,] "[MS, MS:1002963, variation coefficient, ]"     
#> [57,] "Variable timepoint, value 0"                   
#> [58,] "study_variable_group[3]"                       
#> [59,] "6"                                             
#> [60,] "assay[2]|assay[4]"                             
#> [61,] "[MS, MS:1002962, mean, ]"                      
#> [62,] "[MS, MS:1002963, variation coefficient, ]"     
#> [63,] "Variable timepoint, value 6"                   
#> [64,] "study_variable_group[3]"                       
#> [65,] "TRUE"                                          
#> [66,] "assay[1]|assay[3]"                             
#> [67,] "[MS, MS:1002962, mean, ]"                      
#> [68,] "[MS, MS:1002963, variation coefficient, ]"     
#> [69,] "Variable T2D, value TRUE"                      
#> [70,] "study_variable_group[4]"                       
#> [71,] "FALSE"                                         
#> [72,] "assay[2]|assay[4]|assay[5]"                    
#> [73,] "[MS, MS:1002962, mean, ]"                      
#> [74,] "[MS, MS:1002963, variation coefficient, ]"     
#> [75,] "Variable T2D, value FALSE"                     
#> [76,] "study_variable_group[4]"                       

## Specifying a different average and variation function and selecting
## just two sample columns
mtd_study_variables(x,
    groups = c("timepoint", "T2D"),
    average_function = "[MS, MS:1002883, median, ]",
    variation_function = "[MS, MS:1002885, standard error, ]")
#>       [,1]                                  
#>  [1,] "study_variable_group[1]"             
#>  [2,] "study_variable_group[1]-description" 
#>  [3,] "study_variable_group[1]-type"        
#>  [4,] "study_variable_group[1]-datatype"    
#>  [5,] "study_variable_group[2]"             
#>  [6,] "study_variable_group[2]-description" 
#>  [7,] "study_variable_group[2]-type"        
#>  [8,] "study_variable_group[2]-datatype"    
#>  [9,] "study_variable[1]"                   
#> [10,] "study_variable[1]-assay_refs"        
#> [11,] "study_variable[1]-average_function"  
#> [12,] "study_variable[1]-variation_function"
#> [13,] "study_variable[1]-description"       
#> [14,] "study_variable[1]-group_refs"        
#> [15,] "study_variable[2]"                   
#> [16,] "study_variable[2]-assay_refs"        
#> [17,] "study_variable[2]-average_function"  
#> [18,] "study_variable[2]-variation_function"
#> [19,] "study_variable[2]-description"       
#> [20,] "study_variable[2]-group_refs"        
#> [21,] "study_variable[3]"                   
#> [22,] "study_variable[3]-assay_refs"        
#> [23,] "study_variable[3]-average_function"  
#> [24,] "study_variable[3]-variation_function"
#> [25,] "study_variable[3]-description"       
#> [26,] "study_variable[3]-group_refs"        
#> [27,] "study_variable[4]"                   
#> [28,] "study_variable[4]-assay_refs"        
#> [29,] "study_variable[4]-average_function"  
#> [30,] "study_variable[4]-variation_function"
#> [31,] "study_variable[4]-description"       
#> [32,] "study_variable[4]-group_refs"        
#>       [,2]                                            
#>  [1,] "timepoint"                                     
#>  [2,] "Sample matrix column timepoint"                
#>  [3,] "[STATO, STATO:0000251, continuous variable, ]" 
#>  [4,] "xsd:decimal"                                   
#>  [5,] "T2D"                                           
#>  [6,] "Sample matrix column T2D"                      
#>  [7,] "[STATO, STATO:0000252, categorical variable, ]"
#>  [8,] "xsd:boolean"                                   
#>  [9,] "0"                                             
#> [10,] "assay[1]|assay[3]|assay[5]"                    
#> [11,] "[MS, MS:1002883, median, ]"                    
#> [12,] "[MS, MS:1002885, standard error, ]"            
#> [13,] "Variable timepoint, value 0"                   
#> [14,] "study_variable_group[1]"                       
#> [15,] "6"                                             
#> [16,] "assay[2]|assay[4]"                             
#> [17,] "[MS, MS:1002883, median, ]"                    
#> [18,] "[MS, MS:1002885, standard error, ]"            
#> [19,] "Variable timepoint, value 6"                   
#> [20,] "study_variable_group[1]"                       
#> [21,] "TRUE"                                          
#> [22,] "assay[1]|assay[3]"                             
#> [23,] "[MS, MS:1002883, median, ]"                    
#> [24,] "[MS, MS:1002885, standard error, ]"            
#> [25,] "Variable T2D, value TRUE"                      
#> [26,] "study_variable_group[2]"                       
#> [27,] "FALSE"                                         
#> [28,] "assay[2]|assay[4]|assay[5]"                    
#> [29,] "[MS, MS:1002883, median, ]"                    
#> [30,] "[MS, MS:1002885, standard error, ]"            
#> [31,] "Variable T2D, value FALSE"                     
#> [32,] "study_variable_group[2]"                       

## Creating a study variable section without defined study variable groups
mtd_study_variables(x)
#>       [,1]                                  
#>  [1,] "study_variable_group[1]"             
#>  [2,] "study_variable_group[1]-description" 
#>  [3,] "study_variable_group[1]-type"        
#>  [4,] "study_variable_group[1]-datatype"    
#>  [5,] "study_variable[1]"                   
#>  [6,] "study_variable[1]-assay_refs"        
#>  [7,] "study_variable[1]-average_function"  
#>  [8,] "study_variable[1]-variation_function"
#>  [9,] "study_variable[1]-description"       
#> [10,] "study_variable[1]-group_refs"        
#>       [,2]                                            
#>  [1,] "undefined"                                     
#>  [2,] "Sample matrix column undefined"                
#>  [3,] "[STATO, STATO:0000252, categorical variable, ]"
#>  [4,] "xsd:string"                                    
#>  [5,] "undefined"                                     
#>  [6,] "assay[1]|assay[2]|assay[3]|assay[4]|assay[5]"  
#>  [7,] "[MS, MS:1002962, mean, ]"                      
#>  [8,] "[MS, MS:1002963, variation coefficient, ]"     
#>  [9,] "Variable undefined, value undefined"           
#> [10,] "study_variable_group[1]"                       

## Use `mtd_define_study_variables()` to get the definition of study
## variables for a given `x` and `groups`
mtd_define_study_variables(x, c("T2D", "BMI", "individual"))
#>    study_variable study_variable_group
#> 1            TRUE                  T2D
#> 2           FALSE                  T2D
#> 6            29.3                  BMI
#> 7            31.4                  BMI
#> 10           26.5                  BMI
#> 11             I1           individual
#> 12             I2           individual
#> 15             I3           individual
```
