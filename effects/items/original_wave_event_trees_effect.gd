class_name OriginalWaveEventTreesEffect
extends Effect


static func get_id() -> String:
	return "original_wave_event_trees"


func get_text(_player_index: int, _colored: bool = true) -> String:
	var prefix = "+" if value >= 0 else ""
	return "%s%s trees during special waves" % [prefix, str(value)]


func get_icon(_player_index: int):
	return load("res://items/consumables/fruit/fruit_icon.png")
