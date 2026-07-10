extends Node

signal host_started(port, address)
signal host_stopped()
signal client_connected(count)
signal client_disconnected(count)
signal join_started(address, port)
signal join_connected(address, port)
signal join_failed(message)
signal join_stopped()
signal state_snapshot_received(snapshot)

const DEFAULT_PORT := 27450
const PROTOCOL_VERSION := 1
const REMOTE_PLAYER_DEVICE_ID := 5
const INPUT_SEND_INTERVAL := 0.033
const STATE_SEND_INTERVAL := 0.20
const REMOTE_INPUT_DEADZONE := 0.35

enum Mode { OFF, HOST, CLIENT }

var _server: TCP_Server = null
var _clients: = []
var _client_peer: StreamPeerTCP = null
var _client_buffer: = ""
var _client_host: = ""
var _client_port: = DEFAULT_PORT
var _client_connected_once: = false

var _port: = DEFAULT_PORT
var _mode: int = Mode.OFF
var _hosting: = false
var _remote_action_state: = {}
var _input_send_accum: = 0.0
var _state_send_accum: = 0.0
var _last_state_snapshot: = {}


func _ready() -> void:
	set_process(true)


func _process(delta: float) -> void:
	if _mode == Mode.HOST:
		_process_host(delta)
	elif _mode == Mode.CLIENT:
		_process_client(delta)


func start_host(port: int = DEFAULT_PORT) -> int:
	stop_all()
	_server = TCP_Server.new()
	var error = _server.listen(port, "*")
	if error != OK:
		_server = null
		_hosting = false
		_mode = Mode.OFF
		return error

	_port = port
	_hosting = true
	_mode = Mode.HOST
	_last_state_snapshot.clear()
	emit_signal("host_started", _port, get_lan_address())
	return OK


func stop_host() -> void:
	if _mode != Mode.HOST and not _hosting:
		return

	_release_remote_actions()
	_remove_remote_player_if_safe()
	for client in _clients:
		var peer = client.get("peer", null)
		if peer != null:
			peer.disconnect_from_host()
	if _server != null:
		_server.stop()
	_server = null
	_clients.clear()
	if _hosting:
		emit_signal("host_stopped")
	_hosting = false
	_mode = Mode.OFF


func start_client(address: String, port: int = DEFAULT_PORT) -> int:
	stop_all()
	_client_host = address.strip_edges()
	_client_port = port
	_client_buffer = ""
	_client_connected_once = false
	_last_state_snapshot.clear()

	if _client_host.empty():
		_client_host = "127.0.0.1"

	_client_peer = StreamPeerTCP.new()
	var error = _client_peer.connect_to_host(_client_host, _client_port)
	if error != OK:
		_client_peer = null
		_mode = Mode.OFF
		emit_signal("join_failed", "connect_to_host failed: %s" % str(error))
		return error

	_mode = Mode.CLIENT
	emit_signal("join_started", _client_host, _client_port)
	return OK


func stop_client() -> void:
	if _client_peer != null:
		_client_peer.disconnect_from_host()
	_client_peer = null
	_client_buffer = ""
	if _mode == Mode.CLIENT:
		emit_signal("join_stopped")
	_mode = Mode.OFF
	_client_connected_once = false


func stop_all() -> void:
	if _mode == Mode.HOST or _hosting:
		stop_host()
	if _mode == Mode.CLIENT or _client_peer != null:
		stop_client()


func is_hosting() -> bool:
	return _mode == Mode.HOST and _hosting


func is_client_connected() -> bool:
	return _mode == Mode.CLIENT and _client_peer != null and _client_peer.get_status() == StreamPeerTCP.STATUS_CONNECTED


func is_online_session_active() -> bool:
	return is_hosting() or _mode == Mode.CLIENT


func should_force_coop_host() -> bool:
	return is_hosting()


func get_port() -> int:
	return _port


func get_client_count() -> int:
	return _clients.size()


func get_lan_address() -> String:
	for address in IP.get_local_addresses():
		if address.find(":") != -1:
			continue
		if address.begins_with("127."):
			continue
		if address == "0.0.0.0":
			continue
		return address
	return "127.0.0.1"


