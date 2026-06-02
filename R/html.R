#  Escape HTML special characters.
# 
#  Replaces ampersands, angle brackets, and double quotes with their corresponding HTML entities.
# 
#  @param x A character vector containing text to escape.
# 
#  @return A character vector with HTML-sensitive characters converted to their entity equivalents.
escape_html <- function(x) {
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)
  x <- gsub("\"", "&quot;", x, fixed = TRUE)
  x
}

#  Construct a formatted entity descriptor for Telegram messages.
# 
#  @param type Character string identifying the entity type (e.g., `"bold"`, `"italic"`).
#  @param offset Integer position within the message where the entity starts.
#  @param length Integer length of the entity span within the message; defaults to `0`.
#  @param ... Additional named fields to append to the entity descriptor.
# 
#  @return A named list containing the entity metadata, including any extra fields supplied.
make_entity <- function(type, offset, length = 0, ...) {
  e <- list(type = type, offset = as.integer(offset), length = as.integer(length))
  extra <- list(...)
  if (length(extra)) e <- c(e, extra)
  e
}

#  @details
#    Traverses the HTML node tree, tracking active tags and their metadata to
#    construct Telegram message entities (bold, italic, underline, strike,
#    blockquote, code, preformatted, links, custom emoji). Maintains accumulated
#    text while adjusting entity offsets and lengths, handling special cases such
#    as language hints in `<pre><code>` blocks and anchored URLs.
#  @note Wraps the provided fragment in a `<div>` before parsing to satisfy
#    `xml2::read_html`, and automatically finalizes open entities as tags close.
#  @title HTMLToTelegramParser
#  @description Walks an HTML fragment and builds a plain text string and a list of
#  telegram-style message entities.
#  @importFrom xml2 read_html xml_find_first xml_contents xml_type xml_text xml_name xml_attrs
#  @export
#  @noRd
#  @noRd
HTMLToTelegramParser <- R6::R6Class(
  "HTMLToTelegramParser",
  public = list(
    #  @field text accumulated plain text
    text = "",

    #  @field entities list of entity lists
    entities = NULL,

    #  @field building_entities named list of entities currently being built
    building_entities = NULL,

    #  @field open_tags stack of currently open tags
    open_tags = NULL,

    #  @field open_tags_meta stack of metadata associated with open tags
    open_tags_meta = NULL,

    #  @description Initializes the parser state.
    #  @return A new instance of HTMLToTelegramParser.
    initialize = function() {
      self$text <- ""
      self$entities <- list()
      self$building_entities <- list()
      self$open_tags <- list() # stack (first element is top)
      self$open_tags_meta <- list()
    },

    #  @description Push a tag and optional metadata onto the open tags stack.
    #  @param tag The tag name to push.
    #  @param meta Optional metadata associated with the tag.
    #  @return None.
    push_tag = function(tag, meta = NULL) {
      self$open_tags <- c(list(tag), self$open_tags)
      self$open_tags_meta <- c(list(meta), self$open_tags_meta)
    },

    #  @description Pop the top tag and its metadata from the open tags stack.
    #  @return A list containing the popped tag and its metadata, or NULL if the stack
    pop_tag = function() {
      if (length(self$open_tags) == 0L) {
        return(NULL)
      }
      tag <- self$open_tags[[1]]
      self$open_tags <- self$open_tags[-1]
      meta <- self$open_tags_meta[[1]]
      self$open_tags_meta <- self$open_tags_meta[-1]
      list(tag = tag, meta = meta)
    },

    #  @description Get the current top tag from the open tags stack.
    #  @return The top tag name, or NULL if the stack is empty.
    current_tag = function() {
      if (length(self$open_tags) == 0L) {
        return(NULL)
      }
      self$open_tags[[1]]
    },

    #  @description Get the current top metadata from the open tags stack.
    #  @return The top metadata value, or NULL if the stack is empty.
    current_meta = function() {
      if (length(self$open_tags_meta) == 0L) {
        return(NULL)
      }
      self$open_tags_meta[[1]]
    },

    #  @description Handle the start of an HTML element, updating state and building entities as needed.
    #  @param tag The name of the HTML tag.
    #  @param attrs A named list of attributes for the tag.
    #  @return None.
    start_element = function(tag, attrs) {
      meta_value <- NULL
      self$push_tag(tag, meta_value)

      entity_type <- NULL
      args <- list()

      if (tag %in% c("strong", "b")) {
        entity_type <- "bold"
      } else if (tag %in% c("em", "i")) {
        entity_type <- "italic"
      } else if (tag == "u") {
        entity_type <- "underline"
      } else if (tag %in% c("del", "s")) {
        entity_type <- "strike"
      } else if (tag == "blockquote") {
        entity_type <- "blockquote"
      } else if (tag == "code") {
        if (!is.null(self$building_entities$pre)) {
          cls <- attrs[["class"]]
          if (!is.null(cls) && startsWith(cls, "language-")) {
            self$building_entities$pre$language <- sub("^language-", "", cls)
          }
          entity_type <- NULL
        } else {
          entity_type <- "code"
        }
      } else if (tag == "pre") {
        entity_type <- "pre"
        args$language <- ""
      } else if (tag == "a") {
        href <- attrs[["href"]]
        if (is.null(href)) {
          return()
        }
        if (startsWith(href, "mailto:")) {
          href <- sub("^mailto:", "", href)
          entity_type <- "email"
          args$url <- href
        } else {
          meta_value <- href
          self$open_tags_meta[[1]] <- meta_value
          entity_type <- "text_url_candidate"
          args$url <- href
        }
      } else if (tag == "tg-emoji") {
        emoji_id <- attrs[["emoji-id"]]
        if (!is.null(emoji_id) && nzchar(emoji_id) && grepl("^[0-9]+$", emoji_id)) {
          entity_type <- "custom_emoji"
          args$document_id <- as.integer(emoji_id)
        }
      }

      if (!is.null(entity_type) && is.null(self$building_entities[[tag]])) {
        # build entity using do.call to splice args
        ent <- do.call(
          make_entity,
          c(list(type = entity_type, offset = nchar(self$text, type = "chars"), length = 0), args)
        )
        # Mark formatting-nesting metadata
        fmt_types <- c("bold", "italic", "underline", "strike", "blockquote", "code")
        if (ent$type %in% fmt_types) {
          ent$`._is_nested` <- any(vapply(self$building_entities, function(be) be$type %in% fmt_types, logical(1)))
          if (length(self$building_entities) > 0) {
            for (k in names(self$building_entities)) {
              if (self$building_entities[[k]]$type %in% fmt_types) {
                self$building_entities[[k]]$`._has_child` <- TRUE
              }
            }
          }
        }
        self$building_entities[[tag]] <- ent
      }
    },

    #  @description Handle text nodes, updating accumulated text and entity lengths.
    #  @param text The text content to handle.
    #  @return None.
    handle_text = function(text) {
      # Always append the actual text content; do not substitute anchor hrefs
      text_to_add <- text

      if (length(self$building_entities) > 0) {
        for (k in names(self$building_entities)) {
          self$building_entities[[k]]$length <- self$building_entities[[k]]$length + nchar(text_to_add, type = "chars")
        }
      }

      self$text <- paste0(self$text, text_to_add)
    },

    #  @description Handle the end of an HTML element, finalizing any associated entities.
    #  @param tag The name of the HTML tag.
    #  @return None.
    end_element = function(tag) {
      popped <- self$pop_tag()
      # finalize entity if present
      ent <- NULL
      if (!is.null(self$building_entities[[tag]])) {
        ent <- self$building_entities[[tag]]
        self$building_entities[[tag]] <- NULL
        # Normalize 'text_url_candidate' to 'url' or 'text_url'
        if (identical(ent$type, "text_url_candidate")) {
          entity_text <- substr(self$text, ent$offset + 1, ent$offset + ent$length)
          if (!is.null(ent$url) && identical(entity_text, ent$url)) {
            ent$type <- "url"
          } else {
            ent$type <- "text_url"
          }
        }
        # Conditionally adjust lengths only for nested/parent formatting entities
        fmt_types <- c("bold", "italic", "underline", "strike", "blockquote", "code")
        if (!is.null(ent$length) && ent$length > 0L && ent$type %in% fmt_types) {
          if (isTRUE(ent$`._is_nested`) || isTRUE(ent$`._has_child`)) {
            ent$length <- ent$length - 1L
          }
        }
        # Drop internal flags
        ent$`._is_nested` <- NULL
        ent$`._has_child` <- NULL

        self$entities[[length(self$entities) + 1]] <- ent
      }
    },

    #  @description Recursively parse an XML node and its children.
    #  @param node The XML node to parse.
    #  @return None.
    parse_node = function(node) {
      ttype <- xml2::xml_type(node)
      if (ttype == "text") {
        self$handle_text(xml2::xml_text(node))
        return(invisible(NULL))
      }
      if (ttype == "element") {
        tag <- xml2::xml_name(node)
        attrs <- as.list(xml2::xml_attrs(node))
        self$start_element(tag, attrs)
        # walk children (contents includes text nodes)
        children <- xml2::xml_contents(node)
        if (length(children) > 0) {
          for (child in children) self$parse_node(child)
        }
        self$end_element(tag)
      }
      invisible(NULL)
    },

    #  @description Parse an HTML fragment, updating the parser state with text and entities.
    #  @param html_fragment A character string containing the HTML fragment to parse.
    #  @return None.
    feed = function(html_fragment) {
      # xml2::read_html expects a full document; wrap fragment in a div
      wrapped <- paste0("<div>", html_fragment, "</div>")
      doc <- xml2::read_html(wrapped)
      body_node <- xml2::xml_find_first(doc, "//div")
      contents <- xml2::xml_contents(body_node)
      for (n in contents) self$parse_node(n)
      invisible(NULL)
    }
  )
)

