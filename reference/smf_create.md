# Create the mzTab-M Small Molecule Feature (SMF) Table

The Small Molecule Feature (SMF) section of the mzTab-M definition
captures information on the individual MS features (quantified regions,
e.g., elution profiles of specific *m/z* and retention times) that were
measured across the assays.

`smf_create()` provides a simplified workflow to generate this table in
a single step. It takes a matrix of abundances (rows=features,
columns=assays) and optional vectors defining feature properties.

It automatically:

- Formats the abundance matrix (renaming columns to
  `abundance_assay[n]`).

- Adds the required `SMF_ID` and standard mzTab-M columns (e.g.,
  `exp_mass_to_charge`).

- Populates missing mandatory columns with `"null"` strings to ensure
  compliance.

- Sets the line prefix column `SFH` to `"SMF"`.

- Orders columns according to the mzTab-M specification.

**Important:** to support the optional additional parameters passed
along with `...` **all** parameters (such as `adduct_ion`,
`retention_time_in_seconds` etc) have to be **fully** spelled out. All
parameters are vectorized and recycled as needed to match the number of
rows in the abundance matrix, if their length is not equal to the number
of rows or 1, an error is raised.

See also the [specification of the SMF
section](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#64-small-molecule-feature-smf-section)
for details.

## Usage

``` r
smf_create(
  ...,
  smf_df,
  exp_mass_to_charge = NULL,
  retention_time_in_seconds = NULL,
  retention_time_in_seconds_start = NULL,
  retention_time_in_seconds_end = NULL,
  SME_ID_REFS = NULL,
  SME_ID_REF_ambiguity_code = NULL,
  charge = NULL,
  adduct_ion = NULL,
  isotopomer = NULL
)
```

## Arguments

- ...:

  Additional optional columns to add. These arguments must be named. The
  function will automatically prepend `"opt_"` to the names if not
  already present.

- smf_df:

  `matrix` or `data.frame` of abundances. Rows are features, columns are
  assays. The order of columns is assumed to match the order of assays
  defined in the Metadata (MTD) section.

- exp_mass_to_charge:

  `numeric` vector of experimental m/z values. **Cannot** be `NULL`.

- retention_time_in_seconds:

  `numeric` vector of retention times in seconds. Defaults to `"null"`.

- retention_time_in_seconds_start:

  `numeric` vector of start retention times in seconds. Defaults to
  `"null"`.

- retention_time_in_seconds_end:

  `numeric` vector of end retention times in seconds. Defaults to
  `"null"`.

- SME_ID_REFS:

  `character` vector of SME IDs referencing small molecules. Defaults to
  `"null"`.

- SME_ID_REF_ambiguity_code:

  `character` vector of ambiguity codes for SME ID references. Defaults
  to `"null"`.

- charge:

  `integer` vector of charge states. Defaults to `"null"`.

- adduct_ion:

  `character` vector of adducts (e.g. `"[M+H]+"`). Defaults to `"null"`.

- isotopomer:

  `character` vector for isotopomer description. Defaults to `"null"`.

## Value

A complete SMF `data.frame` ready for export. The data frame contains
the 'SFH' line prefix, standard columns ordered according to spec,
abundance columns, and any optional columns.

## Author

Philippine Louail

## Examples

``` r

## Assume we have a matrix of abundances (e.g., from xcms or similar tools)
## Rows are features, Columns are Samples/Assays.
abund_mat <- matrix(
    c(100.1, 105.2, 110.3,
      200.5, 198.2, 201.0,
      50.0, 55.0, 52.1),
    nrow = 3, byrow = TRUE
)

## Define feature metadata (vectors must match number of rows in matrix)
mz_values <- c(150.05, 200.10, 300.15)
rt_values <- c(20.5, 35.1, 40.0)
adducts <- c("[M+H]+", "[M+Na]+", "[M+H]+")

## Create the final dataframe ready for export
## Note: Fields not provided (like charge) are automatically set to "null"
smf_final <- smf_create(
    smf_df = abund_mat,
    exp_mass_to_charge = mz_values,
    retention_time_in_seconds = rt_values,
    adduct_ion = adducts,
    ## Optional custom column example
    global_custom_attribute = c("A", "B", "C")
)

## The result contains the 'SFH' line prefix, standard columns, and
## abundances
head(smf_final)
#>   SFH SMF_ID SME_ID_REFS SME_ID_REF_ambiguity_code adduct_ion isotopomer
#> 1 SMF      1        null                      null     [M+H]+       null
#> 2 SMF      2        null                      null    [M+Na]+       null
#> 3 SMF      3        null                      null     [M+H]+       null
#>   exp_mass_to_charge charge retention_time_in_seconds
#> 1             150.05   null                      20.5
#> 2              200.1   null                      35.1
#> 3             300.15   null                        40
#>   retention_time_in_seconds_start retention_time_in_seconds_end
#> 1                            null                          null
#> 2                            null                          null
#> 3                            null                          null
#>   abundance_assay[1] abundance_assay[2] abundance_assay[3]
#> 1              100.1              105.2              110.3
#> 2              200.5              198.2              201.0
#> 3               50.0               55.0               52.1
#>   opt_global_custom_attribute
#> 1                           A
#> 2                           B
#> 3                           C
```
