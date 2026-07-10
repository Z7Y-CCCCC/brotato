class_name MainMenu
extends Control

signal options_button_pressed
signal credits_button_pressed
signal codex_button_pressed
signal profile_button_pressed
signal mods_button_pressed

onready var continue_button = $"%ContinueButton"
onready var profile_button = $"%ProfileButton"
onready var start_button = $"%StartButton"
onready var options_button = $"%OptionsButton"
onready var codex_button = $"%CodexButton"
onready var mods_button = $"%ModsButton"
onready var quit_button = $"%QuitButton"


onready var more_games_button = $"%MoreGamesButton"
onready var newsletter_button = $"%NewsletterButton"
onready var community_button = $"%CommunityButton"
onready var credits_button = $"%CreditsButton"

onready var error_label = $"%ErrorLabel"
onready var version_label = $"%VersionLabel"
onready var xbox_gamertag = $"%XboxGamerTag"
onready var logo_container = $"%LogoContainer"

onready var left_container = $"MarginContainer/VBoxContainer/HBoxContainer/ButtonsLeft"
onready var right_container = $"MarginContainer/VBoxContainer/HBoxContainer/ButtonsRight"

const ONLINE_LAB_PORT := 27450

var _online_lab_button: Button = null
var _online_lab_join_button: Button = null
var _online_lab_address_input: LineEdit = null
var _online_lab_status_label: Label = null
var _online_lab_clients: = 0

func testActivity(act: String) -> void :
	
	if act != "":
		ProgressData.reset_activity()
		if ProgressData.saved_run_state.has_run_state:
			
			_on_ContinueButton_pressed()
		else:
			
			_on_StartButton_pressed()
	else:
		ProgressData.reset_activity()

func _process(_delta: float) -> void :
	_sync_original_menu_chrome_visibility()
	_refresh_online_lab_status()

	var act = ProgressData.get_pending_dlc_change()
	if act == true:
		print("DLC change, reinit menu")
		ProgressData.read_all_dlcs()

		if ProgressData.is_dlc_available("abyssal_terrors"):
			ProgressData.force_activate_dlc("abyssal_terrors")

		if ProgressData.is_dlc_available_and_active("abyssal_terrors"):
			start_button.grab_focus()

		if ProgressData.is_dlc_available("abyssal_terrors"):
			more_games_button.hide()
		else:
			more_games_button.show()

		var path_left_right = ""

		if Utils.on_gdk_desktop:
			if ProgressData.is_dlc_available_and_active("abyssal_terrors"):
				setup_dlc_desktop_menu()
				path_left_right = codex_button.get_path()
		else:
			codex_button.focus_neighbour_left = path_left_right
			codex_button.focus_neighbour_right = path_left_right
			credits_button.focus_neighbour_left = path_left_right
			credits_button.focus_neighbour_right = path_left_right

		continue_button.focus_neighbour_left = path_left_right
		continue_button.focus_neighbour_right = path_left_right
		start_button.focus_neighbour_left = path_left_right
		start_button.focus_neighbour_right = path_left_right
		options_button.focus_neighbour_left = path_left_right
		options_button.focus_neighbour_right = path_left_right
		quit_button.focus_neighbour_left = path_left_right
		quit_button.focus_neighbour_right = path_left_right

		var menu_gameplay_options = get_parent().find_node("MenuGameplayOptions")
		if menu_gameplay_options != null:
			menu_gameplay_options.refresh_dlc_button()

		start_button.grab_focus()

		if not ProgressData.is_dlc_available("abyssal_terrors"):
			print("DLC is not available anymore, kill any saved run")
			continue_button.hide()
			continue_button.disable()
			ProgressData.saved_run_state.has_run_state = false
			ProgressData.saved_run_state = ProgressData._get_empty_run_state()
		else:
			if ProgressData.saved_run_state.has_run_state and ProgressData.check_dlc_valid_for_saved_run_state() and not ProgressData.saved_run_state.get("is_streamplay_run", false):
				continue_button.show()
				continue_button.activate()

		setup_menu()
		_apply_original_menu_theme()