func get_host_summary() -> String:
	if not is_hosting():
		return "Online Lab: offline."
	return "Online Lab host: %s:%s  clients:%s" % [get_lan_address(), str(_port), str(_clients.size())]


func get_tunnel_hint() -> String:
	return "Tunnel TCP %s with ngrok/frp, then give the public host:port to player 2." % str(_port)


func get_last_state_summary() -> String:
	if _last_state_snapshot.empty():
		return "SYNC: waiting for battle state."

	var wave = _last_state_snapshot.get("wave", "-")
	var timer = _last_state_snapshot.get("time_left", -1)
	var enemies = _last_state_snapshot.get("enemies", 0)
	var players = _last_state_snapshot.get("players", [])
	var timer_text = "--"
	if timer is int or timer is float:
		timer_text = str(int(max(0, timer)))
	return "SYNC: wave %s | %ss | enemies %s | players %s" % [
		str(wave),
		timer_text,
		str(enemies),
		str(players.size())
	]


func parse_address_port(raw: String) -> Dictionary:
	var value = raw.strip_edges()
	if value.empty():
		return {"address": "127.0.0.1", "port": DEFAULT_PORT}

	var address = value
	var port = DEFAULT_PORT
	var colon_index = value.rfind(":")
	if colon_index > 0 and colon_index < value.length() - 1:
		address = value.substr(0, colon_index)
		var port_text = value.substr(colon_index + 1, value.length() - colon_index - 1)
		if port_text.is_valid_integer():
			port = int(port_text)

	return {"address": address, "port": port}


func ensure_online_players_in_coop() -> void:
	if not should_force_coop_host():
		return

	RunData.play_mode = RunData.PlayMode.COOP
	RunData.set_coop_run(true)

	if not CoopService.is_device_assigned(CoopService.KEYBOARD_REMAPPED_DEVICE_ID):
		CoopService._add_player(CoopService.KEYBOARD_REMAPPED_DEVICE_ID, CoopService.PlayerType.KEYBOARD_AND_MOUSE)

	if _clients.size() > 0 and not CoopService.is_device_assigned(REMOTE_PLAYER_DEVICE_ID):
		CoopService._add_player(REMOTE_PLAYER_DEVICE_ID, CoopService.PlayerType.GAMEPAD_XBOX)


func _process_host(delta: float) -> void:
	if not _hosting or _server == null:
		return

	while _server.is_connection_available():
		var peer = _server.take_connection()
		if peer == null:
			return
		_clients.push_back({"peer": peer, "buffer": ""})
		_send_packet(peer, {
			"t": "welcome",
			"protocol": PROTOCOL_VERSION,
			"slot": 2,
			"device": REMOTE_PLAYER_DEVICE_ID,
			"host": get_lan_address(),
			"port": _port
		})
		emit_signal("client_connected", _clients.size())
		ensure_online_players_in_coop()

	for i in range(_clients.size() - 1, -1, -1):
		var client = _clients[i]
		var peer: StreamPeerTCP = client.get("peer", null)
		if peer == null:
			_clients.remove(i)
			if _clients.empty():
				_remove_remote_player_if_safe()
			emit_signal("client_disconnected", _clients.size())
			continue

		peer.poll()
		if peer.get_status() != StreamPeerTCP.STATUS_CONNECTED:
			_clients.remove(i)
			_release_remote_actions()
			if _clients.empty():
				_remove_remote_player_if_safe()
			emit_signal("client_disconnected", _clients.size())
			continue

		client["buffer"] = _read_peer_lines(peer, client.get("buffer", ""), true)

	_state_send_accum += delta
	if _state_send_accum >= STATE_SEND_INTERVAL:
		_state_send_accum = 0.0
		_broadcast_state_snapshot()


