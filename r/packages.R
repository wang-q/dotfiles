#!/usr/bin/env Rscript

is_installed <- function(package) {
    available <- suppressMessages(suppressWarnings(sapply(package, require, quietly = TRUE, character.only = TRUE, warn.conflicts = FALSE)))
    missing <- package[!available]
    if (length(missing) > 0) return(FALSE)
    return(TRUE)
}

# CRAN packages
basic_libraries <- c("devtools", "tidyverse", "reshape2", "getopt", "doParallel")
graphics_libraries <- c("scales", "gridExtra", "knitr", "rmarkdown", "kableExtra", "extrafont", "tikzDevice", "pander")
stat_libraries <- c("survival", "randomForestSRC", "pROC", "verification", "survminer", "VennDiagram")
bio_libraries <- c("BiocManager", "ape", "adephylo", "genetics", "poppr", "taxize", "brranching")

for(library in c(basic_libraries, graphics_libraries, stat_libraries, bio_libraries ) ) {
    if(!is_installed(library)) {
        install.packages(library, repos="https://mirrors.nju.edu.cn/CRAN")
    }
}

# bioconductor packages
bioC_libraries <- c("biomaRt", "GenomicDataCommons", "bsseq", "DSS", "scran", "scater", "edgeR", "pheatmap", "vcd", "monocle", "GenomeInfoDbData", "DESeq2", "clusterProfiler", "factoextra")
bioC_anno <- c("AnnotationDbi", "org.Hs.eg.db", "org.Rn.eg.db", "hthgu133a.db", "hgu133a2.db", "IlluminaHumanMethylation27k.db", "IlluminaHumanMethylation450k.db")

for(library in c( bioC_libraries, bioC_anno ) ) {
    if(!is_installed(library)) {
        BiocManager::install(library, update=FALSE, version = "3.9")
    }
}
