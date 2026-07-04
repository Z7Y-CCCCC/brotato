extends Control

const TITLE_SCREEN_PATH := "res://ui/menus/title_screen/title_screen.tscn"
const MIN_SHOW_TIME := 0.6
const MAX_WAIT_TIME := 2.0

var _elapsed := 0.0
var _progress_ready := false
var _changing_scene := false


func _init() -> void:
	if ProgressData != null:
		var _ready_error = ProgressData.connect("ready", self, "_on_progress_data_ready", [], CONNECT_ONESHOT)


func _ready() -> void:
	if ProgressData != null:
		_progress_ready = not ProgressData.load_status in [LoadStatus.CORRUPTED_ALL_SAVES_EPIC, LoadStatus.CORRUPTED_ALL_SAVES_STEAM]


func _process(delta: float) -> void:
	_elapsed += delta

	if _changing_scene:
		return

	var skip_requested = Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel")
	if skip_requested and _elapsed > 0.1:
		_go_to_title_screen()
		return

	if _elapsed >= MIN_SHOW_TIME and (_progress_ready or _elapsed >= MAX_WAIT_TIME):
		_go_to_title_screen()


func _on_progress_data_ready() -> void:
	if not ProgressData.load_status in [LoadStatus.CORRUPTED_ALL_SAVES_EPIC, LoadStatus.CORRUPTED_ALL_SAVES_STEAM]:
		_progress_ready = true


func _go_to_title_screen() -> void:
	_changing_scene = true

	if ProgressData != null:
		if ProgressData.has_method("_apply_sounds_settings"):
			ProgressData._apply_sounds_settings()
		if ProgressData.has_method("apply_settings"):
			ProgressData.apply_settings()

	var _error = get_tree().change_scene(TITLE_SCREEN_PATH)
