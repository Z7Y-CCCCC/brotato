class_name OriginalCharacterMechanicEffect
extends Effect


static func get_id() -> String:
	return "original_character_mechanic"


func get_text(_player_index: int, _colored: bool = true) -> String:
	match key:
		"original_streak_broker":
			return "Special wave clears permanently grant +%s Luck per Risk." % str(value)
		"original_sun_gardener":
			return "Special wave trees grant temporary regeneration and permanent Harvesting on clear."
		"original_mutation_duelist":
			return "During special waves, gain +%s%% Damage and +%s Attack Speed per Risk." % [str(value * 4), str(value * 3)]
		"original_draft_captain":
			return "Extra draft choices grant combat orders and reduce special-wave enemy count."
		_:
			return "Original character mechanic"


func get_icon(_player_index: int):
	match key:
		"original_sun_gardener":
			return load("res://items/consumables/fruit/fruit_icon.png")
		"original_mutation_duelist":
			return load("res://ui/icons/misc/elite_icon.png")
		"original_draft_captain":
			return load("res://items/consumables/item_box/item_box_icon.png")
		_:
			return load("res://items/materials/material_ui.png")
