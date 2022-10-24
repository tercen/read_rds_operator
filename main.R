library(tercen)
library(dplyr)

is.POSIXct <- function(x) inherits(x, "POSIXct")

doc_to_data = function(df){
  filename = tempfile()
  writeBin(ctx$client$fileService$download(df$documentId[1]), filename)
  on.exit(unlink(filename))
  
  data <- readRDS(filename) 
  
  data %>% 
    as_tibble() %>%
    mutate_if(is.POSIXct, as.character) %>%
    mutate_if(is.logical, as.character) %>%
    mutate_if(is.integer, as.double) %>%
    mutate(.ci = rep_len(df$.ci[1], nrow(.)))
}

ctx <- tercenCtx()

if (!any(ctx$cnames == "documentId")) stop("Column factor documentId is required") 

df <- ctx$cselect() %>% 
  mutate(.ci = 0) %>%
  do(doc_to_data(.))

df %>%
  ctx$addNamespace() %>%
  ctx$save()
