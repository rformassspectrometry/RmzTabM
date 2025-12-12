# The R API for the mzTab-M File Format

## Introduction

The *RmzTabM* package provides the API and core functionality to read
and write files in mzTab-M format. The functions can be re-used and
integrated by other R packages to support import and export of their
respective metabolomics/lipidomics result objects in this format.

## Installation

## R mzTab-M API

The *RmzTabM* package provides low level, core functions and
higher-level functions to work with files in mzTab-M format. The
high-level functions are more user-oriented, simplifying the import and
export of data and information from and to files in mzTab-M format. The
low-level, core functions are developer-oriented, providing helper
functions that can be re-used in other R packages to read and write from
and to mzTab-M files.

For a description of the mzTab-M format and the set of mandatory and
optional fields refer to the official [format
definition](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc).

``` r

library(RmzTabM)
```

### High-level, user faced functions

TODO: implement these functions. These functions should simplify
import/export taking more complex or multiple data parts (`data.frame`s,
`matrix` etc) as input and write the formatted data directly to a
mzTab-M file, or should read a mzTab-M file returning it’s content as
e.g. a `list` of elements.

### Low-level functions

The low-level functions listed in this section provide the base
functionality to convert or format information and data for/from the
[mzTab-M
format](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc).
These functions are designed to be re-used by other R packages and take
and return only basic, plain R data types.

#### Formatting and exporting

##### Metadata

The mzTab-M format defines various fields and parameters to describe the
data and information of an experiment. The *RmzTabM* package provides a
variety of utility functions that help defining and formatting this
information.

See also the [specification of the MTD
section](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section)
for more information and optional and mandatory metadata fields.

The general categories of the metadadata in the mzTab-M MTD section are
*core information*, *sample information*, *MS run information*, *assay
information* and *study variable information*. For each of these
categories a separate R function is available to create and format the
respective fields. As an example, we define below a `data.frame` with
sample information. In our example we assume 3 samples (e.g. cell lines)
each measured at two different time points. An additional column
*genotype* specifies the genotype of the individual samples and a column
*operator* the initials of the researcher extracting the samples.

``` r

#' Define a simple data.frame of the measured samples of an experiment
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
```

      sample_name sample_id timepoint genotype operator  file_name
    1       S1_T1        S1        0h       WT       BB s1-t1.mzML
    2       S1_T2        S1        6h       WT       BB s1-t2.mzML
    3       S2_T1        S2        0h       KO       BB s2-t1.mzML
    4       S2_T2        S2        6h       KO       BB s2-t2.mzML
    5       S3_T1        S3        0h       KO       FB s3-t1.mzML
    6       S3_T2        S3        6h       KO       FB s3-t2.mzML

We will next compile the MTD information for the experiment using the
individual helper functions, starting with the **Core information**:
this comprises general information about the experiment. A minimal set
of fields can be compiled using the
[`mtd_skeleton()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_skeleton.md)
function. We have to provide an ID for the experiment and in addition we
specify the software used to process the data:

``` r

mtd <- mtd_skeleton(
    id = "EXP_001",
    software = "[MS, MS:1001582, xcms, 4.1.0]"
)
mtd
```

          [,1]
     [1,] "mzTab-version"
     [2,] "mzTab-ID"
     [3,] "software[1]"
     [4,] "quantification_method"
     [5,] "cv[1]-label"
     [6,] "cv[1]-full_name"
     [7,] "cv[1]-version"
     [8,] "cv[1]-uri"
     [9,] "cv[2]-label"
    [10,] "cv[2]-full_name"
    [11,] "cv[2]-version"
    [12,] "cv[2]-uri"
    [13,] "database[1]"
    [14,] "database[1]-prefix"
    [15,] "database[1]-version"
    [16,] "database[1]-uri"
    [17,] "small_molecule-quantification_unit"
    [18,] "small_molecule_feature-quantification_unit"
    [19,] "small_molecule-identification_reliability"
          [,2]
     [1,] "2.0.0-M"
     [2,] "id"
     [3,] "[MS, MS:1001582, xcms, 4.1.0]"
     [4,] "[MS, MS:1001834, LC-MS label-free quantitation analysis, ]"
     [5,] "MS"
     [6,] "PSI-MS controlled vocabulary"
     [7,] "4.1.138"
     [8,] "https://raw.githubusercontent.com/HUPO-PSI/psi-ms-CV/master/psi-ms.obo"
     [9,] "PRIDE"
    [10,] "PRIDE PRoteomics IDEntifications (PRIDE) database controlled vocabulary"
    [11,] "16:10:2023 11:38"
    [12,] "https://www.ebi.ac.uk/ols/ontologies/pride"
    [13,] "[,, \"no database\", null ]"
    [14,] "null"
    [15,] "Unknown"
    [16,] "null"
    [17,] "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]"
    [18,] "[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]"
    [19,] "[MS, MS:1002896, compound identification confidence level, ]"           

This represents some minimal information. The data of the MTD section is
formatted as a `character` 2-column `matrix`. We could now either change
the value (i.e., the elements in the second column of this matrix) of
existing fields, or also manually add additional fields/information. As
an example we add a title and description for the experiment. See also
the
[mzTab-M](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section)
format definition for other supported fields.

``` r

mtd <- rbind(
    mtd,
    c("title", "Experiment 1 preprocessed data"),
    c("description", "The preprocessed data of the experiment 1.")
)
```

To help with formatting we can also use the
[`mtd_fields()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_fields.md)
function. Below we use this function to add information about the MS
instrumentation to the MTD section:

``` r

instr <- mtd_fields(
    name = "[MS, MS:1000449, LTQ Orbitrap,]",
    source = "[MS, MS:1000073, ESI,]",
    `analyzer[1]` = "[MS, MS:1000291, linear ion trap,]",
    detector = "[MS, MS:1000253, electron multiplier,]",
    field_prefix = "instrument"
)
instr
```

         [,1]                        [,2]
    [1,] "instrument[1]-name"        "[MS, MS:1000449, LTQ Orbitrap,]"
    [2,] "instrument[1]-source"      "[MS, MS:1000073, ESI,]"
    [3,] "instrument[1]-analyzer[1]" "[MS, MS:1000291, linear ion trap,]"
    [4,] "instrument[1]-detector"    "[MS, MS:1000253, electron multiplier,]"

And we add that information to the `mtd` variable.

``` r

mtd <- rbind(mtd, instr)
```

Note that the general information part should also contain the
references to **all** controlled vocabulary (CV) ontologies used in the
mzTab-M file. The default ontologies added by the `mtb_skeleton()`
function are the *PSI-MS* and the *PRIDE* ontologies. If other
vocabularies are used, they should be added manually (following the
scheme of the others, i.e., the fields starting with `"cv["`).

The next category of metadata information is **sample information**.
This comprises (optional) information on individual samples that were
measured with the various assays/runs. We use the
[`mtd_sample()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_sample.md)
function to assist in compiling this information. Parameters `sample`,
`species`, `tissue` and `cell_type`, `disease` and `description` allow
to provide pre-defined sample properties. Additional sample annotations
and details can be provided through the function’s `...`. For the
example below we define some of these properties and in addition provide
a custom field for the extraction data. Be aware that
[`mtd_sample()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_sample.md)
does **not** support partial or positional matching of parameters; for
each of the parameters the **full parameter name** has to be used (i.e.,
`sample = ...` instead of `sam = ...` or `s = ...`).

``` r

mtd_s <- mtd_sample(
    sample = unique(exp$sample_id),
    species = "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]",
    tissue = "[BTO, BTO:0000759, liver, ]",
    cell_type = "[CL, CL:0000182, hepatocyte, ]",
    c("[,,Extraction date, 2011-12-21]",
      "[,,Extraction date, 2011-12-22]",
      "[,,Extraction date, 2011-12-23]")
    )
```

    1

``` r

mtd_s
```


     [1,] "sample[1]"              "S1"
     [2,] "sample[1]-species[1]"   "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"
     [3,] "sample[1]-tissue[1]"    "[BTO, BTO:0000759, liver, ]"
     [4,] "sample[1]-cell_type[1]" "[CL, CL:0000182, hepatocyte, ]"
     [5,] "sample[1]-custom[1]"    "[,,Extraction date, 2011-12-21]"
     [6,] "sample[2]"              "S2"
     [7,] "sample[2]-species[1]"   "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"
     [8,] "sample[2]-tissue[1]"    "[BTO, BTO:0000759, liver, ]"
     [9,] "sample[2]-cell_type[1]" "[CL, CL:0000182, hepatocyte, ]"
    [10,] "sample[2]-custom[1]"    "[,,Extraction date, 2011-12-22]"
    [11,] "sample[3]"              "S3"
    [12,] "sample[3]-species[1]"   "[NCBITaxon, NCBITaxon:9606, Homo sapiens, ]"
    [13,] "sample[3]-tissue[1]"    "[BTO, BTO:0000759, liver, ]"
    [14,] "sample[3]-cell_type[1]" "[CL, CL:0000182, hepatocyte, ]"
    [15,] "sample[3]-custom[1]"    "[,,Extraction date, 2011-12-23]"            