func _process_client(delta: float) -> void:
	if _client_peer == null:
		return

	_client_peer.poll()
	var status = _client_peer.get_status()

	if status == StreamPeerTCP.STATUS_CONNECTED:
		if not _client_connected_once:
			_client_connected_once = true
			_send_packet(_client_peer, {
				"t": "hello",
				"protocol": PROTOCOL_VERSION,
				"name": "remote_player"
			})
			emit_signal("join_connected", _client_host, _client_port)

		_client_buffer = _read_peer_lines(_client_peer, _client_buffer, false)
		_input_send_accum += delta
		if _input_send_accum >= INPUT_SEND_INTERVAL:
			_input_send_accum = 0.0
			_send_packet(_client_peer, _collect_local_input_packet())

	elif status == StreamPeerTCP.STATUS_ERROR or (_client_connected_once and status == StreamPeerTCP.STATUS_NONE):
		emit_signal("join_failed", "connection closed")
		stop_client()


func _read_peer_lines(peer: StreamPeerTCP, buffer: String, from_remote_client: bool) -> String:
	var available = peer.get_available_bytes()
	if available <= 0:
		return buffer

	buffer += peer.get_utf8_string(available)
	var newline_index = buffer.find("\n")
	while newline_index != -1:
		var line = buffer.substr(0, newline_index).strip_edges()
		buffer = buffer.substr(newline_index + 1, buffer.length() - newline_index - 1)
		if not line.empty():
			_handle_line(line, from_remote_client)
		newline_index = buffer.find("\n")
	return buffer


func _handle_line(line: String, from_remote_client: bool) -> void:
	var parsed = JSON.parse(line)
	if parsed.error != OK or not (parsed.result is Dictionary):
		return

	var packet: Dictionary = parsed.result
	var packet_type = str(packet.get("t", ""))
	if from_remote_client:
		if packet_type == "input":
			_apply_remote_input_packet(packet)
		elif packet_type == "hello":
			ensure_online_players_in_coop()
	else:
		if packet_type == "state":
			_last_state_snapshot = packet
			emit_signal("state_snapshot_received", _last_state_snapshot)
		elif packet_type == "welcome":
			pass


func _send_packet(peer: StreamPeerTCP, packet: Dictionary) -> void:
	if peer == null or peer.get_status() != StreamPeerTCP.STATUS_CONNECTED:
		return
	var line = JSON.print(packet) + "\n"
	peer.put_data(line.to_utf8())


func _send_packet_to_all(packet: Dictionary) -> void:
	for client in _clients:
		_send_packet(client.get("peer", null), packet)


func _collect_local_input_packet() -> Dictionary:
	var button_move = Input.get_vector("button_move_left", "button_move_right", "button_move_up", "button_move_down")
	var analog_move = Input.get_vector("analog_move_left", "analog_move_right", "analog_move_up", "analog_move_down")
	var move = analog_move if analog_move.length() > button_move.length() else button_move
	var aim = Input.get_vector("rjoy_left", "rjoy_right", "rjoy_up", "rjoy_down")

	return {
		"t": "input",
		"mx": move.x,
		"my": move.y,
		"ax": aim.x,
		"ay": aim.y,
		"buttons": {
			"accept": Input.is_action_pressed("ui_accept"),
			"cancel": Input.is_action_pressed("ui_cancel"),
			"select": Input.is_action_pressed("ui_select"),
			"info": Input.is_action_pressed("ui_info"),
			"pause": Input.is_action_pressed("ui_pause"),
			"ban": Input.is_action_pressed("ui_ban"),
			"ltrigger": Input.is_action_pressed("ltrigger"),
			"rtrigger": Input.is_action_pressed("rtrigger")
		}
	}