func _input(event: InputEvent) -> void:
	if not visible:
		return
	if not (event is InputEventKey):
		return
	if not event.pressed or event.echo:
		return
	if event.scancode == KEY_F9:
		_on_OnlineLabButton_pressed()
	elif event.scancode == KEY_F10:
		_on_OnlineLabJoinButton_pressed()


func refresh_menu() -> void :
	var path_left_right = ""

	if ProgressData.is_dlc_available("abyssal_terrors"):
		more_games_button.hide()
	else:
		more_games_button.show()

	if Utils.is_on_console():
		
		newsletter_button.hide()
		community_button.hide()
		mods_button.hide()

		if ProgressData.is_dlc_available_and_active("abyssal_terrors"):
			if Utils.on_gdk_desktop:
				setup_dlc_desktop_menu()
				path_left_right = codex_button.get_path()
			else:
				setup_console_with_dlc_menu()
				path_left_right = more_games_button.get_path()
		else:
			setup_console_no_dlc_menu()

		continue_button.focus_neighbour_left = path_left_right
		continue_button.focus_neighbour_right = path_left_right
		start_button.focus_neighbour_left = path_left_right
		start_button.focus_neighbour_right = path_left_right
		options_button.focus_neighbour_left = path_left_right
		options_button.focus_neighbour_right = path_left_right
		quit_button.focus_neighbour_left = path_left_right
		quit_button.focus_neighbour_right = path_left_right

func setup_menu() -> void :
	refresh_menu()

	if ProgressData.saved_run_state.has_run_state and not ProgressData.check_dlc_valid_for_saved_run_state():
		
		ProgressData.saved_run_state.has_run_state = false
		ProgressData.saved_run_state = ProgressData._get_empty_run_state()
		print("Killed run because it contains DLC maps or characters")


	if ProgressData.saved_run_state.has_run_state and ProgressData.check_dlc_valid_for_saved_run_state() and not ProgressData.saved_run_state.get("is_streamplay_run", false):
		
		continue_button.grab_focus()

		
		start_button.focus_neighbour_top = ""

		if Utils.is_on_console():
			
			if Utils.on_gdk_desktop:
				
				credits_button.focus_neighbour_bottom = ""
				quit_button.focus_neighbour_bottom = continue_button.get_path()
				continue_button.focus_neighbour_top = quit_button.get_path()
			else:
				
				credits_button.focus_neighbour_bottom = continue_button.get_path()
				continue_button.focus_neighbour_top = credits_button.get_path()

	else:
		
		start_button.grab_focus()

		if Utils.is_on_console():
			
			if Utils.on_gdk_desktop:
				
				credits_button.focus_neighbour_bottom = ""
				quit_button.focus_neighbour_bottom = start_button.get_path()
				start_button.focus_neighbour_top = quit_button.get_path()
			else:
				
				start_button.focus_neighbour_top = credits_button.get_path()
				credits_button.focus_neighbour_bottom = start_button.get_path()


func setup_console_no_dlc_menu() -> void :
	setup_console_common()

	credits_button.focus_neighbour_left = more_games_button.get_path()
	credits_button.focus_neighbour_right = more_games_button.get_path()

	codex_button.focus_neighbour_left = more_games_button.get_path()
	codex_button.focus_neighbour_right = more_games_button.get_path()


func setup_console_with_dlc_menu() -> void :
	setup_console_common()

	credits_button.focus_neighbour_left = ""
	credits_button.focus_neighbour_right = ""

	codex_button.focus_neighbour_left = ""
	codex_button.focus_neighbour_right = ""


func setup_console_common() -> void :
	var moved: = false

	
	if credits_button.get_parent() == right_container:
		right_container.remove_child(credits_button)
		left_container.add_child(credits_button)
		credits_button.size_flags_horizontal = 0
		moved = true

	
	if codex_button.get_parent() == right_container:
		right_container.remove_child(codex_button)
		left_container.add_child(codex_button)
		codex_button.size_flags_horizontal = 0
		moved = true

	if moved:
		
		left_container.move_child(credits_button, 6)
		left_container.move_child(codex_button, 4)


