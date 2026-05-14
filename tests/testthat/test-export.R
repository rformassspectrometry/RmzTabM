## LDA_v2.11.1_MTBLS396 as test

test_that("writeMzTabM works", {
    mtd_block <- c(
        "MTD\tmzTab-version\t2.1.0-M",
        "MTD\tmzTab-ID\t1",
        "MTD\tcontact[1]-name\tJuergen Hartler",
        "MTD\tcontact[1]-email\tjuergen.hartler@uni-graz.at",
        "MTD\tcontact[1]-affiliation\tInstitute of Pharmaceutical Sciences, University of Graz, Universitaetsplatz 1/I, 8010 Graz, Austria",
        "MTD\tpublication[1]\tpubmed:29058722|doi:10.1038/nmeth.4470",
        "MTD\tinstrument[1]-name\t[MS, MS:1001742, LTQ Orbitrap Velos, ]",
        "MTD\tinstrument[1]-source\t[MS, MS:1000073, Electrospray Ionization, ]",
        "MTD\tinstrument[1]-analyzer[1]\t[MS, MS:1000484, orbitrap, ]",
        "MTD\tinstrument[1]-detector\t[MS, MS:1000112, Faraday Cup, ]",
        "MTD\tquantification_method\t[MS, MS:1002019, label free raw feature quantitation, ]",
        "MTD\tsample[1]-species[1]\t[NCBITaxon, NCBITaxon:10090, Mus musculus, ]",
        "MTD\tsample[1]-cell_type[1]\t[CL, CL:0000182, hepatocyte, ]",
        "MTD\tsample[1]-disease[1]\t[DOID, DOID:409, liver disease, ]",
        "MTD\tsample[1]-tissue[1]\t[BTO, BTO:0000759, liver, ]",
        "MTD\tsample_processing[1]\t[CHMO, CHMO:0001050, reversed-phase liquid chromatography, ]",
        "MTD\tsoftware[1]\t[, , LipidDataAnalyzer, 2.11.1]",
        "MTD\tsoftware[1]-setting[1]\tisotope_pattern_checked",
        "MTD\tms_run[1]-location\tfile://C:/mzTab/MurineLiver/neg/002_liver2-1_Orbitrap_CID_neg.chrom",
        "MTD\tms_run[1]-hash_method\t[MS, MS:1000569, SHA-1, ]",
        "MTD\tms_run[1]-format\t[MS, MS:1002966, The Lipid Data Analyzer native chrom format., ]",
        "MTD\tms_run[1]-fragmentation_method[1]\t[MS, MS:1000133, collision-induced dissociation, ]",
        "MTD\tms_run[1]-scan_polarity[1]\t[MS, MS:1000129, negative scan, ]",
        "MTD\tms_run[1]-id_format\t[MS, MS:1000776, scan number only nativeID format, ]",
        "MTD\tms_run[2]-location\tfile://C:/mzTab/MurineLiver/neg/003_liver2-1_Orbitrap_CID_neg.chrom",
        "MTD\tms_run[2]-hash_method\t[MS, MS:1000569, SHA-1, ]",
        "MTD\tms_run[2]-format\t[MS, MS:1002966, The Lipid Data Analyzer native chrom format., ]",
        "MTD\tms_run[2]-fragmentation_method[1]\t[MS, MS:1000133, collision-induced dissociation, ]",
        "MTD\tms_run[2]-scan_polarity[1]\t[MS, MS:1000129, negative scan, ]",
        "MTD\tms_run[2]-id_format\t[MS, MS:1000776, scan number only nativeID format, ]",
        "MTD\tms_run[3]-location\tfile://C:/mzTab/MurineLiver/neg/004_liver2-1_Orbitrap_CID_neg.chrom",
        "MTD\tms_run[3]-hash_method\t[MS, MS:1000569, SHA-1, ]",
        "MTD\tms_run[3]-format\t[MS, MS:1002966, The Lipid Data Analyzer native chrom format., ]",
        "MTD\tms_run[3]-fragmentation_method[1]\t[MS, MS:1000133, collision-induced dissociation, ]",
        "MTD\tms_run[3]-scan_polarity[1]\t[MS, MS:1000129, negative scan, ]",
        "MTD\tms_run[3]-id_format\t[MS, MS:1000776, scan number only nativeID format, ]",
        "MTD\tms_run[4]-location\tfile://C:/mzTab/MurineLiver/neg/005_liver2-1_Orbitrap_CID_neg.chrom",
        "MTD\tms_run[4]-hash_method\t[MS, MS:1000569, SHA-1, ]",
        "MTD\tms_run[4]-format\t[MS, MS:1002966, The Lipid Data Analyzer native chrom format., ]",
        "MTD\tms_run[4]-fragmentation_method[1]\t[MS, MS:1000133, collision-induced dissociation, ]",
        "MTD\tms_run[4]-scan_polarity[1]\t[MS, MS:1000129, negative scan, ]",
        "MTD\tms_run[4]-id_format\t[MS, MS:1000776, scan number only nativeID format, ]",
        "MTD\tms_run[5]-location\tfile://C:/mzTab/MurineLiver/neg/006_liver2-1_Orbitrap_CID_neg.chrom",
        "MTD\tms_run[5]-hash_method\t[MS, MS:1000569, SHA-1, ]",
        "MTD\tms_run[5]-format\t[MS, MS:1002966, The Lipid Data Analyzer native chrom format., ]",
        "MTD\tms_run[5]-fragmentation_method[1]\t[MS, MS:1000133, collision-induced dissociation, ]",
        "MTD\tms_run[5]-scan_polarity[1]\t[MS, MS:1000129, negative scan, ]",
        "MTD\tms_run[5]-id_format\t[MS, MS:1000776, scan number only nativeID format, ]",
        "MTD\tms_run[6]-location\tfile://C:/mzTab/MurineLiver/neg/008_liver2-2_Orbitrap_CID_neg.chrom",
        "MTD\tms_run[6]-hash_method\t[MS, MS:1000569, SHA-1, ]",
        "MTD\tms_run[6]-format\t[MS, MS:1002966, The Lipid Data Analyzer native chrom format., ]",
        "MTD\tms_run[6]-fragmentation_method[1]\t[MS, MS:1000133, collision-induced dissociation, ]",
        "MTD\tms_run[6]-scan_polarity[1]\t[MS, MS:1000129, negative scan, ]",
        "MTD\tms_run[6]-id_format\t[MS, MS:1000776, scan number only nativeID format, ]",
        "MTD\tms_run[7]-location\tfile://C:/mzTab/MurineLiver/neg/009_liver2-2_Orbitrap_CID_neg.chrom",
        "MTD\tms_run[7]-hash_method\t[MS, MS:1000569, SHA-1, ]",
        "MTD\tms_run[7]-format\t[MS, MS:1002966, The Lipid Data Analyzer native chrom format., ]",
        "MTD\tms_run[7]-fragmentation_method[1]\t[MS, MS:1000133, collision-induced dissociation, ]",
        "MTD\tms_run[7]-scan_polarity[1]\t[MS, MS:1000129, negative scan, ]",
        "MTD\tms_run[7]-id_format\t[MS, MS:1000776, scan number only nativeID format, ]",
        "MTD\tms_run[8]-location\tfile://C:/mzTab/MurineLiver/neg/010_liver2-2_Orbitrap_CID_neg.chrom",
        "MTD\tms_run[8]-hash_method\t[MS, MS:1000569, SHA-1, ]",
        "MTD\tms_run[8]-format\t[MS, MS:1002966, The Lipid Data Analyzer native chrom format., ]",
        "MTD\tms_run[8]-fragmentation_method[1]\t[MS, MS:1000133, collision-induced dissociation, ]",
        "MTD\tms_run[8]-scan_polarity[1]\t[MS, MS:1000129, negative scan, ]",
        "MTD\tms_run[8]-id_format\t[MS, MS:1000776, scan number only nativeID format, ]",
        "MTD\tms_run[9]-location\tfile://C:/mzTab/MurineLiver/neg/011_liver2-2_Orbitrap_CID_neg.chrom",
        "MTD\tms_run[9]-hash_method\t[MS, MS:1000569, SHA-1, ]",
        "MTD\tms_run[9]-format\t[MS, MS:1002966, The Lipid Data Analyzer native chrom format., ]",
        "MTD\tms_run[9]-fragmentation_method[1]\t[MS, MS:1000133, collision-induced dissociation, ]",
        "MTD\tms_run[9]-scan_polarity[1]\t[MS, MS:1000129, negative scan, ]",
        "MTD\tms_run[9]-id_format\t[MS, MS:1000776, scan number only nativeID format, ]",
        "MTD\tms_run[10]-location\tfile://C:/mzTab/MurineLiver/neg/012_liver2-2_Orbitrap_CID_neg.chrom",
        "MTD\tms_run[10]-hash_method\t[MS, MS:1000569, SHA-1, ]",
        "MTD\tms_run[10]-format\t[MS, MS:1002966, The Lipid Data Analyzer native chrom format., ]",
        "MTD\tms_run[10]-fragmentation_method[1]\t[MS, MS:1000133, collision-induced dissociation, ]",
        "MTD\tms_run[10]-scan_polarity[1]\t[MS, MS:1000129, negative scan, ]",
        "MTD\tms_run[10]-id_format\t[MS, MS:1000776, scan number only nativeID format, ]",
        "MTD\tms_run[11]-location\tfile://C:/mzTab/MurineLiver/neg/014_liver2-3_Orbitrap_CID_neg.chrom",
        "MTD\tms_run[11]-hash_method\t[MS, MS:1000569, SHA-1, ]",
        "MTD\tms_run[11]-format\t[MS, MS:1002966, The Lipid Data Analyzer native chrom format., ]",
        "MTD\tms_run[11]-fragmentation_method[1]\t[MS, MS:1000133, collision-induced dissociation, ]",
        "MTD\tms_run[11]-scan_polarity[1]\t[MS, MS:1000129, negative scan, ]",
        "MTD\tms_run[11]-id_format\t[MS, MS:1000776, scan number only nativeID format, ]",
        "MTD\tms_run[12]-location\tfile://C:/mzTab/MurineLiver/neg/015_liver2-3_Orbitrap_CID_neg.chrom",
        "MTD\tms_run[12]-hash_method\t[MS, MS:1000569, SHA-1, ]",
        "MTD\tms_run[12]-format\t[MS, MS:1002966, The Lipid Data Analyzer native chrom format., ]",
        "MTD\tms_run[12]-fragmentation_method[1]\t[MS, MS:1000133, collision-induced dissociation, ]",
        "MTD\tms_run[12]-scan_polarity[1]\t[MS, MS:1000129, negative scan, ]",
        "MTD\tms_run[12]-id_format\t[MS, MS:1000776, scan number only nativeID format, ]",
        "MTD\tms_run[13]-location\tfile://C:/mzTab/MurineLiver/neg/016_liver2-3_Orbitrap_CID_neg.chrom",
        "MTD\tms_run[13]-hash_method\t[MS, MS:1000569, SHA-1, ]",
        "MTD\tms_run[13]-format\t[MS, MS:1002966, The Lipid Data Analyzer native chrom format., ]",
        "MTD\tms_run[13]-fragmentation_method[1]\t[MS, MS:1000133, collision-induced dissociation, ]",
        "MTD\tms_run[13]-scan_polarity[1]\t[MS, MS:1000129, negative scan, ]",
        "MTD\tms_run[13]-id_format\t[MS, MS:1000776, scan number only nativeID format, ]",
        "MTD\tms_run[14]-location\tfile://C:/mzTab/MurineLiver/neg/017_liver2-3_Orbitrap_CID_neg.chrom",
        "MTD\tms_run[14]-hash_method\t[MS, MS:1000569, SHA-1, ]",
        "MTD\tms_run[14]-format\t[MS, MS:1002966, The Lipid Data Analyzer native chrom format., ]",
        "MTD\tms_run[14]-fragmentation_method[1]\t[MS, MS:1000133, collision-induced dissociation, ]",
        "MTD\tms_run[14]-scan_polarity[1]\t[MS, MS:1000129, negative scan, ]",
        "MTD\tms_run[14]-id_format\t[MS, MS:1000776, scan number only nativeID format, ]",
        "MTD\tms_run[15]-location\tfile://C:/mzTab/MurineLiver/neg/018_liver2-3_Orbitrap_CID_neg.chrom",
        "MTD\tms_run[15]-hash_method\t[MS, MS:1000569, SHA-1, ]",
        "MTD\tms_run[15]-format\t[MS, MS:1002966, The Lipid Data Analyzer native chrom format., ]",
        "MTD\tms_run[15]-fragmentation_method[1]\t[MS, MS:1000133, collision-induced dissociation, ]",
        "MTD\tms_run[15]-scan_polarity[1]\t[MS, MS:1000129, negative scan, ]",
        "MTD\tms_run[15]-id_format\t[MS, MS:1000776, scan number only nativeID format, ]",
        "MTD\tassay[1]-ms_run_ref\tms_run[1]",
        "MTD\tassay[2]-ms_run_ref\tms_run[2]",
        "MTD\tassay[3]-ms_run_ref\tms_run[3]",
        "MTD\tassay[4]-ms_run_ref\tms_run[4]",
        "MTD\tassay[5]-ms_run_ref\tms_run[5]",
        "MTD\tassay[6]-ms_run_ref\tms_run[6]",
        "MTD\tassay[7]-ms_run_ref\tms_run[7]",
        "MTD\tassay[8]-ms_run_ref\tms_run[8]",
        "MTD\tassay[9]-ms_run_ref\tms_run[9]",
        "MTD\tassay[10]-ms_run_ref\tms_run[10]",
        "MTD\tassay[11]-ms_run_ref\tms_run[11]",
        "MTD\tassay[12]-ms_run_ref\tms_run[12]",
        "MTD\tassay[13]-ms_run_ref\tms_run[13]",
        "MTD\tassay[14]-ms_run_ref\tms_run[14]",
        "MTD\tassay[15]-ms_run_ref\tms_run[15]",
        "MTD\tstudy_variable_group[1]\t[,,sample,]",
        "MTD\tstudy_variable_group[1]-description\tSample",
        "MTD\tstudy_variable_group[1]-type\t[STATO, STATO:0000252, categorical variable, ]",
        "MTD\tstudy_variable_group[1]-datatype\txsd:string",
        "MTD\tstudy_variable[1]\tmouse liver 1",
        "MTD\tstudy_variable[1]-description\tmouse liver 1",
        "MTD\tstudy_variable[1]-average_function\t[MS, MS:1002962, The arithmetic mean, ]",
        "MTD\tstudy_variable[1]-variation_function\t[MS, MS:1002963, The coefficient of variation, ]",
        "MTD\tstudy_variable[1]-assay_refs\tassay[1]|assay[2]|assay[3]|assay[4]|assay[5]",
        "MTD\tstudy_variable[1]-group_ref\tstudy_variable_group[1]",
        "MTD\tstudy_variable[2]\tmouse liver 2",
        "MTD\tstudy_variable[2]-description\tmouse liver 2",
        "MTD\tstudy_variable[2]-average_function\t[MS, MS:1002962, The arithmetic mean, ]",
        "MTD\tstudy_variable[2]-variation_function\t[MS, MS:1002963, The coefficient of variation, ]",
        "MTD\tstudy_variable[2]-assay_refs\tassay[6]|assay[7]|assay[8]|assay[9]|assay[10]",
        "MTD\tstudy_variable[2]-group_ref\tstudy_variable_group[1]",
        "MTD\tstudy_variable[3]\tmouse liver 3",
        "MTD\tstudy_variable[3]-description\tmouse liver 3",
        "MTD\tstudy_variable[3]-average_function\t[MS, MS:1002962, The arithmetic mean, ]",
        "MTD\tstudy_variable[3]-variation_function\t[MS, MS:1002963, The coefficient of variation, ]",
        "MTD\tstudy_variable[3]-assay_refs\tassay[11]|assay[12]|assay[13]|assay[14]|assay[15]",
        "MTD\tstudy_variable[3]-group_ref\tstudy_variable_group[1]",
        "MTD\tcv[1]-label\tMS",
        "MTD\tcv[1]-uri\thttps://www.ebi.ac.uk/ols/ontologies/ms",
        "MTD\tcv[1]-version\t20-06-2018",
        "MTD\tcv[1]-full_name\tPSI-MS controlled vocabulary",
        "MTD\tcv[2]-label\tPRIDE",
        "MTD\tcv[2]-uri\thttps://www.ebi.ac.uk/ols/ontologies/pride",
        "MTD\tcv[2]-version\t14-06-2018",
        "MTD\tcv[2]-full_name\tPRIDE PRoteomics IDEntifications (PRIDE) database controlled vocabulary",
        "MTD\tcv[3]-label\tCHMO",
        "MTD\tcv[3]-uri\thttp://purl.obolibrary.org/obo/chmo.owl",
        "MTD\tcv[3]-version\t14-11-2019",
        "MTD\tcv[3]-full_name\tChemical Methods Ontology",
        "MTD\tcv[4]-label\tNCBITaxon",
        "MTD\tcv[4]-uri\thttps://www.ebi.ac.uk/ols/ontologies/ncbitaxon",
        "MTD\tcv[4]-version\t2018-03-02",
        "MTD\tcv[4]-full_name\tNCBI organismal classification",
        "MTD\tcv[5]-label\tCL",
        "MTD\tcv[5]-uri\thttps://www.ebi.ac.uk/ols/ontologies/cl",
        "MTD\tcv[5]-version\t2018-07-07",
        "MTD\tcv[5]-full_name\tCell Ontology",
        "MTD\tcv[6]-label\tBTO",
        "MTD\tcv[6]-uri\thttps://www.ebi.ac.uk/ols/ontologies/bto",
        "MTD\tcv[6]-version\t2016-05-05",
        "MTD\tcv[6]-full_name\tBRENDA tissue / enzyme source",
        "MTD\tcv[7]-label\tDOID",
        "MTD\tcv[7]-uri\thttps://www.ebi.ac.uk/ols/ontologies/doid",
        "MTD\tcv[7]-version\t2018-07-05",
        "MTD\tcv[7]-full_name\tHuman Disease Ontology",
        "MTD\tsmall_molecule-quantification_unit\t[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]",
        "MTD\tsmall_molecule_feature-quantification_unit\t[PRIDE, PRIDE:0000330, Arbitrary quantification unit, ]",
        "MTD\tsmall_molecule-identification_reliability\t[MS, MS:1002896, compound identification confidence level, ]",
        "MTD\tdatabase[1]\t[, , LipidDataAnalyzer2, lda2]",
        "MTD\tdatabase[1]-prefix\tlda2",
        "MTD\tdatabase[1]-uri\thttps://github.com/ThallingerLab/LDA2",
        "MTD\tdatabase[1]-version\t2.11.1",
        "MTD\tid_confidence_measure[1]\t[MS, MS:1002890, fragmentation score, ]"
    )
    mtd_block <- read.table(text = mtd_block, sep = "\t")[, 2:3]

    SML_block <- c(
    "SMH\tSML_ID\tSMF_ID_REFS\tdatabase_identifier\tchemical_formula\tsmiles\tinchi\tchemical_name\turi\ttheoretical_neutral_mass\tadduct_ions\treliability\tbest_id_confidence_measure\tbest_id_confidence_value\tabundance_assay[1]\tabundance_assay[2]\tabundance_assay[3]\tabundance_assay[4]\tabundance_assay[5]\tabundance_assay[6]\tabundance_assay[7]\tabundance_assay[8]\tabundance_assay[9]\tabundance_assay[10]\tabundance_assay[11]\tabundance_assay[12]\tabundance_assay[13]\tabundance_assay[14]\tabundance_assay[15]\tabundance_study_variable[1]\tabundance_study_variable[2]\tabundance_study_variable[3]\tabundance_variation_study_variable[1]\tabundance_variation_study_variable[2]\tabundance_variation_study_variable[3]\topt_global_lipid_species\topt_global_lipid_lda_species",
    "SML\t1\t1\tlda2:LPS 11:1\tC17H32NO9P\tnull\tnull\tLPS 11:1\tnull\t425.181468792\t[M-H]-\t3\t[MS, MS:1002890, fragmentation score, ]\tnull\t32605.1391601563\tnull\tnull\tnull\tnull\tnull\tnull\tnull\tnull\tnull\tnull\tnull\tnull\tnull\tnull\t32605.1391601563\t0\t0\tNaN\tNaN\tNaN\tLPS 11:1\tLPS 11:1_38.45"
    )
    SML_block <- read.table(text = SML_block, sep = "\t", header = TRUE,
                            check.names = FALSE, colClasses = "character")

    SMF_block <- c(
    "SFH\tSMF_ID\tSME_ID_REFS\tSME_ID_REF_ambiguity_code\tadduct_ion\tisotopomer\texp_mass_to_charge\tcharge\tretention_time_in_seconds\tretention_time_in_seconds_start\tretention_time_in_seconds_end\tabundance_assay[1]\tabundance_assay[2]\tabundance_assay[3]\tabundance_assay[4]\tabundance_assay[5]\tabundance_assay[6]\tabundance_assay[7]\tabundance_assay[8]\tabundance_assay[9]\tabundance_assay[10]\tabundance_assay[11]\tabundance_assay[12]\tabundance_assay[13]\tabundance_assay[14]\tabundance_assay[15]",
    "SMF\t1\tnull\tnull\t[M-H]-\tnull\t424.177185058594\t-1\t2306.94995117188\t2285.84008789063\t2339.75\t32605.138671875\tnull\tnull\tnull\tnull\tnull\tnull\tnull\tnull\tnull\tnull\tnull\tnull\tnull\tnull"
    )
    SMF_block <- read.table(text = SMF_block, sep = "\t", header = TRUE,
                            check.names = FALSE, colClasses = "character")

    SME_block <- c(
    "SEH\tSME_ID\tevidence_input_id\tdatabase_identifier\tchemical_formula\tsmiles\tinchi\tchemical_name\turi\tderivatized_form\tadduct_ion\texp_mass_to_charge\tcharge\ttheoretical_mass_to_charge\tspectra_ref\tidentification_method\tms_level\tid_confidence_measure[1]\trank\topt_global_lipid_species\topt_global_lipid_lda_species" ,
    "SME\t1\t1\tlda2:P-PE 34:1\tC39H75NO7P\tnull\tnull\tP-PE 34:1\tnull\tnull\t[M-H]-\t700.527709960938\t-1\t700.528116037\tms_run[1]:scan=7661\t[, , LipidDataAnalyzer, 2.11.1]\t[MS, MS:1000511, ms level, 2]\tnull\t1\tP-PE 34:1\tP-PE 34:1_28.05"
    )
    SME_block <- read.table(text = SME_block, sep = "\t", header = TRUE,
                            check.names = FALSE, colClasses = "character")


    f <- tempfile(fileext = ".mztab")

    expect_error(writeMzTabM(), "argument \"x\" is missing")

    x <- list("MTD" = mtd_block)
    expect_error(writeMzTabM(x), "argument \"path\" is missing")

    expect_error(writeMzTabM("not_a_list", path = f), "x must be a list")
    expect_error(writeMzTabM(x = list(), path = f), "MTD section")
    x <- list("MTD" = mtd_block, "SME" = SME_block)
    expect_error(writeMzTabM(x, path = f), "Missing \"SFH\" section")

    ## Test save only MTD in a pregenerated file
    x <- list("MTD" = mtd_block)
    expect_no_error(writeMzTabM(x, path = f))
    ## Test save MTD+SML in a pregenerated file
    x <- list("MTD" = mtd_block, "SML" = SML_block)
    expect_no_error(writeMzTabM(x, path = f))
    ## Test save MTD+SML+SMF in a pregenerated file
    x <- list("MTD" = mtd_block, "SML" = SML_block, "SMF" = SMF_block)
    expect_no_error(writeMzTabM(x, path = f))
    ## Test save MTD+SML+SMF+SME in a pregenerated file
    x <- list("MTD" = mtd_block, "SML" = SML_block, "SMF" = SMF_block,
              "SME" = SME_block)
    expect_no_error(writeMzTabM(x, path = f))
    ## Test save MTD+SMF in a pregenerated file
    x <- list("MTD" = mtd_block, "SMF" = SMF_block)
    expect_no_error(writeMzTabM(x, path = f))
    ## Test save MTD+SMF+SME in a pregenerated file
    x <- list("MTD" = mtd_block, "SMF" = SMF_block, "SME" = SME_block)
    expect_no_error(writeMzTabM(x, path = f))

    ## Test comments
    x <- list("MTD" = mtd_block, "SML" = SML_block)
    expect_no_error(writeMzTabM(x, path = f, comments = "Comment 1"))
    expect_no_error(writeMzTabM(x, path = f,
                                 comments = c("Comment 1", "Comment 2")))

    ## Test save only MTD in a not-existing directory
    f <- file.path(tempdir(), "not_existing_dir", "example.mztab")
    x <- list("MTD" = mtd_block)
    expect_no_error(writeMzTabM(x, path = f))

    ## Test save only MTD in a not-existing directory without extension
    f <- file.path(tempdir(), "not_existing_dir_2", "example_no_ext")
    x <- list("MTD" = mtd_block)
    expect_no_error(writeMzTabM(x, path = f))

    ## Test save only MTD in a not-existing directory without filename
    f <- file.path(tempdir(), "not_existing_dir_2/")
    x <- list("MTD" = mtd_block)
    expect_no_error(writeMzTabM(x, path = f))
})
