## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----sample_data, include=FALSE-----------------------------------------------
sample <- readRDS(system.file("extdata/vignettes/channel_sample.rds", package = "telegramR"))
replies <- sample$replies
reactions <- sample$reactions
library(telegramR)
library(dplyr)
library(stringr)
library(ggplot2)

## ----setup, eval=FALSE--------------------------------------------------------
# library(telegramR)
# library(dplyr)
# library(stringr)
# library(ggplot2)
# 
# api_id <- 123456
# api_hash <- "0123456789abcdef0123456789abcdef"
# 
# client <- TelegramClient$new("my_session", api_id, api_hash)
# client$start()

## ----replies, eval=FALSE------------------------------------------------------
# replies <- download_channel_replies(
#   client,
#   "V_Zelenskiy_official",
#   message_limit = 20,
#   reply_limit = Inf
# )

## ----reactions, eval=FALSE----------------------------------------------------
# reactions <- download_channel_reactions(
#   client,
#   "V_Zelenskiy_official",
#   limit = 200
# )

## -----------------------------------------------------------------------------
emoji_counts <- reactions %>%
  filter(!is.na(reactions_json)) %>%
  mutate(reactions_json = ifelse(reactions_json == "{}", NA_character_, reactions_json)) %>%
  filter(!is.na(reactions_json))

emoji_counts