func setup_dlc_desktop_menu() -> void :
	
	if credits_button.get_parent() == left_container:
		left_container.remove_child(credits_button)
		right_container.add_child(credits_button)
		credits_button.size_flags_horizontal = 8

	
	if codex_button.get_parent() == left_container:
		left_container.remove_child(codex_button)
		right_container.add_child(codex_button)
		codex_button.size_flags_horizontal = 8

	credits_button.focus_neighbour_left = quit_button.get_path()
	credits_button.focus_neighbour_right = quit_button.get_path()

	codex_button.focus_neighbour_left = options_button.get_path()
	codex_button.focus_neighbour_right = options_button.get_path()

	
	right_container.move_child(credits_button, right_container.get_child_count() - 1)


func init() -> void :
	if Streamplay.playing():
		Streamplay.stop()
		RunData.reset()

	more_games_button.text = "MENU_DLC_AVAILABLE_STANDARD"
	more_games_button.add_color_override("font_color", Utils.DLC_BUTTON_TEXT_COLOR)
	more_games_button.theme = load("res://resources/themes/special_button_theme.tres")
	for dlc in ProgressData.available_dlcs:
		if dlc.my_id == "abyssal_terrors":
			more_games_button.text = "MENU_MORE_GAMES"
			more_games_button.remove_color_override("font_color")
			more_games_button.theme = null
			break

	reset_resume_state()
	setup_menu()


	
	if Utils.is_on_console():
		var newVersion = ProgressData.VERSION

		if Utils.on_nintendo_nx_or_ounce:
			newVersion = ProgressData.VERSION_SWITCH

		var newPos = newVersion.find("-")
		if newPos >= 0:
			newVersion = newVersion.substr(0, newPos)
		version_label.text = "version " + newVersion

		if Utils.on_gdk:
			xbox_gamertag.text = OS_Seaven.get_gamertag()
			xbox_gamertag.show()
		else:
			xbox_gamertag.hide()
	else:
		version_label.text = "version " + ProgressData.VERSION

	if not Utils.is_on_console() and ProgressData.load_status != LoadStatus.SAVE_OK:

		var status_text = "(!) "

		if ProgressData.load_status == LoadStatus.CORRUPTED_SAVE:
			status_text += tr("CORRUPTED_SAVE")
		elif ProgressData.load_status == LoadStatus.CORRUPTED_SAVE_LATEST:
			status_text += tr("CORRUPTED_SAVE_LATEST")
		elif ProgressData.load_status == LoadStatus.CORRUPTED_ALL_SAVES_STEAM:
			status_text += tr("CORRUPTED_ALL_SAVES_STEAM")
		elif ProgressData.load_status == LoadStatus.CORRUPTED_ALL_SAVES_NO_STEAM:
			status_text += tr("CORRUPTED_ALL_SAVES_NO_STEAM")
		elif ProgressData.load_status == LoadStatus.CORRUPTED_ALL_SAVES_EPIC:
			status_text += tr("CORRUPTED_ALL_SAVES_EPIC")
		elif ProgressData.load_status == LoadStatus.CORRUPTED_ALL_SAVES_NO_EPIC:
			status_text += tr("CORRUPTED_ALL_SAVES_NO_EPIC")
		elif ProgressData.load_status == LoadStatus.CORRUPTED_RUN_SAVE:
			status_text += tr("CORRUPTED_RUN_SAVE")

		error_label.text = status_text
		error_label.show()
	elif not Utils.is_on_console() and not CrashReporter.previous_crash_message.empty():
		var error_text = "(!) "
		if CrashReporter.previous_crashed_mod.empty():
			error_text += "%s %s" % [
				tr("CRASH_RECOVERY_MESSAGE_GENERAL"), 
				tr("CRASH_RECOVERY_MESSAGE_MODS_DISABLED")
			]
		else:
			error_text += "%s %s" % [
				tr("CRASH_RECOVERY_MESSAGE_MOD").replace("{0}", CrashReporter.previous_crashed_mod), 
				tr("CRASH_RECOVERY_MESSAGE_MODS_DISABLED")
			]
		error_label.text = error_text
		error_label.show()
	else:
		error_label.hide()

	_apply_original_menu_theme()

	var act = ProgressData.get_pending_activity()
	testActivity(act)


