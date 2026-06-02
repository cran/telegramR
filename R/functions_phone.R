#  AcceptCallRequest R6 class
# 
#  Represents AcceptCallRequest TLRequest.
# 
# 
#  @title AcceptCallRequest
#  @description Telegram API type AcceptCallRequest
#  @export
#  @noRd
#  @noRd
AcceptCallRequest <- R6::R6Class(
  "AcceptCallRequest",
  public = list(
    #  @field peer Field.
    peer = NULL,
    #  @field g_b Field.
    g_b = NULL,
    #  @field protocol Field.
    protocol = NULL,

    #  @description Initialize an AcceptCallRequest
    # 
    #  @param peer Input phone call object.
    #  @param g_b Raw bytes.
    #  @param protocol Protocol object.
    #  @return invisible self
    initialize = function(peer, g_b, protocol) {
      self$peer <- peer
      self$g_b <- g_b
      self$protocol <- protocol
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "AcceptCallRequest",
        peer = if (!is.null(self$peer) && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        g_b = self$g_b,
        protocol = if (!is.null(self$protocol) && is.function(self$protocol$to_list)) self$protocol$to_list() else self$protocol
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x3bd2b4a0
      ctor <- int_to_raw_le(0x3bd2b4a0, 4L)

      if (!is.null(self$peer) && is.function(self$peer$bytes)) {
        peer_raw <- self$peer$bytes()
      } else {
        warning("peer does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      if (is.null(self$g_b)) {
        gb_raw <- int_to_raw_le(0L, 4L)
      } else {
        if (is.character(self$g_b)) {
          gb_bytes <- charToRaw(enc2utf8(self$g_b))
        } else if (is.raw(self$g_b)) {
          gb_bytes <- self$g_b
        } else {
          stop("g_b must be a raw vector or a single string")
        }
        gb_raw <- c(int_to_raw_le(length(gb_bytes), 4L), gb_bytes)
      }

      if (!is.null(self$protocol) && is.function(self$protocol$bytes)) {
        protocol_raw <- self$protocol$bytes()
      } else {
        warning("protocol does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      c(ctor, peer_raw, gb_raw, protocol_raw)
    }
  )
)

#  Create AcceptCallRequest from a reader
# 
#  Reads fields from reader and returns a new AcceptCallRequest instance.
# 
#  @param reader An object exposing tgread_object(), tgread_bytes() methods.
#  @return AcceptCallRequest instance
AcceptCallRequest$set("public", "from_reader", function(reader) {
  peer <- reader$tgread_object()
  gb <- reader$tgread_bytes()
  protocol <- reader$tgread_object()
  AcceptCallRequest$new(peer = peer, g_b = gb, protocol = protocol)
})


#  CheckGroupCallRequest R6 class
# 
# 
# 
#  @title CheckGroupCallRequest
#  @description Telegram API type CheckGroupCallRequest
#  @export
#  @noRd
#  @noRd
CheckGroupCallRequest <- R6::R6Class(
  "CheckGroupCallRequest",
  public = list(
    #  @field call Field.
    call = NULL,
    #  @field sources Field.
    sources = NULL,

    #  @description Initialize a CheckGroupCallRequest
    # 
    #  @param call Input group call object.
    #  @param sources List of integers.
    #  @return invisible self
    initialize = function(call, sources) {
      self$call <- call
      self$sources <- sources
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call method.
    #  @return invisible self
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "CheckGroupCallRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call,
        sources = if (!is.null(self$sources)) self$sources else list()
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0xb59cf977
      ctor <- int_to_raw_le(0xb59cf977, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      sources_list <- self$sources
      if (is.null(sources_list)) sources_list <- list()
      sources_count <- length(sources_list)
      # Vector constructor id for TL: 0x1cb5c415 little-endian
      vector_ctor <- int_to_raw_le(0x1cb5c415, 4L)
      sources_count_raw <- int_to_raw_le(sources_count, 4L)
      sources_raw <- raw(0)
      if (sources_count > 0) {
        for (s in sources_list) {
          sources_raw <- c(sources_raw, int_to_raw_le(as.integer(s), 4L))
        }
      }

      c(ctor, call_raw, vector_ctor, sources_count_raw, sources_raw)
    }
  )
)

#  Create CheckGroupCallRequest from a reader
# 
#  Reads fields from reader and returns a new CheckGroupCallRequest instance.
# 
#  @param reader An object exposing tgread_object(), read_int() methods.
#  @return CheckGroupCallRequest instance
CheckGroupCallRequest$set("public", "from_reader", function(reader) {
  call <- reader$tgread_object()
  reader$read_int() # skip vector constructor id
  sources_count <- reader$read_int()
  sources_list <- vector("list", sources_count)
  for (i in seq_len(sources_count)) {
    sources_list[[i]] <- reader$read_int()
  }
  CheckGroupCallRequest$new(call = call, sources = sources_list)
})


#  ConfirmCallRequest R6 class
# 
#  Represents ConfirmCallRequest TLRequest.
# 
# 
#  @title ConfirmCallRequest
#  @description Telegram API type ConfirmCallRequest
#  @export
#  @noRd
#  @noRd
ConfirmCallRequest <- R6::R6Class(
  "ConfirmCallRequest",
  public = list(
    #  @field peer Field.
    peer = NULL,
    #  @field g_a Field.
    g_a = NULL,
    #  @field key_fingerprint Field.
    key_fingerprint = NULL,
    #  @field protocol Field.
    protocol = NULL,

    #  @description Initialize a ConfirmCallRequest
    # 
    #  @param peer Input phone call object.
    #  @param g_a Raw bytes.
    #  @param key_fingerprint Integer key fingerprint.
    #  @param protocol Protocol object.
    #  @return invisible self
    initialize = function(peer, g_a, key_fingerprint, protocol) {
      self$peer <- peer
      self$g_a <- g_a
      self$key_fingerprint <- as.integer(key_fingerprint)
      self$protocol <- protocol
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "ConfirmCallRequest",
        peer = if (!is.null(self$peer) && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        g_a = self$g_a,
        key_fingerprint = self$key_fingerprint,
        protocol = if (!is.null(self$protocol) && is.function(self$protocol$to_list)) self$protocol$to_list() else self$protocol
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x2efe1722
      ctor <- int_to_raw_le(0x2efe1722, 4L)

      if (!is.null(self$peer) && is.function(self$peer$bytes)) {
        peer_raw <- self$peer$bytes()
      } else {
        warning("peer does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      if (is.null(self$g_a)) {
        ga_raw <- int_to_raw_le(0L, 4L)
      } else {
        if (is.character(self$g_a)) {
          ga_bytes <- charToRaw(enc2utf8(self$g_a))
        } else if (is.raw(self$g_a)) {
          ga_bytes <- self$g_a
        } else {
          stop("g_a must be a raw vector or a single string")
        }
        ga_raw <- c(int_to_raw_le(length(ga_bytes), 4L), ga_bytes)
      }

      key_fingerprint_raw <- int_to_raw_le(as.integer(self$key_fingerprint), 8L)

      if (!is.null(self$protocol) && is.function(self$protocol$bytes)) {
        protocol_raw <- self$protocol$bytes()
      } else {
        warning("protocol does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      c(ctor, peer_raw, ga_raw, key_fingerprint_raw, protocol_raw)
    }
  )
)

#  Create ConfirmCallRequest from a reader
# 
#  Reads fields from reader and returns a new ConfirmCallRequest instance.
# 
#  @param reader An object exposing tgread_object(), tgread_bytes(), read_long() methods.
#  @return ConfirmCallRequest instance
ConfirmCallRequest$set("public", "from_reader", function(reader) {
  peer <- reader$tgread_object()
  ga <- reader$tgread_bytes()
  key_fingerprint <- reader$read_long()
  protocol <- reader$tgread_object()
  ConfirmCallRequest$new(peer = peer, g_a = ga, key_fingerprint = key_fingerprint, protocol = protocol)
})


#  CreateConferenceCallRequest R6 class
# 
#  Represents CreateConferenceCallRequest TLRequest.
# 
# 
#  @title CreateConferenceCallRequest
#  @description Telegram API type CreateConferenceCallRequest
#  @export
#  @noRd
#  @noRd
CreateConferenceCallRequest <- R6::R6Class(
  "CreateConferenceCallRequest",
  public = list(
    #  @field muted Field.
    muted = NULL,
    #  @field video_stopped Field.
    video_stopped = NULL,
    #  @field join Field.
    join = NULL,
    #  @field random_id Field.
    random_id = NULL,
    #  @field public_key Field.
    public_key = NULL,
    #  @field block Field.
    block = NULL,
    #  @field params Field.
    params = NULL,

    #  @description Initialize a CreateConferenceCallRequest
    # 
    #  @param muted Logical or NULL.
    #  @param video_stopped Logical or NULL.
    #  @param join Logical or NULL.
    #  @param random_id Integer or NULL (if NULL, a random 32-bit signed int is generated).
    #  @param public_key Integer or NULL.
    #  @param block Raw bytes or NULL.
    #  @param params DataJSON-like object or NULL.
    #  @return invisible self
    initialize = function(muted = NULL, video_stopped = NULL, join = NULL, random_id = NULL, public_key = NULL, block = NULL, params = NULL) {
      self$muted <- muted
      self$video_stopped <- video_stopped
      self$join <- join
      if (is.null(random_id)) {
        # Generate a random 32-bit signed integer
        self$random_id <- as.integer(floor(runif(1, min = -2^31, max = 2^31 - 1)))
      } else {
        self$random_id <- as.integer(random_id)
      }
      self$public_key <- public_key
      self$block <- block
      self$params <- params
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "CreateConferenceCallRequest",
        muted = self$muted,
        video_stopped = self$video_stopped,
        join = self$join,
        random_id = self$random_id,
        public_key = self$public_key,
        block = self$block,
        params = if (!is.null(self$params) && is.function(self$params$to_list)) self$params$to_list() else self$params
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation.
    #  @return raw vector (bytes)
    bytes = function() {
      # Constructor id little-endian for 0x7d0444bb
      ctor <- int_to_raw_le(0x7d0444bb, 4L)

      # Validate mutual presence
      join_present <- !is.null(self$join) && isTRUE(self$join)
      public_key_present <- !is.null(self$public_key)
      block_present <- !is.null(self$block)
      params_present <- !is.null(self$params)
      all_present <- join_present && public_key_present && block_present && params_present
      all_absent <- !join_present && !public_key_present && !block_present && !params_present
      if (!(all_present || all_absent)) {
        stop("join, public_key, block, params parameters must all be present or all absent")
      }

      flags_val <- 0L
      if (!is.null(self$muted) && isTRUE(self$muted)) flags_val <- bitwOr(flags_val, 1L)
      if (!is.null(self$video_stopped) && isTRUE(self$video_stopped)) flags_val <- bitwOr(flags_val, 4L)
      if (join_present) flags_val <- bitwOr(flags_val, 8L)
      flags_raw <- int_to_raw_le(flags_val, 4L)

      random_id_raw <- int_to_raw_le(as.integer(self$random_id), 4L)

      public_key_raw <- raw(0)
      if (public_key_present) {
        # Assume 256-bit as 32 bytes little-endian
        if (is.numeric(self$public_key)) {
          pk <- as.numeric(self$public_key)
          pk_raw <- raw(32)
          for (i in seq_len(32)) {
            pk_raw[i] <- as.raw(bitwAnd(bitwShiftR(pk, 8 * (i - 1L)), 0xffL))
          }
          public_key_raw <- pk_raw
        } else if (is.raw(self$public_key) && length(self$public_key) == 32L) {
          public_key_raw <- self$public_key
        } else {
          stop("public_key must be a 256-bit integer or raw(32)")
        }
      }

      block_raw <- raw(0)
      if (block_present) {
        if (is.character(self$block)) {
          block_bytes <- charToRaw(enc2utf8(self$block))
        } else if (is.raw(self$block)) {
          block_bytes <- self$block
        } else {
          stop("block must be a raw vector or a single string")
        }
        block_raw <- c(int_to_raw_le(length(block_bytes), 4L), block_bytes)
      }

      params_raw <- raw(0)
      if (params_present) {
        if (!is.null(self$params) && is.function(self$params$bytes)) {
          params_raw <- self$params$bytes()
        } else {
          warning("params does not implement bytes(); returning raw(0)")
          return(raw(0))
        }
      }

      c(ctor, flags_raw, random_id_raw, public_key_raw, block_raw, params_raw)
    }
  )
)

#  Create CreateConferenceCallRequest from a reader
# 
#  Reads fields from reader and returns a new CreateConferenceCallRequest instance.
# 
#  @param reader An object exposing read_int(), read_large_int(), tgread_bytes(), tgread_object() methods.
#  @return CreateConferenceCallRequest instance
CreateConferenceCallRequest$set("public", "from_reader", function(reader) {
  flags <- reader$read_int()
  muted_val <- bitwAnd(flags, 1L) != 0L
  video_stopped_val <- bitwAnd(flags, 4L) != 0L
  join_val <- bitwAnd(flags, 8L) != 0L
  random_id_val <- reader$read_int()
  public_key_val <- NULL
  block_val <- NULL
  params_val <- NULL
  if (bitwAnd(flags, 8L) != 0L) {
    public_key_val <- reader$read_large_int(bits = 256L)
    block_val <- reader$tgread_bytes()
    params_val <- reader$tgread_object()
  }
  CreateConferenceCallRequest$new(muted = muted_val, video_stopped = video_stopped_val, join = join_val, random_id = random_id_val, public_key = public_key_val, block = block_val, params = params_val)
})


#  CreateGroupCallRequest R6 class
# 
#  Represents CreateGroupCallRequest TLRequest.
# 
# 
#  @title CreateGroupCallRequest
#  @description Telegram API type CreateGroupCallRequest
#  @export
#  @noRd
#  @noRd
CreateGroupCallRequest <- R6::R6Class(
  "CreateGroupCallRequest",
  public = list(
    #  @field peer Field.
    peer = NULL,
    #  @field rtmp_stream Field.
    rtmp_stream = NULL,
    #  @field random_id Field.
    random_id = NULL,
    #  @field title Field.
    title = NULL,
    #  @field schedule_date Field.
    schedule_date = NULL,

    #  @description Initialize a CreateGroupCallRequest
    # 
    #  @param peer Input peer object.
    #  @param rtmp_stream Logical or NULL.
    #  @param random_id Integer or NULL (if NULL, a random 32-bit signed int is generated).
    #  @param title String or NULL.
    #  @param schedule_date Datetime or NULL.
    #  @return invisible self
    initialize = function(peer, rtmp_stream = NULL, random_id = NULL, title = NULL, schedule_date = NULL) {
      self$peer <- peer
      self$rtmp_stream <- rtmp_stream
      if (is.null(random_id)) {
        # Generate a random 32-bit signed integer
        self$random_id <- as.integer(floor(runif(1, min = -2^31, max = 2^31 - 1)))
      } else {
        self$random_id <- as.integer(random_id)
      }
      self$title <- title
      self$schedule_date <- schedule_date
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_peer method.
    #  @return invisible self
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(self$peer)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "CreateGroupCallRequest",
        peer = if (!is.null(self$peer) && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        rtmp_stream = self$rtmp_stream,
        random_id = self$random_id,
        title = self$title,
        schedule_date = self$schedule_date
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x48cdc6d8
      ctor <- int_to_raw_le(0x48cdc6d8, 4L)

      flags_val <- 0L
      if (!is.null(self$rtmp_stream) && isTRUE(self$rtmp_stream)) flags_val <- bitwOr(flags_val, 4L)
      if (!is.null(self$title)) flags_val <- bitwOr(flags_val, 1L)
      if (!is.null(self$schedule_date)) flags_val <- bitwOr(flags_val, 2L)
      flags_raw <- int_to_raw_le(flags_val, 4L)

      if (!is.null(self$peer) && is.function(self$peer$bytes)) {
        peer_raw <- self$peer$bytes()
      } else {
        warning("peer does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      random_id_raw <- int_to_raw_le(as.integer(self$random_id), 4L)

      title_raw <- raw(0)
      if (!is.null(self$title)) {
        if (!is.character(self$title) || length(self$title) != 1L) {
          stop("title must be a single string")
        }
        title_bytes <- charToRaw(enc2utf8(self$title))
        title_raw <- c(int_to_raw_le(length(title_bytes), 4L), title_bytes)
      }

      schedule_date_raw <- raw(0)
      if (!is.null(self$schedule_date)) {
        # Assume serialize_datetime equivalent; for simplicity, use as.integer(as.POSIXct(schedule_date))
        # But need proper TL datetime serialization; placeholder
        schedule_date_raw <- int_to_raw_le(as.integer(as.POSIXct(self$schedule_date)), 4L)
      }

      c(ctor, flags_raw, peer_raw, random_id_raw, title_raw, schedule_date_raw)
    }
  )
)

#  Create CreateGroupCallRequest from a reader
# 
#  Reads fields from reader and returns a new CreateGroupCallRequest instance.
# 
#  @param reader An object exposing read_int(), tgread_object(), tgread_string(), tgread_date() methods.
#  @return CreateGroupCallRequest instance
CreateGroupCallRequest$set("public", "from_reader", function(reader) {
  flags <- reader$read_int()
  rtmp_stream_val <- bitwAnd(flags, 4L) != 0L
  peer_obj <- reader$tgread_object()
  random_id_val <- reader$read_int()
  title_val <- NULL
  if (bitwAnd(flags, 1L) != 0L) {
    title_val <- reader$tgread_string()
  }
  schedule_date_val <- NULL
  if (bitwAnd(flags, 2L) != 0L) {
    schedule_date_val <- reader$tgread_date()
  }
  CreateGroupCallRequest$new(peer = peer_obj, rtmp_stream = rtmp_stream_val, random_id = random_id_val, title = title_val, schedule_date = schedule_date_val)
})


#  DeclineConferenceCallInviteRequest R6 class
# 
#  Represents DeclineConferenceCallInviteRequest TLRequest.
# 
# 
#  @title DeclineConferenceCallInviteRequest
#  @description Telegram API type DeclineConferenceCallInviteRequest
#  @export
#  @noRd
#  @noRd
DeclineConferenceCallInviteRequest <- R6::R6Class(
  "DeclineConferenceCallInviteRequest",
  public = list(
    #  @field msg_id Field.
    msg_id = NULL,

    #  @description Initialize a DeclineConferenceCallInviteRequest
    # 
    #  @param msg_id Integer message id.
    #  @return invisible self
    initialize = function(msg_id) {
      self$msg_id <- as.integer(msg_id)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "DeclineConferenceCallInviteRequest",
        msg_id = self$msg_id
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation.
    #  @return raw vector (bytes)
    bytes = function() {
      # Constructor id little-endian for 0x3c479971
      ctor <- int_to_raw_le(0x3c479971, 4L)
      msg_id_raw <- int_to_raw_le(as.integer(self$msg_id), 4L)
      c(ctor, msg_id_raw)
    }
  )
)

#  Create DeclineConferenceCallInviteRequest from a reader
# 
#  Reads fields from reader and returns a new DeclineConferenceCallInviteRequest instance.
# 
#  @param reader An object exposing read_int() method.
#  @return DeclineConferenceCallInviteRequest instance
DeclineConferenceCallInviteRequest$set("public", "from_reader", function(reader) {
  msg_id_val <- reader$read_int()
  DeclineConferenceCallInviteRequest$new(msg_id = msg_id_val)
})


#  DeleteConferenceCallParticipantsRequest R6 class
# 
#  Represents DeleteConferenceCallParticipantsRequest TLRequest.
# 
# 
#  @title DeleteConferenceCallParticipantsRequest
#  @description Telegram API type DeleteConferenceCallParticipantsRequest
#  @export
#  @noRd
#  @noRd
DeleteConferenceCallParticipantsRequest <- R6::R6Class(
  "DeleteConferenceCallParticipantsRequest",
  public = list(
    #  @field call Field.
    call = NULL,
    #  @field ids Field.
    ids = NULL,
    #  @field block Field.
    block = NULL,
    #  @field only_left Field.
    only_left = NULL,
    #  @field kick Field.
    kick = NULL,

    #  @description Initialize a DeleteConferenceCallParticipantsRequest
    # 
    #  @param call Input group call object.
    #  @param ids List of integers.
    #  @param block Raw bytes.
    #  @param only_left Logical or NULL.
    #  @param kick Logical or NULL.
    #  @return invisible self
    initialize = function(call, ids, block, only_left = NULL, kick = NULL) {
      self$call <- call
      self$ids <- ids
      self$block <- block
      self$only_left <- only_left
      self$kick <- kick
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call method.
    #  @return invisible self
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "DeleteConferenceCallParticipantsRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call,
        ids = if (!is.null(self$ids)) self$ids else list(),
        block = self$block,
        only_left = self$only_left,
        kick = self$kick
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x8ca60525
      ctor <- int_to_raw_le(0x8ca60525, 4L)

      flags_val <- 0L
      if (!is.null(self$only_left) && isTRUE(self$only_left)) flags_val <- bitwOr(flags_val, 1L)
      if (!is.null(self$kick) && isTRUE(self$kick)) flags_val <- bitwOr(flags_val, 2L)
      flags_raw <- int_to_raw_le(flags_val, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      ids_list <- self$ids
      if (is.null(ids_list)) ids_list <- list()
      ids_count <- length(ids_list)
      # Vector constructor id for TL: 0x1cb5c415 little-endian
      vector_ctor <- int_to_raw_le(0x1cb5c415, 4L)
      ids_count_raw <- int_to_raw_le(ids_count, 4L)
      ids_raw <- raw(0)
      if (ids_count > 0) {
        for (id_val in ids_list) {
          ids_raw <- c(ids_raw, int_to_raw_le(as.integer(id_val), 8L)) # Assuming long (64-bit)
        }
      }

      if (is.null(self$block)) {
        block_raw <- int_to_raw_le(0L, 4L)
      } else {
        if (is.character(self$block)) {
          block_bytes <- charToRaw(enc2utf8(self$block))
        } else if (is.raw(self$block)) {
          block_bytes <- self$block
        } else {
          stop("block must be a raw vector or a single string")
        }
        block_raw <- c(int_to_raw_le(length(block_bytes), 4L), block_bytes)
      }

      c(ctor, flags_raw, call_raw, vector_ctor, ids_count_raw, ids_raw, block_raw)
    }
  )
)

#  Create DeleteConferenceCallParticipantsRequest from a reader
# 
#  Reads fields from reader and returns a new DeleteConferenceCallParticipantsRequest instance.
# 
#  @param reader An object exposing read_int(), tgread_object(), tgread_bytes() methods.
#  @return DeleteConferenceCallParticipantsRequest instance
DeleteConferenceCallParticipantsRequest$set("public", "from_reader", function(reader) {
  flags <- reader$read_int()
  only_left_val <- bitwAnd(flags, 1L) != 0L
  kick_val <- bitwAnd(flags, 2L) != 0L
  call_obj <- reader$tgread_object()
  reader$read_int() # skip vector constructor id
  ids_count <- reader$read_int()
  ids_list <- vector("list", ids_count)
  for (i in seq_len(ids_count)) {
    ids_list[[i]] <- reader$read_long()
  }
  block_val <- reader$tgread_bytes()
  DeleteConferenceCallParticipantsRequest$new(call = call_obj, ids = ids_list, block = block_val, only_left = only_left_val, kick = kick_val)
})


#  DiscardCallRequest R6 class
# 
#  Represents DiscardCallRequest TLRequest.
# 
# 
#  @title DiscardCallRequest
#  @description Telegram API type DiscardCallRequest
#  @export
#  @noRd
#  @noRd
DiscardCallRequest <- R6::R6Class(
  "DiscardCallRequest",
  public = list(
    #  @field peer Field.
    peer = NULL,
    #  @field duration Field.
    duration = NULL,
    #  @field reason Field.
    reason = NULL,
    #  @field connection_id Field.
    connection_id = NULL,
    #  @field video Field.
    video = NULL,

    #  @description Initialize a DiscardCallRequest
    # 
    #  @param peer Input phone call object.
    #  @param duration Integer duration.
    #  @param reason Phone call discard reason object.
    #  @param connection_id Integer connection id.
    #  @param video Logical or NULL.
    #  @return invisible self
    initialize = function(peer, duration, reason, connection_id, video = NULL) {
      self$peer <- peer
      self$duration <- as.integer(duration)
      self$reason <- reason
      self$connection_id <- as.integer(connection_id)
      self$video <- video
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "DiscardCallRequest",
        peer = if (!is.null(self$peer) && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        duration = self$duration,
        reason = if (!is.null(self$reason) && is.function(self$reason$to_list)) self$reason$to_list() else self$reason,
        connection_id = self$connection_id,
        video = self$video
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0xb2cbc1c0
      ctor <- int_to_raw_le(0xb2cbc1c0, 4L)

      flags_val <- 0L
      if (!is.null(self$video) && isTRUE(self$video)) flags_val <- bitwOr(flags_val, 1L)
      flags_raw <- int_to_raw_le(flags_val, 4L)

      if (!is.null(self$peer) && is.function(self$peer$bytes)) {
        peer_raw <- self$peer$bytes()
      } else {
        warning("peer does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      duration_raw <- int_to_raw_le(as.integer(self$duration), 4L)

      if (!is.null(self$reason) && is.function(self$reason$bytes)) {
        reason_raw <- self$reason$bytes()
      } else {
        warning("reason does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      connection_id_raw <- int_to_raw_le(as.integer(self$connection_id), 8L)

      c(ctor, flags_raw, peer_raw, duration_raw, reason_raw, connection_id_raw)
    }
  )
)

#  Create DiscardCallRequest from a reader
# 
#  Reads fields from reader and returns a new DiscardCallRequest instance.
# 
#  @param reader An object exposing read_int(), tgread_object(), tgread_bool() methods.
#  @return DiscardCallRequest instance
DiscardCallRequest$set("public", "from_reader", function(reader) {
  flags <- reader$read_int()
  video_val <- bitwAnd(flags, 1L) != 0L
  peer_obj <- reader$tgread_object()
  duration_val <- reader$read_int()
  reason_obj <- reader$tgread_object()
  connection_id_val <- reader$read_long()
  DiscardCallRequest$new(peer = peer_obj, duration = duration_val, reason = reason_obj, connection_id = connection_id_val, video = video_val)
})


#  DiscardGroupCallRequest R6 class
# 
#  Represents DiscardGroupCallRequest TLRequest.
# 
# 
#  @title DiscardGroupCallRequest
#  @description Telegram API type DiscardGroupCallRequest
#  @export
#  @noRd
#  @noRd
DiscardGroupCallRequest <- R6::R6Class(
  "DiscardGroupCallRequest",
  public = list(
    #  @field call Field.
    call = NULL,

    #  @description Initialize a DiscardGroupCallRequest
    # 
    #  @param call Input group call object.
    #  @return invisible self
    initialize = function(call) {
      self$call <- call
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call method.
    #  @return invisible self
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "DiscardGroupCallRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x7a777135
      ctor <- int_to_raw_le(0x7a777135, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      c(ctor, call_raw)
    }
  )
)

#  Create DiscardGroupCallRequest from a reader
# 
#  Reads fields from reader and returns a new DiscardGroupCallRequest instance.
# 
#  @param reader An object exposing tgread_object() method.
#  @return DiscardGroupCallRequest instance
DiscardGroupCallRequest$set("public", "from_reader", function(reader) {
  call_obj <- reader$tgread_object()
  DiscardGroupCallRequest$new(call = call_obj)
})


#  EditGroupCallParticipantRequest R6 class
# 
#  Represents EditGroupCallParticipantRequest TLRequest.
# 
# 
#  @title EditGroupCallParticipantRequest
#  @description Telegram API type EditGroupCallParticipantRequest
#  @export
#  @noRd
#  @noRd
EditGroupCallParticipantRequest <- R6::R6Class(
  "EditGroupCallParticipantRequest",
  public = list(
    #  @field call Field.
    call = NULL,
    #  @field participant Field.
    participant = NULL,
    #  @field muted Field.
    muted = NULL,
    #  @field volume Field.
    volume = NULL,
    #  @field raise_hand Field.
    raise_hand = NULL,
    #  @field video_stopped Field.
    video_stopped = NULL,
    #  @field video_paused Field.
    video_paused = NULL,
    #  @field presentation_paused Field.
    presentation_paused = NULL,

    #  @description Initialize an EditGroupCallParticipantRequest
    # 
    #  @param call Input group call object.
    #  @param participant Input peer object.
    #  @param muted Logical or NULL.
    #  @param volume Integer or NULL.
    #  @param raise_hand Logical or NULL.
    #  @param video_stopped Logical or NULL.
    #  @param video_paused Logical or NULL.
    #  @param presentation_paused Logical or NULL.
    #  @return invisible self
    initialize = function(call, participant, muted = NULL, volume = NULL, raise_hand = NULL, video_stopped = NULL, video_paused = NULL, presentation_paused = NULL) {
      self$call <- call
      self$participant <- participant
      self$muted <- muted
      self$volume <- volume
      self$raise_hand <- raise_hand
      self$video_stopped <- video_stopped
      self$video_paused <- video_paused
      self$presentation_paused <- presentation_paused
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call and get_input_peer methods.
    #  @return invisible self
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      self$participant <- utils$get_input_peer(self$participant)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "EditGroupCallParticipantRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call,
        participant = if (!is.null(self$participant) && is.function(self$participant$to_list)) self$participant$to_list() else self$participant,
        muted = self$muted,
        volume = self$volume,
        raise_hand = self$raise_hand,
        video_stopped = self$video_stopped,
        video_paused = self$video_paused,
        presentation_paused = self$presentation_paused
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0xa5273abf
      ctor <- int_to_raw_le(0xa5273abf, 4L)

      flags_val <- 0L
      if (!is.null(self$muted)) flags_val <- bitwOr(flags_val, 1L)
      if (!is.null(self$volume)) flags_val <- bitwOr(flags_val, 2L)
      if (!is.null(self$raise_hand)) flags_val <- bitwOr(flags_val, 4L)
      if (!is.null(self$video_stopped)) flags_val <- bitwOr(flags_val, 8L)
      if (!is.null(self$video_paused)) flags_val <- bitwOr(flags_val, 16L)
      if (!is.null(self$presentation_paused)) flags_val <- bitwOr(flags_val, 32L)
      flags_raw <- int_to_raw_le(flags_val, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      if (!is.null(self$participant) && is.function(self$participant$bytes)) {
        participant_raw <- self$participant$bytes()
      } else {
        warning("participant does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      muted_raw <- raw(0)
      if (!is.null(self$muted)) {
        muted_raw <- if (isTRUE(self$muted)) bool_true_token else bool_false_token
      }

      volume_raw <- raw(0)
      if (!is.null(self$volume)) {
        volume_raw <- int_to_raw_le(as.integer(self$volume), 4L)
      }

      raise_hand_raw <- raw(0)
      if (!is.null(self$raise_hand)) {
        raise_hand_raw <- if (isTRUE(self$raise_hand)) bool_true_token else bool_false_token
      }

      video_stopped_raw <- raw(0)
      if (!is.null(self$video_stopped)) {
        video_stopped_raw <- if (isTRUE(self$video_stopped)) bool_true_token else bool_false_token
      }

      video_paused_raw <- raw(0)
      if (!is.null(self$video_paused)) {
        video_paused_raw <- if (isTRUE(self$video_paused)) bool_true_token else bool_false_token
      }

      presentation_paused_raw <- raw(0)
      if (!is.null(self$presentation_paused)) {
        presentation_paused_raw <- if (isTRUE(self$presentation_paused)) bool_true_token else bool_false_token
      }

      c(ctor, flags_raw, call_raw, participant_raw, muted_raw, volume_raw, raise_hand_raw, video_stopped_raw, video_paused_raw, presentation_paused_raw)
    }
  )
)

#  Create EditGroupCallParticipantRequest from a reader
# 
#  Reads fields from reader and returns a new EditGroupCallParticipantRequest instance.
# 
#  @param reader An object exposing read_int(), tgread_object(), tgread_bool() methods.
#  @return EditGroupCallParticipantRequest instance
EditGroupCallParticipantRequest$set("public", "from_reader", function(reader) {
  flags <- reader$read_int()
  call_obj <- reader$tgread_object()
  participant_obj <- reader$tgread_object()
  muted_val <- if (bitwAnd(flags, 1L) != 0L) reader$tgread_bool() else NULL
  volume_val <- if (bitwAnd(flags, 2L) != 0L) reader$read_int() else NULL
  raise_hand_val <- if (bitwAnd(flags, 4L) != 0L) reader$tgread_bool() else NULL
  video_stopped_val <- if (bitwAnd(flags, 8L) != 0L) reader$tgread_bool() else NULL
  video_paused_val <- if (bitwAnd(flags, 16L) != 0L) reader$tgread_bool() else NULL
  presentation_paused_val <- if (bitwAnd(flags, 32L) != 0L) reader$tgread_bool() else NULL
  EditGroupCallParticipantRequest$new(call = call_obj, participant = participant_obj, muted = muted_val, volume = volume_val, raise_hand = raise_hand_val, video_stopped = video_stopped_val, video_paused = video_paused_val, presentation_paused = presentation_paused_val)
})


#  EditGroupCallTitleRequest R6 class
# 
#  Represents EditGroupCallTitleRequest TLRequest.
# 
# 
#  @title EditGroupCallTitleRequest
#  @description Telegram API type EditGroupCallTitleRequest
#  @export
#  @noRd
#  @noRd
EditGroupCallTitleRequest <- R6::R6Class(
  "EditGroupCallTitleRequest",
  public = list(
    #  @field call Field.
    call = NULL,
    #  @field title Field.
    title = NULL,

    #  @description Initialize an EditGroupCallTitleRequest
    # 
    #  @param call Input group call object.
    #  @param title String title.
    #  @return invisible self
    initialize = function(call, title) {
      self$call <- call
      self$title <- title
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call method.
    #  @return invisible self
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "EditGroupCallTitleRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call,
        title = self$title
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x1ca6ac0a
      ctor <- int_to_raw_le(0x1ca6ac0a, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      if (!is.character(self$title) || length(self$title) != 1L) {
        stop("title must be a single string")
      }
      title_bytes <- charToRaw(enc2utf8(self$title))
      title_raw <- c(int_to_raw_le(length(title_bytes), 4L), title_bytes)

      c(ctor, call_raw, title_raw)
    }
  )
)

#  Create EditGroupCallTitleRequest from a reader
# 
#  Reads fields from reader and returns a new EditGroupCallTitleRequest instance.
# 
#  @param reader An object exposing tgread_object() and tgread_string() methods.
#  @return EditGroupCallTitleRequest instance
EditGroupCallTitleRequest$set("public", "from_reader", function(reader) {
  call_obj <- reader$tgread_object()
  title_val <- reader$tgread_string()
  EditGroupCallTitleRequest$new(call = call_obj, title = title_val)
})


#  ExportGroupCallInviteRequest R6 class
# 
#  Represents ExportGroupCallInviteRequest TLRequest.
# 
# 
#  @title ExportGroupCallInviteRequest
#  @description Telegram API type ExportGroupCallInviteRequest
#  @export
#  @noRd
#  @noRd
ExportGroupCallInviteRequest <- R6::R6Class(
  "ExportGroupCallInviteRequest",
  public = list(
    #  @field call Field.
    call = NULL,
    #  @field can_self_unmute Field.
    can_self_unmute = NULL,

    #  @description Initialize an ExportGroupCallInviteRequest
    # 
    #  @param call Input group call object.
    #  @param can_self_unmute Logical or NULL.
    #  @return invisible self
    initialize = function(call, can_self_unmute = NULL) {
      self$call <- call
      self$can_self_unmute <- can_self_unmute
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call method.
    #  @return invisible self
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "ExportGroupCallInviteRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call,
        can_self_unmute = self$can_self_unmute
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0xe6aa647f
      ctor <- int_to_raw_le(0xe6aa647f, 4L)

      flags_val <- 0L
      if (!is.null(self$can_self_unmute) && isTRUE(self$can_self_unmute)) flags_val <- bitwOr(flags_val, 1L)
      flags_raw <- int_to_raw_le(flags_val, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      c(ctor, flags_raw, call_raw)
    }
  )
)

#  Create ExportGroupCallInviteRequest from a reader
# 
#  Reads fields from reader and returns a new ExportGroupCallInviteRequest instance.
# 
#  @param reader An object exposing read_int() and tgread_object() methods.
#  @return ExportGroupCallInviteRequest instance
ExportGroupCallInviteRequest$set("public", "from_reader", function(reader) {
  flags <- reader$read_int()
  can_self_unmute_val <- bitwAnd(flags, 1L) != 0L
  call_obj <- reader$tgread_object()
  ExportGroupCallInviteRequest$new(call = call_obj, can_self_unmute = can_self_unmute_val)
})


#  @title GetCallConfigRequest R6 class
#  @description Represents GetCallConfigRequest TLRequest.
#  @export
#  @noRd
#  @noRd
GetCallConfigRequest <- R6::R6Class(
  "GetCallConfigRequest",
  public = list(
    #  @description Convert object to a list
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "GetCallConfigRequest"
      )
    },

    #  @description Produce raw bytes for the request
    #  Builds the TL-serialized byte representation.
    #  @return raw vector (bytes)
    bytes = function() {
      # Constructor id little-endian for 0x55451fa9
      int_to_raw_le(0x55451fa9, 4L)
    }
  )
)

#  Create GetCallConfigRequest from a reader
# 
#  Reads fields from reader and returns a new GetCallConfigRequest instance.
# 
#  @param reader An object (not used here).
#  @return GetCallConfigRequest instance
GetCallConfigRequest$set("public", "from_reader", function(reader) {
  GetCallConfigRequest$new()
})


#  GetGroupCallRequest R6 class
# 
#  Represents GetGroupCallRequest TLRequest.
# 
# 
#  @title GetGroupCallRequest
#  @description Telegram API type GetGroupCallRequest
#  @export
#  @noRd
#  @noRd
GetGroupCallRequest <- R6::R6Class(
  "GetGroupCallRequest",
  public = list(
    #  @field call Field.
    call = NULL,
    #  @field limit Field.
    limit = NULL,

    #  @description Initialize a GetGroupCallRequest
    # 
    #  @param call Input group call object.
    #  @param limit Integer limit.
    #  @return invisible self
    initialize = function(call, limit) {
      self$call <- call
      self$limit <- as.integer(limit)
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call method.
    #  @return invisible self
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "GetGroupCallRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call,
        limit = self$limit
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x041845db
      ctor <- int_to_raw_le(0x041845db, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      limit_raw <- int_to_raw_le(as.integer(self$limit), 4L)

      c(ctor, call_raw, limit_raw)
    }
  )
)

#  Create GetGroupCallRequest from a reader
# 
#  Reads fields from reader and returns a new GetGroupCallRequest instance.
# 
#  @param reader An object exposing tgread_object() and read_int() methods.
#  @return GetGroupCallRequest instance
GetGroupCallRequest$set("public", "from_reader", function(reader) {
  call_obj <- reader$tgread_object()
  limit_val <- reader$read_int()
  GetGroupCallRequest$new(call = call_obj, limit = limit_val)
})


#  GetGroupCallChainBlocksRequest R6 class
# 
#  Represents GetGroupCallChainBlocksRequest TLRequest.
# 
# 
#  @title GetGroupCallChainBlocksRequest
#  @description Telegram API type GetGroupCallChainBlocksRequest
#  @export
#  @noRd
#  @noRd
GetGroupCallChainBlocksRequest <- R6::R6Class(
  "GetGroupCallChainBlocksRequest",
  public = list(
    #  @field call Field.
    call = NULL,
    #  @field sub_chain_id Field.
    sub_chain_id = NULL,
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,

    #  @description Initialize a GetGroupCallChainBlocksRequest
    # 
    #  @param call Input group call object.
    #  @param sub_chain_id Integer sub chain id.
    #  @param offset Integer offset.
    #  @param limit Integer limit.
    #  @return invisible self
    initialize = function(call, sub_chain_id, offset, limit) {
      self$call <- call
      self$sub_chain_id <- as.integer(sub_chain_id)
      self$offset <- as.integer(offset)
      self$limit <- as.integer(limit)
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call method.
    #  @return invisible self
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "GetGroupCallChainBlocksRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call,
        sub_chain_id = self$sub_chain_id,
        offset = self$offset,
        limit = self$limit
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0xee9f88a6
      ctor <- int_to_raw_le(0xee9f88a6, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      sub_chain_id_raw <- int_to_raw_le(as.integer(self$sub_chain_id), 4L)
      offset_raw <- int_to_raw_le(as.integer(self$offset), 4L)
      limit_raw <- int_to_raw_le(as.integer(self$limit), 4L)

      c(ctor, call_raw, sub_chain_id_raw, offset_raw, limit_raw)
    }
  )
)

#  Create GetGroupCallChainBlocksRequest from a reader
# 
#  Reads fields from reader and returns a new GetGroupCallChainBlocksRequest instance.
# 
#  @param reader An object exposing tgread_object() and read_int() methods.
#  @return GetGroupCallChainBlocksRequest instance
GetGroupCallChainBlocksRequest$set("public", "from_reader", function(reader) {
  call_obj <- reader$tgread_object()
  sub_chain_id_val <- reader$read_int()
  offset_val <- reader$read_int()
  limit_val <- reader$read_int()
  GetGroupCallChainBlocksRequest$new(call = call_obj, sub_chain_id = sub_chain_id_val, offset = offset_val, limit = limit_val)
})


#  GetGroupCallJoinAsRequest R6 class
# 
#  Represents GetGroupCallJoinAsRequest TLRequest.
# 
# 
#  @title GetGroupCallJoinAsRequest
#  @description Telegram API type GetGroupCallJoinAsRequest
#  @export
#  @noRd
#  @noRd
GetGroupCallJoinAsRequest <- R6::R6Class(
  "GetGroupCallJoinAsRequest",
  public = list(
    #  @field peer Field.
    peer = NULL,

    #  @description Initialize a GetGroupCallJoinAsRequest
    # 
    #  @param peer Input peer object.
    #  @return invisible self
    initialize = function(peer) {
      self$peer <- peer
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_peer method.
    #  @return invisible self
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(self$peer)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "GetGroupCallJoinAsRequest",
        peer = if (!is.null(self$peer) && is.function(self$peer$to_list)) self$peer$to_list() else self$peer
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0xef7c213a
      ctor <- int_to_raw_le(0xef7c213a, 4L)

      if (!is.null(self$peer) && is.function(self$peer$bytes)) {
        peer_raw <- self$peer$bytes()
      } else {
        warning("peer does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      c(ctor, peer_raw)
    }
  )
)

#  Create GetGroupCallJoinAsRequest from a reader
# 
#  Reads fields from reader and returns a new GetGroupCallJoinAsRequest instance.
# 
#  @param reader An object exposing tgread_object() method.
#  @return GetGroupCallJoinAsRequest instance
GetGroupCallJoinAsRequest$set("public", "from_reader", function(reader) {
  peer_obj <- reader$tgread_object()
  GetGroupCallJoinAsRequest$new(peer = peer_obj)
})


#  GetGroupCallStreamChannelsRequest R6 class
# 
#  Represents GetGroupCallStreamChannelsRequest TLRequest.
# 
# 
#  @title GetGroupCallStreamChannelsRequest
#  @description Telegram API type GetGroupCallStreamChannelsRequest
#  @export
#  @noRd
#  @noRd
GetGroupCallStreamChannelsRequest <- R6::R6Class(
  "GetGroupCallStreamChannelsRequest",
  public = list(
    #  @field call Field.
    call = NULL,

    #  @description Initialize a GetGroupCallStreamChannelsRequest
    # 
    #  @param call Input group call object.
    #  @return invisible self
    initialize = function(call) {
      self$call <- call
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call method.
    #  @return invisible self
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "GetGroupCallStreamChannelsRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x1ab21940
      ctor <- int_to_raw_le(0x1ab21940, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      c(ctor, call_raw)
    }
  )
)

#  Create GetGroupCallStreamChannelsRequest from a reader
# 
#  Reads fields from reader and returns a new GetGroupCallStreamChannelsRequest instance.
# 
#  @param reader An object exposing tgread_object() method.
#  @return GetGroupCallStreamChannelsRequest instance
GetGroupCallStreamChannelsRequest$set("public", "from_reader", function(reader) {
  call_obj <- reader$tgread_object()
  GetGroupCallStreamChannelsRequest$new(call = call_obj)
})


#  GetGroupCallStreamRtmpUrlRequest R6 class
# 
#  Represents GetGroupCallStreamRtmpUrlRequest TLRequest.
# 
# 
#  @title GetGroupCallStreamRtmpUrlRequest
#  @description Telegram API type GetGroupCallStreamRtmpUrlRequest
#  @export
#  @noRd
#  @noRd
GetGroupCallStreamRtmpUrlRequest <- R6::R6Class(
  "GetGroupCallStreamRtmpUrlRequest",
  public = list(
    #  @field peer Field.
    peer = NULL,
    #  @field revoke Field.
    revoke = NULL,

    #  @description Initialize a GetGroupCallStreamRtmpUrlRequest
    # 
    #  @param peer Input peer object.
    #  @param revoke Logical.
    #  @return invisible self
    initialize = function(peer, revoke) {
      self$peer <- peer
      self$revoke <- revoke
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_peer method.
    #  @return invisible self
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(self$peer)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "GetGroupCallStreamRtmpUrlRequest",
        peer = if (!is.null(self$peer) && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        revoke = self$revoke
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0xdeb3abbf
      ctor <- int_to_raw_le(0xdeb3abbf, 4L)

      if (!is.null(self$peer) && is.function(self$peer$bytes)) {
        peer_raw <- self$peer$bytes()
      } else {
        warning("peer does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      revoke_token <- if (isTRUE(self$revoke)) bool_true_token else bool_false_token

      c(ctor, peer_raw, revoke_token)
    }
  )
)

#  Create GetGroupCallStreamRtmpUrlRequest from a reader
# 
#  Reads fields from reader and returns a new GetGroupCallStreamRtmpUrlRequest instance.
# 
#  @param reader An object exposing tgread_object() and tgread_bool() methods.
#  @return GetGroupCallStreamRtmpUrlRequest instance
GetGroupCallStreamRtmpUrlRequest$set("public", "from_reader", function(reader) {
  peer_obj <- reader$tgread_object()
  revoke_val <- reader$tgread_bool()
  GetGroupCallStreamRtmpUrlRequest$new(peer = peer_obj, revoke = revoke_val)
})


#  GetGroupParticipantsRequest R6 class
# 
#  Represents GetGroupParticipantsRequest TLRequest.
# 
# 
#  @title GetGroupParticipantsRequest
#  @description Telegram API type GetGroupParticipantsRequest
#  @export
#  @noRd
#  @noRd
GetGroupParticipantsRequest <- R6::R6Class(
  "GetGroupParticipantsRequest",
  public = list(
    #  @field call Field.
    call = NULL,
    #  @field ids Field.
    ids = NULL,
    #  @field sources Field.
    sources = NULL,
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,

    #  @description Initialize a GetGroupParticipantsRequest
    # 
    #  @param call Input group call object.
    #  @param ids List of input peer objects.
    #  @param sources List of integers.
    #  @param offset String.
    #  @param limit Integer.
    #  @return invisible self
    initialize = function(call, ids, sources, offset, limit) {
      self$call <- call
      self$ids <- ids
      self$sources <- sources
      self$offset <- offset
      self$limit <- limit
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call and get_input_peer methods.
    #  @return invisible self
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      tmp <- list()
      if (!is.null(self$ids) && length(self$ids) > 0) {
        for (x in self$ids) {
          tmp[[length(tmp) + 1L]] <- utils$get_input_peer(x)
        }
      }
      self$ids <- tmp
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "GetGroupParticipantsRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call,
        ids = if (!is.null(self$ids)) lapply(self$ids, function(x) if (is.function(x$to_list)) x$to_list() else x) else list(),
        sources = if (!is.null(self$sources)) self$sources else list(),
        offset = self$offset,
        limit = self$limit
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0xc558d8ab
      ctor <- int_to_raw_le(0xc558d8ab, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      ids_list <- self$ids
      if (is.null(ids_list)) ids_list <- list()
      ids_count <- length(ids_list)
      # Vector constructor id for TL: 0x1cb5c415 little-endian
      vector_ctor <- int_to_raw_le(0x1cb5c415, 4L)
      ids_count_raw <- int_to_raw_le(ids_count, 4L)
      ids_raw <- raw(0)
      if (ids_count > 0) {
        for (u in ids_list) {
          if (!is.null(u) && is.function(u$bytes)) {
            ids_raw <- c(ids_raw, u$bytes())
          } else {
            warning("peer in ids does not implement bytes(); returning raw(0)")
            return(raw(0))
          }
        }
      }

      sources_list <- self$sources
      if (is.null(sources_list)) sources_list <- list()
      sources_count <- length(sources_list)
      sources_count_raw <- int_to_raw_le(sources_count, 4L)
      sources_raw <- raw(0)
      if (sources_count > 0) {
        for (s in sources_list) {
          sources_raw <- c(sources_raw, int_to_raw_le(as.integer(s), 4L))
        }
      }

      if (!is.character(self$offset) || length(self$offset) != 1L) {
        stop("offset must be a single string")
      }
      offset_bytes <- charToRaw(enc2utf8(self$offset))
      offset_raw <- c(int_to_raw_le(length(offset_bytes), 4L), offset_bytes)

      limit_raw <- int_to_raw_le(as.integer(self$limit), 4L)

      c(ctor, call_raw, vector_ctor, ids_count_raw, ids_raw, vector_ctor, sources_count_raw, sources_raw, offset_raw, limit_raw)
    }
  )
)

#  Create GetGroupParticipantsRequest from a reader
# 
#  Reads fields from reader and returns a new GetGroupParticipantsRequest instance.
# 
#  @param reader An object exposing tgread_object(), read_int(), tgread_string() methods.
#  @return GetGroupParticipantsRequest instance
GetGroupParticipantsRequest$set("public", "from_reader", function(reader) {
  call_obj <- reader$tgread_object()
  reader$read_int() # skip vector constructor id
  ids_count <- reader$read_int()
  ids_list <- vector("list", ids_count)
  for (i in seq_len(ids_count)) {
    ids_list[[i]] <- reader$tgread_object()
  }
  reader$read_int() # skip vector constructor id
  sources_count <- reader$read_int()
  sources_list <- vector("list", sources_count)
  for (i in seq_len(sources_count)) {
    sources_list[[i]] <- reader$read_int()
  }
  offset_val <- reader$tgread_string()
  limit_val <- reader$read_int()
  GetGroupParticipantsRequest$new(call = call_obj, ids = ids_list, sources = sources_list, offset = offset_val, limit = limit_val)
})


#  InviteConferenceCallParticipantRequest R6 class
# 
#  Represents InviteConferenceCallParticipantRequest TLRequest.
# 
# 
#  @title InviteConferenceCallParticipantRequest
#  @description Telegram API type InviteConferenceCallParticipantRequest
#  @export
#  @noRd
#  @noRd
InviteConferenceCallParticipantRequest <- R6::R6Class(
  "InviteConferenceCallParticipantRequest",
  public = list(
    #  @field call Field.
    call = NULL,
    #  @field user_id Field.
    user_id = NULL,
    #  @field video Field.
    video = NULL,

    #  @description Initialize an InviteConferenceCallParticipantRequest
    # 
    #  @param call Input group call object.
    #  @param user_id Input user object.
    #  @param video Logical or NULL.
    #  @return invisible self
    initialize = function(call, user_id, video = NULL) {
      self$call <- call
      self$user_id <- user_id
      self$video <- video
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call and get_input_user methods.
    #  @return invisible self
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      self$user_id <- utils$get_input_user(self$user_id)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "InviteConferenceCallParticipantRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call,
        user_id = if (!is.null(self$user_id) && is.function(self$user_id$to_list)) self$user_id$to_list() else self$user_id,
        video = self$video
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0xbcf22685
      ctor <- int_to_raw_le(0xbcf22685, 4L)

      flags_val <- 0L
      if (!is.null(self$video) && isTRUE(self$video)) flags_val <- bitwOr(flags_val, 1L)
      flags_raw <- int_to_raw_le(flags_val, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      if (!is.null(self$user_id) && is.function(self$user_id$bytes)) {
        user_raw <- self$user_id$bytes()
      } else {
        warning("user_id does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      c(ctor, flags_raw, call_raw, user_raw)
    }
  )
)

#  Create InviteConferenceCallParticipantRequest from a reader
# 
#  Reads fields from reader and returns a new InviteConferenceCallParticipantRequest instance.
# 
#  @param reader An object exposing read_int(), tgread_object() methods.
#  @return InviteConferenceCallParticipantRequest instance
InviteConferenceCallParticipantRequest$set("public", "from_reader", function(reader) {
  flags_val <- reader$read_int()
  video_val <- bitwAnd(flags_val, 1L) != 0L
  call_obj <- reader$tgread_object()
  user_id_obj <- reader$tgread_object()
  InviteConferenceCallParticipantRequest$new(call = call_obj, user_id = user_id_obj, video = video_val)
})


#  InviteToGroupCallRequest R6 class
# 
#  Represents InviteToGroupCallRequest TLRequest.
# 
# 
#  @title InviteToGroupCallRequest
#  @description Telegram API type InviteToGroupCallRequest
#  @export
#  @noRd
#  @noRd
InviteToGroupCallRequest <- R6::R6Class(
  "InviteToGroupCallRequest",
  public = list(
    #  @field call Field.
    call = NULL,
    #  @field users Field.
    users = NULL,

    #  @description Initialize an InviteToGroupCallRequest
    # 
    #  @param call Input group call object.
    #  @param users List of input user objects.
    #  @return invisible self
    initialize = function(call, users) {
      self$call <- call
      self$users <- users
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call and get_input_user methods.
    #  @return invisible self
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      tmp <- list()
      if (!is.null(self$users) && length(self$users) > 0) {
        for (x in self$users) {
          tmp[[length(tmp) + 1L]] <- utils$get_input_user(x)
        }
      }
      self$users <- tmp
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "InviteToGroupCallRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call,
        users = if (!is.null(self$users)) lapply(self$users, function(x) if (is.function(x$to_list)) x$to_list() else x) else list()
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x7b393160
      ctor <- int_to_raw_le(0x7b393160, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      users_list <- self$users
      if (is.null(users_list)) users_list <- list()
      users_count <- length(users_list)
      # Vector constructor id for TL: 0x1cb5c415 little-endian
      vector_ctor <- int_to_raw_le(0x1cb5c415, 4L)
      users_count_raw <- int_to_raw_le(users_count, 4L)
      users_raw <- raw(0)
      if (users_count > 0) {
        for (u in users_list) {
          if (!is.null(u) && is.function(u$bytes)) {
            users_raw <- c(users_raw, u$bytes())
          } else {
            warning("user in users does not implement bytes(); returning raw(0)")
            return(raw(0))
          }
        }
      }

      c(ctor, call_raw, vector_ctor, users_count_raw, users_raw)
    }
  )
)

#  Create InviteToGroupCallRequest from a reader
# 
#  Reads fields from reader and returns a new InviteToGroupCallRequest instance.
# 
#  @param reader An object exposing tgread_object(), read_int() methods.
#  @return InviteToGroupCallRequest instance
InviteToGroupCallRequest$set("public", "from_reader", function(reader) {
  call_obj <- reader$tgread_object()
  reader$read_int() # skip vector constructor id
  users_count <- reader$read_int()
  users_list <- vector("list", users_count)
  for (i in seq_len(users_count)) {
    users_list[[i]] <- reader$tgread_object()
  }
  InviteToGroupCallRequest$new(call = call_obj, users = users_list)
})


#  JoinGroupCallRequest R6 class
# 
#  Represents JoinGroupCallRequest TLRequest.
# 
# 
#  @title JoinGroupCallRequest
#  @description Telegram API type JoinGroupCallRequest
#  @export
#  @noRd
#  @noRd
JoinGroupCallRequest <- R6::R6Class(
  "JoinGroupCallRequest",
  public = list(
    #  @field call Field.
    call = NULL,
    #  @field join_as Field.
    join_as = NULL,
    #  @field params Field.
    params = NULL,
    #  @field muted Field.
    muted = NULL,
    #  @field video_stopped Field.
    video_stopped = NULL,
    #  @field invite_hash Field.
    invite_hash = NULL,
    #  @field public_key Field.
    public_key = NULL,
    #  @field block Field.
    block = NULL,

    #  @description Initialize a JoinGroupCallRequest
    # 
    #  @param call Input group call object.
    #  @param join_as Input peer object to join as.
    #  @param params DataJSON-like object.
    #  @param muted Logical or NULL.
    #  @param video_stopped Logical or NULL.
    #  @param invite_hash Optional string or NULL.
    #  @param public_key Optional integer (256-bit) or NULL.
    #  @param block Optional raw vector or NULL.
    #  @return invisible self
    initialize = function(call, join_as, params, muted = NULL, video_stopped = NULL, invite_hash = NULL, public_key = NULL, block = NULL) {
      self$call <- call
      self$join_as <- join_as
      self$params <- params
      self$muted <- muted
      self$video_stopped <- video_stopped
      self$invite_hash <- invite_hash
      self$public_key <- public_key
      self$block <- block
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call and get_input_peer methods.
    #  @return invisible self
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      self$join_as <- utils$get_input_peer(self$join_as)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "JoinGroupCallRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call,
        join_as = if (!is.null(self$join_as) && is.function(self$join_as$to_list)) self$join_as$to_list() else self$join_as,
        params = if (!is.null(self$params) && is.function(self$params$to_list)) self$params$to_list() else self$params,
        muted = self$muted,
        video_stopped = self$video_stopped,
        invite_hash = self$invite_hash,
        public_key = self$public_key,
        block = self$block
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x8fb53057
      ctor <- int_to_raw_le(0x8fb53057, 4L)

      # flags: 1=muted, 2=invite_hash, 4=video_stopped, 8=public_key+block
      flags_val <- 0L
      if (!is.null(self$muted) && isTRUE(self$muted)) flags_val <- bitwOr(flags_val, 1L)
      if (!is.null(self$invite_hash)) flags_val <- bitwOr(flags_val, 2L)
      if (!is.null(self$video_stopped) && isTRUE(self$video_stopped)) flags_val <- bitwOr(flags_val, 4L)
      public_key_present <- !is.null(self$public_key)
      block_present <- !is.null(self$block)
      if ((public_key_present && block_present) || (!public_key_present && !block_present)) {
        if (public_key_present) flags_val <- bitwOr(flags_val, 8L)
      } else {
        stop("public_key and block parameters must both be present or both be absent")
      }
      flags_raw <- int_to_raw_le(flags_val, 4L)

      # call bytes
      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      # join_as bytes
      if (!is.null(self$join_as) && is.function(self$join_as$bytes)) {
        join_as_raw <- self$join_as$bytes()
      } else {
        warning("join_as does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      # invite_hash bytes
      invite_hash_raw <- raw(0)
      if (!is.null(self$invite_hash)) {
        if (!is.character(self$invite_hash) || length(self$invite_hash) != 1L) {
          stop("invite_hash must be a single string")
        }
        hash_bytes <- charToRaw(enc2utf8(self$invite_hash))
        invite_hash_raw <- c(int_to_raw_le(length(hash_bytes), 4L), hash_bytes)
      }

      # public_key bytes (256-bit, 32 bytes, little-endian)
      public_key_raw <- raw(0)
      if (public_key_present) {
        # Accept numeric or raw(32)
        if (is.numeric(self$public_key)) {
          # Convert to 32-byte little-endian
          pk <- as.numeric(self$public_key)
          # Use 32 bytes, little-endian
          pk_raw <- raw(32)
          for (i in seq_len(32)) {
            pk_raw[i] <- as.raw(bitwAnd(bitwShiftR(pk, 8 * (i - 1L)), 0xffL))
          }
          public_key_raw <- pk_raw
        } else if (is.raw(self$public_key) && length(self$public_key) == 32L) {
          public_key_raw <- self$public_key
        } else {
          stop("public_key must be a 256-bit integer or raw(32)")
        }
      }

      # block bytes
      block_raw <- raw(0)
      if (block_present) {
        if (is.character(self$block)) {
          block_bytes <- charToRaw(enc2utf8(self$block))
        } else if (is.raw(self$block)) {
          block_bytes <- self$block
        } else {
          stop("block must be a raw vector or a single string")
        }
        block_raw <- c(int_to_raw_le(length(block_bytes), 4L), block_bytes)
      }

      # params bytes
      if (!is.null(self$params) && is.function(self$params$bytes)) {
        params_raw <- self$params$bytes()
      } else {
        warning("params does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      c(ctor, flags_raw, call_raw, join_as_raw, invite_hash_raw, public_key_raw, block_raw, params_raw)
    }
  )
)

#  Create JoinGroupCallRequest from a reader
# 
#  Reads fields from reader and returns a new JoinGroupCallRequest instance.
# 
#  @param reader An object exposing read_int(), tgread_object(), tgread_string(), read_large_int(), tgread_bytes() methods.
#  @return JoinGroupCallRequest instance
JoinGroupCallRequest$set("public", "from_reader", function(reader) {
  flags_val <- reader$read_int()
  muted_val <- bitwAnd(flags_val, 1L) != 0L
  video_stopped_val <- bitwAnd(flags_val, 4L) != 0L
  call_obj <- reader$tgread_object()
  join_as_obj <- reader$tgread_object()
  invite_hash_val <- NULL
  if (bitwAnd(flags_val, 2L) != 0L) {
    invite_hash_val <- reader$tgread_string()
  }
  public_key_val <- NULL
  block_val <- NULL
  if (bitwAnd(flags_val, 8L) != 0L) {
    public_key_val <- reader$read_large_int(bits = 256L)
    block_val <- reader$tgread_bytes()
  }
  params_obj <- reader$tgread_object()
  JoinGroupCallRequest$new(
    call = call_obj,
    join_as = join_as_obj,
    params = params_obj,
    muted = muted_val,
    video_stopped = video_stopped_val,
    invite_hash = invite_hash_val,
    public_key = public_key_val,
    block = block_val
  )
})


#  JoinGroupCallPresentationRequest R6 class
# 
#  Represents JoinGroupCallPresentationRequest TLRequest.
# 
# 
#  @title JoinGroupCallPresentationRequest
#  @description Telegram API type JoinGroupCallPresentationRequest
#  @export
#  @noRd
#  @noRd
JoinGroupCallPresentationRequest <- R6::R6Class(
  "JoinGroupCallPresentationRequest",
  public = list(
    #  @field call Field.
    call = NULL,
    #  @field params Field.
    params = NULL,

    #  @description Initialize a JoinGroupCallPresentationRequest
    # 
    #  @param call Input group call object.
    #  @param params DataJSON-like object.
    #  @return invisible self
    initialize = function(call, params) {
      self$call <- call
      self$params <- params
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call method.
    #  @return invisible self
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "JoinGroupCallPresentationRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call,
        params = if (!is.null(self$params) && is.function(self$params$to_list)) self$params$to_list() else self$params
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes dependent objects provide bytes().
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0xcbea6bc4
      ctor <- int_to_raw_le(0xcbea6bc4, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      if (!is.null(self$params) && is.function(self$params$bytes)) {
        params_raw <- self$params$bytes()
      } else {
        warning("params does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      c(ctor, call_raw, params_raw)
    }
  )
)

#  Create JoinGroupCallPresentationRequest from a reader
# 
#  Reads fields from reader and returns a new JoinGroupCallPresentationRequest instance.
# 
#  @param reader An object exposing tgread_object() method.
#  @return JoinGroupCallPresentationRequest instance
JoinGroupCallPresentationRequest$set("public", "from_reader", function(reader) {
  call_obj <- reader$tgread_object()
  params_obj <- reader$tgread_object()
  JoinGroupCallPresentationRequest$new(call = call_obj, params = params_obj)
})


#  LeaveGroupCallRequest R6 class
# 
#  Represents LeaveGroupCallRequest TLRequest.
# 
# 
#  @title LeaveGroupCallRequest
#  @description Telegram API type LeaveGroupCallRequest
#  @export
#  @noRd
#  @noRd
LeaveGroupCallRequest <- R6::R6Class(
  "LeaveGroupCallRequest",
  public = list(
    #  @field call Field.
    call = NULL,
    #  @field source Field.
    source = NULL,

    #  @description Initialize a LeaveGroupCallRequest
    # 
    #  @param call Input group call object.
    #  @param source Integer source identifier.
    #  @return invisible self
    initialize = function(call, source) {
      self$call <- call
      self$source <- as.integer(source)
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call method.
    #  @return invisible self
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "LeaveGroupCallRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call,
        source = self$source
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes `call$bytes()` exists.
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x500377f9
      ctor <- int_to_raw_le(0x500377f9, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      source_raw <- int_to_raw_le(as.integer(self$source), 4L)

      c(ctor, call_raw, source_raw)
    }
  )
)

#  Create LeaveGroupCallRequest from a reader
# 
#  Reads fields from reader and returns a new LeaveGroupCallRequest instance.
# 
#  @param reader An object exposing tgread_object() and read_int() methods.
#  @return LeaveGroupCallRequest instance
LeaveGroupCallRequest$set("public", "from_reader", function(reader) {
  call_obj <- reader$tgread_object()
  source_val <- reader$read_int()
  LeaveGroupCallRequest$new(call = call_obj, source = source_val)
})


#  LeaveGroupCallPresentationRequest R6 class
# 
#  Represents LeaveGroupCallPresentationRequest TLRequest.
# 
# 
#  @title LeaveGroupCallPresentationRequest
#  @description Telegram API type LeaveGroupCallPresentationRequest
#  @export
#  @noRd
#  @noRd
LeaveGroupCallPresentationRequest <- R6::R6Class(
  "LeaveGroupCallPresentationRequest",
  public = list(
    #  @field call Field.
    call = NULL,

    #  @description Initialize a LeaveGroupCallPresentationRequest
    # 
    #  @param call Input group call object.
    #  @return invisible self
    initialize = function(call) {
      self$call <- call
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call method.
    #  @return invisible self
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "LeaveGroupCallPresentationRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes `call$bytes()` exists.
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x1c50d144
      ctor <- int_to_raw_le(0x1c50d144, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      c(ctor, call_raw)
    }
  )
)

#  Create LeaveGroupCallPresentationRequest from a reader
# 
#  Reads fields from reader and returns a new LeaveGroupCallPresentationRequest instance.
# 
#  @param reader An object exposing tgread_object() method.
#  @return LeaveGroupCallPresentationRequest instance
LeaveGroupCallPresentationRequest$set("public", "from_reader", function(reader) {
  call_obj <- reader$tgread_object()
  LeaveGroupCallPresentationRequest$new(call = call_obj)
})


#  ReceivedCallRequest R6 class
# 
#  Represents ReceivedCallRequest TLRequest.
# 
# 
#  @title ReceivedCallRequest
#  @description Telegram API type ReceivedCallRequest
#  @export
#  @noRd
#  @noRd
ReceivedCallRequest <- R6::R6Class(
  "ReceivedCallRequest",
  public = list(
    #  @field peer Field.
    peer = NULL,

    #  @description Initialize a ReceivedCallRequest
    # 
    #  @param peer Input phone call object.
    #  @return invisible self
    initialize = function(peer) {
      self$peer <- peer
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  No-op kept for API parity.
    # 
    #  @param client Client object (unused).
    #  @param utils Utility object (unused).
    #  @return invisible self
    resolve = function(client, utils) {
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "ReceivedCallRequest",
        peer = if (!is.null(self$peer) && is.function(self$peer$to_list)) self$peer$to_list() else self$peer
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes `peer$bytes()` exists.
    #  @return raw vector (bytes). If dependent object doesn't provide bytes(),
    #          a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x17d54f61
      ctor <- int_to_raw_le(0x17d54f61, 4L)

      if (!is.null(self$peer) && is.function(self$peer$bytes)) {
        peer_raw <- self$peer$bytes()
      } else {
        warning("peer does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      c(ctor, peer_raw)
    }
  )
)

#  Create ReceivedCallRequest from a reader
# 
#  Reads fields from reader and returns a new ReceivedCallRequest instance.
# 
#  @param reader An object exposing tgread_object() method.
#  @return ReceivedCallRequest instance
ReceivedCallRequest$set("public", "from_reader", function(reader) {
  peer_obj <- reader$tgread_object()
  ReceivedCallRequest$new(peer = peer_obj)
})


#  RequestCallRequest R6 class
# 
#  Represents RequestCallRequest TLRequest.
# 
# 
#  @title RequestCallRequest
#  @description Telegram API type RequestCallRequest
#  @export
#  @noRd
#  @noRd
RequestCallRequest <- R6::R6Class(
  "RequestCallRequest",
  public = list(
    #  @field user_id Field.
    user_id = NULL,
    #  @field g_a_hash Field.
    g_a_hash = NULL,
    #  @field protocol Field.
    protocol = NULL,
    #  @field video Field.
    video = NULL,
    #  @field random_id Field.
    random_id = NULL,

    #  @description Initialize a RequestCallRequest
    # 
    #  @param user_id Input user object.
    #  @param g_a_hash Raw vector or single string representing bytes.
    #  @param protocol Protocol object.
    #  @param video Logical or NULL.
    #  @param random_id Integer or NULL (if NULL a random 32-bit int is chosen).
    #  @return invisible self
    initialize = function(user_id, g_a_hash, protocol, video = NULL, random_id = NULL) {
      self$user_id <- user_id
      self$g_a_hash <- g_a_hash
      self$protocol <- protocol
      self$video <- video
      if (is.null(random_id)) {
        # choose a signed 32-bit integer (non-negative is acceptable)
        self$random_id <- as.integer(floor(runif(1, min = -2^31, max = 2^31 - 1)))
      } else {
        self$random_id <- as.integer(random_id)
      }
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (unused here).
    #  @param utils Utility object with get_input_user method.
    #  @return invisible self
    resolve = function(client, utils) {
      # synchronous translation of original async resolve
      self$user_id <- utils$get_input_user(self$user_id)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "RequestCallRequest",
        user_id = if (!is.null(self$user_id) && is.function(self$user_id$to_list)) self$user_id$to_list() else self$user_id,
        g_a_hash = self$g_a_hash,
        protocol = if (!is.null(self$protocol) && is.function(self$protocol$to_list)) self$protocol$to_list() else self$protocol,
        video = self$video,
        random_id = self$random_id
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes `user_id$bytes()` and
    #  `protocol$bytes()` exist. `g_a_hash` may be raw vector or single string.
    #  @return raw vector (bytes). If dependent objects don't provide bytes(),
    #          a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x42ff96ed
      ctor <- int_to_raw_le(0x42ff96ed, 4L)

      flags_val <- 0L
      if (!is.null(self$video) && isTRUE(self$video)) flags_val <- bitwOr(flags_val, 1L)
      flags_raw <- int_to_raw_le(flags_val, 4L)

      if (!is.null(self$user_id) && is.function(self$user_id$bytes)) {
        user_raw <- self$user_id$bytes()
      } else {
        warning("user_id does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      random_raw <- int_to_raw_le(as.integer(self$random_id), 4L)

      if (is.null(self$g_a_hash)) {
        ga_raw <- int_to_raw_le(0L, 4L)
      } else {
        if (is.character(self$g_a_hash)) {
          ga_bytes <- charToRaw(enc2utf8(self$g_a_hash))
        } else if (is.raw(self$g_a_hash)) {
          ga_bytes <- self$g_a_hash
        } else {
          stop("g_a_hash must be a raw vector or a single string")
        }
        ga_raw <- c(int_to_raw_le(length(ga_bytes), 4L), ga_bytes)
      }

      if (!is.null(self$protocol) && is.function(self$protocol$bytes)) {
        protocol_raw <- self$protocol$bytes()
      } else {
        warning("protocol does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      c(ctor, flags_raw, user_raw, random_raw, ga_raw, protocol_raw)
    }
  )
)

#  Create RequestCallRequest from a reader
# 
#  Reads fields from reader and returns a new RequestCallRequest instance.
# 
#  @param reader An object exposing read_int(), tgread_object(), tgread_bytes(), tgread_object() methods.
#  @return RequestCallRequest instance
RequestCallRequest$set("public", "from_reader", function(reader) {
  flags_val <- reader$read_int()
  video_flag <- bitwAnd(flags_val, 1L) != 0L
  user_obj <- reader$tgread_object()
  random_val <- reader$read_int()
  g_a_val <- reader$tgread_bytes()
  protocol_obj <- reader$tgread_object()
  RequestCallRequest$new(user_id = user_obj, g_a_hash = g_a_val, protocol = protocol_obj, video = video_flag, random_id = random_val)
})


#  SaveCallDebugRequest R6 class
# 
#  Represents SaveCallDebugRequest TLRequest.
# 
# 
#  @title SaveCallDebugRequest
#  @description Telegram API type SaveCallDebugRequest
#  @export
#  @noRd
#  @noRd
SaveCallDebugRequest <- R6::R6Class(
  "SaveCallDebugRequest",
  public = list(
    #  @field peer Field.
    peer = NULL,
    #  @field debug Field.
    debug = NULL,

    #  @description Initialize a SaveCallDebugRequest
    # 
    #  @param peer Input phone call object.
    #  @param debug DataJSON-like object.
    #  @return invisible self
    initialize = function(peer, debug) {
      self$peer <- peer
      self$debug <- debug
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  This is a no-op here but kept for parity with other requests.
    # 
    #  @param client Client object (unused).
    #  @param utils Utility object (unused).
    #  @return invisible self
    resolve = function(client, utils) {
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "SaveCallDebugRequest",
        peer = if (!is.null(self$peer) && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        debug = if (!is.null(self$debug) && is.function(self$debug$to_list)) self$debug$to_list() else self$debug
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes `peer$bytes()` and
    #  `debug$bytes()` exist. Returns raw(0) and emits a warning if they don't.
    #  @return raw vector (bytes)
    bytes = function() {
      # Constructor id little-endian for 0x277add7e
      ctor <- int_to_raw_le(0x277add7e, 4L)

      if (!is.null(self$peer) && is.function(self$peer$bytes)) {
        peer_raw <- self$peer$bytes()
      } else {
        warning("peer does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      if (!is.null(self$debug) && is.function(self$debug$bytes)) {
        debug_raw <- self$debug$bytes()
      } else {
        warning("debug does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      c(ctor, peer_raw, debug_raw)
    }
  )
)

#  Create SaveCallDebugRequest from a reader
# 
#  Reads fields from reader and returns a new SaveCallDebugRequest instance.
# 
#  @param reader An object exposing tgread_object() method.
#  @return SaveCallDebugRequest instance
SaveCallDebugRequest$set("public", "from_reader", function(reader) {
  peer_obj <- reader$tgread_object()
  debug_obj <- reader$tgread_object()
  SaveCallDebugRequest$new(peer = peer_obj, debug = debug_obj)
})


#  SaveCallLogRequest R6 class
# 
#  Represents SaveCallLogRequest TLRequest.
# 
# 
#  @title SaveCallLogRequest
#  @description Telegram API type SaveCallLogRequest
#  @export
#  @noRd
#  @noRd
SaveCallLogRequest <- R6::R6Class(
  "SaveCallLogRequest",
  public = list(
    #  @field peer Field.
    peer = NULL,
    #  @field file Field.
    file = NULL,

    #  @description Initialize a SaveCallLogRequest
    # 
    #  @param peer Input phone call object.
    #  @param file Input file object.
    #  @return invisible self
    initialize = function(peer, file) {
      self$peer <- peer
      self$file <- file
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  This is a no-op here but kept for parity with other requests.
    # 
    #  @param client Client object (unused).
    #  @param utils Utility object (unused).
    #  @return invisible self
    resolve = function(client, utils) {
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "SaveCallLogRequest",
        peer = if (!is.null(self$peer) && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        file = if (!is.null(self$file) && is.function(self$file$to_list)) self$file$to_list() else self$file
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes `peer$bytes()` and
    #  `file$bytes()` exist. Returns raw(0) and emits a warning if they don't.
    #  @return raw vector (bytes)
    bytes = function() {
      # Constructor id little-endian for 0x41248786
      ctor <- int_to_raw_le(0x41248786, 4L)

      if (!is.null(self$peer) && is.function(self$peer$bytes)) {
        peer_raw <- self$peer$bytes()
      } else {
        warning("peer does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      if (!is.null(self$file) && is.function(self$file$bytes)) {
        file_raw <- self$file$bytes()
      } else {
        warning("file does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      c(ctor, peer_raw, file_raw)
    }
  )
)

#  Create SaveCallLogRequest from a reader
# 
#  Reads fields from reader and returns a new SaveCallLogRequest instance.
# 
#  @param reader An object exposing tgread_object() method.
#  @return SaveCallLogRequest instance
SaveCallLogRequest$set("public", "from_reader", function(reader) {
  peer_obj <- reader$tgread_object()
  file_obj <- reader$tgread_object()
  SaveCallLogRequest$new(peer = peer_obj, file = file_obj)
})


#  SaveDefaultGroupCallJoinAsRequest R6 class
# 
#  Represents SaveDefaultGroupCallJoinAsRequest TLRequest.
# 
# 
#  @title SaveDefaultGroupCallJoinAsRequest
#  @description Telegram API type SaveDefaultGroupCallJoinAsRequest
#  @export
#  @noRd
#  @noRd
SaveDefaultGroupCallJoinAsRequest <- R6::R6Class(
  "SaveDefaultGroupCallJoinAsRequest",
  public = list(
    #  @field peer Field.
    peer = NULL,
    #  @field join_as Field.
    join_as = NULL,

    #  @description Initialize a SaveDefaultGroupCallJoinAsRequest
    # 
    #  @param peer Input peer object.
    #  @param join_as Input peer object to join as.
    #  @return invisible self
    initialize = function(peer, join_as) {
      self$peer <- peer
      self$join_as <- join_as
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_peer method.
    #  @return invisible self
    resolve = function(client, utils) {
      # synchronous translation of original async resolve
      self$peer <- utils$get_input_peer(self$peer)
      self$join_as <- utils$get_input_peer(self$join_as)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "SaveDefaultGroupCallJoinAsRequest",
        peer = if (!is.null(self$peer) && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        join_as = if (!is.null(self$join_as) && is.function(self$join_as$to_list)) self$join_as$to_list() else self$join_as
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes `peer$bytes()` and
    #  `join_as$bytes()` exist.
    #  @return raw vector (bytes). If dependent objects don't provide bytes(),
    #          a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x575e1f8c
      ctor <- int_to_raw_le(0x575e1f8c, 4L)

      if (!is.null(self$peer) && is.function(self$peer$bytes)) {
        peer_raw <- self$peer$bytes()
      } else {
        warning("peer does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      if (!is.null(self$join_as) && is.function(self$join_as$bytes)) {
        join_as_raw <- self$join_as$bytes()
      } else {
        warning("join_as does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      c(ctor, peer_raw, join_as_raw)
    }
  )
)

#  Create SaveDefaultGroupCallJoinAsRequest from a reader
# 
#  Reads fields from reader and returns a new SaveDefaultGroupCallJoinAsRequest instance.
# 
#  @param reader An object exposing tgread_object() method.
#  @return SaveDefaultGroupCallJoinAsRequest instance
SaveDefaultGroupCallJoinAsRequest$set("public", "from_reader", function(reader) {
  peer_obj <- reader$tgread_object()
  join_as_obj <- reader$tgread_object()
  SaveDefaultGroupCallJoinAsRequest$new(peer = peer_obj, join_as = join_as_obj)
})


#  SendConferenceCallBroadcastRequest R6 class
# 
#  Represents SendConferenceCallBroadcastRequest TLRequest.
# 
# 
#  @title SendConferenceCallBroadcastRequest
#  @description Telegram API type SendConferenceCallBroadcastRequest
#  @export
#  @noRd
#  @noRd
SendConferenceCallBroadcastRequest <- R6::R6Class(
  "SendConferenceCallBroadcastRequest",
  public = list(
    #  @field call Field.
    call = NULL,
    #  @field block Field.
    block = NULL,

    #  @description Initialize a SendConferenceCallBroadcastRequest
    # 
    #  @param call Input group call object.
    #  @param block Raw vector or single string representing bytes.
    #  @return invisible self
    initialize = function(call, block) {
      self$call <- call
      self$block <- block
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call method.
    #  @return invisible self
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "SendConferenceCallBroadcastRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call,
        block = self$block
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes `call$bytes()` exists.
    #  @return raw vector (bytes). If dependent objects don't provide bytes(),
    #          a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0xc6701900
      ctor <- int_to_raw_le(0xc6701900, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      if (is.null(self$block)) {
        block_raw <- int_to_raw_le(0L, 4L)
      } else {
        if (is.character(self$block)) {
          block_bytes <- charToRaw(enc2utf8(self$block))
        } else if (is.raw(self$block)) {
          block_bytes <- self$block
        } else {
          stop("block must be a raw vector or a single string")
        }
        block_raw <- c(int_to_raw_le(length(block_bytes), 4L), block_bytes)
      }

      c(ctor, call_raw, block_raw)
    }
  )
)

#  Create SendConferenceCallBroadcastRequest from a reader
# 
#  Reads fields from reader and returns a new SendConferenceCallBroadcastRequest instance.
# 
#  @param reader An object exposing tgread_object() and tgread_bytes() methods.
#  @return SendConferenceCallBroadcastRequest instance
SendConferenceCallBroadcastRequest$set("public", "from_reader", function(reader) {
  call_obj <- reader$tgread_object()
  block_val <- reader$tgread_bytes()
  SendConferenceCallBroadcastRequest$new(call = call_obj, block = block_val)
})


#  SendSignalingDataRequest R6 class
# 
#  Represents SendSignalingDataRequest TLRequest.
# 
# 
#  @title SendSignalingDataRequest
#  @description Telegram API type SendSignalingDataRequest
#  @export
#  @noRd
#  @noRd
SendSignalingDataRequest <- R6::R6Class(
  "SendSignalingDataRequest",
  public = list(
    #  @field peer Field.
    peer = NULL,
    #  @field data Field.
    data = NULL,

    #  @description Initialize a SendSignalingDataRequest
    # 
    #  @param peer Input phone call object.
    #  @param data Raw vector containing bytes to send.
    initialize = function(peer, data) {
      self$peer <- peer
      self$data <- data
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "SendSignalingDataRequest",
        peer = if (!is.null(self$peer) && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        data = self$data
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes `peer$bytes()` exists.
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0xff7a9383
      ctor <- int_to_raw_le(0xff7a9383, 4L)

      if (!is.null(self$peer) && is.function(self$peer$bytes)) {
        peer_raw <- self$peer$bytes()
      } else {
        warning("peer does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      if (is.null(self$data)) {
        data_raw <- int_to_raw_le(0L, 4L)
      } else {
        # Expect data to be a raw vector; if it's character convert to raw utf8
        if (is.character(self$data)) {
          data_bytes <- charToRaw(enc2utf8(self$data))
        } else if (is.raw(self$data)) {
          data_bytes <- self$data
        } else {
          stop("data must be a raw vector or a single string")
        }
        data_raw <- c(int_to_raw_le(length(data_bytes), 4L), data_bytes)
      }

      c(ctor, peer_raw, data_raw)
    }
  )
)

#  Create SendSignalingDataRequest from a reader
# 
#  Reads fields from reader and returns a new SendSignalingDataRequest instance.
# 
#  @param reader An object exposing tgread_object() and tgread_bytes() methods.
#  @return SendSignalingDataRequest instance
SendSignalingDataRequest$set("public", "from_reader", function(reader) {
  peer_obj <- reader$tgread_object()
  data_val <- reader$tgread_bytes()
  SendSignalingDataRequest$new(peer = peer_obj, data = data_val)
})


#  SetCallRatingRequest R6 class
# 
#  Represents SetCallRatingRequest TLRequest.
# 
# 
#  @title SetCallRatingRequest
#  @description Telegram API type SetCallRatingRequest
#  @export
#  @noRd
#  @noRd
SetCallRatingRequest <- R6::R6Class(
  "SetCallRatingRequest",
  public = list(
    #  @field peer Field.
    peer = NULL,
    #  @field rating Field.
    rating = NULL,
    #  @field comment Field.
    comment = NULL,
    #  @field user_initiative Field.
    user_initiative = NULL,

    #  @description Initialize a SetCallRatingRequest
    # 
    #  @param peer Input phone call object.
    #  @param rating Integer rating value.
    #  @param comment String comment.
    #  @param user_initiative Logical or NULL.
    initialize = function(peer, rating, comment, user_initiative = NULL) {
      self$peer <- peer
      self$rating <- as.integer(rating)
      self$comment <- comment
      self$user_initiative <- user_initiative
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object (not used here but kept for parity).
    resolve = function(client, utils) {
      # No-op for now; kept to match pattern where needed.
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "SetCallRatingRequest",
        peer = if (!is.null(self$peer) && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        rating = self$rating,
        comment = self$comment,
        user_initiative = self$user_initiative
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes `peer$bytes()` exists.
    #  @return raw vector (bytes). If dependent objects don't provide bytes(), a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x59ead627
      ctor <- int_to_raw_le(0x59ead627, 4L)

      flags_val <- 0L
      if (!is.null(self$user_initiative) && isTRUE(self$user_initiative)) {
        flags_val <- bitwOr(flags_val, 1L)
      }
      flags_raw <- int_to_raw_le(flags_val, 4L)

      if (!is.null(self$peer) && is.function(self$peer$bytes)) {
        peer_raw <- self$peer$bytes()
      } else {
        warning("peer does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      rating_raw <- int_to_raw_le(as.integer(self$rating), 4L)

      if (!is.character(self$comment) || length(self$comment) != 1L) {
        stop("comment must be a single string")
      }
      comment_bytes <- charToRaw(enc2utf8(self$comment))
      comment_raw <- c(int_to_raw_le(length(comment_bytes), 4L), comment_bytes)

      c(ctor, flags_raw, peer_raw, rating_raw, comment_raw)
    }
  )
)

#  Create SetCallRatingRequest from a reader
# 
#  Reads fields from reader and returns a new SetCallRatingRequest instance.
# 
#  @param reader An object exposing read_int(), tgread_object(), tgread_string() methods.
#  @return SetCallRatingRequest instance
SetCallRatingRequest$set("public", "from_reader", function(reader) {
  flags_val <- reader$read_int()
  user_initiative_flag <- bitwAnd(flags_val, 1L) != 0L
  peer_obj <- reader$tgread_object()
  rating_val <- reader$read_int()
  comment_val <- reader$tgread_string()
  SetCallRatingRequest$new(peer = peer_obj, rating = rating_val, comment = comment_val, user_initiative = user_initiative_flag)
})


#  StartScheduledGroupCallRequest R6 class
# 
#  Represents StartScheduledGroupCallRequest TLRequest.
# 
# 
#  @title StartScheduledGroupCallRequest
#  @description Telegram API type StartScheduledGroupCallRequest
#  @export
#  @noRd
#  @noRd
StartScheduledGroupCallRequest <- R6::R6Class(
  "StartScheduledGroupCallRequest",
  public = list(
    #  @field call Field.
    call = NULL,

    #  @description Initialize a StartScheduledGroupCallRequest
    # 
    #  @param call Input group call (object).
    initialize = function(call) {
      self$call <- call
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call method.
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "StartScheduledGroupCallRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. Assumes `self$call$bytes()` exists.
    #  @return raw vector (bytes). If dependent objects don't provide bytes(),
    #          a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x5680e342
      ctor <- int_to_raw_le(0x5680e342, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      c(ctor, call_raw)
    }
  )
)

#  Create StartScheduledGroupCallRequest from a reader
# 
#  Reads fields from reader and returns a new StartScheduledGroupCallRequest instance.
# 
#  @param reader An object exposing tgread_object() method.
#  @return StartScheduledGroupCallRequest instance
StartScheduledGroupCallRequest$set("public", "from_reader", function(reader) {
  call_obj <- reader$tgread_object()
  StartScheduledGroupCallRequest$new(call = call_obj)
})


#  ToggleGroupCallRecordRequest R6 class
# 
#  Represents ToggleGroupCallRecordRequest TLRequest.
# 
# 
#  @title ToggleGroupCallRecordRequest
#  @description Telegram API type ToggleGroupCallRecordRequest
#  @export
#  @noRd
#  @noRd
ToggleGroupCallRecordRequest <- R6::R6Class(
  "ToggleGroupCallRecordRequest",
  public = list(
    #  @field call Field.
    call = NULL,
    #  @field start Field.
    start = NULL,
    #  @field video Field.
    video = NULL,
    #  @field title Field.
    title = NULL,
    #  @field video_portrait Field.
    video_portrait = NULL,

    #  @description Initialize a ToggleGroupCallRecordRequest
    # 
    #  @param call Input group call (object).
    #  @param start Logical or NULL.
    #  @param video Logical or NULL.
    #  @param title Optional string or NULL.
    #  @param video_portrait Logical or NULL.
    initialize = function(call, start = NULL, video = NULL, title = NULL, video_portrait = NULL) {
      self$call <- call
      self$start <- start
      self$video <- video
      self$title <- title
      self$video_portrait <- video_portrait
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call method.
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "ToggleGroupCallRecordRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call,
        start = self$start,
        video = self$video,
        title = self$title,
        video_portrait = self$video_portrait
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  This constructs the TL-serialized bytes. Assumes `call$bytes()` exists.
    #  @return raw vector
    bytes = function() {
      # Constructor id little-endian for 0xf128c708
      ctor <- int_to_raw_le(0xf128c708, 4L)

      # Validate mutual presence of video and video_portrait like original implementation
      video_present <- !is.null(self$video)
      portrait_present <- !is.null(self$video_portrait)
      if (!((video_present && portrait_present) || (!video_present && !portrait_present))) {
        stop("video and video_portrait parameters must either both be present or both be absent")
      }

      flags_val <- 0L
      if (!is.null(self$start) && isTRUE(self$start)) flags_val <- bitwOr(flags_val, 1L)
      if (!is.null(self$title)) flags_val <- bitwOr(flags_val, 2L)
      if (video_present) flags_val <- bitwOr(flags_val, 4L)

      flags_raw <- int_to_raw_le(flags_val, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      title_raw <- raw(0)
      if (!is.null(self$title)) {
        # assume serialize_bytes equivalent: length prefixed string bytes; reuse previous pattern (caller may provide proper encode)
        # Here we assume title is a raw-like or character to be encoded as utf-8 with length prefix; use simple utf-8 encoding with length as 4-byte LE int
        if (!is.character(self$title) || length(self$title) != 1L) {
          stop("title must be a single string")
        }
        title_bytes <- charToRaw(enc2utf8(self$title))
        title_raw <- c(int_to_raw_le(length(title_bytes), 4L), title_bytes)
      }

      portrait_token <- raw(0)
      if (!is.null(self$video_portrait)) {
        portrait_token <- if (isTRUE(self$video_portrait)) bool_true_token else bool_false_token
      }

      c(ctor, flags_raw, call_raw, title_raw, portrait_token)
    }
  )
)

#  Create ToggleGroupCallRecordRequest from a reader
# 
#  @param reader An object exposing read_int(), tgread_object(), tgread_string(), tgread_bool() methods.
#  @return ToggleGroupCallRecordRequest instance
ToggleGroupCallRecordRequest$set("public", "from_reader", function(reader) {
  flags_val <- reader$read_int()
  start_flag <- bitwAnd(flags_val, 1L) != 0L
  video_flag <- bitwAnd(flags_val, 4L) != 0L

  call_obj <- reader$tgread_object()

  title_val <- NULL
  if (bitwAnd(flags_val, 2L) != 0L) {
    title_val <- reader$tgread_string()
  }

  video_portrait_val <- NULL
  if (video_flag) {
    video_portrait_val <- reader$tgread_bool()
  }

  ToggleGroupCallRecordRequest$new(call = call_obj, start = start_flag, video = video_flag, title = title_val, video_portrait = video_portrait_val)
})


# Helper to convert integer to little-endian raw vector of given width (bytes)
int_to_raw_le <- function(x, width = 4L) {
  stopifnot(is.numeric(x), length(x) == 1L, width >= 1L)
  if (x > 2147483647 && width == 4L) {
    x <- x - 4294967296
  }
  writeBin(as.integer(x), con = raw(), size = width, endian = "little")
}

# Telegram boolean encoding tokens used in the original implementation
bool_true_token <- as.raw(c(0xb5L, 0x75L, 0x72L, 0x99L))
bool_false_token <- as.raw(c(0x37L, 0x97L, 0x79L, 0xbcL))

#  ToggleGroupCallSettingsRequest R6 class
# 
#  Represents ToggleGroupCallSettingsRequest TLRequest.
# 
# 
#  @title ToggleGroupCallSettingsRequest
#  @description Telegram API type ToggleGroupCallSettingsRequest
#  @export
#  @noRd
#  @noRd
ToggleGroupCallSettingsRequest <- R6::R6Class(
  "ToggleGroupCallSettingsRequest",
  public = list(
    #  @field call Field.
    call = NULL,
    #  @field reset_invite_hash Field.
    reset_invite_hash = NULL,
    #  @field join_muted Field.
    join_muted = NULL,

    #  @description Initialize a ToggleGroupCallSettingsRequest
    # 
    #  @param call Input group call (object).
    #  @param reset_invite_hash Logical or NULL.
    #  @param join_muted Logical or NULL.
    initialize = function(call, reset_invite_hash = NULL, join_muted = NULL) {
      self$call <- call
      self$reset_invite_hash <- reset_invite_hash
      self$join_muted <- join_muted
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  Typically used to convert high-level entities into input objects.
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call method.
    resolve = function(client, utils) {
      # synchronous translation of original async resolve
      self$call <- utils$get_input_group_call(self$call)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "ToggleGroupCallSettingsRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call,
        reset_invite_hash = self$reset_invite_hash,
        join_muted = self$join_muted
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  Builds the TL-serialized byte representation. This implementation
    #  assumes `self$call` exposes a bytes() method returning a raw vector.
    # 
    #  @return raw vector (bytes). If dependent objects don't provide bytes(),
    #          a warning is emitted and raw(0) is returned.
    bytes = function() {
      # Constructor id little-endian for 0x74bbb43d
      ctor <- int_to_raw_le(0x74bbb43d, 4L)

      # flags: bit 1 -> join_muted present, bit 2 -> reset_invite_hash
      flags_val <- 0L
      if (!is.null(self$join_muted)) flags_val <- bitwOr(flags_val, 1L)
      if (!is.null(self$reset_invite_hash) && isTRUE(self$reset_invite_hash)) flags_val <- bitwOr(flags_val, 2L)
      flags_raw <- int_to_raw_le(flags_val, 4L)

      # call bytes
      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      # join_muted token if present
      join_token <- raw(0)
      if (!is.null(self$join_muted)) {
        join_token <- if (isTRUE(self$join_muted)) bool_true_token else bool_false_token
      }

      c(ctor, flags_raw, call_raw, join_token)
    }
  )
)

#  Create ToggleGroupCallSettingsRequest from a reader
# 
#  Reads fields from reader and returns a new ToggleGroupCallSettingsRequest instance.
# 
#  @param reader An object exposing read_int(), tgread_object(), tgread_bool() methods.
#  @return ToggleGroupCallSettingsRequest instance
ToggleGroupCallSettingsRequest$set("public", "from_reader", function(reader) {
  flags_val <- reader$read_int()
  reset_invite_hash <- as.logical(bitwAnd(flags_val, 2L))
  call_obj <- reader$tgread_object()
  join_muted <- if (bitwAnd(flags_val, 1L) != 0L) reader$tgread_bool() else NULL
  ToggleGroupCallSettingsRequest$new(call = call_obj, reset_invite_hash = reset_invite_hash, join_muted = join_muted)
})


#  ToggleGroupCallStartSubscriptionRequest R6 class
# 
#  Represents ToggleGroupCallStartSubscriptionRequest TLRequest.
# 
# 
#  @title ToggleGroupCallStartSubscriptionRequest
#  @description Telegram API type ToggleGroupCallStartSubscriptionRequest
#  @export
#  @noRd
#  @noRd
ToggleGroupCallStartSubscriptionRequest <- R6::R6Class(
  "ToggleGroupCallStartSubscriptionRequest",
  public = list(
    #  @field call Field.
    call = NULL,
    #  @field subscribed Field.
    subscribed = NULL,

    #  @description Initialize a ToggleGroupCallStartSubscriptionRequest
    # 
    #  @param call Input group call (object).
    #  @param subscribed Logical (TRUE/FALSE).
    initialize = function(call, subscribed) {
      self$call <- call
      self$subscribed <- subscribed
      invisible(self)
    },

    #  @description Resolve input references
    # 
    #  @param client Client object (passed to utils functions).
    #  @param utils Utility object with get_input_group_call method.
    resolve = function(client, utils) {
      self$call <- utils$get_input_group_call(self$call)
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return A named list representing the request.
    to_list = function() {
      list(
        `_` = "ToggleGroupCallStartSubscriptionRequest",
        call = if (!is.null(self$call) && is.function(self$call$to_list)) self$call$to_list() else self$call,
        subscribed = self$subscribed
      )
    },

    #  @description Produce raw bytes for the request
    # 
    #  This constructs the TL-serialized bytes. Assumes `call$bytes()` exists.
    #  @return raw vector
    bytes = function() {
      # Constructor id little-endian for 0x219c34e6
      ctor <- int_to_raw_le(0x219c34e6, 4L)

      if (!is.null(self$call) && is.function(self$call$bytes)) {
        call_raw <- self$call$bytes()
      } else {
        warning("call does not implement bytes(); returning raw(0)")
        return(raw(0))
      }

      sub_token <- if (isTRUE(self$subscribed)) bool_true_token else bool_false_token

      c(ctor, call_raw, sub_token)
    }
  )
)

#  Create ToggleGroupCallStartSubscriptionRequest from a reader
# 
#  @param reader An object exposing tgread_object(), tgread_bool() methods.
#  @return ToggleGroupCallStartSubscriptionRequest instance
ToggleGroupCallStartSubscriptionRequest$set("public", "from_reader", function(reader) {
  call_obj <- reader$tgread_object()
  subscribed <- reader$tgread_bool()
  ToggleGroupCallStartSubscriptionRequest$new(call = call_obj, subscribed = subscribed)
})
