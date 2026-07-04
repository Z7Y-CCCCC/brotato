class_name OriginalWaveEventChanceEffect
extends Effect


static func get_id() -> String:
	return "original_wave_event_chance"


func get_text(_player_index: int, _colored: bool = true) -> String:
	var prefix = "+" if value >= 0 else ""
	return "%s%s%% special wave chance" % [prefix, str(value)]


func get_icon(_player_index: int) -> Texture:
	return load("res://ui/icons/misc/elite_icon.png")
