#  GetChannelDifferenceRequest R6 class
# 
#  Representation of updates.GetChannelDifference request.
# 
#  @title GetChannelDifferenceRequest
#  @description Telegram API type GetChannelDifferenceRequest
#  @export
#  @noRd
#  @noRd
GetChannelDifferenceRequest <- R6::R6Class(
  "GetChannelDifferenceRequest",
  public = list(
    #  @field channel Field.
    channel = NULL,
    #  @field filter Field.
    filter = NULL,
    #  @field pts Field.
    pts = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field force Field.
    force = NULL,

    #  @description Initializes a new GetChannelDifferenceRequest.
    #  @param channel TypeInputChannel Input channel (R6 object with bytes() or raw
    #  @param filter TypeChannelMessagesFilter Filter (R6 object with bytes() or raw())
    #  @param pts integer PTS
    #  @param limit integer Limit
    #  @param force logical|NULL Optional force flag
    initialize = function(channel, filter, pts, limit, force = NULL) {
      self$channel <- channel
      self$filter <- filter
      self$pts <- as.integer(pts)
      self$limit <- as.integer(limit)
      self$force <- if (!is.null(force)) as.logical(force) else NULL
    },

    #  @description Converts the request to a list representation.
    #  @return A list representing the request.
    to_list = function() {
      list(
        `_` = "GetChannelDifferenceRequest",
        channel = self$channel,
        filter = self$filter,
        pts = self$pts,
        limit = self$limit,
        force = self$force
      )
    },

    #  @description Serializes the request to raw bytes.
    #  @return A raw vector representing the serialized request.
    bytes = function() {
      # header constructor id: 0x03173d78 (0x3173d78)
      flags <- 0L
      if (!is.null(self$force) && isTRUE(self$force)) flags <- bitwOr(flags, 1L)

      channel_bytes <- private$get_object_bytes(self$channel)
      filter_bytes <- private$get_object_bytes(self$filter)

      parts <- list(
        private$pack_int32_le(0x3173d78),
        private$pack_int32_le(flags),
        channel_bytes,
        filter_bytes,
        private$pack_int32_le(self$pts),
        private$pack_int32_le(self$limit)
      )

      do.call(c, parts)
    }
  ),
  active = list(),
  private = list(
    pack_int32_le = function(x) {
      int_to_raw_le(x, 4L)
    },
    get_object_bytes = function(obj) {
      # If already raw, return as is. If R6 object with bytes() method, call it.
      if (is.raw(obj)) {
        obj
      } else if (is.function(obj$bytes)) {
        obj$bytes()
      } else if (is.list(obj) && !is.null(obj$`_`) && is.function(obj$to_bytes)) {
        # fallback if objects implement to_bytes
        obj$to_bytes()
      } else {
        stop("Cannot serialize object to bytes: expected raw or object with bytes() method")
      }
    }
  ),
  class = TRUE
)

#  Create GetChannelDifferenceRequest from reader
# 
#  @param reader Object with methods read_int() and tgread_object()
#  @return GetChannelDifferenceRequest
GetChannelDifferenceRequest$set("public", "from_reader", function(reader) {
  flags_val <- reader$read_int()
  force_val <- bitwAnd(flags_val, 1L) != 0L
  channel_val <- reader$tgread_object()
  filter_val <- reader$tgread_object()
  pts_val <- reader$read_int()
  limit_val <- reader$read_int()

  GetChannelDifferenceRequest$new(
    channel = channel_val,
    filter = filter_val,
    pts = pts_val,
    limit = limit_val,
    force = force_val
  )
})


