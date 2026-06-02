#  @import logger
#  @import jsonlite
#  @import httr
#  @import R6
NULL
#  Constants
DEFAULT_DC_ID <- 2
DEFAULT_IPV4_IP <- "149.154.167.51"
DEFAULT_IPV6_IP <- "2001:67c:4e8:f002::a"
DEFAULT_PORT <- 443

# Global variables
LAYER <- 216 # Telegram API layer (aligned with recent Telethon layer)

# Time in seconds before disconnecting exported senders
DISCONNECT_EXPORTED_AFTER <- 60

#  Export State Class
# 
#  Tracks the state of exported MTProto senders
# 
#  @description
#  This class manages the state of exported MTProto senders, including
#  tracking the number of borrowed senders and the time since the last
#  borrowed sender was returned.
#  @export
#  @noRd
#  @noRd
ExportState <- R6::R6Class("ExportState",
  public = list(
    #  @description
    #  Constructor for the ExportState class
    #  @return None.
    initialize = function() {
      private$n <- 0
      private$zero_ts <- 0
      private$connected <- FALSE
    },

    #  @description
    #  Add a borrowed sender
    #  @return None.
    add_borrow = function() {
      private$n <- private$n + 1
      private$connected <- TRUE
    },

    #  @description
    #  Return a borrowed sender
    #  @return None.
    add_return = function() {
      private$n <- private$n - 1
      stopifnot("Returned sender more than it was borrowed" = private$n >= 0)
      if (private$n == 0) {
        private$zero_ts <- as.numeric(Sys.time())
      }
    },

    #  @description
    #  Check if the sender should be disconnected
    #  @return TRUE if should disconnect, FALSE otherwise.
    should_disconnect = function() {
      return(private$n == 0 &&
        private$connected &&
        (as.numeric(Sys.time()) - private$zero_ts) > DISCONNECT_EXPORTED_AFTER)
    },

    #  @description
    #  Check if the sender needs to connect
    #  @return TRUE if needs to connect, FALSE otherwise.
    need_connect = function() {
      return(!private$connected)
    },

    #  @description
    #  Mark the sender as disconnected
    #  @return None.
    mark_disconnected = function() {
      stopifnot("Marked as disconnected when it was borrowed" = self$should_disconnect())
      private$connected <- FALSE
    }
  ),
  private = list(
    n = NULL,
    zero_ts = NULL,
    connected = NULL
  )
)

