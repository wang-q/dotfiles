#!/usr/bin/env Rscript

is_installed <- function(package) {
    available <- suppressMessages(suppressWarnings(sapply(package, require, quietly = TRUE, character.only = TRUE, warn.conflicts = FALSE)))
    missing <- package[!available]
    if (length(missing) > 0) return(FALSE)
    return(TRUE)
}

# CRAN packages
basic_libraries <- c("devtools", "magrittr", "stringr", "plyr", "dplyr", "readr", "reshape2", "getopt", "doParallel")
graphics_libraries <- c("scales", "ggplot2", "gridExtra", "knitr", "rmarkdown", "extrafont", "tikzDevice", "pander")
stat_libraries <- c("survival", "randomForestSRC", "pROC", "verification", "survminer", "VennDiagram")
bio_libraries <- c("ape", "adephylo", "genetics", "poppr", "taxize", "brranching")

for(library in c(basic_libraries, graphics_libraries, stat_libraries, bio_libraries ) ) {
    if(!is_installed(library)) {
        install.packages(library, repos="https://mirrors.tuna.tsinghua.edu.cn/CRAN")
    }
}

# bioconductor packages
bioC_libraries <- c("biomaRt", "GenomicDataCommons")
bioC_anno <- c("hthgu133a.db", "hgu133a2.db", "IlluminaHumanMethylation27k.db", "IlluminaHumanMethylation450k.db")

source("http://www.bioconductor.org/biocLite.R")
for(library in c( bioC_libraries, bioC_anno ) ) {
    if(!is_installed(library)) {
        biocLite(library)
    }
}