#  GetDifferenceRequest R6 class
# 
#  Representation of updates.GetDifference request.
# 
#  @title GetDifferenceRequest
#  @description Telegram API type GetDifferenceRequest
#  @export
#  @noRd
#  @noRd
GetDifferenceRequest <- R6::R6Class(
  "GetDifferenceRequest",
  public = list(
    #  @field pts Field.
    pts = NULL,
    #  @field date Field.
    date = NULL,
    #  @field qts Field.
    qts = NULL,
    #  @field pts_limit Field.
    pts_limit = NULL,
    #  @field pts_total_limit Field.
    pts_total_limit = NULL,
    #  @field qts_limit Field.
    qts_limit = NULL,

    #  @description Converts the request to a list representation.
    #  @param pts integer PTS
    #  @param date POSIXct|NULL Date
    #  @param qts integer QTS
    #  @param pts_limit integer|NULL Optional pts_limit
    #  @param pts_total_limit integer|NULL Optional pts_total_limit
    #  @param qts_limit integer|NULL Optional qts_limit
    initialize = function(pts, date = NULL, qts, pts_limit = NULL, pts_total_limit = NULL, qts_limit = NULL) {
      self$pts <- as.integer(pts)
      self$date <- date
      self$qts <- as.integer(qts)
      self$pts_limit <- if (!is.null(pts_limit)) as.integer(pts_limit) else NULL
      self$pts_total_limit <- if (!is.null(pts_total_limit)) as.integer(pts_total_limit) else NULL
      self$qts_limit <- if (!is.null(qts_limit)) as.integer(qts_limit) else NULL
    },

    #  @description Initializes a new GetDifferenceRequest.
    #  @return A new GetDifferenceRequest instance.
    to_list = function() {
      list(
        `_` = "GetDifferenceRequest",
        pts = self$pts,
        date = self$date,
        qts = self$qts,
        pts_limit = self$pts_limit,
        pts_total_limit = self$pts_total_limit,
        qts_limit = self$qts_limit
      )
    },

    #  @description Converts the request to a list representation.
    #  @return A list representing the request.
    bytes = function() {
      # header constructor id: 0x19c2f763
      flags <- 0L
      if (!is.null(self$pts_limit)) flags <- bitwOr(flags, 2L)
      if (!is.null(self$pts_total_limit)) flags <- bitwOr(flags, 1L)
      if (!is.null(self$qts_limit)) flags <- bitwOr(flags, 4L)

      parts <- list(
        private$pack_int32_le(0x19c2f763),
        private$pack_int32_le(flags),
        private$pack_int32_le(self$pts)
      )
      if (!is.null(self$pts_limit)) parts <- c(parts, list(private$pack_int32_le(self$pts_limit)))
      if (!is.null(self$pts_total_limit)) parts <- c(parts, list(private$pack_int32_le(self$pts_total_limit)))
      # serialize_datetime is expected to be available in the environment and return raw()
      parts <- c(parts, list(serialize_datetime(self$date)))
      parts <- c(parts, list(private$pack_int32_le(self$qts)))
      if (!is.null(self$qts_limit)) parts <- c(parts, list(private$pack_int32_le(self$qts_limit)))

      do.call(c, parts)
    }
  ),
  active = list(),
  private = list(
    pack_int32_le = function(x) {
      int_to_raw_le(x, 4L)
    }
  ),
  class = TRUE
)

#  Create GetDifferenceRequest from reader
# 
#  @param reader Object with methods read_int() and tgread_date()
#  @return GetDifferenceRequest
GetDifferenceRequest$set("public", "from_reader", function(reader) {
  flags <- reader$read_int()

  pts_val <- reader$read_int()
  pts_limit_val <- if (bitwAnd(flags, 2L) != 0L) reader$read_int() else NULL
  pts_total_limit_val <- if (bitwAnd(flags, 1L) != 0L) reader$read_int() else NULL
  date_val <- reader$tgread_date()
  qts_val <- reader$read_int()
  qts_limit_val <- if (bitwAnd(flags, 4L) != 0L) reader$read_int() else NULL

  GetDifferenceRequest$new(
    pts = pts_val,
    date = date_val,
    qts = qts_val,
    pts_limit = pts_limit_val,
    pts_total_limit = pts_total_limit_val,
    qts_limit = qts_limit_val
  )
})

#  GetStateRequest R6 class
# 
#  Representation of updates.GetState request.
# 
#  @title GetStateRequest
#  @description Telegram API type GetStateRequest
#  @export
#  @noRd
#  @noRd
GetStateRequest <- R6::R6Class(
  "GetStateRequest",
  public = list(
    #  @description Converts the request to a list representation.
    initialize = function() {},

    #  @description Serializes the request to raw bytes.
    #  @return A raw vector representing the serialized request.
    to_list = function() {
      list(`_` = "GetStateRequest")
    },

    #  @description Initializes a new GetStateRequest.
    #  @return A new GetStateRequest instance.
    bytes = function() {
      private$pack_int32_le(0xedd4882a)
    }
  ),
  private = list(
    pack_int32_le = function(x) {
      int_to_raw_le(x, 4L)
    }
  ),
  class = TRUE
)

#  Create GetStateRequest from reader
# 
#  @param reader Object with methods read_int() etc.
#  @return GetStateRequest
GetStateRequest$set("public", "from_reader", function(reader) {
  GetStateRequest$new()
})
