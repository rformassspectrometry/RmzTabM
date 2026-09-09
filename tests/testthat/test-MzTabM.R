test_that("MzTabM class, constructor, show and validation works", {
    a <- new("MzTabM")
    expect_s4_class(a, "MzTabM")
    expect_true(validObject(a))

    a@mtd <- matrix(1:3, ncol = 3)
    expect_match(.mztab_validate_slots(a), "with two columns|Profile")
    expect_error(validObject(a), "with two columns")
    a@mtd <- matrix(ncol = 2, nrow = 0)
    a@sme <- matrix(NA_character_, ncol = 8, nrow = 3)
    res <- .mztab_validate_slots(a)
    expect_match(res[1L], "can not be empty")
    expect_match(res[2L], "SMF section needs to be defined")

    res <- capture.output(show(a))
    expect_match(res[2L], "SME section with 3 rows")

    a <- MzTabM()
    expect_s4_class(a, "MzTabM")
    res <- capture.output(show(a))
    expect_match(res[2L], "2.1.0-M")

    a <- MzTabM(mtd = mtdSkeleton(id = "001", software = "[,,RmzTabM,]"),
                smf = matrix(NA_character_, ncol = 4, nrow = 3),
                sml = matrix(NA_character_, ncol = 8, nrow = 2),
                sme = matrix(NA_character_, ncol = 7, nrow = 5))
    res <- capture.output(show(a))
    expect_match(res[3L], "24 rows")
    expect_match(res[4L], "2 rows and 8 columns")
    expect_match(res[5L], "3 rows and 4 columns")
    expect_match(res[6L], "5 rows and 7 columns")
})

test_that("mtdSetInstrument/mtdGetInstrument works with MzTabM", {
    m <- MzTabM(mtd = mtdSkeleton(id = "001", software = "[,,RmzTabM,]"))
    res <- getMtdInstrument(m)
    expect_equal(res, NA_character_)
    m <- setMtdInstrument(
        m, name = "[MS, MS:1000449, LTQ Orbitrap,]",
        source = "[MS, MS:1000073, ESI,]",
        analyzer = c(`analyzer[1]` = "[MS, MS:1000291, linear ion trap,]"),
        detector = "[MS, MS:1000253, electron multiplier,]")
    res <- getMtdInstrument(m)
    expect_equal(length(res), 4L)
    ## add
    m <- setMtdInstrument(m, name = "[,,name,]", source = "[,,source,]",
                          analyzer = c(`analyzer[1]` = "[,,analyzer,]"),
                          detector = "[,,detector,]", replace = FALSE)
    res <- getMtdInstrument(m)
    expect_equal(length(res), 8L)
    expect_equal(grep("instrument[1]", names(res), fixed = TRUE), 1:4)
    expect_equal(grep("instrument[2]", names(res), fixed = TRUE), 5:8)
    ## replace
    m <- setMtdInstrument(m, name = "[,,name2,]", source = "[,,source2,]",
                          analyzer = c(`analyzer[1]` = "[,,analyzer2,]"),
                          detector = "[,,detector2,]", replace = TRUE)
    res <- getMtdInstrument(m)
    expect_equal(length(res), 4L)
    expect_equal(grep("instrument[1]", names(res), fixed = TRUE), 1:4)
    expect_equal(res[1L], c(`instrument[1]-name` = "[,,name2,]"))
})

test_that("mtdSetDatabase/mtdGetDatabase works with MzTabM", {
    x <- MzTabM(mtd = mtdSkeleton(id = "001", software = "[,,RmzTabM,]"))
    res <- getMtdDatabase(x)
    expect_equal(res,
                 c("database[1]" = "[,, \"no database\", null ]",
                   "database[1]-prefix" = "null",
                   "database[1]-version" = "Unknown",
                   "database[1]-uri" = "null"))

    ##setMtdDatabase adds database metadata fields to a valid MTD section
    m <- setMtdDatabase(x, name = "[MIRIAM, MIR:00100079, HMDB, ]",
                        prefix = "hmdb", version = "3.6",
                        uri = "http://www.hmdb.ca/")
    res <- getMtdDatabase(m)
    expect_equal(res,
                 c("database[1]" = "[MIRIAM, MIR:00100079, HMDB, ]",
                   "database[1]-prefix" = "hmdb",
                   "database[1]-version" = "3.6",
                   "database[1]-uri" = "http://www.hmdb.ca/"))

    ##setMtdDatabase appends new database metadata when replace = FALSE
    m2 <- setMtdDatabase(m, name = "[MIRIAM, MIR:00100030, ChEBI, ]",
                        prefix = "chebi", version = "2023",
                        uri = "https://www.ebi.ac.uk/chebi/", replace = FALSE)
    res <- getMtdDatabase(m2)
    expect_equal(length(res), 8L)

    ##setMtdDatabase replaces existing database metadata when replace = TRUE
    x <- MzTabM(mtd = mtdSkeleton(id = "001", software = "[,,RmzTabM,]"))
    mtd <- setMtdDatabase(x, name = "[MIRIAM, MIR:00100079, HMDB, ]",
                        prefix = "hmdb", version = "3.6",
                        uri = "http://www.hmdb.ca/")
    mtd2 <- setMtdDatabase(mtd, name = "[MIRIAM, MIR:00100030, ChEBI, ]",
                        prefix = "chebi", version = "2023",
                        uri = "https://www.ebi.ac.uk/chebi/", replace = TRUE)
    res <- getMtdDatabase(mtd2)
    expect_equal(length(res), 4L)
})