func reload_logo(screen: TitleScreenBackgroundData) -> void :
	for child in logo_container.get_children():
		child.queue_free()

	var instance = screen.logo_scene.instance()
	logo_container.add_child(instance)


func _apply_original_menu_theme() -> void:
	_ensure_original_menu_chrome()
	_ensure_online_lab_status_card()
	_ensure_online_lab_button()
	_sync_original_menu_chrome_visibility()

	left_container.add_constant_override("separation", 8)
	right_container.add_constant_override("separation", 10)

	_style_menu_button(start_button, Color(0.98, 0.68, 0.24, 1), true)
	_style_menu_button(continue_button, Color(0.65, 0.94, 0.77, 1), true)
	_style_menu_button(profile_button, Color(0.54, 0.86, 1.0, 1))
	_style_menu_button(codex_button, Color(0.79, 0.7, 1.0, 1))
	_style_menu_button(options_button, Color(0.78, 0.93, 0.94, 1))
	_style_menu_button(quit_button, Color(1.0, 0.55, 0.49, 1))

	_style_menu_button(mods_button, Color(0.88, 0.82, 0.46, 1))
	_style_menu_button(more_games_button, Color(0.86, 0.7, 0.36, 1))
	_style_menu_button(newsletter_button, Color(0.45, 0.83, 0.91, 1))
	_style_menu_button(community_button, Color(0.52, 0.92, 0.69, 1))
	_style_menu_button(credits_button, Color(0.7, 0.78, 0.86, 1))

	if _online_lab_button != null:
		_style_menu_button(_online_lab_button, Color(0.25, 0.95, 0.83, 1), true)
		_online_lab_button.text = "HOST: STOP" if LocalTunnelCoopService.is_hosting() else "HOST ONLINE"
		_online_lab_button.rect_min_size = Vector2(360, 54)
		_online_lab_button.size_flags_horizontal = SIZE_SHRINK_END

	if _online_lab_join_button != null:
		_style_menu_button(_online_lab_join_button, Color(0.48, 0.72, 1.0, 1), true)
		_online_lab_join_button.text = "LEAVE HOST" if LocalTunnelCoopService.is_client_connected() else "JOIN HOST"
		_online_lab_join_button.rect_min_size = Vector2(360, 54)
		_online_lab_join_button.size_flags_horizontal = SIZE_SHRINK_END

	for button in right_container.get_children():
		if button is Button:
			button.rect_min_size = Vector2(max(button.rect_min_size.x, 275), 58)

	_refresh_online_lab_status()


func _ensure_original_menu_chrome() -> void:
	var host = get_parent()
	if host == null:
		return

	var chrome = host.get_node_or_null("OriginalMenuChrome")
	if chrome == null:
		chrome = Panel.new()
		chrome.name = "OriginalMenuChrome"
		chrome.mouse_filter = MOUSE_FILTER_IGNORE
		chrome.anchor_left = 0.018
		chrome.anchor_top = 0.49
		chrome.anchor_right = 0.982
		chrome.anchor_bottom = 0.985
		chrome.margin_left = 0
		chrome.margin_top = 0
		chrome.margin_right = 0
		chrome.margin_bottom = 0
		chrome.add_stylebox_override("panel", _make_panel_style(Color(0.015, 0.035, 0.04, 0.76), Color(0.24, 0.91, 0.82, 0.8), 26, 3))
		host.add_child(chrome)
		host.move_child(chrome, 0)

		var rail = ColorRect.new()
		rail.name = "NeonRail"
		rail.mouse_filter = MOUSE_FILTER_IGNORE
		rail.anchor_left = 0.018
		rail.anchor_top = 0.035
		rail.anchor_right = 0.982
		rail.anchor_bottom = 0.047
		rail.color = Color(0.18, 0.95, 0.84, 0.62)
		chrome.add_child(rail)

		var caption = Label.new()
		caption.name = "OriginalMenuCaption"
		caption.mouse_filter = MOUSE_FILTER_IGNORE
		caption.anchor_left = 0.025
		caption.anchor_top = 0.07
		caption.anchor_right = 0.65
		caption.anchor_bottom = 0.18
		caption.text = "ZJY ORIGINAL EXPEDITION  //  LOCAL CO-OP + ONLINE LAB"
		caption.add_color_override("font_color", Color(0.72, 1.0, 0.94, 0.88))
		var caption_font = load("res://resources/fonts/actual/base/font_22.tres")
		if caption_font != null:
			caption.add_font_override("font", caption_font)
		chrome.add_child(caption)

	chrome.show()


