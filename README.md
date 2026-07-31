# R implementation for mzTab-M

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![R-CMD-check-bioc](https://github.com/RforMassSpectrometry/RmzTabM/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/RforMassSpectrometry/RmzTabM/actions?query=workflow%3AR-CMD-check-bioc)
[![codecov](https://codecov.io/gh/rformassspectrometry/RmzTabM/graph/badge.svg?token=v2UTVt3UrA)](https://codecov.io/gh/rformassspectrometry/RmzTabM)

## Welcome to **RmzTabM**!

This is the mzTab-M R API and reference implementation.

mzTab-M is intended as a reporting standard for quantitative results from
metabolomics/lipodomics approaches. This format is further intended to provide
local LIMS systems as well as MS metabolomics repositories a simple way to share
and combine basic information.

:pushpin: see the [package
vignette](https://rformassspectrometry.github.io/RmzTabM/articles/rmztabm-api.html)
for examples and an introduction of the provided functionality.

mzTab-M has been developed with a view to support the following general tasks:

1. Facilitate the sharing of final experimental results, especially with
   researchers outside the field of metabolomics.

2. Export of results to external software, including programs such as Microsoft
   Excel® and Open Office Spreadsheet and statistical software / coding
   languages such as R.

3. Act as an output format of (web-) services that report MS-based results and
   thus can produce standardized result pages.

4. Be able to link to the external experimental evidence e.g. by referencing
   back to mzML files.


## Related Projects

- [legacy rmzTabM package](https://github.com/lifs-tools/rmzTabM)
- [mzTab-M Standard Specification](http://github.com/HUPO-PSI/mztab)
- [jmzTab-M Reference Implementation and Validator](https://github.com/lifs-tools/jmztab-m)
- [jmzTab-M Webapplication and Validator](https://github.com/lifs-tools/jmztab-m-webapp)


## Installation

The R package can be installed from Bioconductor using:

```r
#' Install required packages
install.packages("BiocManager")

#' Install the package
BiocManager::install("RmzTabM")
```

## 🛠️ Development status

:information_source: *core functions* are expected to take and return single
base R data types.

- [X] core functionality to format metadata (MTD section)
      [documentation](https://rformassspectrometry.github.io/RmzTabM/reference/MTD-export.html)
- [X] core functionality to format small molecule feature (SMF section)
      [documentation](https://rformassspectrometry.github.io/RmzTabM/reference/SMF-export.html)
- [X] core functionality to format the (SML section)
      [documentation](https://rformassspectrometry.github.io/RmzTabM/reference/SML-export.html)
- [X] core functionality to format the (SME section)
      [documentation](https://rformassspectrometry.github.io/RmzTabM/reference/SME-export.html)
- [X] core functionality to extract metadata from an mzTab-M file and
      reconstruct a sample/experiment `data.frame`
- [X] core functionality to extract the SMF data table from an mzTab-M file
- [X] core functionality to extract the SME data table from an mzTab-M file
- [X] core functionality to extract the SML data table from an mzTab-M file
- [X] high-level functionality to simplify exporting experimental data in
      mzTab-M
      format. [documentation](https://rformassspectrometry.github.io/RmzTabM/reference/SummarizedExperiment-mzTab-M.html)
- [ ] support for mzTab-M JSON format
- [ ] mzTab-M file validation

:eyes: see also the package [NEWS](NEWS.md) for updates.

## 🤝 Contribution

Please help us improving and completing the package! Any type of contribution
welcome :open_hands: - including discussions, suggestions or actual code. Don't
be afraid - we're friendly :relaxed:! :point_right: get involved by opening an
issue.

Please also check out the [**RforMassSpectrometry Contributions
Guide**](https://rformassspectrometry.github.io/RforMassSpectrometry/articles/RforMassSpectrometry.html#contributions).

### 📜 Code of Conduct

We follow the [**RforMassSpectrometry Code of
Conduct**](https://rformassspectrometry.github.io/RforMassSpectrometry/articles/RforMassSpectrometry.html#code-of-conduct)
to maintain an inclusive and respectful community.

-------------------------------------------------------------------------------

## 🙌 Acknowledgements

We thank the many researchers contributing through discussions or through
code. An potentially incomplete list of people:

- Nils Hoffmann
- Steffen Neumann
- Kozo Nishida
- Frank Giacomoni
- Nils Paulhe
- Ozgur Yurekten
- Janik Kokot
