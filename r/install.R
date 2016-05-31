#!/usr/bin/env Rscript

is_installed <- function(package) {
    available <- suppressMessages(suppressWarnings(sapply(package, require, quietly = TRUE, character.only = TRUE, warn.conflicts = FALSE)))
    missing <- package[!available]
    if (length(missing) > 0) return(FALSE)
    return(TRUE)
}

# CRAN packages
basic_libraries <- c("plyr", "reshape2", "getopt")
graphics_libraries <- c("scales", "ggplot2", "gridExtra", "knitr", "rmarkdown", "extrafont")
bio_libraries <- c("ape")

for(library in c(basic_libraries, graphics_libraries, bio_libraries ) ) {
    if(!is_installed(library)) {
        install.packages(library)
    }
}

# bioconductor packages
bioC_libraries <- c("biomaRt")

source("http://www.bioconductor.org/biocLite.R")
for(library in bioC_libraries) {
    if(!is_installed(library)) {
        biocLite(library)
    }
}

# extrafont
library(extrafont)
font_install('fontcm', prompt = FALSE)
font_import(prompt = FALSE)
fonts()
