class_name OriginalWaveStreakRewardEffect
extends Effect


static func get_id() -> String:
	return "original_wave_streak_reward"


func get_text(_player_index: int, _colored: bool = true) -> String:
	var prefix = "+" if value >= 0 else ""
	return "%s%s%% special wave streak rewards" % [prefix, str(value)]


func get_icon(_player_index: int) -> Texture:
	return load("res://items/materials/material_ui.png")