func _sync_original_menu_chrome_visibility() -> void:
	var host = get_parent()
	if host == null:
		return
	var chrome = host.get_node_or_null("OriginalMenuChrome")
	if chrome != null:
		chrome.visible = visible
	var card = host.get_node_or_null("OnlineLabStatusCard")
	if card != null:
		card.visible = visible


func _ensure_online_lab_status_card() -> void:
	var host = get_parent()
	if host == null:
		return

	var card = host.get_node_or_null("OnlineLabStatusCard")
	if card == null:
		card = PanelContainer.new()
		card.name = "OnlineLabStatusCard"
		card.mouse_filter = MOUSE_FILTER_IGNORE
		card.anchor_left = 0.59
		card.anchor_top = 0.28
		card.anchor_right = 0.965
		card.anchor_bottom = 0.47
		card.margin_left = 0
		card.margin_top = 0
		card.margin_right = 0
		card.margin_bottom = 0
		card.add_stylebox_override("panel", _make_panel_style(Color(0.02, 0.07, 0.08, 0.78), Color(0.25, 0.92, 0.82, 0.74), 20, 2))
		host.add_child(card)

		var margin = MarginContainer.new()
		margin.name = "Margin"
		margin.add_constant_override("margin_left", 22)
		margin.add_constant_override("margin_right", 22)
		margin.add_constant_override("margin_top", 16)
		margin.add_constant_override("margin_bottom", 16)
		card.add_child(margin)

		var label = Label.new()
		label.name = "StatusLabel"
		label.autowrap = true
		label.valign = VALIGN_CENTER
		label.text = ""
		label.add_color_override("font_color", Color(0.9, 1.0, 0.96, 1))
		var label_font = load("res://resources/fonts/actual/base/font_22.tres")
		if label_font != null:
			label.add_font_override("font", label_font)

		var vbox = VBoxContainer.new()
		vbox.name = "VBox"
		vbox.add_constant_override("separation", 8)
		margin.add_child(vbox)
		vbox.add_child(label)

		var line = LineEdit.new()
		line.name = "AddressInput"
		line.text = "127.0.0.1:27450"
		line.placeholder_text = "host or tunnel address, e.g. 192.168.1.8:27450"
		line.rect_min_size = Vector2(360, 36)
		line.add_color_override("font_color", Color(0.92, 1.0, 0.96, 1))
		line.add_color_override("cursor_color", Color(0.25, 0.95, 0.83, 1))
		vbox.add_child(line)

	_online_lab_status_label = card.get_node("Margin/VBox/StatusLabel")
	_online_lab_address_input = card.get_node("Margin/VBox/AddressInput")


