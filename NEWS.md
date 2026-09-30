# telegramR 0.0.2

* Removed unused sample video files from `inst/extdata`, shrinking the source
  tarball to ~3.4Mb (under CRAN's 5Mb guideline).

* Exported `TelegramClient`, the high-level client class, so `TelegramClient$new()`
  works after `library(telegramR)` (its `@export` had been in a comment that
  roxygen ignored, leaving it inaccessible).

* Synced the bundled 'Telegram' TL schema to layer 229 and regenerated all TL
  type and request classes, fixing dialog and message parsing against current
  'Telegram' servers.
* Reworked the schema code-generation tooling in `data-raw/` entirely in R
  (`generate_tl.R`, `overwrite_stale.R`, `dedupe_types.R`, `emit_missing.R`,
  and the `regenerate.R` pipeline), replacing the previous scripts. The
  pipeline is idempotent and documents every generated class with roxygen.
* Fixed serialisation of 64-bit integers and byte fields, and the
  send-media chain.
* Fixed the asynchronous test helpers to resolve `promises` objects, and a
  latent unqualified `openssl::rand_bytes()` call in the obfuscated transport.

# telegramR 0.0.1

* Initial CRAN release.
* Full MTProto client for Telegram: authentication, serialisation/deserialisation
  of the TL schema, encrypted transport, and session management.
* High-level helpers for downloading channel messages, reactions, and replies
  at scale (`download_channel_messages()`, `batch_download_channels()`).
* Two-factor authentication support via `PasswordKdf`.
* Story support via `functions_stories.R` request classes.
