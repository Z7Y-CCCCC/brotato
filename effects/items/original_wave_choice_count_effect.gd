class_name OriginalWaveChoiceCountEffect
extends Effect


static func get_id() -> String:
	return "original_wave_choice_count"


func get_text(_player_index: int, _colored: bool = true) -> String:
	var prefix = "+" if value >= 0 else ""
	return "%s%s special wave draft choice" % [prefix, str(value)]


func get_icon(_player_index: int):
	return load("res://items/consumables/item_box/item_box_icon.png")
