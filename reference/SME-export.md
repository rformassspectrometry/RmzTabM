# Creating the mzTab-M Small Molecule (SME) Table

The Small Molecule (SME) table is representing evidence for
identifications of small molecules/features, from database search or any
other process used to give putative identifications to molecules. In a
typical case, each row represents one result from a single search or
intepretation of a piece of evidence (e.g. a database search with a
fragmentation spectrum). Multiple results from a given input data item
(e.g. one fragment spectrum) SHOULD share the same value under
`"evidence_input_id"`. The small molecule evidence section MUST always
come after the `"Small Molecule Feature"` (SMF) Table. There MUST NOT be
any empty cells and missing values MUST be reported using `"null"`. All
columns are MANDATORY except for `"opt_"` columns.

A detailed description of the SME format and its columns is provided in
the [respective
section](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#65-small-molecule-evidence-sme-section)
of the mzTab-M specification.

The functions to create and format the SME content are:

- `sme_create()`: provides a simplified workflow to generate this table
  in a single step. It takes vectors defining feature properties.

  It automatically:

  - Adds the required `SME_ID` and standard mzTab-M columns (e.g.,
    `evidence_input_id`).

  - Populates missing mandatory columns with `"null"` strings to ensure
    compliance.

  - Sets the line prefix column `SEH` to `"SME"`.

  - Orders columns according to the mzTab-M specification.

  **Important:** to support the optional additional parameters passed
  along with `...` **all** parameters have to be **fully** spelled out.
  All parameters are vectorized and recycled as needed to match the
  number of rows in the abundance matrix. If their length is not equal
  to the number of rows or 1, an error is raised.

  See also the [specification of the SMF
  section](https://github.com/HUPO-PSI/mzTab-M/blob/main/specification_documents/mzTab_format_specification_2_1-M.adoc#65-small-molecule-evidence-sme-section)
  for details.

- `sme_sort()`: can be used to sort the columns of the SME data frame
  according to the standard order defined in the mzTab-M specification.
  This is useful if you have added custom columns and want to ensure the
  standard columns are in the correct order for export.

## Usage

``` r
sme_create(
  ...,
  evidence_input_id = character(),
  database_identifier = character(),
  chemical_formula = character(),
  smiles = character(),
  inchi = character(),
  chemical_name = character(),
  uri = character(),
  derivatized_form = character(),
  adduct_ions = character(),
  exp_mass_to_charge = numeric(),
  charge = numeric(),
  theoretical_mass_to_charge = numeric(),
  spectra_ref = character(),
  identification_method = character(),
  ms_level = character(),
  id_confidence_measure = NULL,
  rank = 1,
  mtd = NULL
)

sme_sort(x)

sme_id_confidence_measure(x, mtd, nr = numeric())

sme_spectra_ref_validator(x, mtd)
```

## Arguments

- ...:

  optional columns to be added to the SME. The length of arguments
  passed through `...` has to match `nrow(x)` and the arguments **have**
  to be named. The name of the argument is used for the column name,
  prefixed with `"opt_"`.

- evidence_input_id:

  `character` with the file unique identifier for the input data used to
  support this identification e.g. fragment spectrum, RT and m/z pair,
  isotope profile that was used for the identification process, to serve
  as a grouping mechanism, whereby multiple rows of results from the
  same input data share the same ID. The identifiers may be human
  readable but should not be assumed to be interpretable. For example,
  if fragmentation spectra have been searched then the ID may be the
  spectrum reference, or for accurate mass search, the
  `"ms_run[2]:458.75"`.

- database_identifier:

  `character` with the putative identification for the small molecule
  sourced from an external database. This could include additionally a
  chemical class or an identifier to a spectral library entity, even if
  its actual identity is unknown. Has to be in the format *:* to provide
  the database/source of annotation and the ID (e.g.
  `"HMDB:HMDB0001847"`). Can be `"null"` or `NA` for molecules without
  annotations. The length of `database_identifier` has to match the
  number of rows of `x`. If not provided (the default) `"null"` is
  assigned to each row/molecule.

- chemical_formula:

  `character` with the chemical formula of the compound. This should be
  specified in Hill notation (EA Hill 1900), i.e. elements in the order
  C, H and then alphabetically all other elements. Counts of one may be
  omitted. Elements should be capitalized properly to avoid confusion
  (e.g., `“CO”` vs. `“Co”`). The chemical formula reported should refer
  to the neutral form. Charge state is reported by the charge field. For
  example: `"N-acetylglucosamine"` would be encoded by the string
  `“C8H15NO6”`. Can be `"null"` but, if provided, its length has to
  match the number of rows of `x`.

- smiles:

  `character` with the potential molecule structures in the simplified
  molecular-input line-entry system (SMILES) for the small molecule. Can
  be `"null"` but, if provided, its length has to match the number of
  rows of `x`.

- inchi:

  `character` with the potential standard IUPAC International Chemical
  Identifier (InChI) of the given substance. Can be `"null"` but, if
  provided, its length has to match the number of rows of `x`.

- chemical_name:

  `character` with the possible chemical/common names for the small
  molecule, or general description if a chemical name is unavailable.
  Can be `"null"` but, if provided, its length has to match the number
  of rows of `x`.

- uri:

  `character` with the URI pointing to the small molecule’s entry in a
  reference database (e.g., the small molecule’s HMDB or KEGG entry).
  Can be `"null"` but, if provided, its length has to match the number
  of rows of `x`.

- derivatized_form:

  `character` with the derivatized form that has been analysed by MS,
  then the functional group attached to the molecule should be reported
  using suitable CV terms as appropriate.

- adduct_ions:

  [`character()`](https://rdrr.io/r/base/character.html) with the
  assumed classification of molecule’s adduct ion after detection,
  following the general style in the 2013 IUPAC recommendations on terms
  relating to MS (e.g. `"[M+Na]1"`, `"[M+NH4]1+"`, `"[M-H]1-"`,
  `"[M+Cl]1-"`). Can be `"null"` (or `NA`) but, if provided, its length
  has to match the number of rows of `x`.

- exp_mass_to_charge:

  `numeric` with the experimental mass/charge value for the precursor
  ion. If multiple adduct forms have been combined into a single
  identification event/search, then a single value e.g. for the
  protonated form SHOULD be reported here.

- charge:

  `numeric` with the small molecule evidence’s charge value using
  positive integers both for positive and negative polarity modes.

- theoretical_mass_to_charge:

  `numeric` with the theoretical mass/charge value for the small
  molecule or the database mass/charge value.

- spectra_ref:

  `character` Reference to a spectrum in a spectrum file. If a separate
  spectrum file has been used for fragmentation spectrum, this MUST be
  reported in the metadata section as additional ms_runs. The reference
  must be in the format `"ms_run[1-n]:{SPECTRA_REF}"`. Multiple spectra
  MUST be referenced using a `"|"` delimited list for the (rare) cases
  in which search engines have combined or aggregated multiple spectra
  in advance of the search to make identifications. If a fragmentation
  spectrum has not been used, the value should indicate the ms_run to
  which is identification is mapped e.g. `"ms_run[1]"`.

- identification_method:

  `character` with the database search, search engine or process that
  was used to identify this small molecule (e.g. the name of software,
  database or manual curation etc). If manual validation has been
  performed quality, the following CV term SHOULD be used:
  `"quality estimation by manual validation"` `MS:1001058`.

- ms_level:

  `character` with the highest MS level used to inform identification
  (e.g. from an MS2 fragmentation spectrum =
  `""[MS, MS:1000511, ms level, 2]""`. For direct fragmentation or data
  independent approaches where fragmentation data is used, appropriate
  CV terms SHOULD be used.

- id_confidence_measure:

  `matrix` with any statistical value or score for the identification.
  The metadata section reports the type of score used, as
  `"id_confidence_measure[1-n]"`.

- rank:

  `numeric`with the rank of this identification from this approach as
  increasing integers from 1 (best ranked identification). Ties (equal
  score) are represented by using the same rank, defaults to `"1"` if
  there is no ranking system used.

- mtd:

  two-column `matrix` or `data.frame` with the metadata (MTD) definition
  of the data set. The first column needs to contain the metadata field
  names, the second the corresponding values. See
  [MTD-export](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-export.md)
  help page for more information.

- x:

  for `sme_spectra_ref_validator()`: `character` with reference to a
  spectrum in a spectrum file. For `sme_id_confidence_measure()`:
  `matrix` or `data.frame` with any statistical value or score for the
  identification. For
  [`sml_sort()`](https://rformassspectrometry.github.io/RmzTabM/reference/SML-export.md):
  a SML `data.frame`, such as created by
  [`sml_create()`](https://rformassspectrometry.github.io/RmzTabM/reference/SML-export.md).

- nr:

  `numeric` with the number of small molecule evidence.

## Value

A complete SME `data.frame` ready for export. The data frame contains
the 'SEH' line prefix, standard columns ordered according to spec, and
any optional columns.

## Details

All parameters passed to the `sme_create()` function must be **fully
named**.

## See also

[MTD-export](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-export.md),
[SMF-export](https://rformassspectrometry.github.io/RmzTabM/reference/SMF-export.md)
and
[SML-export](https://rformassspectrometry.github.io/RmzTabM/reference/SML-export.md)
for creating and formatting the metadata (MTD), small molecule feature
(SMF) and small molecule (SML) sections.

## Author

Gabriele Tomè

## Examples

``` r

## Define minimum required MTD section
mtd <- cbind(c("ms_run[1]-location", "ms_run[1]-format",
               "ms_run[1]-id_format", "ms_run[1]-scan_polarity[1]",
               "ms_run[2]-location", "ms_run[2]-format",
               "ms_run[2]-id_format", "ms_run[2]-scan_polarity[1]",
               "ms_run[3]-location", "ms_run[3]-format",
               "ms_run[3]-id_format", "ms_run[3]-scan_polarity[1]"),
             c("1.mzML", "[MS, MS:1000584, mzML file, ]",
               "[MS, MS:1000530, mzML unique identifier, ]",
               "[MS, MS:1000130, positive scan, ]",
               "2.mzML", "[MS, MS:1000584, mzML file, ]",
               "[MS, MS:1000530, mzML unique identifier, ]",
               "[MS, MS:1000130, positive scan, ]",
               "3.mzML", "[MS, MS:1000584, mzML file, ]",
               "[MS, MS:1000530, mzML unique identifier, ]",
               "[MS, MS:1000130, positive scan, ]"))

## Define minimum parameter to build SME section
evidence_input_id = c("ms_run[1]:mass=700.5255;rt=20·5",
                      "ms_run[2]:mass=452.2782;rt=35.1",
                      "ms_run[3]:mass=882.6210;rt=40.0")
exp_mass_to_charge = c(700.5255, 452.2782, 882.6210)
charge = c(1, 1, 1)
theoretical_mass_to_charge = c(700.5281, 452.2777, 882.6224)
spectra_ref = c("ms_run[1]:index=7646", "ms_run[2]:index=7640",
                "ms_run[3]:index=7671|ms_run[3]:index=7725")
identification_method = "[, , LipidDataAnalyzer, 2.11.1]"
ms_level = "[MS, MS:1000511, ms level, 2]"

## Create the final dataframe ready for export
## Note: Fields not provided are automatically set to "null"
sme_final <- sme_create(
    evidence_input_id = evidence_input_id,
    exp_mass_to_charge = exp_mass_to_charge,
    charge = charge,
    theoretical_mass_to_charge = theoretical_mass_to_charge,
    spectra_ref = spectra_ref,
    identification_method = identification_method,
    ms_level = ms_level,
    mtd = mtd
)

## The result contains the 'SEH' line prefix and standard columns
head(sme_final)
#>   SEH               evidence_input_id database_identifier chemical_formula
#> 1 SME ms_run[1]:mass=700.5255;rt=20·5                null             null
#> 2 SME ms_run[2]:mass=452.2782;rt=35.1                null             null
#> 3 SME ms_run[3]:mass=882.6210;rt=40.0                null             null
#>   smiles inchi chemical_name  uri derivatized_form adduct_ions
#> 1   null  null          null null             null        null
#> 2   null  null          null null             null        null
#> 3   null  null          null null             null        null
#>   exp_mass_to_charge charge theoretical_mass_to_charge
#> 1           700.5255      1                   700.5281
#> 2           452.2782      1                   452.2777
#> 3            882.621      1                   882.6224
#>                                 spectra_ref           identification_method
#> 1                      ms_run[1]:index=7646 [, , LipidDataAnalyzer, 2.11.1]
#> 2                      ms_run[2]:index=7640 [, , LipidDataAnalyzer, 2.11.1]
#> 3 ms_run[3]:index=7671|ms_run[3]:index=7725 [, , LipidDataAnalyzer, 2.11.1]
#>                        ms_level rank
#> 1 [MS, MS:1000511, ms level, 2]    1
#> 2 [MS, MS:1000511, ms level, 2]    1
#> 3 [MS, MS:1000511, ms level, 2]    1
```
