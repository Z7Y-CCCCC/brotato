class_name StatsOnFruitEffect
extends Effect

export(String) var stat = "stat_elemental_damage"
export(int) var chance = 100

var stat_hash: int = Keys.stat_elemental_damage_hash


static func get_id() -> String:
	return "stats_on_fruit"


func _generate_hashes() -> void:
	._generate_hashes()
	stat_hash = Keys.generate_hash(stat)


func apply(player_index: int) -> void:
	if stat != "":
		stat_hash = Keys.generate_hash(stat)
	RunData.get_player_effects(player_index)[Keys.stats_on_fruit_hash].push_back([stat_hash, value, chance])


func unapply(player_index: int) -> void:
	var effects = RunData.get_player_effects(player_index)[Keys.stats_on_fruit_hash]
	for i in effects.size():
		var effect = effects[i]
		if effect[0] == stat_hash and effect[1] == value and effect[2] == chance:
			effects.remove(i)
			return


func get_text(_player_index: int, _colored: bool = true) -> String:
	var prefix = "+" if value >= 0 else ""
	return "%s%% chance to gain %s%s %s when eating fruit" % [str(chance), prefix, str(value), tr(stat.to_upper())]


func get_icon(_player_index: int):
	return ItemService.get_stat_small_icon(stat_hash)


func duplicate(subresources := false) -> Resource:
	var duplication = .duplicate(subresources)

	if stat != "":
		stat_hash = Keys.generate_hash(stat)

	duplication.stat_hash = stat_hash
	return duplication
