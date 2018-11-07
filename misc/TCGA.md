
```r
require(devtools)
install_github("Bioconductor/GenomicDataCommons")

library(GenomicDataCommons)
library(magrittr)
```

* 可用的查询

```r
available_fields('projects')

available_fields('cases')

available_fields('files')

```

* 样本类型

```r
resp <- cases() %>%
    filter(~ project.project_id=='TCGA-SKCM' & project.project_id=='TCGA-SKCM' ) %>%
    facet('samples.sample_type') %>%
    aggregations()

resp$samples.sample_type

```

* 样本 ID

```r
skcm_ids <- cases() %>%
    filter(~ project.project_id=='TCGA-SKCM' & project.project_id=='TCGA-SKCM' ) %>%
    ids()

skcm_ids[1]
```

* 样本内数据

```r
resp <- files() %>%
    filter(~ cases.case_id=='e11a109d-31cb-40f7-aa17-50797b287a4f' &
        access=='open' &
        experimental_strategy=='WXS' ) %>%
    result()

resp$results[['id']] %>% cat()
```