test_that("mtdSetCv/mtdGetCv works with MzTabM", {
    x <- MzTabM(mtd = mtdSkeleton(id = "001", software = "[,,RmzTabM,]"))
    res <- getMtdCv(x)
    expect_equal(res[1L],
                 c("cv[1]-label" = "MS"))

    ##setMtdCv adds CV metadata fields to a valid MTD section when replace = FALSE
    cv <- setMtdCv(x, label = "MS",
                    full_name = "PSI-MS controlled vocabulary",
                    version = "4.1.11",
                    uri = "https://purl.obolibrary.org/obo/ms.obo",
                    replace = FALSE)
    res <- getMtdCv(cv)
    expect_equal(length(res), 16L)
    expect_true(any(grepl("cv\\[4\\]-label", names(res))))
    expect_true(any(grepl("cv\\[4\\]-full_name", names(res))))
    expect_true(any(grepl("cv\\[4\\]-version", names(res))))
    expect_true(any(grepl("cv\\[4\\]-uri", names(res))))
    expect_true(any(grepl("MS", res)))
    expect_true(any(grepl("PSI-MS controlled vocabulary", res)))
    expect_true(any(grepl("4.1.11", res)))
    expect_true(any(grepl("https://purl.obolibrary.org/obo/ms.obo",
                          res)))

    ##setMtdCv replaces existing CV metadata when replace = TRUE
    cv <- setMtdCv(x, label = "MS", full_name = "PSI-MS controlled vocabulary",
                 version = "4.1.11",
                 uri = "https://purl.obolibrary.org/obo/ms.obo",
                 replace = TRUE)
    res <- getMtdCv(cv)
    expect_equal(length(res), 4L)
})

test_that("mtdSetContact/mtdGetContact works with MzTabM", {
    x <- MzTabM(mtd = mtdSkeleton(id = "001", software = "[,,RmzTabM,]"))
    res <- getMtdContact(x)
    expect_equal(res, NA_character_)

    ## setMtdContact adds contact metadata fields to a valid MTD section
    c <- setMtdContact(x, name = "Name Surname", affiliation = "PSI-MS",
                         email = "name.surname@mail.com",
                         orcid = "0000-0001-2345-6789")
    res <- getMtdContact(c)
    expect_true(any(grepl("contact\\[1\\]-name", names(res))))
    expect_true(any(grepl("contact\\[1\\]-affiliation", names(res))))
    expect_true(any(grepl("contact\\[1\\]-email", names(res))))
    expect_true(any(grepl("Name Surname", res)))
    expect_true(any(grepl("PSI-MS", res)))
    expect_true(any(grepl("name.surname@mail.com", res)))
    expect_true(any(grepl("0000-0001-2345-6789", res)))

    ## setMtdContact appends new contact metadata when replace = FALSE
    c <- setMtdContact(c, name = "Person 2", affiliation = "Lab B",
        email = "person2@mail.com", orcid = "0000-0001-2345-6789",
        replace = FALSE)
    res <- getMtdContact(c)
    expect_equal(length(res), 8L)

    ## setMtdContact replaces existing contact metadata when replace = TRUE
    c2 <- setMtdContact(c, name = "Person 2", affiliation = "Lab B",
                    email = "person2@mail.com", orcid = "0000-0001-2345-678X",
                    replace = TRUE)
    res <- getMtdContact(c2)
    expect_equal(length(res), 4L)
})

