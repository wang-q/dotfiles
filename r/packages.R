#!/usr/bin/env Rscript

is_installed <- function(package) {
    available <- suppressMessages(suppressWarnings(sapply(package, require, quietly = TRUE, character.only = TRUE, warn.conflicts = FALSE)))
    missing <- package[!available]
    if (length(missing) > 0) return(FALSE)
    return(TRUE)
}

# CRAN packages
basic_libs <- c("devtools", "reshape2", "getopt", "foreach", "doParallel", "tidyverse")
graphics_libs <- c("scales", "gridExtra", "knitr", "rmarkdown", "kableExtra", "extrafont", "tikzDevice", "pander")
stat_libs <- c("survival", "randomForestSRC", "pROC", "verification", "timeROC", "survminer", "VennDiagram", "vcd")
clust_libs <- c("densityClust", "mclust", "FNN", "tmvnsim")
bio_libs <- c("BiocManager", "ape", "adephylo", "genetics", "poppr", "taxize", "brranching")
misc_libs <- c("conquer", "covr", "deldir", "gmodels", "LearnBayes", "openxlsx", "rio", "rvcheck", "units")

for(library in c(basic_libs, graphics_libs, stat_libs, clust_libs, bio_libs, misc_libs ) ) {
    if(!is_installed(library)) {
        install.packages(library, repos="https://mirrors.ustc.edu.cn/CRAN")
    }
}
BiocManager::install(version = "3.17", ask = FALSE)

# bioconductor packages
bioC_libs <- c("biomaRt", "GenomicDataCommons", "GEOquery", "bsseq", "DSS", "scran", "scater", "edgeR", "pheatmap", "monocle", "DESeq2", "clusterProfiler", "factoextra")

for(library in c( bioC_libs ) ) {
    if(!is_installed(library)) {
        BiocManager::install(library, update=FALSE, version = "3.17")
    }
}
