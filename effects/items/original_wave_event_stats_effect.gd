class_name OriginalWaveEventStatsEffect
extends Effect

export(String) var stat = "stat_attack_speed"

var stat_hash: int = Keys.stat_attack_speed_hash


static func get_id() -> String:
	return "original_wave_event_stats"


func _generate_hashes() -> void:
	._generate_hashes()
	stat_hash = Keys.generate_hash(stat)


func apply(player_index: int) -> void:
	if stat != "":
		stat_hash = Keys.generate_hash(stat)
	RunData.get_player_effects(player_index)[Keys.original_wave_event_stats_hash].push_back([stat_hash, value])


func unapply(player_index: int) -> void:
	var effects = RunData.get_player_effects(player_index)[Keys.original_wave_event_stats_hash]
	for i in effects.size():
		var effect = effects[i]
		if effect[0] == stat_hash and effect[1] == value:
			effects.remove(i)
			return


func get_text(_player_index: int, _colored: bool = true) -> String:
	var prefix = "+" if value >= 0 else ""
	return "%s%s %s during special waves" % [prefix, str(value), tr(stat.to_upper())]


func get_icon(_player_index: int):
	return ItemService.get_stat_small_icon(stat_hash)


func duplicate(subresources := false) -> Resource:
	var duplication = .duplicate(subresources)
	if stat != "":
		stat_hash = Keys.generate_hash(stat)
	duplication.stat_hash = stat_hash
	return duplication
