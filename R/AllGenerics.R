
setClassUnion("dfmatrix", c("data.frame", "matrix"))

setGeneric("setMtdInstrument", function(x, ...)
    standardGeneric("setMtdInstrument"))

setGeneric("setMtdDatabase", function(x, ...)
    standardGeneric("setMtdDatabase"))

setGeneric("setMtdCv", function(x, ...)
    standardGeneric("setMtdCv"))

setGeneric("setMtdContact", function(x, ...)
    standardGeneric("setMtdContact"))

setGeneric("setMtdField", function(x, ...)
    standardGeneric("setMtdField"))

setGeneric("mzTabMToList", function(x, ...)
    standardGeneric("mzTabMToList"))

setGeneric("MzTabM", function(mtd, ...) standardGeneric("MzTabM"))

setGeneric("smf", function(object, ...) standardGeneric("smf"))

setGeneric("mtd", function(object, ...) standardGeneric("mtd"))