func _apply_remote_input_packet(packet: Dictionary) -> void:
	var move = Vector2(float(packet.get("mx", 0.0)), float(packet.get("my", 0.0)))
	var aim = Vector2(float(packet.get("ax", 0.0)), float(packet.get("ay", 0.0)))
	var buttons: Dictionary = packet.get("buttons", {})

	_set_remote_action("button_move_left", move.x < -REMOTE_INPUT_DEADZONE)
	_set_remote_action("button_move_right", move.x > REMOTE_INPUT_DEADZONE)
	_set_remote_action("button_move_up", move.y < -REMOTE_INPUT_DEADZONE)
	_set_remote_action("button_move_down", move.y > REMOTE_INPUT_DEADZONE)

	_set_remote_action("ui_left", move.x < -REMOTE_INPUT_DEADZONE)
	_set_remote_action("ui_right", move.x > REMOTE_INPUT_DEADZONE)
	_set_remote_action("ui_up", move.y < -REMOTE_INPUT_DEADZONE)
	_set_remote_action("ui_down", move.y > REMOTE_INPUT_DEADZONE)

	_set_remote_action("rjoy_left", aim.x < -REMOTE_INPUT_DEADZONE)
	_set_remote_action("rjoy_right", aim.x > REMOTE_INPUT_DEADZONE)
	_set_remote_action("rjoy_up", aim.y < -REMOTE_INPUT_DEADZONE)
	_set_remote_action("rjoy_down", aim.y > REMOTE_INPUT_DEADZONE)

	_set_remote_action("ui_accept", bool(buttons.get("accept", false)))
	_set_remote_action("ui_cancel", bool(buttons.get("cancel", false)))
	_set_remote_action("ui_select", bool(buttons.get("select", false)))
	_set_remote_action("ui_info", bool(buttons.get("info", false)))
	_set_remote_action("ui_pause", bool(buttons.get("pause", false)))
	_set_remote_action("ui_ban", bool(buttons.get("ban", false)))
	_set_remote_action("ltrigger", bool(buttons.get("ltrigger", false)))
	_set_remote_action("rtrigger", bool(buttons.get("rtrigger", false)))


func _set_remote_action(base_action: String, pressed: bool) -> void:
	var action = "%s_%s" % [base_action, REMOTE_PLAYER_DEVICE_ID]
	if _remote_action_state.get(action, false) == pressed:
		return

	_remote_action_state[action] = pressed
	var event = InputEventAction.new()
	event.action = action
	event.device = REMOTE_PLAYER_DEVICE_ID
	event.pressed = pressed
	Input.parse_input_event(event)


func _release_remote_actions() -> void:
	for action in _remote_action_state.keys():
		if not _remote_action_state[action]:
			continue
		var event = InputEventAction.new()
		event.action = action
		event.device = REMOTE_PLAYER_DEVICE_ID
		event.pressed = false
		Input.parse_input_event(event)
	_remote_action_state.clear()


func _remove_remote_player_if_safe() -> void:
	if not CoopService.is_device_assigned(REMOTE_PLAYER_DEVICE_ID):
		return
	if _is_battle_scene_active():
		return
	CoopService._remove_player(REMOTE_PLAYER_DEVICE_ID)


func _is_battle_scene_active() -> bool:
	var scene = get_tree().current_scene
	if scene == null or scene.get_script() == null:
		return false
	return scene.get_script().resource_path == "res://main.gd"


func _broadcast_state_snapshot() -> void:
	if _clients.empty():
		return
	var snapshot = _build_state_snapshot()
	_last_state_snapshot = snapshot
	_send_packet_to_all(snapshot)


func _build_state_snapshot() -> Dictionary:
	var snapshot = {
		"t": "state",
		"wave": RunData.current_wave,
		"time_left": -1,
		"enemies": 0,
		"players": []
	}

	if RunData.wave_timer != null:
		snapshot["time_left"] = RunData.wave_timer.time_left

	var scene = get_tree().current_scene
	if scene == null:
		return snapshot

	var players = scene.get("_players")
	if players is Array:
		for player in players:
			if player == null or not is_instance_valid(player):
				continue
			var health = 0
			var max_health = 0
			if player.current_stats != null:
				health = player.current_stats.health
			if player.max_stats != null:
				max_health = player.max_stats.health
			snapshot["players"].push_back({
				"i": player.player_index,
				"x": player.global_position.x,
				"y": player.global_position.y,
				"hp": health,
				"max_hp": max_health,
				"dead": player.dead
			})

	var spawner = scene.get("_entity_spawner")
	if spawner != null and spawner.has_method("get_all_enemies"):
		snapshot["enemies"] = spawner.get_all_enemies(false).size()

	return snapshot
