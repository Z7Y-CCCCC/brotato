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
		"original_lawn_engineer":
			return "Special-wave trees become work sites: gain temporary Engineering and Armor, then permanent Engineering on clear."
		"original_comet_runner":
			return "Special-wave Risk becomes momentum: gain temporary Speed, Attack Speed, and Pickup Range."
		"original_echo_librarian":
			return "Archives special waves: gain XP on clear and extra XP Gain from large draft pools."
		"original_orchard_alchemist":
			return "Fruit eaten during special waves is distilled into permanent Elemental Damage and Luck."
		"original_void_chef":
			return "Fruit eaten during special waves is void-cooked into materials and temporary Explosion Damage."
		"original_paper_samurai":
			return "Special-wave Risk sharpens the blade: gain Crit Chance and Crit Damage, but lose Armor temporarily."
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
		"original_lawn_engineer":
			return load("res://items/stats/engineering.png")
		"original_comet_runner":
			return load("res://items/stats/speed.png")
		"original_echo_librarian":
			return load("res://items/materials/material_ui.png")
		"original_orchard_alchemist":
			return load("res://items/stats/elemental_damage.png")
		"original_void_chef":
			return load("res://items/all/plastic_explosive/plastic_explosive_icon.png")
		"original_paper_samurai":
			return load("res://items/stats/crit_chance.png")
		_:
			return load("res://items/materials/material_ui.png")