func _ensure_online_lab_button() -> void:
	if _online_lab_button == null:
		_online_lab_button = right_container.get_node_or_null("OnlineLabButton")
	if _online_lab_join_button == null:
		_online_lab_join_button = right_container.get_node_or_null("OnlineLabJoinButton")

	if _online_lab_button == null:
		_online_lab_button = Button.new()
		_online_lab_button.name = "OnlineLabButton"
		_online_lab_button.align = 0
		_online_lab_button.expand_icon = true
		_online_lab_button.set_script(load("res://ui/menus/global/my_menu_button.gd"))
		right_container.add_child(_online_lab_button)
		right_container.move_child(_online_lab_button, min(1, right_container.get_child_count() - 1))

	if _online_lab_join_button == null:
		_online_lab_join_button = Button.new()
		_online_lab_join_button.name = "OnlineLabJoinButton"
		_online_lab_join_button.align = 0
		_online_lab_join_button.expand_icon = true
		_online_lab_join_button.set_script(load("res://ui/menus/global/my_menu_button.gd"))
		right_container.add_child(_online_lab_join_button)
		right_container.move_child(_online_lab_join_button, min(2, right_container.get_child_count() - 1))

	if not _online_lab_button.is_connected("pressed", self, "_on_OnlineLabButton_pressed"):
		_online_lab_button.connect("pressed", self, "_on_OnlineLabButton_pressed")
	if not _online_lab_join_button.is_connected("pressed", self, "_on_OnlineLabJoinButton_pressed"):
		_online_lab_join_button.connect("pressed", self, "_on_OnlineLabJoinButton_pressed")

	if not LocalTunnelCoopService.is_connected("host_started", self, "_on_online_lab_host_started"):
		LocalTunnelCoopService.connect("host_started", self, "_on_online_lab_host_started")
	if not LocalTunnelCoopService.is_connected("host_stopped", self, "_on_online_lab_host_stopped"):
		LocalTunnelCoopService.connect("host_stopped", self, "_on_online_lab_host_stopped")
	if not LocalTunnelCoopService.is_connected("client_connected", self, "_on_online_lab_client_count_changed"):
		LocalTunnelCoopService.connect("client_connected", self, "_on_online_lab_client_count_changed")
	if not LocalTunnelCoopService.is_connected("client_disconnected", self, "_on_online_lab_client_count_changed"):
		LocalTunnelCoopService.connect("client_disconnected", self, "_on_online_lab_client_count_changed")
	if not LocalTunnelCoopService.is_connected("join_started", self, "_on_online_lab_join_started"):
		LocalTunnelCoopService.connect("join_started", self, "_on_online_lab_join_started")
	if not LocalTunnelCoopService.is_connected("join_connected", self, "_on_online_lab_join_connected"):
		LocalTunnelCoopService.connect("join_connected", self, "_on_online_lab_join_connected")
	if not LocalTunnelCoopService.is_connected("join_failed", self, "_on_online_lab_join_failed"):
		LocalTunnelCoopService.connect("join_failed", self, "_on_online_lab_join_failed")
	if not LocalTunnelCoopService.is_connected("join_stopped", self, "_on_online_lab_join_stopped"):
		LocalTunnelCoopService.connect("join_stopped", self, "_on_online_lab_join_stopped")
	if not LocalTunnelCoopService.is_connected("state_snapshot_received", self, "_on_online_lab_state_snapshot_received"):
		LocalTunnelCoopService.connect("state_snapshot_received", self, "_on_online_lab_state_snapshot_received")


func _style_menu_button(button: Button, accent: Color, primary: bool = false) -> void:
	if button == null:
		return

	var normal = _make_button_style(Color(0.025, 0.04, 0.045, 0.82), accent, 0.35 if primary else 0.22)
	var hover = _make_button_style(accent, Color(1, 1, 1, 0.92), 0.92)
	var pressed = _make_button_style(Color(accent.r * 0.62, accent.g * 0.62, accent.b * 0.62, 1), Color(1, 1, 1, 1), 0.85)
	var disabled = _make_button_style(Color(0.08, 0.08, 0.08, 0.35), Color(0.5, 0.5, 0.5, 0.35), 0.2)

	button.add_stylebox_override("normal", normal)
	button.add_stylebox_override("hover", hover)
	button.add_stylebox_override("focus", hover.duplicate())
	button.add_stylebox_override("pressed", pressed)
	button.add_stylebox_override("disabled", disabled)
	button.add_color_override("font_color", Color(0.95, 1.0, 0.98, 1))
	button.add_color_override("font_color_hover", Color(0.02, 0.035, 0.035, 1))
	button.add_color_override("font_color_focus", Color(0.02, 0.035, 0.035, 1))
	button.add_color_override("font_color_pressed", Color(0.02, 0.035, 0.035, 1))
	button.add_color_override("font_color_disabled", Color(0.9, 0.9, 0.9, 0.35))
	button.add_constant_override("hseparation", 8)