We can then add this information to the `mtd` variable by simply
[`rbind()`](https://rdrr.io/r/base/cbind.html)ing it.

``` r

mtd <- rbind(mtd, mtd_s)
```

Next we compile **MS run information** of the experiment using the
[`mtd_ms_run()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_ms_run.md)
helper function. This should comprise all (MS-specific) information
related to the measurement of each sample - including also the MS data
file names and locations. For our example we use the file names reported
in the sample data frame and specify the polarity of the measurement
runs.

``` r

mtd_msr <- mtd_ms_run(
    location = exp$file_name,
    format = "[MS, MS:1000584, mzML file, ]",
    id_format = "[MS, MS:1000530, mzML unique identifier, ]",
    scan_polarity = "positive")
mtd_msr
```

                                       values
     [1,] "ms_run[1]-location"         "s1-t1.mzML"
     [2,] "ms_run[1]-format"           "[MS, MS:1000584, mzML file, ]"
     [3,] "ms_run[1]-id_format"        "[MS, MS:1000530, mzML unique identifier, ]"
     [4,] "ms_run[1]-scan_polarity[1]" "[MS, MS:1000130, positive scan, ]"
     [5,] "ms_run[2]-location"         "s1-t2.mzML"
     [6,] "ms_run[2]-format"           "[MS, MS:1000584, mzML file, ]"
     [7,] "ms_run[2]-id_format"        "[MS, MS:1000530, mzML unique identifier, ]"
     [8,] "ms_run[2]-scan_polarity[1]" "[MS, MS:1000130, positive scan, ]"
     [9,] "ms_run[3]-location"         "s2-t1.mzML"
    [10,] "ms_run[3]-format"           "[MS, MS:1000584, mzML file, ]"
    [11,] "ms_run[3]-id_format"        "[MS, MS:1000530, mzML unique identifier, ]"
    [12,] "ms_run[3]-scan_polarity[1]" "[MS, MS:1000130, positive scan, ]"
    [13,] "ms_run[4]-location"         "s2-t2.mzML"
    [14,] "ms_run[4]-format"           "[MS, MS:1000584, mzML file, ]"
    [15,] "ms_run[4]-id_format"        "[MS, MS:1000530, mzML unique identifier, ]"
    [16,] "ms_run[4]-scan_polarity[1]" "[MS, MS:1000130, positive scan, ]"
    [17,] "ms_run[5]-location"         "s3-t1.mzML"
    [18,] "ms_run[5]-format"           "[MS, MS:1000584, mzML file, ]"
    [19,] "ms_run[5]-id_format"        "[MS, MS:1000530, mzML unique identifier, ]"
    [20,] "ms_run[5]-scan_polarity[1]" "[MS, MS:1000130, positive scan, ]"
    [21,] "ms_run[6]-location"         "s3-t2.mzML"
    [22,] "ms_run[6]-format"           "[MS, MS:1000584, mzML file, ]"
    [23,] "ms_run[6]-id_format"        "[MS, MS:1000530, mzML unique identifier, ]"
    [24,] "ms_run[6]-scan_polarity[1]" "[MS, MS:1000130, positive scan, ]"         

Each row in the `exp` data frame was assigned to a `"ms_run"` with the
location and format of the respective file as well as the polarity in
which the data was acquired. We can combine this data with the `mtd`
variable.

``` r

mtd <- rbind(mtd, mtd_msr)
```

Next we define the **assay information**. Generally, each measurement
(MS run) is associated to one assay, but also more complex
configurations are supported. See the help of the
[`mtd_assay()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_assay.md)
function for details on multiplexed or pre-fractionated samples.
Mandatory information that has to be provided to the
[`mtd_assay()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_assay.md)
function are the name (ID) of the assay and the reference to the MS run
in which the assay was measured. For the latter, a format of
`"ms_run[<index of the MS run>]"` is expected. For our example we
provide in addition also the (optional, but suggested) reference to the
original sample. Note that each assay must represent one column in the
following feature abundance table (SMF).

``` r

mtd_a <- mtd_assay(
    assay = exp$sample_name,
    sample_ref = c("sample[1]", "sample[1]", "sample[2]", "sample[2]",
                   "sample[3]", "sample[3]"),
    ms_run_ref = paste0("ms_run[", seq_len(nrow(exp)), "]")
)
```

    0

``` r

mtd_a
```


     [1,] "assay[1]"            "S1_T1"
     [2,] "assay[1]-sample_ref" "sample[1]"
     [3,] "assay[1]-ms_run_ref" "ms_run[1]"
     [4,] "assay[2]"            "S1_T2"
     [5,] "assay[2]-sample_ref" "sample[1]"
     [6,] "assay[2]-ms_run_ref" "ms_run[2]"
     [7,] "assay[3]"            "S2_T1"
     [8,] "assay[3]-sample_ref" "sample[2]"
     [9,] "assay[3]-ms_run_ref" "ms_run[3]"
    [10,] "assay[4]"            "S2_T2"
    [11,] "assay[4]-sample_ref" "sample[2]"
    [12,] "assay[4]-ms_run_ref" "ms_run[4]"
    [13,] "assay[5]"            "S3_T1"
    [14,] "assay[5]-sample_ref" "sample[3]"
    [15,] "assay[5]-ms_run_ref" "ms_run[5]"
    [16,] "assay[6]"            "S3_T2"
    [17,] "assay[6]-sample_ref" "sample[3]"
    [18,] "assay[6]-ms_run_ref" "ms_run[6]"

We add this information to the `mtd` variable.

``` r

mtd <- rbind(mtd, mtd_a)
```

At last we compile the **study variable information** of our example
experiment. This should capture all experiment-relevant study variables.
In R, such information is generally encoded in a *sample* or *phenotype*
`data.frame`, with rows being individual samples (or measurements
thereof) and columns the sample characteristics (i.e., the study
variables). For our example we use the
[`mtd_study_variables()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_study_variables.md)
function to generate the mzTab-M study variable information, specifying
with parameter `study_variable_columns` the names of the `data.frame`
containing the relevant information.

``` r

mtd_svar <- mtd_study_variables(
    exp,
    study_variable_columns = c("timepoint", "genotype", "operator"))
mtd_svar
```

          [,1]
     [1,] "study_variable[1]"
     [2,] "study_variable[1]-assay_refs"
     [3,] "study_variable[1]-average_function"
     [4,] "study_variable[1]-variation_function"
     [5,] "study_variable[1]-description"
     [6,] "study_variable[2]"
     [7,] "study_variable[2]-assay_refs"
     [8,] "study_variable[2]-average_function"
     [9,] "study_variable[2]-variation_function"
    [10,] "study_variable[2]-description"
    [11,] "study_variable[3]"
    [12,] "study_variable[3]-assay_refs"
    [13,] "study_variable[3]-average_function"
    [14,] "study_variable[3]-variation_function"
    [15,] "study_variable[3]-description"
    [16,] "study_variable[4]"
    [17,] "study_variable[4]-assay_refs"
    [18,] "study_variable[4]-average_function"
    [19,] "study_variable[4]-variation_function"
    [20,] "study_variable[4]-description"
    [21,] "study_variable[5]"
    [22,] "study_variable[5]-assay_refs"
    [23,] "study_variable[5]-average_function"
    [24,] "study_variable[5]-variation_function"
    [25,] "study_variable[5]-description"
    [26,] "study_variable[6]"
    [27,] "study_variable[6]-assay_refs"
    [28,] "study_variable[6]-average_function"
    [29,] "study_variable[6]-variation_function"
    [30,] "study_variable[6]-description"
          [,2]
     [1,] "timepoint:0h"
     [2,] "assay[1]|assay[3]|assay[5]"
     [3,] "[MS, MS:1002962, mean, ]"
     [4,] "[MS, MS:1002963, variation coefficient, ]"
     [5,] "Column: timepoint, value: 0h"
     [6,] "timepoint:6h"
     [7,] "assay[2]|assay[4]|assay[6]"
     [8,] "[MS, MS:1002962, mean, ]"
     [9,] "[MS, MS:1002963, variation coefficient, ]"
    [10,] "Column: timepoint, value: 6h"
    [11,] "genotype:WT"
    [12,] "assay[1]|assay[2]"
    [13,] "[MS, MS:1002962, mean, ]"
    [14,] "[MS, MS:1002963, variation coefficient, ]"
    [15,] "Column: genotype, value: WT"
    [16,] "genotype:KO"
    [17,] "assay[3]|assay[4]|assay[5]|assay[6]"
    [18,] "[MS, MS:1002962, mean, ]"
    [19,] "[MS, MS:1002963, variation coefficient, ]"
    [20,] "Column: genotype, value: KO"
    [21,] "operator:BB"
    [22,] "assay[1]|assay[2]|assay[3]|assay[4]"
    [23,] "[MS, MS:1002962, mean, ]"
    [24,] "[MS, MS:1002963, variation coefficient, ]"
    [25,] "Column: operator, value: BB"
    [26,] "operator:FB"
    [27,] "assay[5]|assay[6]"
    [28,] "[MS, MS:1002962, mean, ]"
    [29,] "[MS, MS:1002963, variation coefficient, ]"
    [30,] "Column: operator, value: FB"              

Each unique value in each of the specified columns is encoded as a
`study_variable` (or rather as a *study variable value*), with its
*assay_refs* attribute containing the rows/assays in which this value
was measured. The variable’s *description* (by default) indicates the
name of the column. The *average_function* and *variation_function*
attributes allow to define the function that was used to calculate the
average and variance of the abundance values for that variable value. In
upcoming versions a dedicated attribute *group* can be used to specify
the name of the column (i.e. the study variable name) the study variable
value is provided in.

We next add the study variable information to the `mtd`variable.

``` r

mtd <- rbind(mtd, mtd_svar)
```

At last we sort the elements according to the expected order in the MTD
section using the
[`mtd_sort()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_sort.md)
function.

``` r

mtd <- mtd_sort(mtd)
```

This two-column `matrix` could now be saved to a text file using a
tabulator (`"\t"`) as a field separator. The full metadata header is
shown in the table below.

``` r

library(pander)
pandoc.table(mtd, style = "rmarkdown", split.table = Inf)
```

|   |   |
|:--:|:--:|
| mzTab-version | 2.0.0-M |
| mzTab-ID | id |
| title | Experiment 1 preprocessed data |
| description | The preprocessed data of the experiment 1. |
| instrument\[1\]-name | \[MS, MS:1000449, LTQ Orbitrap,\] |
| instrument\[1\]-source | \[MS, MS:1000073, ESI,\] |
| instrument\[1\]-analyzer\[1\] | \[MS, MS:1000291, linear ion trap,\] |
| instrument\[1\]-detector | \[MS, MS:1000253, electron multiplier,\] |
| software\[1\] | \[MS, MS:1001582, xcms, 4.1.0\] |
| quantification_method | \[MS, MS:1001834, LC-MS label-free quantitation analysis, \] |
| sample\[1\] | S1 |
| sample\[1\]-species\[1\] | \[NCBITaxon, NCBITaxon:9606, Homo sapiens, \] |
| sample\[1\]-tissue\[1\] | \[BTO, BTO:0000759, liver, \] |
| sample\[1\]-cell_type\[1\] | \[CL, CL:0000182, hepatocyte, \] |
| sample\[1\]-custom\[1\] | \[,,Extraction date, 2011-12-21\] |
| sample\[2\] | S2 |
| sample\[2\]-species\[1\] | \[NCBITaxon, NCBITaxon:9606, Homo sapiens, \] |
| sample\[2\]-tissue\[1\] | \[BTO, BTO:0000759, liver, \] |
| sample\[2\]-cell_type\[1\] | \[CL, CL:0000182, hepatocyte, \] |
| sample\[2\]-custom\[1\] | \[,,Extraction date, 2011-12-22\] |
| sample\[3\] | S3 |
| sample\[3\]-species\[1\] | \[NCBITaxon, NCBITaxon:9606, Homo sapiens, \] |
| sample\[3\]-tissue\[1\] | \[BTO, BTO:0000759, liver, \] |
| sample\[3\]-cell_type\[1\] | \[CL, CL:0000182, hepatocyte, \] |
| sample\[3\]-custom\[1\] | \[,,Extraction date, 2011-12-23\] |
| ms_run\[1\]-location | s1-t1.mzML |
| ms_run\[1\]-format | \[MS, MS:1000584, mzML file, \] |
| ms_run\[1\]-id_format | \[MS, MS:1000530, mzML unique identifier, \] |
| ms_run\[1\]-scan_polarity\[1\] | \[MS, MS:1000130, positive scan, \] |
| ms_run\[2\]-location | s1-t2.mzML |
| ms_run\[2\]-format | \[MS, MS:1000584, mzML file, \] |
| ms_run\[2\]-id_format | \[MS, MS:1000530, mzML unique identifier, \] |
| ms_run\[2\]-scan_polarity\[1\] | \[MS, MS:1000130, positive scan, \] |
| ms_run\[3\]-location | s2-t1.mzML |
| ms_run\[3\]-format | \[MS, MS:1000584, mzML file, \] |
| ms_run\[3\]-id_format | \[MS, MS:1000530, mzML unique identifier, \] |
| ms_run\[3\]-scan_polarity\[1\] | \[MS, MS:1000130, positive scan, \] |
| ms_run\[4\]-location | s2-t2.mzML |
| ms_run\[4\]-format | \[MS, MS:1000584, mzML file, \] |
| ms_run\[4\]-id_format | \[MS, MS:1000530, mzML unique identifier, \] |
| ms_run\[4\]-scan_polarity\[1\] | \[MS, MS:1000130, positive scan, \] |
| ms_run\[5\]-location | s3-t1.mzML |
| ms_run\[5\]-format | \[MS, MS:1000584, mzML file, \] |
| ms_run\[5\]-id_format | \[MS, MS:1000530, mzML unique identifier, \] |
| ms_run\[5\]-scan_polarity\[1\] | \[MS, MS:1000130, positive scan, \] |
| ms_run\[6\]-location | s3-t2.mzML |
| ms_run\[6\]-format | \[MS, MS:1000584, mzML file, \] |
| ms_run\[6\]-id_format | \[MS, MS:1000530, mzML unique identifier, \] |
| ms_run\[6\]-scan_polarity\[1\] | \[MS, MS:1000130, positive scan, \] |
| assay\[1\] | S1_T1 |
| assay\[1\]-sample_ref | sample\[1\] |
| assay\[1\]-ms_run_ref | ms_run\[1\] |
| assay\[2\] | S1_T2 |
| assay\[2\]-sample_ref | sample\[1\] |
| assay\[2\]-ms_run_ref | ms_run\[2\] |
| assay\[3\] | S2_T1 |
| assay\[3\]-sample_ref | sample\[2\] |
| assay\[3\]-ms_run_ref | ms_run\[3\] |
| assay\[4\] | S2_T2 |
| assay\[4\]-sample_ref | sample\[2\] |
| assay\[4\]-ms_run_ref | ms_run\[4\] |
| assay\[5\] | S3_T1 |
| assay\[5\]-sample_ref | sample\[3\] |
| assay\[5\]-ms_run_ref | ms_run\[5\] |
| assay\[6\] | S3_T2 |
| assay\[6\]-sample_ref | sample\[3\] |
| assay\[6\]-ms_run_ref | ms_run\[6\] |
| study_variable\[1\] | timepoint:0h |
| study_variable\[1\]-assay_refs | assay\[1\]\|assay\[3\]\|assay\[5\] |
| study_variable\[1\]-average_function | \[MS, MS:1002962, mean, \] |
| study_variable\[1\]-variation_function | \[MS, MS:1002963, variation coefficient, \] |
| study_variable\[1\]-description | Column: timepoint, value: 0h |
| study_variable\[2\] | timepoint:6h |
| study_variable\[2\]-assay_refs | assay\[2\]\|assay\[4\]\|assay\[6\] |
| study_variable\[2\]-average_function | \[MS, MS:1002962, mean, \] |
| study_variable\[2\]-variation_function | \[MS, MS:1002963, variation coefficient, \] |
| study_variable\[2\]-description | Column: timepoint, value: 6h |
| study_variable\[3\] | genotype:WT |
| study_variable\[3\]-assay_refs | assay\[1\]\|assay\[2\] |
| study_variable\[3\]-average_function | \[MS, MS:1002962, mean, \] |
| study_variable\[3\]-variation_function | \[MS, MS:1002963, variation coefficient, \] |
| study_variable\[3\]-description | Column: genotype, value: WT |
| study_variable\[4\] | genotype:KO |
| study_variable\[4\]-assay_refs | assay\[3\]\|assay\[4\]\|assay\[5\]\|assay\[6\] |
| study_variable\[4\]-average_function | \[MS, MS:1002962, mean, \] |
| study_variable\[4\]-variation_function | \[MS, MS:1002963, variation coefficient, \] |
| study_variable\[4\]-description | Column: genotype, value: KO |
| study_variable\[5\] | operator:BB |
| study_variable\[5\]-assay_refs | assay\[1\]\|assay\[2\]\|assay\[3\]\|assay\[4\] |
| study_variable\[5\]-average_function | \[MS, MS:1002962, mean, \] |
| study_variable\[5\]-variation_function | \[MS, MS:1002963, variation coefficient, \] |
| study_variable\[5\]-description | Column: operator, value: BB |
| study_variable\[6\] | operator:FB |
| study_variable\[6\]-assay_refs | assay\[5\]\|assay\[6\] |
| study_variable\[6\]-average_function | \[MS, MS:1002962, mean, \] |
| study_variable\[6\]-variation_function | \[MS, MS:1002963, variation coefficient, \] |
| study_variable\[6\]-description | Column: operator, value: FB |
| cv\[1\]-label | MS |
| cv\[1\]-full_name | PSI-MS controlled vocabulary |
| cv\[1\]-version | 4.1.138 |
| cv\[1\]-uri | https://raw.githubusercontent.com/HUPO-PSI/psi-ms-CV/master/psi-ms.obo |
| cv\[2\]-label | PRIDE |
| cv\[2\]-full_name | PRIDE PRoteomics IDEntifications (PRIDE) database controlled vocabulary |
| cv\[2\]-version | 16:10:2023 11:38 |
| cv\[2\]-uri | https://www.ebi.ac.uk/ols/ontologies/pride |
| database\[1\] | \[,, “no database”, null \] |
| database\[1\]-prefix | null |
| database\[1\]-version | Unknown |
| database\[1\]-uri | null |
| small_molecule-quantification_unit | \[PRIDE, PRIDE:0000330, Arbitrary quantification unit, \] |
| small_molecule_feature-quantification_unit | \[PRIDE, PRIDE:0000330, Arbitrary quantification unit, \] |
| small_molecule-identification_reliability | \[MS, MS:1002896, compound identification confidence level, \] |

#### Reading and importing

TODO: implement these functions moving the respective code from the
legacy repo

#### General utility functions

General utility functions include:

- [`mtd_fields()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_fields.md):
  to format values in the mzTab-M-specific format.
- [`mtd_sort()`](https://rformassspectrometry.github.io/RmzTabM/reference/mtd_sort.md):
  to sort rows of the metadata `matrix` into the expected order.

## Session information

``` r

sessionInfo()
```

    R Under development (unstable) (2025-12-07 r89119)
    Platform: x86_64-pc-linux-gnu
    Running under: Ubuntu 24.04.3 LTS

    Matrix products: default
    BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3
    LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0

    locale:
     [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C
     [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8
     [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8
     [7] LC_PAPER=en_US.UTF-8       LC_NAME=C
     [9] LC_ADDRESS=C               LC_TELEPHONE=C
    [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C

    time zone: UTC
    tzcode source: system (glibc)

    attached base packages:
    [1] stats     graphics  grDevices utils     datasets  methods   base

    other attached packages:
    [1] pander_0.6.6   RmzTabM_0.97.2

    loaded via a namespace (and not attached):
     [1] compiler_4.6.0  fastmap_1.2.0   cli_3.6.5       tools_4.6.0
     [5] htmltools_0.5.9 yaml_2.3.12     Rcpp_1.1.0.8.1  rmarkdown_2.30
     [9] knitr_1.50      jsonlite_2.0.0  xfun_0.54       digest_0.6.39
    [13] rlang_1.1.6     evaluate_1.0.5 
