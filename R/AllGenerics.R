
setClassUnion("dfmatrix", c("data.frame", "matrix"))

setGeneric("setMtdInstrument", function(x, ...)
    standardGeneric("setMtdInstrument"))

setGeneric("setMtdDatabase", function(x, ...)
    standardGeneric("setMtdDatabase"))

setGeneric("setMtdCv", function(x, ...)
    standardGeneric("setMtdCv"))

setGeneric("setMtdContact", function(x, ...)
    standardGeneric("setMtdContact"))

setGeneric("setMtdProtocol", function(x, ...)
    standardGeneric("setMtdProtocol"))

setGeneric("setMtdField", function(x, ...)
    standardGeneric("setMtdField"))

setGeneric("MzTabM", function(mtd, ...) standardGeneric("MzTabM"))

setGeneric("mtd", function(object, ...) standardGeneric("mtd"))

setGeneric("sml", function(object, ...) standardGeneric("sml"))

setGeneric("smf", function(object, ...) standardGeneric("smf"))

setGeneric("sme", function(object, ...) standardGeneric("sme"))
