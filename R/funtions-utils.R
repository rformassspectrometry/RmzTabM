## Generic helper functions

.prefix_zero <- function(x) {
    sprintf(paste0("%0", ceiling(log10(max(x) + 1)), "d"), x)
}