#  Parse HTML into plain text and telegram-style entities
# 
#  @param html character(1) HTML fragment
#  @return named list with elements \code{text} and \code{entities}
#  @export
parse_html_to_telegram <- function(html) {
  if (is.null(html) || !nzchar(html)) {
    return(list(text = html, entities = list()))
  }
  parser <- HTMLToTelegramParser$new()
  parser$feed(html)
  # sort entities by offset
  ents <- parser$entities
  if (length(ents) > 0) {
    order_idx <- order(vapply(ents, function(e) e$offset, integer(1)))
    ents <- ents[order_idx]
  }
  list(text = parser$text, entities = ents)
}

#  Unparse plain text and entities back to HTML
# 
#  @param text character(1) plain text
#  @param entities list of entity lists as produced by \code{parse_html_to_telegram}
#  @return character(1) HTML string
#  @export
unparse_telegram_to_html <- function(text, entities) {
  if (is.null(text) || !nzchar(text)) {
    return(text)
  }
  if (is.null(entities) || length(entities) == 0) {
    return(escape_html(text))
  }

  n <- nchar(text, type = "chars")
  # opens[[pos+1]] / closes[[pos+1]] each entry is list(idx=i, str=tag)
  opens <- vector("list", n + 1L)
  closes <- vector("list", n + 1L)

  for (i in seq_along(entities)) {
    e <- entities[[i]]
    s <- as.integer(e$offset)
    epos <- as.integer(e$offset + e$length)
    typ <- e$type

    start_tag <- ""
    end_tag <- ""

    if (typ == "bold") {
      start_tag <- "<strong>"
      end_tag <- "</strong>"
    } else if (typ == "italic") {
      start_tag <- "<em>"
      end_tag <- "</em>"
    } else if (typ == "underline") {
      start_tag <- "<u>"
      end_tag <- "</u>"
    } else if (typ == "strike") {
      start_tag <- "<del>"
      end_tag <- "</del>"
    } else if (typ == "blockquote") {
      start_tag <- "<blockquote>"
      end_tag <- "</blockquote>"
    } else if (typ == "code") {
      start_tag <- "<code>"
      end_tag <- "</code>"
    } else if (typ == "pre") {
      lang <- if (!is.null(e$language) && nzchar(e$language)) e$language else ""
      start_tag <- paste0("<pre>\n    <code class='language-", escape_html(lang), "'>\n")
      end_tag <- "\n    </code>\n</pre>"
    } else if (typ == "email") {
      href <- escape_html(e$url %||% "")
      start_tag <- paste0('<a href="mailto:', href, '">')
      end_tag <- "</a>"
    } else if (typ == "url") {
      href <- escape_html(substr(text, s + 1L, s + e$length))
      start_tag <- paste0('<a href="', href, '">')
      end_tag <- "</a>"
    } else if (typ == "text_url") {
      href <- escape_html(e$url %||% "")
      start_tag <- paste0('<a href="', href, '">')
      end_tag <- "</a>"
    } else if (typ == "custom_emoji") {
      start_tag <- paste0('<tg-emoji emoji-id="', as.integer(e$document_id), '">')
      end_tag <- "</tg-emoji>"
    } else {
      next
    }

    opens[[s + 1L]] <- c(opens[[s + 1L]], list(list(idx = i, str = start_tag)))
    closes[[epos + 1L]] <- c(closes[[epos + 1L]], list(list(idx = i, str = end_tag)))
  }

  # Build output by scanning positions 0..n; insert closes then opens; append escaped char
  out_parts <- character(0)
  for (pos in 0:n) {
    cs <- closes[[pos + 1L]]
    if (length(cs)) {
      ord <- order(vapply(cs, `[[`, integer(1), "idx"), decreasing = TRUE)
      cs <- cs[ord]
      out_parts <- c(out_parts, vapply(cs, `[[`, character(1), "str"))
    }
    os <- opens[[pos + 1L]]
    if (length(os)) {
      ord <- order(vapply(os, `[[`, integer(1), "idx"), decreasing = FALSE)
      os <- os[ord]
      out_parts <- c(out_parts, vapply(os, `[[`, character(1), "str"))
    }
    if (pos < n) {
      ch <- substr(text, pos + 1L, pos + 1L)
      out_parts <- c(out_parts, escape_html(ch))
    }
  }

  paste0(out_parts, collapse = "")
}

# null-coalesce helper defined in telegrambaseclient.R
