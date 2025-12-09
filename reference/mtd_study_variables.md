# mzTab-M *study variables* metadata information

A *study variable* in the mzTab-M definition is the **value** of an
experimental variable (condition or factor), e.g., `"control"`, or
`"2 hours"` (i.e., it is not the name of the factor). Each study
variable **must** be reported in the following abundance tables. Each
assay of a data set must be referred to from at least one study
variable\* Even if a data set has no experimental variables, a study
variable **must** be reported, linking to all assays, with the name
`"undefined"`.

Information for the mzTab-M *study variable* metadata section can be
created using the `mtd_study_variables()` function. This function
extracts the relevant information from an input `data.frame` in which
rows are expected to represent *assays* (each row being one assay) and
columns the experimental factors that should be added as study
variables.

The `mtd_define_study_variables()` function can be used to get the set
(and order) of study variables that would be generated from an input
`data.frame` depending on the parameter `study_variable_columns`.

## Usage

``` r
mtd_study_variables(
  x,
  study_variable_columns = character(),
  average_function = "[MS, MS:1002962, mean, ]",
  variation_function = "[MS, MS:1002963, variation coefficient, ]",
  description = character(),
  factors = character()
)

mtd_define_study_variables(x, study_variable_columns = character())
```

## Arguments

- x:

  `data.frame` with rows corresponding to individual *assays* and
  columns containing the experimental conditions/study variables. The
  number of rows is thus expected to be the same as the number of assays
  defined in the *assay* metadata section (using e.g.,
  [`mtd_assay()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_assay.md))
  and the order of rows is expected to match the order of assays.

- study_variable_columns:

  `character` with the names of the columns in `x`to be included as
  study variables. If not defined (the default) a single study variable
  will be defined assigning all assays to it.

- average_function:

  optional `character` defining the function used to calculate the study
  variable quantification value (reported in the following table(s)).
  Can be of length 1 or equal to the number of study variables (to allow
  defining a different function per variable). Use
  `mtd_define_study_variables()` to get the complete set of study
  variables for parameters `x` and `study_variable_columns`. Defaults to
  the arithmetic mean.

- variation_function:

  optional `character` defining the function used to calculate the study
  variable quantification variation value (reported in the following
  table(s)). Can be of length 1 or equal to the number of study
  variables (to allow defining a different function per variable). Use
  `mtd_define_study_variables()` to get the complete set of study
  variables for parameters `x` and `study_variable_columns`. Defaults to
  the coefficient of variation.

- description:

  `character` with a textual description of the study variable. If
  provided, its length needs to be equal to the number of study
  variables. Use `mtd_define_study_variables()` to get the complete set
  of study variables for parameters `x` and `study_variable_columns`. If
  not provided (the default) the description is used combines the column
  name in `x` and the value of the variable.

- factors:

  Currently not supported.

## Value

two-column `character` `matrix` with the content for the study variables
metadata section.

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
    timepoint = c("0h", "6h", "0h", "6h", "0h"),
    T2D = c(TRUE, FALSE, TRUE, FALSE, FALSE)
)

## Study variables for this data set would be `"timepoint"` and `"T2D"`:
mtd_study_variables(x, study_variable_columns = c("timepoint", "T2D"))
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
#>       [,2]                                       
#>  [1,] "timepoint:0h"                             
#>  [2,] "assay[1]|assay[3]|assay[5]"               
#>  [3,] "[MS, MS:1002962, mean, ]"                 
#>  [4,] "[MS, MS:1002963, variation coefficient, ]"
#>  [5,] "Column: timepoint, value: 0h"             
#>  [6,] "timepoint:6h"                             
#>  [7,] "assay[2]|assay[4]"                        
#>  [8,] "[MS, MS:1002962, mean, ]"                 
#>  [9,] "[MS, MS:1002963, variation coefficient, ]"
#> [10,] "Column: timepoint, value: 6h"             
#> [11,] "T2D:TRUE"                                 
#> [12,] "assay[1]|assay[3]"                        
#> [13,] "[MS, MS:1002962, mean, ]"                 
#> [14,] "[MS, MS:1002963, variation coefficient, ]"
#> [15,] "Column: T2D, value: TRUE"                 
#> [16,] "T2D:FALSE"                                
#> [17,] "assay[2]|assay[4]|assay[5]"               
#> [18,] "[MS, MS:1002962, mean, ]"                 
#> [19,] "[MS, MS:1002963, variation coefficient, ]"
#> [20,] "Column: T2D, value: FALSE"                

## Specifying a different average and variation function
mtd_study_variables(x,
    study_variable_columns = c("timepoint", "T2D"),
    average_function = "[MS, MS:1002883, median, ]",
    variation_function = "[MS, MS:1002885, standard error, ]")
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
#>       [,2]                                
#>  [1,] "timepoint:0h"                      
#>  [2,] "assay[1]|assay[3]|assay[5]"        
#>  [3,] "[MS, MS:1002883, median, ]"        
#>  [4,] "[MS, MS:1002885, standard error, ]"
#>  [5,] "Column: timepoint, value: 0h"      
#>  [6,] "timepoint:6h"                      
#>  [7,] "assay[2]|assay[4]"                 
#>  [8,] "[MS, MS:1002883, median, ]"        
#>  [9,] "[MS, MS:1002885, standard error, ]"
#> [10,] "Column: timepoint, value: 6h"      
#> [11,] "T2D:TRUE"                          
#> [12,] "assay[1]|assay[3]"                 
#> [13,] "[MS, MS:1002883, median, ]"        
#> [14,] "[MS, MS:1002885, standard error, ]"
#> [15,] "Column: T2D, value: TRUE"          
#> [16,] "T2D:FALSE"                         
#> [17,] "assay[2]|assay[4]|assay[5]"        
#> [18,] "[MS, MS:1002883, median, ]"        
#> [19,] "[MS, MS:1002885, standard error, ]"
#> [20,] "Column: T2D, value: FALSE"         

## Creating a study variable section without defined study variables
mtd_study_variables(x)
#>      [,1]                                  
#> [1,] "study_variable[1]"                   
#> [2,] "study_variable[1]-assay_refs"        
#> [3,] "study_variable[1]-average_function"  
#> [4,] "study_variable[1]-variation_function"
#> [5,] "study_variable[1]-description"       
#>      [,2]                                          
#> [1,] "undefined"                                   
#> [2,] "assay[1]|assay[2]|assay[3]|assay[4]|assay[5]"
#> [3,] "[MS, MS:1002962, mean, ]"                    
#> [4,] "[MS, MS:1002963, variation coefficient, ]"   
#> [5,] "Undefined"                                   
```