#  Telegram Base Client
# 
#  Abstract base class for telegram client implementation
# 
#  @description
#  This class provides the core functionality for a Telegram client,
#  including connection management, session handling, and
#  message processing.
#  @export
#  @noRd
#  @noRd
TelegramBaseClient <- R6::R6Class("TelegramBaseClient",
  public = list(
    #  @description Initialize a new Telegram client
    # 
    #  @param session Session object or path to session file
    #  @param api_id API ID from my.telegram.org
    #  @param api_hash API hash from my.telegram.org
    #  @param connection Connection class to use
    #  @param use_ipv6 Whether to connect through IPv6
    #  @param proxy Proxy settings
    #  @param local_addr Local address to bind to
    #  @param timeout Connection timeout
    #  @param request_retries How many times to retry requests
    #  @param connection_retries How many times to retry connections
    #  @param retry_delay Delay between retries
    #  @param auto_reconnect Whether to automatically reconnect
    #  @param sequential_updates Whether to process updates sequentially
    #  @param flood_sleep_threshold Time in seconds to automatically sleep on flood wait errors
    #  @param raise_last_call_error Whether to raise the last call error
    #  @param device_model Device model to report
    #  @param system_version System version to report
    #  @param app_version App version to report
    #  @param lang_code Language code
    #  @param system_lang_code System language code
    #  @param base_logger Base logger to use
    #  @param receive_updates Whether to receive updates
    #  @param catch_up Whether to catch up on missed updates
    #  @param entity_cache_limit Maximum number of entities to keep in cache
    initialize = function(session,
                          api_id,
                          api_hash,
                          connection = NULL, # ConnectionTcpFull in Python
                          #  @field use_ipv6 Field.
                          use_ipv6 = FALSE,
                          #  @field proxy Field.
                          proxy = NULL,
                          #  @field local_addr Field.
                          local_addr = NULL,
                          #  @field timeout Field.
                          timeout = 10,
                          #  @field request_retries Field.
                          request_retries = 5,
                          #  @field connection_retries Field.
                          connection_retries = 5,
                          #  @field retry_delay Field.
                          retry_delay = 1,
                          #  @field auto_reconnect Field.
                          auto_reconnect = TRUE,
                          #  @field sequential_updates Field.
                          sequential_updates = FALSE,
                          #  @field flood_sleep_threshold Field.
                          flood_sleep_threshold = 60,
                          #  @field raise_last_call_error Field.
                          raise_last_call_error = FALSE,
                          #  @field device_model Field.
                          device_model = NULL,
                          #  @field system_version Field.
                          system_version = NULL,
                          #  @field app_version Field.
                          app_version = NULL,
                          #  @field lang_code Field.
                          lang_code = "en",
                          #  @field system_lang_code Field.
                          system_lang_code = "en",
                          #  @field base_logger Field.
                          base_logger = NULL,
                          #  @field receive_updates Field.
                          receive_updates = TRUE,
                          #  @field catch_up Field.
                          catch_up = FALSE,
                          entity_cache_limit = 5000) {
      step <- "validate"
      trace_file <- file.path(tempdir(), "telegramR_init_trace.log")
      trace_log <- function(msg) {
        tryCatch({
          cat(sprintf("[%s] %s\n", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), msg), file = trace_file, append = TRUE)
        }, error = function(e) NULL)
      }
      on_error <- function(e) {
        trace_log(sprintf("ERROR step=%s msg=%s", step, conditionMessage(e)))
        stop(sprintf("TelegramBaseClient$initialize failed at step=%s: %s", step, conditionMessage(e)), call. = FALSE)
      }
      trace_log("start initialize")
      tryCatch({
        trace_log("step validate")
        if (is.null(api_id) || is.null(api_hash) || api_id == "" || api_hash == "") {
          stop("Your API ID or Hash cannot be empty or NULL. Refer to telethon.rtfd.io for more information.")
        }

        step <- "session"
        trace_log("step session")
        private$use_ipv6 <- use_ipv6

        # Handle session object
        if (is.character(session) || inherits(session, "Path")) {
          session_path <- as.character(session)
          loaded_session <- NULL
          if (file.exists(session_path)) {
            loaded_session <- tryCatch(readRDS(session_path), error = function(e) NULL)
          }
          private$session <- loaded_session %||% list()
          private$session$path <- session_path
          private$session$server_address <- private$session$server_address %||% if (use_ipv6) DEFAULT_IPV6_IP else DEFAULT_IPV4_IP
          private$session$port <- private$session$port %||% DEFAULT_PORT
          private$session$dc_id <- private$session$dc_id %||% DEFAULT_DC_ID
        } else if (is.null(session)) {
          # Create in-memory session
          private$session <- list(memory = TRUE)
          private$session$server_address <- if (use_ipv6) DEFAULT_IPV6_IP else DEFAULT_IPV4_IP
          private$session$port <- DEFAULT_PORT
          private$session$dc_id <- DEFAULT_DC_ID
        } else {
          private$session <- session
        }

        step <- "core"
        trace_log("step core")
        # Core attributes
        private$api_id <- as.integer(api_id)
        private$api_hash <- api_hash
        private$raise_last_call_error <- raise_last_call_error
        private$request_retries <- request_retries
        private$connection_retries <- connection_retries
        private$retry_delay <- retry_delay
        private$proxy <- proxy
        private$local_addr <- local_addr
        private$timeout <- timeout
        private$auto_reconnect <- auto_reconnect
        private$connection <- connection # This would be a factory in a full implementation

        step <- "version"
        trace_log("step version")
        # Version (set early so it's available for init_request defaults)
        private$version <- "1.0.0"

        step <- "sysinfo"
        trace_log("step sysinfo")
        # System info for connection initialization
        sys_info <- Sys.info()

      if (grepl("64", R.version$arch)) {
        default_device_model <- "PC 64bit"
      } else if (grepl("32", R.version$arch)) {
        default_device_model <- "PC 32bit"
      } else {
        default_device_model <- R.version$arch
      }

      default_system_version <- sub("-.*", "", sys_info["release"])

      # Create init request structure
      private$init_request <- list(
        api_id = private$api_id,
        device_model = if (!is.null(device_model)) device_model else default_device_model,
        system_version = if (!is.null(system_version)) system_version else default_system_version,
        app_version = if (!is.null(app_version)) app_version else private$version,
        lang_code = lang_code,
        system_lang_code = system_lang_code,
        lang_pack = "", # "langPacks are for official apps only"
        #  @field query Field.
        query = NULL,
        proxy = NULL # init_proxy would be set here in the Python version
      )

      # State fields
      private$flood_sleep_threshold <- min(flood_sleep_threshold %||% 0, 24 * 60 * 60)
      private$flood_waited_requests <- list()
      private$borrowed_senders <- list()
      private$borrow_sender_lock <- NULL # Would be a mutex in a real implementation
      private$sender_pool <- list()
      private$exported_sessions <- list()
      private$loop <- NULL
      private$updates_error <- NULL
      private$updates_handle <- NULL
      private$keepalive_handle <- NULL
      private$last_request <- as.numeric(Sys.time())
      private$no_updates <- !receive_updates
      private$sequential_updates <- sequential_updates
      private$event_handler_tasks <- list()
      private$authorized <- NULL # NULL = unknown, FALSE = no, TRUE = yes
      private$event_builders <- list()
      private$conversations <- list()
      private$albums <- list()
      private$parse_mode <- "markdown" # Default parse mode
      private$phone_code_hash <- list()
      private$phone <- NULL
      private$tos <- NULL
      private$megagroup_cache <- list()
      private$catch_up <- catch_up
      private$updates_queue <- NULL # Would be a queue in a full implementation
      private$message_box <- NULL # Would be a MessageBox in a full implementation
      ec_cls <- base::get0("EntityCache", envir = asNamespace("telegramR"))
      if (is.null(ec_cls) || !base::is.function(ec_cls$new)) {
        stop("EntityCache$new is not a function")
      }
        step <- "entity_cache"
        trace_log("step entity_cache")
        private$mb_entity_cache <- ec_cls$new()
      private$entity_cache_limit <- entity_cache_limit

        step <- "connection_sender"
        trace_log("step connection_sender")
        # Ensure we always have a sender; connection is configured separately.
        if (is.null(private$connection)) {
          conn_ab <- base::get0("ConnectionTcpAbridged", envir = asNamespace("telegramR"))
          conn_full <- base::get0("ConnectionTcpFull", envir = asNamespace("telegramR"))
          if (!is.null(conn_ab)) {
            private$connection <- conn_ab
          } else if (!is.null(conn_full)) {
            private$connection <- conn_full
          }
        }
        sender_cls <- base::get0("MTProtoSender", envir = asNamespace("telegramR"))
        if (is.null(sender_cls) || !base::is.function(sender_cls$new)) {
          stop("MTProtoSender$new is not a function")
        }
        private$sender <- sender_cls$new(
        #  @field auth_key_callback Field.
        auth_key_callback = NULL,
        retries = private$connection_retries,
        delay = private$retry_delay,
        auto_reconnect = private$auto_reconnect,
        connect_timeout = private$timeout,
        #  @field auto_reconnect_callback Field.
        auto_reconnect_callback = NULL
        )

      # Restore auth key from persisted session when available.
      # Use the active binding to set the key data on the existing AuthKey
      # object so that the shared reference with MTProtoState is preserved.
        step <- "restore_auth"
        trace_log("step restore_auth")
        if (!is.null(private$session$auth_key)) {
          if (inherits(private$session$auth_key, "AuthKey")) {
            private$sender$auth_key$key <- private$session$auth_key$key
          } else {
            private$sender$auth_key$key <- private$session$auth_key
          }
        }

        # Do not auto-connect in constructor; connection is explicit via connect().

        # Version
        private$version <- "1.0.0" # Version of the R client
        trace_log("initialize complete")
      }, error = on_error)
    },

    #  Connect to Telegram
    # 
    #  Establishes a connection to Telegram servers
    # 
    #  @return A future that resolves when connected
    connect = function() {
      if (is.null(private$session)) {
        stop("TelegramClient instance cannot be reused after logging out")
      }

      if (is.null(private$loop)) {
        private$loop <- "running" # Placeholder for the event loop
      }

      log_info <- function(msg) {
        if (!isTRUE(getOption("telegramR.test_mode"))) {
          logger::log_info(msg)
        }
      }

      log_info("Connecting to Telegram...")

      # Configure the sender with session details
      if (!is.null(private$sender) && is.function(private$sender$is_connected) && !private$sender$is_connected()) {
        if (is.function(private$sender$set_auth_key_callback)) {
          private$sender$set_auth_key_callback(function(auth_key) {
            if (!is.null(private$session)) {
              # Store raw key bytes for reliable serialization via saveRDS
              if (inherits(auth_key, "AuthKey")) {
                private$session$auth_key <- auth_key$key
              } else {
                private$session$auth_key <- auth_key
              }
              private$save_session()
            }
          })
        }

        if (is.function(private$sender$set_update_callback)) {
          private$sender$set_update_callback(function(update) {
            if (!private$no_updates) {
              logger::log_debug("Received update: {class(update)[1]}")
              if (!is.null(private$updates_queue) && is.function(private$updates_queue$put)) {
                private$updates_queue$put(update)
              }
            }
          })
        }

        private$connect_sender()
      }

      if (is.null(private$sender) || !is.function(private$sender$is_connected) || !isTRUE(private$sender$is_connected())) {
        stop("ConnectionError: Sender is disconnected after connect attempt")
      }

      private$save_session()

      if (private$catch_up && !is.null(private$message_box)) {
        log_info("Catching up on missed updates...")
      }

      # Try to send init request if supported; otherwise fall back to a default config
      config_result <- tryCatch(
        {
          if (!is.null(private$sender) && is.function(private$sender$send)) {
            init_query <- InitConnectionRequest$new(
              api_id = private$init_request$api_id,
              device_model = private$init_request$device_model,
              system_version = private$init_request$system_version,
              app_version = private$init_request$app_version,
              lang_code = private$init_request$lang_code,
              system_lang_code = private$init_request$system_lang_code,
              lang_pack = private$init_request$lang_pack,
              query = GetConfigRequest$new()
            )
            # Telegram expects the first query in a session to be wrapped into
            # invokeWithLayer(initConnection(...)).
            fut <- private$sender$send(
              InvokeWithLayerRequest$new(layer = as.integer(LAYER), query = init_query)
            )
            future::value(fut)
          } else {
            list(dc_options = list())
          }
        },
        error = function(e) {
          logger::log_warn("Skipping init request: {e$message}")
          list(dc_options = list())
        }
      )

      private$config <- config_result

      if (!private$no_updates) {
        private$updates_queue <- Queue$new()
        private$updates_handle <- "active"
        private$keepalive_handle <- "active"
      }

      log_info("Connected to Telegram!")

      if (isTRUE(getOption("telegramR.auth_status_message", TRUE)) &&
          is.function(self$is_user_authorized)) {
        auth_val <- tryCatch(
          {
            res <- self$is_user_authorized()
            if (inherits(res, "Future")) {
              future::value(res)
            } else {
              res
            }
          },
          error = function(e) NULL
        )
        if (isTRUE(auth_val)) {
          log_info("Authorized session detected. No login required.")
        } else if (identical(auth_val, FALSE)) {
          log_info("Not authorized. Request a login code with `client$send_code_request()`.")
        } else if (!is.null(private$session$auth_key)) {
          log_info("Auth key is present. This does NOT guarantee authorization; you may still need to log in.")
        } else {
          log_info("Authorization status unknown. If needed, request a login code with `client$send_code_request()`.")
        }
      }

      if (isTRUE(getOption("telegramR.async", FALSE))) {
        return(future::future(TRUE))
      }
      invisible(TRUE)
    },

    #  Check if client is connected
    # 
    #  @return TRUE if connected, FALSE otherwise
    is_connected = function() {
      if (!is.null(private$sender) && is.function(private$sender$is_connected)) {
        return(isTRUE(private$sender$is_connected()))
      }
      return(FALSE)
    },

    #  Disconnect from Telegram
    # 
    #  Closes the connection to Telegram servers
    # 
    #  @return A future that resolves when disconnected
    disconnect = function() {
      # If session is gone, behave as tests expect
      if (is.null(private$session)) {
        stop("TelegramClient instance cannot be reused after logging out")
      }
      private$disconnect_internal()
      future::future(TRUE)
    },

    #  Set proxy for the connection
    # 
    #  @param proxy Proxy configuration
    set_proxy = function(proxy) {
      private$proxy <- proxy

      # Update init request with new proxy
      # Would need to update the actual connection in a real implementation

      logger::log_info("Proxy updated. Will take effect on reconnection.")
    },

    #  Get client version
    # 
    #  @return Current client version
    get_version = function() {
      return(private$version)
    },

    #  Get the flood sleep threshold
    # 
    #  @return Current flood sleep threshold in seconds
    get_flood_sleep_threshold = function() {
      return(private$flood_sleep_threshold)
    },

    #  Set the flood sleep threshold
    # 
    #  @param value New threshold in seconds
    set_flood_sleep_threshold = function(value) {
      private$flood_sleep_threshold <- min(value %||% 0, 24 * 60 * 60)
    },

    # Add missing accessor for proxy used in tests
    get_proxy = function() {
      return(private$proxy)
    },

    #  @description
    #  Switch the client to a different data center.
    #  @param new_dc The new DC ID.
    switch_dc = function(new_dc) {
      dc <- future::value(private$get_dc(new_dc))

      private$session$dc_id <- dc$id
      private$session$server_address <- dc$ip_address
      private$session$port <- dc$port
      private$session$auth_key <- NULL
      if (isTRUE(getOption("telegramR.trace_migrate", FALSE))) {
        message(sprintf(
          "[trace] switch_dc -> dc_id=%s ip=%s port=%s",
          as.character(private$session$dc_id),
          as.character(private$session$server_address),
          as.character(private$session$port)
        ))
      }

      if (!is.null(private$sender)) {
        private$sender$auth_key <- AuthKey$new(NULL)
        tryCatch(future::value(private$sender$disconnect()), error = function(e) NULL)
        private$connect_sender()
      }
      invisible(TRUE)
    }
    ,
    #  @description
    #  Alias for switch_dc.
    #  @param new_dc The new DC ID.
    set_dc = function(new_dc) {
      self$switch_dc(new_dc)
    }
    ,
    #  @description
    #  Get session file path (if file-backed).
    #  @return Path or NULL.
    get_session_path = function() {
      private$session$path %||% NULL
    }
    ,
    #  @description
    #  Clear stored auth key (and optionally delete session file).
    #  @param delete_file Whether to delete the session file if present.
    #  @return TRUE if cleared.
    clear_session_auth_key = function(delete_file = TRUE) {
      if (!is.null(private$session)) {
        private$session$auth_key <- NULL
      }
      if (!is.null(private$sender)) {
        private$sender$auth_key <- AuthKey$new(NULL)
      }
      if (isTRUE(delete_file) && !is.null(private$session$path) && file.exists(private$session$path)) {
        tryCatch(unlink(private$session$path, force = TRUE), error = function(e) NULL)
      }
      invisible(TRUE)
    }
  ),
  private = list(
    # Core attributes
    session = NULL,
    api_id = NULL,
    api_hash = NULL,
    version = NULL,
    sender = NULL,

    # Connection related
    use_ipv6 = NULL,
    proxy = NULL,
    local_addr = NULL,
    timeout = NULL,
    request_retries = NULL,
    connection_retries = NULL,
    retry_delay = NULL,
    auto_reconnect = NULL,
    connection = NULL,
    init_request = NULL,
    loop = NULL,

    # State fields
    log = NULL,
    flood_sleep_threshold = NULL,
    flood_waited_requests = NULL,
    borrowed_senders = NULL,
    borrow_sender_lock = NULL,
    # Connection pool: dc_id (char) -> list of idle MTProtoSender objects
    # Senders are returned here by return_exported_sender and reused by
    # subsequent borrow_exported_sender calls to the same DC, eliminating
    # per-file auth-key export/import round trips.
    sender_pool = NULL,
    sender_pool_max = 4L,
    exported_sessions = NULL,
    updates_error = NULL,
    updates_handle = NULL,
    keepalive_handle = NULL,
    last_request = NULL,
    no_updates = NULL,
    sequential_updates = NULL,
    event_handler_tasks = NULL,
    authorized = NULL,
    event_builders = NULL,
    conversations = NULL,
    albums = NULL,
    parse_mode = NULL,
    phone_code_hash = NULL,
    phone = NULL,
    tos = NULL,
    megagroup_cache = NULL,
    catch_up = NULL,
    updates_queue = NULL,
    message_box = NULL,
    mb_entity_cache = NULL,
    entity_cache_limit = NULL,
    raise_last_call_error = NULL,
    config = NULL,
    cdn_config = NULL,

    # Methods
    disconnect_internal = function() {
      if (!isTRUE(getOption("telegramR.test_mode"))) {
        logger::log_info("Disconnecting from Telegram")
      }

      # Cancel update and keepalive handles
      private$updates_handle <- NULL
      private$keepalive_handle <- NULL

      # Disconnect borrowed senders
      for (dc_id in names(private$borrowed_senders)) {
        state_sender <- private$borrowed_senders[[dc_id]]
        state <- state_sender[[1]]
        sender <- state_sender[[2]]
        logger::log_debug("Disconnecting borrowed sender for DC {dc_id}")
        tryCatch(
          {
            sender$disconnect()
          },
          error = function(e) {
            logger::log_warn("Error disconnecting sender for DC {dc_id}: {e$message}")
          }
        )
      }
      private$borrowed_senders <- list()
      private$sender_pool <- list()

      # Cancel event handlers
      private$event_handler_tasks <- list()

      # Save state
      private$save_states_and_entities()

      # Close session
      private$close_session()
    },
    save_session = function() {
      if (is.null(private$session)) {
        logger::log_warn("Cannot save session, session is NULL")
        return(NULL)
      }

      if (!is.null(private$session$path)) {
        # For file-based sessions, save the data to disk
        session_data <- list(
          dc_id = private$session$dc_id,
          server_address = private$session$server_address,
          port = private$session$port,
          auth_key = private$session$auth_key,
          user_id = private$session$user_id,
          bot_token = private$session$bot_token
        )
        saveRDS(session_data, private$session$path)
        logger::log_debug("Session data saved to {private$session$path}")
      }
    },
    close_session = function() {
      if (is.null(private$session)) {
        return(NULL)
      }

      # Save any pending data before closing
      private$save_session()

      # Disconnect the sender if it exists
      if (!is.null(private$sender)) {
        tryCatch(
          {
            private$sender$disconnect()
          },
          error = function(e) {
            logger::log_warn("Error disconnecting sender: {e$message}")
          }
        )
      }

      # Clear session data
      private$session <- NULL
      if (!isTRUE(getOption("telegramR.test_mode"))) {
        logger::log_info("Session closed")
      }
    },
    save_states_and_entities = function() {
      # Save message box state if it exists
      if (!is.null(private$message_box)) {
        # Would save message states in a real implementation
        logger::log_debug("Saving message box states")
      }

      # Save entity cache to session if supported
      if (!is.null(private$mb_entity_cache) && !is.null(private$session)) {
        cache_len <- if (is.function(private$mb_entity_cache$size)) {
          private$mb_entity_cache$size()
        } else {
          length(private$mb_entity_cache)
        }
        if (cache_len > 0) {
          private$session$entities <- private$mb_entity_cache
          logger::log_debug("Saved {cache_len} entities to session")
        }
      }
    },
    get_dc = function(dc_id, cdn = FALSE) {
      future({
        default_dc_options <- function() {
          list(
            list(id = 1, ip_address = "149.154.175.50", port = 443, ipv6 = FALSE, cdn = FALSE),
            list(id = 2, ip_address = "149.154.167.50", port = 443, ipv6 = FALSE, cdn = FALSE),
            list(id = 3, ip_address = "149.154.175.100", port = 443, ipv6 = FALSE, cdn = FALSE),
            list(id = 4, ip_address = "149.154.167.91", port = 443, ipv6 = FALSE, cdn = FALSE),
            list(id = 5, ip_address = "149.154.171.5", port = 443, ipv6 = FALSE, cdn = FALSE)
          )
        }
        if (is.null(private$config)) {
          private$config <- list(dc_options = list())
        }

        # Try to fetch config if missing dc_options
        if (is.null(private$config$dc_options) || length(private$config$dc_options) == 0) {
          config_result <- NULL
          if (!is.null(private$sender) && is.function(private$sender$send)) {
            config_result <- tryCatch({
              if (!is.null(private$init_request)) {
                init_query <- InitConnectionRequest$new(
                  api_id = private$init_request$api_id,
                  device_model = private$init_request$device_model,
                  system_version = private$init_request$system_version,
                  app_version = private$init_request$app_version,
                  lang_code = private$init_request$lang_code,
                  system_lang_code = private$init_request$system_lang_code,
                  lang_pack = private$init_request$lang_pack,
                  query = GetConfigRequest$new()
                )
                fut <- private$sender$send(
                  InvokeWithLayerRequest$new(layer = as.integer(LAYER), query = init_query)
                )
                future::value(fut)
              } else {
                fut <- private$sender$send(GetConfigRequest$new())
                future::value(fut)
              }
            }, error = function(e) NULL)
          }

          if (!is.null(config_result) && !is.null(config_result$dc_options)) {
            private$config <- config_result
          } else {
            private$config$dc_options <- default_dc_options()
          }
        }

        # Find matching DC
        dc_options <- private$config$dc_options
        if (is.null(dc_options) || length(dc_options) == 0) {
          dc_options <- default_dc_options()
        }
        for (dc in dc_options) {
          if (dc$id == dc_id &&
            identical(isTRUE(dc$ipv6), private$use_ipv6) &&
            identical(isTRUE(dc$cdn), cdn)) {
            return(dc)
          }
        }

        # Retry ignoring IPv6
        logger::log_warn(
          "Failed to get DC {dc_id} (cdn = {cdn}) with use_ipv6 = {private$use_ipv6}; retrying ignoring IPv6 check"
        )

        for (dc in dc_options) {
          if (dc$id == dc_id && identical(isTRUE(dc$cdn), cdn)) {
            return(dc)
          }
        }

        stop(sprintf("Failed to get DC %d (cdn = %s)", dc_id, cdn))
      })
    },
    create_exported_sender = function(dc_id) {
      # Would create an exported sender in a real implementation
      future({
        dc <- private$get_dc(dc_id)
        sender <- "new_sender" # Placeholder for a new sender

        # Would connect the sender to the DC

        logger::log_info("Exporting auth for new borrowed sender in DC {dc_id}")

        # Would send export/import authorization

        return(sender)
      })
    },
    borrow_exported_sender = function(dc_id) {
      future({
        dc_key <- as.character(dc_id)
        logger::log_debug("Borrowing sender for DC {dc_id}")

        # --- Connection pool: reuse an idle sender if one is available ---
        pool <- private$sender_pool[[dc_key]]
        if (!is.null(pool) && length(pool) > 0) {
          sender <- pool[[length(pool)]]
          private$sender_pool[[dc_key]] <- pool[-length(pool)]
          logger::log_debug("Reused pooled sender for DC {dc_id} (pool size now {length(private$sender_pool[[dc_key]])})")

          # Track in borrowed_senders for state management
          state_sender <- private$borrowed_senders[[dc_key]]
          if (is.null(state_sender)) {
            state <- ExportState$new()
            private$borrowed_senders[[dc_key]] <- list(state, sender)
          } else {
            state <- state_sender[[1]]
          }
          state$add_borrow()
          return(sender)
        }

        # --- No pooled sender: create or reconnect ---
        state_sender <- private$borrowed_senders[[dc_key]]

        if (is.null(state_sender)) {
          state <- ExportState$new()
          sender <- private$create_exported_sender(dc_id)
          private$borrowed_senders[[dc_key]] <- list(state, sender)
        } else {
          state <- state_sender[[1]]
          sender <- state_sender[[2]]

          if (state$need_connect()) {
            dc <- private$get_dc(dc_id)
            # Would reconnect the sender to the DC
          }
        }

        state$add_borrow()
        return(sender)
      })
    },
    return_exported_sender = function(sender) {
      future({
        dc_key <- as.character(sender$dc_id)
        logger::log_debug("Returning borrowed sender for DC {sender$dc_id}")

        state_sender <- private$borrowed_senders[[dc_key]]
        if (!is.null(state_sender)) {
          state <- state_sender[[1]]
          state$add_return()
        }

        # --- Return sender to pool (up to sender_pool_max per DC) ---
        pool <- private$sender_pool[[dc_key]] %||% list()
        if (length(pool) < private$sender_pool_max) {
          private$sender_pool[[dc_key]] <- c(pool, list(sender))
          logger::log_debug("Returned sender to pool for DC {sender$dc_id} (pool size now {length(private$sender_pool[[dc_key]])})")
        }
        # If pool is full the sender is simply dropped (will be GC'd)

        return(TRUE)
      })
    },
    clean_exported_senders = function() {
      future({
        for (dc_id in names(private$borrowed_senders)) {
          state_sender <- private$borrowed_senders[[dc_id]]
          state <- state_sender[[1]]
          sender <- state_sender[[2]]

          if (state$should_disconnect()) {
            logger::log_info("Disconnecting borrowed sender for DC {dc_id}")
            # Would disconnect the sender in a real implementation
            state$mark_disconnected()
            # Also drain any pooled senders for this DC
            private$sender_pool[[dc_id]] <- list()
          }
        }

        return(TRUE)
      })
    },
    get_cdn_client = function(cdn_redirect) {
      future({
        session <- private$exported_sessions[[as.character(cdn_redirect$dc_id)]]

        if (is.null(session)) {
          dc <- private$get_dc(cdn_redirect$dc_id, cdn = TRUE)
          session <- private$clone_session()

          # Update session with the DC information
          # Since we're using a simple list structure for sessions
          session$dc_id <- dc$id
          session$server_address <- dc$ip_address
          session$port <- dc$port

          private$exported_sessions[[as.character(cdn_redirect$dc_id)]] <- session
        }

        logger::log_info("Creating new CDN client")

        # Would create a new MTProtoSender for this CDN connection
        # and configure it with the CDN session

        return("cdn_client") # Placeholder for a new client
      })
    },
    clone_session = function() {
      # Clone current session
      return(private$session)
    },

    # Safely call sender$connect with supported arguments
    connect_sender = function() {
      if (is.null(private$sender) || !is.function(private$sender$connect)) {
        return(invisible(FALSE))
      }
      conn_fun <- private$sender$connect

      build_connection <- function() {
        conn_class <- private$connection
        if (is.null(conn_class)) {
          if (exists("ConnectionTcpAbridged", inherits = TRUE)) {
            conn_class <- ConnectionTcpAbridged
          } else if (exists("ConnectionTcpFull", inherits = TRUE)) {
            conn_class <- ConnectionTcpFull
          }
        }
        if (inherits(conn_class, "Connection")) {
          return(conn_class)
        }

        args <- list(
          ip = private$session$server_address,
          port = private$session$port,
          dc_id = private$session$dc_id,
          proxy = private$proxy,
          local_addr = private$local_addr,
          loggers = private$log
        )

        if (inherits(conn_class, "R6ClassGenerator")) {
          init_fun <- conn_class$public_methods$initialize
          fml <- tryCatch(names(formals(init_fun)), error = function(e) NULL)
          if (!is.null(fml) && !("..." %in% fml)) {
            args <- args[intersect(names(args), fml)]
          }
          return(do.call(conn_class$new, args))
        }

        if (is.function(conn_class)) {
          fml <- tryCatch(names(formals(conn_class)), error = function(e) NULL)
          if (!is.null(fml) && !("..." %in% fml)) {
            args <- args[intersect(names(args), fml)]
          }
          return(do.call(conn_class, args))
        }

        return(conn_class)
      }

      fml <- tryCatch(names(formals(conn_fun)), error = function(e) NULL)
      res <- NULL
      if (!is.null(fml) && ("connection" %in% fml || "..." %in% fml)) {
        res <- tryCatch(
          {
            conn_fun(build_connection())
          },
          error = function(e) {
            call_txt <- tryCatch(paste(deparse(conditionCall(e)), collapse = " "), error = function(...) "")
            msg_txt <- tryCatch(conditionMessage(e), error = function(...) as.character(e))
            logger::log_warn("connect() failed: {msg_txt} [{class(e)[1]}] {call_txt}")
            stop(e)
          }
        )
      } else {
        # Legacy fallback for older connect signatures
        args <- list(
          server_address = private$session$server_address,
          port = private$session$port,
          dc_id = private$session$dc_id,
          auth_key = private$session$auth_key
        )
        if (!is.null(fml) && !("..." %in% fml)) {
          args <- args[intersect(names(args), fml)]
        }
        res <- tryCatch(
          {
            do.call(conn_fun, args)
          },
          error = function(e) {
            call_txt <- tryCatch(paste(deparse(conditionCall(e)), collapse = " "), error = function(...) "")
            msg_txt <- tryCatch(conditionMessage(e), error = function(...) as.character(e))
            logger::log_warn("connect() failed: {msg_txt} [{class(e)[1]}] {call_txt}")
            stop(e)
          }
        )
      }
      if (inherits(res, c("Future", "promise"))) {
        res <- tryCatch(future::value(res), error = function(e) {
          call_txt <- tryCatch(paste(deparse(conditionCall(e)), collapse = " "), error = function(...) "")
          msg_txt <- tryCatch(conditionMessage(e), error = function(...) as.character(e))
          logger::log_warn("connect() failed: {msg_txt} [{class(e)[1]}] {call_txt}")
          stop(e)
        })
      }
      if (is.null(private$sender) || !is.function(private$sender$is_connected) || !isTRUE(private$sender$is_connected())) {
        logger::log_warn("Sender still disconnected after connect()")
        return(invisible(FALSE))
      }
      invisible(TRUE)
    }
  )
)

if (!exists("Queue", inherits = FALSE)) {
#  @noRd
#  @noRd
  Queue <- R6::R6Class(
    "Queue",
    public = list(
      #  @field items Field.
      items = NULL,
      initialize = function() {
        self$items <- list()
      },
      put = function(item) {
        self$items[[length(self$items) + 1]] <- item
        invisible(NULL)
      }
    )
  )
}

#  Null coalescing operator
#  @name null-coalesce
#  @param x The first value
#  @param y The second value
#  @return The first value if not NULL, otherwise the second value
#  @export
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