func _make_panel_style(bg: Color, border: Color, radius: int, width: int) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.border_width_left = width
	style.border_width_top = width
	style.border_width_right = width
	style.border_width_bottom = width
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_right = radius
	style.corner_radius_bottom_left = radius
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	return style


func _make_button_style(bg: Color, accent: Color, accent_alpha: float) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = Color(accent.r, accent.g, accent.b, accent_alpha)
	style.border_width_left = 5
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 4
	style.corner_radius_top_left = 15
	style.corner_radius_top_right = 15
	style.corner_radius_bottom_right = 15
	style.corner_radius_bottom_left = 15
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 9
	style.content_margin_bottom = 9
	return style


func _on_OnlineLabButton_pressed() -> void:
	if LocalTunnelCoopService.is_hosting():
		LocalTunnelCoopService.stop_host()
		return

	var error = LocalTunnelCoopService.start_host(ONLINE_LAB_PORT)
	if error != OK:
		_set_online_lab_status("HOST failed: TCP %s is busy or blocked." % str(ONLINE_LAB_PORT))


func _on_OnlineLabJoinButton_pressed() -> void:
	if LocalTunnelCoopService.is_client_connected():
		LocalTunnelCoopService.stop_client()
		return

	var raw_address = "127.0.0.1:%s" % str(ONLINE_LAB_PORT)
	if _online_lab_address_input != null:
		raw_address = _online_lab_address_input.text
	var parsed = LocalTunnelCoopService.parse_address_port(raw_address)
	var error = LocalTunnelCoopService.start_client(parsed["address"], parsed["port"])
	if error != OK:
		_set_online_lab_status("JOIN failed: %s:%s" % [parsed["address"], str(parsed["port"])])


func _on_online_lab_host_started(port: int, address: String) -> void:
	_online_lab_clients = 0
	if _online_lab_button != null:
		_online_lab_button.text = "HOST: STOP"
	_refresh_online_lab_status(port, address)


func _on_online_lab_host_stopped() -> void:
	_online_lab_clients = 0
	if _online_lab_button != null:
		_online_lab_button.text = "HOST ONLINE"
	_refresh_online_lab_status()


func _on_online_lab_client_count_changed(count: int) -> void:
	_online_lab_clients = count
	_refresh_online_lab_status()


func _on_online_lab_join_started(address: String, port: int) -> void:
	_set_online_lab_status("JOIN connecting to %s:%s ..." % [address, str(port)])


func _on_online_lab_join_connected(address: String, port: int) -> void:
	if _online_lab_join_button != null:
		_online_lab_join_button.text = "LEAVE HOST"
	_set_online_lab_status("JOIN connected: sending local input to %s:%s.\nUse host screen share / local display to play P2." % [address, str(port)])


func _on_online_lab_join_failed(message: String) -> void:
	if _online_lab_join_button != null:
		_online_lab_join_button.text = "JOIN HOST"
	_set_online_lab_status("JOIN failed: %s" % message)


func _on_online_lab_join_stopped() -> void:
	if _online_lab_join_button != null:
		_online_lab_join_button.text = "JOIN HOST"
	_refresh_online_lab_status()


func _on_online_lab_state_snapshot_received(_snapshot: Dictionary) -> void:
	_refresh_online_lab_status()


