extends Node

signal host_started(port, address)
signal host_stopped()
signal client_connected(count)
signal client_disconnected(count)

const DEFAULT_PORT := 27450

var _server: TCP_Server = null
var _clients: = []
var _port: = DEFAULT_PORT
var _hosting: = false


func _ready() -> void:
	set_process(true)


func _process(_delta: float) -> void:
	if not _hosting or _server == null:
		return

	while _server.is_connection_available():
		var peer = _server.take_connection()
		if peer == null:
			return
		_clients.push_back(peer)
		_send_welcome(peer)
		emit_signal("client_connected", _clients.size())

	for i in range(_clients.size() - 1, -1, -1):
		var client = _clients[i]
		if client == null or client.get_status() != StreamPeerTCP.STATUS_CONNECTED:
			_clients.remove(i)
			emit_signal("client_disconnected", _clients.size())


func start_host(port: int = DEFAULT_PORT) -> int:
	stop_host()
	_server = TCP_Server.new()
	var error = _server.listen(port, "*")
	if error != OK:
		_server = null
		_hosting = false
		return error

	_port = port
	_hosting = true
	emit_signal("host_started", _port, get_lan_address())
	return OK


func stop_host() -> void:
	for client in _clients:
		if client != null:
			client.disconnect_from_host()
	if _server != null:
		_server.stop()
	_server = null
	_clients.clear()
	if _hosting:
		emit_signal("host_stopped")
	_hosting = false


func is_hosting() -> bool:
	return _hosting


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
	if not _hosting:
		return "Online Lab: offline."
	return "Online Lab host: %s:%s  clients:%s" % [get_lan_address(), str(_port), str(_clients.size())]


func get_tunnel_hint() -> String:
	return "Tunnel TCP %s with ngrok/frp, then give the public host:port to player 2." % str(_port)


func _send_welcome(peer: StreamPeerTCP) -> void:
	if peer == null:
		return
	var message = "BROTATO_ZJY_ONLINE_LAB host=%s port=%s clients=%s\n" % [
		get_lan_address(),
		str(_port),
		str(_clients.size())
	]
	peer.put_data(message.to_utf8())
