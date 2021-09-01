#!/usr/bin/env Rscript

is_installed <- function(package) {
    available <- suppressMessages(suppressWarnings(sapply(package, require, quietly = TRUE, character.only = TRUE, warn.conflicts = FALSE)))
    missing <- package[!available]
    if (length(missing) > 0) return(FALSE)
    return(TRUE)
}

# CRAN packages
basic_libraries <- c("devtools", "tidyverse", "reshape2", "getopt", "foreach", "doParallel")
graphics_libraries <- c("scales", "gridExtra", "knitr", "rmarkdown", "kableExtra", "extrafont", "ggplot2", "tikzDevice", "pander")
stat_libraries <- c("survival", "randomForestSRC", "pROC", "verification", "timeROC", "survminer", "VennDiagram")
bio_libraries <- c("BiocManager", "ape", "adephylo", "genetics", "poppr", "taxize", "brranching")

for(library in c(basic_libraries, graphics_libraries, stat_libraries, bio_libraries ) ) {
    if(!is_installed(library)) {
        install.packages(library, repos="https://mirrors4.tuna.tsinghua.edu.cn/CRAN")
    }
}
BiocManager::install(version = "3.13", ask = FALSE)

# bioconductor packages
bioC_libraries <- c("biomaRt", "GenomicDataCommons", "GEOquery", "bsseq", "DSS", "scran", "scater", "edgeR", "pheatmap", "vcd", "monocle", "GenomeInfoDbData", "DESeq2", "clusterProfiler", "factoextra")
bioC_anno <- c("AnnotationDbi", "org.Hs.eg.db", "org.Rn.eg.db", "hthgu133a.db", "hgu133a2.db")

for(library in c( bioC_libraries, bioC_anno ) ) {
    if(!is_installed(library)) {
        BiocManager::install(library, update=FALSE, version = "3.13")
    }
}
