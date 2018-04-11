#!/usr/bin/env Rscript

is_installed <- function(package) {
    available <- suppressMessages(suppressWarnings(sapply(package, require, quietly = TRUE, character.only = TRUE, warn.conflicts = FALSE)))
    missing <- package[!available]
    if (length(missing) > 0) return(FALSE)
    return(TRUE)
}

# CRAN packages
basic_libraries <- c("devtools", "magrittr", "stringr", "plyr", "dplyr", "readr", "reshape2", "getopt", "doMC")
graphics_libraries <- c("scales", "ggplot2", "gridExtra", "knitr", "rmarkdown", "extrafont", "tikzDevice", "pander")
bio_libraries <- c("ape", "adephylo", "genetics", "poppr", "taxize", "brranching", "survival", "randomForestSRC", "pROC")

for(library in c(basic_libraries, graphics_libraries, bio_libraries ) ) {
    if(!is_installed(library)) {
        install.packages(library, repos="https://mirrors.tuna.tsinghua.edu.cn/CRAN")
    }
}

# bioconductor packages
bioC_libraries <- c("biomaRt", "hthgu133a.db", "hgu133a2.db", "IlluminaHumanMethylation27k.db", "IlluminaHumanMethylation450k.db")

source("http://www.bioconductor.org/biocLite.R")
for(library in bioC_libraries) {
    if(!is_installed(library)) {
        biocLite(library)
    }
}
