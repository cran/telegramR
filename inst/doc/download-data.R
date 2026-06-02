## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----sample_data, include=FALSE-----------------------------------------------
sample <- readRDS(system.file("extdata/vignettes/channel_sample.rds", package = "telegramR"))
msgs <- sample$msgs
info <- sample$info
reactions <- sample$reactions
replies <- sample$replies
members <- sample$members
estimate <- sample$estimate
library(telegramR)

## ----setup, eval=FALSE--------------------------------------------------------
# library(telegramR)
# 
# # Replace these with your own API ID and Hash
# api_id <- 123456
# api_hash <- "0123456789abcdef0123456789abcdef"
# 
# client <- TelegramClient$new("my_session", api_id, api_hash)
# client$start()

## ----download_messages, eval=FALSE--------------------------------------------
# # Download the most recent 200 messages from a channel
# msgs <- download_channel_messages(
#   client,
#   "telegram",
#   limit = 200
# )

## ----msgs_sample_output-------------------------------------------------------
msgs

## ----download_info, eval=FALSE------------------------------------------------
# info <- download_channel_info(client, "telegram")

## ----inf----------------------------------------------------------------------
info

## ----estimate, eval=FALSE-----------------------------------------------------
# estimate <- estimate_channel_post_count(client, "telegram")

## ----estimate_sample_output---------------------------------------------------
estimate

## ----download_media, eval=FALSE-----------------------------------------------
# # Find the first message with media
# first_media <- msgs[which(!is.na(msgs$media_type) & msgs$media_type != ""), ][1, ]
# 
# if (nrow(first_media) > 0) {
#   # You can still use download_media on the underlying message object
#   # if you need the original media data.
# }

## ----disconnect, eval=FALSE---------------------------------------------------
# client$disconnect()

## ----download_messages_range, eval=FALSE--------------------------------------
# # Download a date range (UTC)
# msgs_range <- download_channel_messages(
#   client,
#   "telegram",
#   start_date = "2025-01-01",
#   end_date   = "2025-02-01",
#   limit      = Inf
# )

## ----download_reactions, eval=FALSE-------------------------------------------
# reactions <- download_channel_reactions(
#   client,
#   "telegram",
#   limit = 500
# )

## -----------------------------------------------------------------------------
reactions

## ----download_replies, eval=FALSE---------------------------------------------
# # Fetch replies for the latest 20 posts
# replies <- download_channel_replies(
#   client,
#   "telegram",
#   message_limit = 20,
#   reply_limit = Inf
# )

## -----------------------------------------------------------------------------
replies

## ----download_members, eval=FALSE---------------------------------------------
# members <- download_channel_members(
#   client,
#   "telegram",
#   limit = 500
# )

## -----------------------------------------------------------------------------
members

## ----channel_id_example, eval=FALSE-------------------------------------------
# msgs_by_id <- download_channel_messages(client, 1234567890, limit = 100)