test_that("mtdSetProtocol/mtdGetProtocol works with MzTabM", {
    x <- MzTabM(mtd = mtdSkeleton(id = "001", software = "[,,RmzTabM,]"))
    res <- getMtdProtocol(x)
    expect_equal(res, NA_character_)

    ## setMtdProtocol adds contact metadata fields to a valid MTD section
    result <- setMtdProtocol(x, name = "Mass Spectrometry",
                    type = c("[CHMO, CHMO:0000470, mass spectrometry, ]"),
                    description = c("Eluting compounds were detected ..."),
                    parameters = c("[MS, MS:1000008, ionization type, [MS,MS:1000073, electrospray ionization, ]]"))
    res <- getMtdProtocol(result)
    expect_equal(res[["protocol[1]-name"]], "Mass Spectrometry")
    expect_equal(res[["protocol[1]-type"]],
                "[CHMO, CHMO:0000470, mass spectrometry, ]")
    expect_equal(res[["protocol[1]-description"]],
                "Eluting compounds were detected ...")
    expect_equal(res[["protocol[1]-parameter[1]"]],
                "[MS, MS:1000008, ionization type, [MS,MS:1000073, electrospray ionization, ]]")

    ## setMtdProtocol appends new contact metadata when replace = FALSE
    mtd2 <- setMtdProtocol(result, name = c("extraction"),
             type = c("[MSIO, MSIO:0000141, metabolite extraction,]"),
             description = c("Extraction using 80% methanol"),
             parameters = list("[MSIO, MSIO:0000107, quenching, [MSIO, MSIO:0000109, liquid nitrogen,]]"),
             replace = FALSE)
    res <- getMtdProtocol(mtd2)
    name_rows <- res[grepl("protocol.*name$", names(res))]
    expect_equal(length(name_rows), 2L)

    ## setMtdProtocol replaces existing contact metadata when replace = TRUE
    mtd3 <- setMtdProtocol(mtd2, name = "Test replace",
             type = "[, , null, null]",
             description = "Test description",
             parameters = "[ , , null, null]", replace = TRUE)
    res <- getMtdProtocol(mtd3)
    name_rows <- res[grepl("protocol.*name$", names(res))]
    expect_equal(length(name_rows), 1L)
    expect_equal(res[["protocol[1]-name"]], "Test replace")
})

test_that("mtdGetField works with MzTabM", {
    x <- MzTabM(mtd = mtdSkeleton(id = "001", software = "[,,RmzTabM,]"))
    res <- getMtdField(x, "software")
    expect_equal(res, c("software[1]" = "[,,RmzTabM,]"))

    ## getMtdField returns NA if field is not present
    res <- getMtdField(x, "nonexistent_field")
    expect_equal(res, NA_character_)

    ## setMtdField adds a new metadata field to a valid MTD section
    f <- setMtdField(x, field = "publication",
                value = "https://pubs.acs.org/doi/10.1021/acs.analchem.8b04310")
    result <- getMtdField(f, "publication")
    expect_equal(result,
                c("publication[1]" = "https://pubs.acs.org/doi/10.1021/acs.analchem.8b04310"))

    ## setMtdField appends new values when replace = FALSE
    f2 <- setMtdField(f, field = "publication",
                    value = "https://doi.org/second", replace = FALSE)
    result <- getMtdField(f2, "publication")
    expect_equal(length(result), 2L)

    ## setMtdField replaces existing field values when replace = TRUE
    f3 <- setMtdField(f2, field = "publication",
                    value = "https://doi.org/second", replace = TRUE)
    result <- getMtdField(f3, "publication")
    expect_equal(length(result), 1L)

    ## Add new single field
    f4 <- setMtdField(f3, field = "title", value = "Title 1")
    result <- getMtdField(f4, "title")
    expect_equal(result, c("title" = "Title 1"))
})

test_that("mtd,MzTabM works", {
    a <- MzTabM()
    res <- mtd(a)
    expect_equal(res, a@mtd)
})

test_that("sml,MzTabM works", {
    a <- MzTabM()
    res <- sml(a)
    expect_equal(dim(res), c(0, 0))
})

test_that("smf,MzTabM works", {
    a <- MzTabM()
    res <- smf(a)
    expect_equal(dim(res), c(0, 0))
})

test_that("sme,MzTabM works", {
    a <- MzTabM()
    res <- sme(a)
    expect_equal(dim(res), c(0, 0))
})
