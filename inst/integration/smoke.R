#!/usr/bin/env Rscript
# Standalone live integration smoke test for telegramR.
#
# Exercises the documented high-level flows against the real Telegram API.
# Unit tests mock the wire and cannot catch the serialization/iterator bugs
# these cover. Run outside testthat (the package treats a testthat run as
# "no real network"), so this is a plain script that the CI integration job
# executes directly.
#
# Requires:
#   TELEGRAMR_API_ID, TELEGRAMR_API_HASH
#   one of TELEGRAMR_SESSION_FILE (path) or TELEGRAMR_SESSION_B64 (base64 .rds)
# Optional:
#   TELEGRAMR_TEST_CHANNEL (default "telegram")
# Exits 0 if all checks pass or are skipped for lack of credentials; 1 on any
# failure.

# Prefer the development sources when run from a package checkout (so CI tests
# the code under review); fall back to the installed package otherwise.
suppressPackageStartupMessages({
  if (file.exists("DESCRIPTION") && requireNamespace("devtools", quietly = TRUE)) {
    devtools::load_all(".", quiet = TRUE, export_all = FALSE)
  } else {
    library(telegramR)
  }
})
options(telegramR.debug_pump = FALSE, telegramR.debug_process = FALSE, telegramR.debug_parse = FALSE)

api_id   <- Sys.getenv("TELEGRAMR_API_ID")
api_hash <- Sys.getenv("TELEGRAMR_API_HASH")
channel  <- Sys.getenv("TELEGRAMR_TEST_CHANNEL", "telegram")

if (!nzchar(api_id) || !nzchar(api_hash)) {
  message("Integration smoke: credentials not set; skipping.")
  quit(status = 0)
}

# Restore a session from a path or base64 secret into a throwaway temp file.
sess <- tempfile(fileext = ".rds")
src <- Sys.getenv("TELEGRAMR_SESSION_FILE")
b64 <- Sys.getenv("TELEGRAMR_SESSION_B64")
if (nzchar(src) && file.exists(src)) {
  file.copy(src, sess, overwrite = TRUE)
} else if (nzchar(b64)) {
  writeBin(base64enc::base64decode(gsub("\\s", "", b64)), sess)
} else {
  message("Integration smoke: no session provided; skipping.")
  quit(status = 0)
}

`%||%` <- function(a, b) if (is.null(a) || length(a) == 0) b else a
val <- function(x) if (inherits(x, c("Future", "promise"))) future::value(x) else x
TelegramClient <- get("TelegramClient", envir = asNamespace("telegramR"))
# Bind the exported helpers used below (load_all attaches them, but be explicit
# so the script also works against an installed package namespace).
ns <- asNamespace("telegramR")
for (fn in c("download_channel_info", "download_channel_messages",
             "download_channel_reactions", "download_channel_media",
             "estimate_channel_post_count", "check_username_on_telegram",
             "send_message", "send_file")) {
  if (exists(fn, envir = ns, inherits = FALSE)) assign(fn, get(fn, envir = ns))
}

client <- TelegramClient$new(session = sess, api_id = api_id, api_hash = api_hash)
val(client$connect())
if (!isTRUE(tryCatch(val(client$is_user_authorized()), error = function(e) FALSE))) {
  message("Integration smoke: session not authorised; skipping.")
  quit(status = 0)
}

failures <- 0L
check <- function(name, expr, cap = 240) {
  res <- tryCatch({ setTimeLimit(elapsed = cap, transient = TRUE); force(expr) },
                  error = function(e) structure(conditionMessage(e), class = "smoke_error"),
                  finally = setTimeLimit())
  if (inherits(res, "smoke_error")) {
    failures <<- failures + 1L
    cat(sprintf("FAIL  %-46s %s\n", name, substr(res, 1, 90)))
  } else {
    cat(sprintf("ok    %-46s\n", name))
  }
  flush(stdout())
  invisible(res)
}
expect <- function(cond, msg) if (!isTRUE(cond)) stop(msg, call. = FALSE)

me <- check("get_me", { m <- val(client$get_me()); expect(!is.null(m$id), "no id"); m })
check("get_dialogs", { d <- val(client$get_dialogs(limit = 5)); expect(is.list(d), "not a list"); d })
info <- check("download_channel_info", { i <- download_channel_info(client, channel); expect(nrow(i) == 1 && nzchar(i$title), "bad info"); i })
check("download_channel_messages", { m <- download_channel_messages(client, channel, limit = 20, show_progress = FALSE); expect(nrow(m) > 0, "no messages"); m })
if (inherits(info, "data.frame")) {
  check("download_channel_messages(numeric id)", { m <- download_channel_messages(client, as.numeric(info$channel_id), limit = 3, show_progress = FALSE); expect(nrow(m) > 0, "no messages by id"); m })
}
check("estimate_channel_post_count", { e <- estimate_channel_post_count(client, channel); expect(e$last_message_id > 0, "bad estimate"); e })
check("download_channel_reactions", { r <- download_channel_reactions(client, channel, limit = 20); expect(is.data.frame(r), "not df"); r })
check("download_channel_media", {
  d <- tempfile(); dir.create(d)
  md <- download_channel_media(client, channel, limit = 5, media_types = c("photo", "video"), out_dir = d)
  expect(is.data.frame(md), "not df")
  if (nrow(md) > 0) expect(any(file.size(list.files(d, full.names = TRUE)) > 0), "empty files")
  md
}, cap = 400)
check("check_username_on_telegram", check_username_on_telegram(client, "durov"))
check("send_message(me)", { s <- send_message(client, "me", paste("telegramR CI smoke", Sys.time())); expect(inherits(s, "Message") || (is.list(s) && !is.null(s$id)), "no message returned"); s })
check("send_file(me)", { tf <- tempfile(fileext = ".txt"); writeLines("telegramR CI smoke file", tf); f <- send_file(client, "me", tf); expect(inherits(f, "Message") || (is.list(f) && !is.null(f$id)), "no message returned"); f })
check("get_profile_photos(me)", { p <- client$get_profile_photos("me", limit = 5); expect(is.list(p), "not a list"); p })

invisible(tryCatch(val(client$disconnect()), error = function(e) NULL))
cat(sprintf("\nIntegration smoke: %d failure(s)\n", failures))
quit(status = if (failures > 0) 1L else 0L)
