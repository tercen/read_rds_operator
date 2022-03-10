library(tercen)
library(dplyr)

options("tercen.workflowId" = "wwww")
options("tercen.stepId"     = "dddd")

getOption("tercen.workflowId")
getOption("tercen.stepId")


tabl<-read.csv2(file = "./tests/c03_simple_exp.tsv", sep="\t")

saveRDS(tabl, file = "./tests/c03_simple_exp.rds", ascii = FALSE, version = NULL,compress = TRUE, refhook = NULL)


is.POSIXct <- function(x) inherits(x, "POSIXct")

doc_to_data = function(df){
  filename = tempfile()
  writeBin(ctx$client$fileService$download(df$documentId[1]), filename)
  on.exit(unlink(filename))
  readRDS(filename) %>% 
    as_tibble() %>%
    mutate_if(is.POSIXct, as.character) %>%
    mutate_if(is.logical, as.character) %>%
    mutate_if(is.integer, as.double) %>%
    mutate(.ci= rep_len(df$.ci[1], nrow(.)))
}

ctx <- tercenCtx()

if (!any(ctx$cnames == "documentId")) stop("Column factor documentId is required") 

ctx$cselect() %>% 
  mutate(.ci= 1:nrow(.)-1L) %>%
  split(.$.ci) %>%
  lapply(doc_to_data) %>%
  bind_rows() %>%
  ctx$addNamespace() %>%
  ctx$save()