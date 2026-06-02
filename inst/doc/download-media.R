## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----sample_data, include=FALSE-----------------------------------------------
sample <- readRDS(system.file("extdata/vignettes/channel_sample.rds", package = "telegramR"))
media_sample <- sample$media
library(telegramR)
library(dplyr)

## ----setup, eval=FALSE--------------------------------------------------------
# library(telegramR)
# library(dplyr)
# 
# # Replace these with your own API ID and Hash
# api_id <- 123456
# api_hash <- "0123456789abcdef0123456789abcdef"
# 
# client <- TelegramClient$new("my_session", api_id, api_hash)
# client$start()

## ----download_media, eval=FALSE-----------------------------------------------
# # Download media into ./downloads
# media <- download_channel_media(
#   client,
#   "telegram",
#   limit = 200,
#   media_types = c("photo", "video"),
#   start_date = "2025-01-01",
#   end_date = "2025-02-01",
#   out_dir = tempdir()
# )

## ----lll, include=FALSE-------------------------------------------------------
media <- media_sample

## ----shows, eval=TRUE---------------------------------------------------------
# Inspect results
media

## ----display, eval=TRUE-------------------------------------------------------
photo_path <- media %>% 
  filter(media_type == "photo") %>% 
  slice(1) %>% 
  pull(file_path)

# In a real session with downloaded files, display the photo:
# knitr::include_graphics(file.path("..", photo_path))
cat("Photo path:", photo_path, "\n")
cat("(Photo display omitted in offline demo — run with eval=TRUE and real credentials to download.)\n")