func _refresh_online_lab_status(port: int = ONLINE_LAB_PORT, address: String = "") -> void:
	if _online_lab_status_label == null:
		return

	if LocalTunnelCoopService.is_hosting():
		var host_address = address if not address.empty() else LocalTunnelCoopService.get_lan_address()
		_set_online_lab_status("HOST: %s:%s | clients: %s\nP2 = virtual device %s. Start = COOP character select.\nTunnel TCP %s with ngrok/frp for internet play." % [
			host_address,
			str(port),
			str(_online_lab_clients),
			str(LocalTunnelCoopService.REMOTE_PLAYER_DEVICE_ID),
			str(port)
		])
	elif LocalTunnelCoopService.is_client_connected():
		_set_online_lab_status("JOIN connected. Sending movement/menu input to host.\n%s" % LocalTunnelCoopService.get_last_state_summary())
	elif LocalTunnelCoopService.is_online_session_active():
		var target = LocalTunnelCoopService.parse_address_port(_online_lab_address_input.text if _online_lab_address_input != null else "")
		_set_online_lab_status("JOIN connecting...\nTarget: %s:%s" % [target["address"], str(target["port"])])
	else:
		_set_online_lab_status("Online Lab ready.\nHOST opens local TCP %s. JOIN connects to host/tunnel address.\nCurrent build: host-authoritative battle + remote P2 input + state sync." % str(ONLINE_LAB_PORT))


func _set_online_lab_status(text: String) -> void:
	if _online_lab_status_label != null:
		_online_lab_status_label.text = text


func _on_StartButton_pressed() -> void :
	MusicManager.tween( - 5)
	ProgressData.start_activity()
	if LocalTunnelCoopService.should_force_coop_host():
		RunData.play_mode = RunData.PlayMode.COOP
		RunData.set_coop_run(true)
		LocalTunnelCoopService.ensure_online_players_in_coop()
	var _error = get_tree().change_scene(MenuData.character_selection_scene)


func _on_OptionsButton_pressed() -> void :
	emit_signal("options_button_pressed")


func _on_CommunityButton_pressed() -> void :
	var _error = OS.shell_open(MenuData.community_url)


func _on_QuitButton_pressed() -> void :
	if not Utils.is_on_console() or Utils.on_gdk_desktop:
		get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)


func _on_NewsletterButton_pressed() -> void :
	var _error = OS.shell_open(MenuData.newsletter_url)


func _on_MoreGamesButton_pressed() -> void :
	if Utils.is_on_console():
		ProgressData.show_store_dlc1()
	else:
		if more_games_button.text == "MENU_MORE_GAMES":
			Platform.open_store_page(MenuData.more_games_url)

		else:
			Platform.open_store_page(MenuData.dlc_url)


func _on_CreditsButton_pressed() -> void :
	emit_signal("credits_button_pressed")


func _on_CodexButton_pressed() -> void :
	emit_signal("codex_button_pressed")


func _on_ContinueButton_pressed() -> void :
	if ProgressData.saved_run_state.has_run_state and ProgressData.saved_run_state.get("is_streamplay_run", false):
		return
	if not ProgressData.saved_run_state.has_run_state or not ProgressData.check_dlc_valid_for_saved_run_state():
		return

	if not ChallengeService.is_challenge_completed(ChallengeService.chal_hourglass_hash) and ProgressData.data.has("chal_hourglass_quit_wave") and ProgressData.data["chal_hourglass_quit_wave"]:
		ChallengeService.complete_challenge(ChallengeService.chal_hourglass_hash)
	ProgressData.data["chal_hourglass_quit_wave"] = false

	ProgressData.start_activity()

	RunData.continue_current_run_in_shop()

	var scene: = "res://ui/menus/shop/coop_resume.tscn" if RunData.play_mode == RunData.PlayMode.COOP else "res://ui/menus/shop/shop.tscn"
	var _error = get_tree().change_scene(scene)


func _on_ModsButton_pressed() -> void :
	emit_signal("mods_button_pressed")


static func reset_resume_state() -> void :
	
	CoopService.clear()
	RunData.cancel_resume()


func _on_ProfileButton_pressed():
	emit_signal("profile_button_pressed")
