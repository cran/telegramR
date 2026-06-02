# telegramR 0.0.1

* Initial CRAN release.
* Full MTProto client for Telegram: authentication, serialisation/deserialisation
  of the TL schema, encrypted transport, and session management.
* High-level helpers for downloading channel messages, reactions, and replies
  at scale (`download_channel_messages()`, `batch_download_channels()`).
* Two-factor authentication support via `PasswordKdf`.
* Story support via `functions_stories.R` request classes.
