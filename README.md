# telegramR <a href="https://romankyrychenko.github.io/telegramR/"><img src="man/figures/logo.png" align="right" height="139" alt="telegramR website" /></a>

<!-- badges: start -->
[![R-CMD-check](https://github.com/RomanKyrychenko/telegramR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/RomanKyrychenko/telegramR/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/RomanKyrychenko/telegramR/graph/badge.svg)](https://app.codecov.io/gh/RomanKyrychenko/telegramR)
<!-- badges: end -->

`telegramR` is an R client for Telegram's MTProto API. It is intended as an R alternative to Python's [Telethon](https://github.com/LonamiWebs/Telethon) and focuses on full-client functionality (not the Bot API).

**Install**

From CRAN (once accepted):

```r
install.packages("telegramR")
```

From GitHub (development version):

```r
# install.packages("remotes")
remotes::install_github("RomanKyrychenko/telegramR")
```

**Prerequisites**

You need Telegram API credentials from [my.telegram.org](https://my.telegram.org):

- `api_id`
- `api_hash`

**Quick Start (Login)**

```r
library(telegramR)

api_id   <- 123456
api_hash <- "0123456789abcdef0123456789abcdef"

# Create a client. The session file stores your auth key so you
# don't need to re-login every time.
client <- TelegramClient$new(
  session  = "my_session",
  api_id   = api_id,
  api_hash = api_hash
)

# Connect and log in interactively.
# You will be prompted for your phone number, the login code Telegram
# sends you, and (if enabled) your 2FA password.
client$start()
```

You can also supply the phone number and a code callback explicitly:

```r
client$start(
  phone         = "+15551234567",
  code_callback = function() readline("Enter the code: ")
)
```

If your account has 2FA enabled, pass `password`:

```r
client$start(
  phone    = "+15551234567",
  password = "my2FApassword"
)
```

**Step-by-step login (non-interactive)**

If you prefer full control over each step:

```r
client <- TelegramClient$new("my_session", api_id = api_id, api_hash = api_hash)
client$connect()

# Request a login code
client$send_code_request("+15551234567")

# Sign in with the code you received
client$sign_in("+15551234567", code = "12345")
```

**Download messages from a channel**

Use high‑level helpers to fetch channel data as tibbles:

```r
library(telegramR)

msgs <- download_channel_messages(
  client,
  "telegram",
  limit = 200
)

msgs
```

The result contains a compact schema:

- `message_id`, `date`, `text`
- `views`, `forwards`, `replies`
- `reactions_total`, `reactions_json`
- `media_type`, `is_forward`, `forward_from_id`, `forward_from_message_id`, `forward_saved_from_message_id`, `forward_from_name`
- `reply_to_msg_id`, `edit_date`, `post_author`
- `channel_id`, `channel_username`, `channel_title`

You can also fetch channel info:

```r
info <- download_channel_info(client, "telegram")
info
```

Filter by date range:

```r
msgs <- download_channel_messages(
  client,
  "telegram",
  start_date = "2025-01-01",
  end_date   = "2025-02-01",
  limit      = Inf
)
```

And get an approximate post count (upper bound) without downloading everything:

```r
estimate_channel_post_count(client, "telegram")
```

**Reactions, replies, and members**

```r
reactions <- download_channel_reactions(client, "telegram", limit = 500)
replies <- download_channel_replies(client, "telegram", message_limit = 50)
members <- download_channel_members(client, "telegram", limit = 1000)
media <- download_channel_media(client, "telegram", limit = 200, out_dir = "downloads")
```

All helpers accept a numeric channel id when it is available in your session cache:

```r
msgs_by_id <- download_channel_messages(client, 1234567890, limit = 100)
```

**Download media**

```r
dir.create("downloads", showWarnings = FALSE)

media <- download_channel_media(
  client,
  "telegram",
  limit = 200,
  media_types = c("photo", "video"),
  start_date = "2025-01-01",
  end_date = "2025-02-01",
  out_dir = "downloads"
)

head(media)
```

You can also download directly from raw messages:

```r

for (m in messages) {
  if (!is.null(m$media)) {
    future::value(client$download_media(m, file = "downloads/"))
  }
}
```

**Notes**

- Sessions are persisted to the file you pass to `TelegramClient$new()`.
  Remove that file to force a fresh login.
- Be mindful of Telegram rate limits when downloading large histories or
  media collections. Add `Sys.sleep()` between requests.
- Most high-level methods (like `get_entity`, `download_media`) return
  [future](https://cran.r-project.org/package=future) objects. Unwrap
  them with `future::value()`.
- To silence pump/process debug messages, keep these options disabled:
  `options(telegramR.debug_pump = FALSE, telegramR.debug_process = FALSE, telegramR.debug_parse = FALSE)`.
- To trace hangs in channel info/message downloads, enable:
  `options(telegramR.trace_hang = TRUE, telegramR.trace_parse = TRUE)` to see step-by-step parsing and network waits.
 - Some channels send photos as documents with `image/*` MIME types. `download_channel_media()` treats `image` as a photo-type alias when `photo` is requested.

**Citation**

In R, use:

```r
citation("telegramR")
```

GitHub and reference managers can also read the repository's `CITATION.cff`.
