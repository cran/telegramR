# Internal utils bridge for generated request resolve() methods.
# Many generated classes expect a `utils$...` object with both snake_case and
# camelCase helpers. Provide a minimal adapter here.

utils <- list(
  # snake_case
  get_input_peer = get_input_peer,
  get_input_user = get_input_user,
  get_input_channel = get_input_channel,
  get_input_message = get_input_message,
  get_input_media = get_input_media,
  get_input_document = get_input_document,
  get_input_photo = get_input_photo,
  get_input_chat_photo = get_input_chat_photo,
  get_input_group_call = get_input_group_call,
  get_message_id = get_message_id,
  get_peer_id = get_peer_id,
  get_display_name = get_display_name,
  is_list_like = is_list_like,

  # camelCase aliases used by generated code
  getInputPeer = get_input_peer,
  getInputUser = get_input_user,
  getInputChannel = get_input_channel,
  getInputMessage = get_input_message,
  getInputMedia = get_input_media,
  getInputDocument = get_input_document,
  getInputPhoto = get_input_photo,
  getInputChatPhoto = get_input_chat_photo
)

# Minimal helpers object expected by some generated code (e.g., chats.R).
helpers <- list(
  `_entity_type` = entity_type,
  `_EntityType` = EntityType
)
