# Attach internal namespace so tests can access non-exported objects by name
if (!"telegramR" %in% loadedNamespaces()) {
  library(telegramR)
}
if (!"telegramR-internal" %in% search()) {
  attach(asNamespace("telegramR"), name = "telegramR-internal", warn.conflicts = FALSE)
}
