# The R API for the mzTab-M File Format

## Introduction

## Installation

## R mzTab-M API

… TODO … general info, links to information …

``` r

library(RmzTabM)
```

### High-level, user faced functions

### Low-level functions

The low-level functions listed in this section provide the functionality
to convert or format information and data for/from the \[mzTab-M\]
format. These functions are designed to be re-used by other R packages
and should take and return only basic, plain R data types.

#### Formatting and exporting

##### Metadata

The mzTab-M format defines various fields and parameters to describe the
data and information of an experiment. The *RmzTabM* package provides a
variety of utility functions that help defining and formatting this
information.

See also the [specification of the MTD
section](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#62-metadata-section)
for more information and optional and mandatory metadata fields.

#### Reading and importing

#### General utility functions

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
    [1] RmzTabM_0.97.0

    loaded via a namespace (and not attached):
     [1] compiler_4.6.0  fastmap_1.2.0   cli_3.6.5       tools_4.6.0
     [5] htmltools_0.5.9 yaml_2.3.11     rmarkdown_2.30  knitr_1.50
     [9] jsonlite_2.0.0  xfun_0.54       digest_0.6.39   rlang_1.1.6
    [13] evaluate_1.0.5 
