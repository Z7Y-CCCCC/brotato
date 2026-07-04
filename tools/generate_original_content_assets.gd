extends SceneTree

const CHARACTER_ROOT := "res://custom_elements/characters"
const ITEM_ROOT := "res://custom_elements/items"

const CHARACTER_SPECS := [
	{
		"id": "lawn_engineer",
		"name": "Lawn Engineer",
		"colors": [Color(0.22, 0.62, 0.26), Color(0.92, 0.74, 0.28)],
		"weapons": ["res://weapons/melee/wrench/1/wrench_data.tres", "res://weapons/melee/pruner/1/pruner_data.tres"],
		"effects": [
			{"file": "signature_effect.tres", "type": "default", "script": "res://effects/items/original_character_mechanic_effect.gd", "key": "original_lawn_engineer", "value": 1},
			{"file": "engineering_effect.tres", "type": "default", "key": "stat_engineering", "value": 8},
			{"file": "trees_effect.tres", "type": "default", "key": "trees", "value": 2},
			{"file": "special_trees_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_trees_effect.gd", "key": "original_wave_event_trees", "value": 2},
			{"file": "special_engineering_effect.tres", "type": "event_stat", "stat": "stat_engineering", "value": 6},
			{"file": "damage_tradeoff_effect.tres", "type": "default", "key": "stat_percent_damage", "value": -8}
		],
		"wanted_tags": ["stat_engineering", "structure", "exploration"]
	},
	{
		"id": "comet_runner",
		"name": "Comet Runner",
		"colors": [Color(0.18, 0.48, 0.95), Color(1.0, 0.36, 0.18)],
		"weapons": ["res://weapons/ranged/taser/1/taser_data.tres", "res://weapons/melee/lightning_shiv/1/lightning_shiv_data.tres"],
		"effects": [
			{"file": "signature_effect.tres", "type": "default", "script": "res://effects/items/original_character_mechanic_effect.gd", "key": "original_comet_runner", "value": 1},
			{"file": "speed_effect.tres", "type": "default", "key": "stat_speed", "value": 12},
			{"file": "pickup_range_effect.tres", "type": "default", "key": "pickup_range", "value": 30},
			{"file": "event_chance_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_chance_effect.gd", "key": "original_wave_event_chance", "value": 15},
			{"file": "special_attack_speed_effect.tres", "type": "event_stat", "stat": "stat_attack_speed", "value": 12},
			{"file": "armor_tradeoff_effect.tres", "type": "default", "key": "stat_armor", "value": -2}
		],
		"wanted_tags": ["stat_speed", "stat_attack_speed", "exploration"]
	},
	{
		"id": "echo_librarian",
		"name": "Echo Librarian",
		"colors": [Color(0.2, 0.22, 0.58), Color(0.82, 0.72, 1.0)],
		"weapons": ["res://weapons/ranged/wand/1/wand_data.tres", "res://weapons/ranged/slingshot/1/slingshot_data.tres"],
		"effects": [
			{"file": "signature_effect.tres", "type": "default", "script": "res://effects/items/original_character_mechanic_effect.gd", "key": "original_echo_librarian", "value": 1},
			{"file": "luck_effect.tres", "type": "default", "key": "stat_luck", "value": 10},
			{"file": "xp_effect.tres", "type": "default", "key": "xp_gain", "value": 10},
			{"file": "event_reward_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_reward_effect.gd", "key": "original_wave_event_reward", "value": 35},
			{"file": "special_range_effect.tres", "type": "event_stat", "stat": "stat_range", "value": 25},
			{"file": "enemy_health_tradeoff_effect.tres", "type": "default", "key": "enemy_health", "value": 12, "sign": 1}
		],
		"wanted_tags": ["stat_luck", "stat_range", "economy"]
	},
	{
		"id": "streak_broker",
		"name": "Streak Broker",
		"colors": [Color(0.75, 0.46, 0.14), Color(1.0, 0.88, 0.3)],
		"weapons": ["res://weapons/ranged/pistol/1/pistol_data.tres", "res://weapons/melee/scissors/1/scissors_data.tres"],
		"effects": [
			{"file": "signature_effect.tres", "type": "default", "script": "res://effects/items/original_character_mechanic_effect.gd", "key": "original_streak_broker", "value": 1},
			{"file": "luck_effect.tres", "type": "default", "key": "stat_luck", "value": 12},
			{"file": "event_chance_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_chance_effect.gd", "key": "original_wave_event_chance", "value": 20},
			{"file": "streak_reward_effect.tres", "type": "default", "script": "res://effects/items/original_wave_streak_reward_effect.gd", "key": "original_wave_streak_reward", "value": 60},
			{"file": "event_reward_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_reward_effect.gd", "key": "original_wave_event_reward", "value": 20},
			{"file": "enemy_damage_tradeoff_effect.tres", "type": "default", "key": "enemy_damage", "value": 10, "sign": 1}
		],
		"wanted_tags": ["economy", "stat_luck", "exploration"]
	},
	{
		"id": "sun_gardener",
		"name": "Sun Gardener",
		"colors": [Color(0.94, 0.62, 0.14), Color(0.22, 0.72, 0.28)],
		"weapons": ["res://weapons/melee/pruner/1/pruner_data.tres", "res://weapons/melee/stick/1/stick_data.tres"],
		"effects": [
			{"file": "signature_effect.tres", "type": "default", "script": "res://effects/items/original_character_mechanic_effect.gd", "key": "original_sun_gardener", "value": 1},
			{"file": "trees_effect.tres", "type": "default", "key": "trees", "value": 4},
			{"file": "special_trees_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_trees_effect.gd", "key": "original_wave_event_trees", "value": 3},
			{"file": "enemy_fruit_drops_effect.tres", "type": "default", "key": "enemy_fruit_drops", "value": 12},
			{"file": "special_harvesting_effect.tres", "type": "event_stat", "stat": "stat_harvesting", "value": 18},
			{"file": "speed_tradeoff_effect.tres", "type": "default", "key": "stat_speed", "value": -6}
		],
		"wanted_tags": ["stat_harvesting", "exploration", "stat_luck"]
	},
	{
		"id": "mutation_duelist",
		"name": "Mutation Duelist",
		"colors": [Color(0.72, 0.12, 0.16), Color(0.88, 0.9, 1.0)],
		"weapons": ["res://weapons/melee/spear/1/spear_data.tres", "res://weapons/ranged/taser/1/taser_data.tres"],
		"effects": [
			{"file": "signature_effect.tres", "type": "default", "script": "res://effects/items/original_character_mechanic_effect.gd", "key": "original_mutation_duelist", "value": 1},
			{"file": "damage_effect.tres", "type": "default", "key": "stat_percent_damage", "value": 8},
			{"file": "special_damage_effect.tres", "type": "event_stat", "stat": "stat_percent_damage", "value": 16},
			{"file": "special_attack_speed_effect.tres", "type": "event_stat", "stat": "stat_attack_speed", "value": 10},
			{"file": "event_chance_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_chance_effect.gd", "key": "original_wave_event_chance", "value": 12},
			{"file": "enemy_speed_tradeoff_effect.tres", "type": "default", "key": "enemy_speed", "value": 10, "sign": 1}
		],
		"wanted_tags": ["damage", "stat_attack_speed", "stat_speed"]
	},
	{
		"id": "draft_captain",
		"name": "Draft Captain",
		"colors": [Color(0.16, 0.38, 0.78), Color(0.95, 0.86, 0.45)],
		"weapons": ["res://weapons/ranged/double_barrel_shotgun/1/double_barrel_shotgun_data.tres", "res://weapons/ranged/laser_gun/1/laser_gun_data.tres"],
		"effects": [
			{"file": "signature_effect.tres", "type": "default", "script": "res://effects/items/original_character_mechanic_effect.gd", "key": "original_draft_captain", "value": 1},
			{"file": "event_chance_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_chance_effect.gd", "key": "original_wave_event_chance", "value": 25},
			{"file": "choice_count_effect.tres", "type": "default", "script": "res://effects/items/original_wave_choice_count_effect.gd", "key": "original_wave_choice_count", "value": 1},
			{"file": "event_reward_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_reward_effect.gd", "key": "original_wave_event_reward", "value": 25},
			{"file": "special_armor_effect.tres", "type": "event_stat", "stat": "stat_armor", "value": 3},
			{"file": "special_range_effect.tres", "type": "event_stat", "stat": "stat_range", "value": 35},
			{"file": "number_enemies_tradeoff_effect.tres", "type": "default", "key": "number_of_enemies", "value": 12, "sign": 1}
		],
		"wanted_tags": ["stat_range", "economy", "stat_armor"]
	}
]

const ITEM_SPECS := [
	{
		"id": "seed_vault",
		"name": "Seed Vault",
		"tier": 1,
		"value": 52,
		"colors": [Color(0.18, 0.58, 0.22), Color(0.95, 0.82, 0.34)],
		"tags": ["economy", "exploration", "stat_harvesting"],
		"effects": [
			{"file": "harvesting_effect.tres", "type": "default", "key": "stat_harvesting", "value": 8},
			{"file": "special_trees_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_trees_effect.gd", "key": "original_wave_event_trees", "value": 1},
			{"file": "event_reward_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_reward_effect.gd", "key": "original_wave_event_reward", "value": 10}
		]
	},
	{
		"id": "meteor_coupon",
		"name": "Meteor Coupon",
		"tier": 2,
		"value": 78,
		"colors": [Color(0.76, 0.24, 0.12), Color(1.0, 0.62, 0.24)],
		"tags": ["damage", "stat_attack_speed", "exploration"],
		"effects": [
			{"file": "event_chance_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_chance_effect.gd", "key": "original_wave_event_chance", "value": 12},
			{"file": "special_attack_speed_effect.tres", "type": "event_stat", "stat": "stat_attack_speed", "value": 8},
			{"file": "special_speed_effect.tres", "type": "event_stat", "stat": "stat_speed", "value": 4},
			{"file": "enemy_damage_tradeoff_effect.tres", "type": "default", "key": "enemy_damage", "value": 5, "sign": 1}
		]
	},
	{
		"id": "echo_bookmark",
		"name": "Echo Bookmark",
		"tier": 1,
		"value": 48,
		"colors": [Color(0.24, 0.22, 0.64), Color(0.82, 0.78, 1.0)],
		"tags": ["economy", "stat_luck", "stat_range"],
		"effects": [
			{"file": "luck_effect.tres", "type": "default", "key": "stat_luck", "value": 6},
			{"file": "event_reward_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_reward_effect.gd", "key": "original_wave_event_reward", "value": 15},
			{"file": "special_range_effect.tres", "type": "event_stat", "stat": "stat_range", "value": 12}
		]
	},
	{
		"id": "streak_ledger",
		"name": "Streak Ledger",
		"tier": 2,
		"value": 82,
		"colors": [Color(0.76, 0.5, 0.16), Color(1.0, 0.9, 0.36)],
		"tags": ["economy", "stat_luck", "exploration"],
		"effects": [
			{"file": "streak_reward_effect.tres", "type": "default", "script": "res://effects/items/original_wave_streak_reward_effect.gd", "key": "original_wave_streak_reward", "value": 45},
			{"file": "event_chance_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_chance_effect.gd", "key": "original_wave_event_chance", "value": 8},
			{"file": "luck_effect.tres", "type": "default", "key": "stat_luck", "value": 5}
		]
	},
	{
		"id": "risk_compass",
		"name": "Risk Compass",
		"tier": 1,
		"value": 58,
		"colors": [Color(0.18, 0.42, 0.78), Color(0.95, 0.75, 0.24)],
		"tags": ["exploration", "stat_speed", "economy"],
		"effects": [
			{"file": "event_chance_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_chance_effect.gd", "key": "original_wave_event_chance", "value": 10},
			{"file": "choice_count_effect.tres", "type": "default", "script": "res://effects/items/original_wave_choice_count_effect.gd", "key": "original_wave_choice_count", "value": 1},
			{"file": "event_reward_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_reward_effect.gd", "key": "original_wave_event_reward", "value": 12},
			{"file": "speed_effect.tres", "type": "default", "key": "stat_speed", "value": 4}
		]
	},
	{
		"id": "sunforge_battery",
		"name": "Sunforge Battery",
		"tier": 2,
		"value": 76,
		"colors": [Color(0.9, 0.36, 0.1), Color(1.0, 0.82, 0.22)],
		"tags": ["damage", "stat_elemental_damage", "stat_attack_speed"],
		"effects": [
			{"file": "special_elemental_effect.tres", "type": "event_stat", "stat": "stat_elemental_damage", "value": 8},
			{"file": "special_attack_speed_effect.tres", "type": "event_stat", "stat": "stat_attack_speed", "value": 8},
			{"file": "enemy_speed_tradeoff_effect.tres", "type": "default", "key": "enemy_speed", "value": 4, "sign": 1}
		]
	},
	{
		"id": "clone_stamp",
		"name": "Clone Stamp",
		"tier": 1,
		"value": 46,
		"colors": [Color(0.28, 0.7, 0.86), Color(0.86, 0.94, 1.0)],
		"tags": ["economy", "stat_crit_chance", "damage"],
		"effects": [
			{"file": "number_enemies_effect.tres", "type": "default", "key": "number_of_enemies", "value": 8, "sign": 1},
			{"file": "event_reward_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_reward_effect.gd", "key": "original_wave_event_reward", "value": 18},
			{"file": "special_crit_effect.tres", "type": "event_stat", "stat": "stat_crit_chance", "value": 7}
		]
	},
	{
		"id": "blackout_sprout",
		"name": "Blackout Sprout",
		"tier": 2,
		"value": 72,
		"colors": [Color(0.12, 0.44, 0.22), Color(0.44, 1.0, 0.42)],
		"tags": ["exploration", "stat_engineering", "stat_harvesting"],
		"effects": [
			{"file": "special_trees_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_trees_effect.gd", "key": "original_wave_event_trees", "value": 2},
			{"file": "special_engineering_effect.tres", "type": "event_stat", "stat": "stat_engineering", "value": 6},
			{"file": "harvesting_effect.tres", "type": "default", "key": "stat_harvesting", "value": 6}
		]
	}
]


func _init() -> void:
	for spec in CHARACTER_SPECS:
		_generate_character(spec)
	for spec in ITEM_SPECS:
		_generate_item(spec)
	quit()


func _generate_character(spec: Dictionary) -> void:
	var folder = "%s/%s" % [CHARACTER_ROOT, spec.id]
	_make_dir(folder)
	var colors = spec.colors
	for part in ["body", "accessory", "eyes", "mouth", "icon"]:
		_make_texture("%s/%s_%s" % [folder, spec.id, part], colors[0], colors[1], part, spec.id)

	var appearances = []
	appearances.append(_write_appearance(folder, spec.id, "body", 14, 0, 1.0))
	appearances.append(_write_appearance(folder, spec.id, "accessory", 10, 1, 1.2))
	appearances.append(_write_appearance(folder, spec.id, "eyes", 7, 2, 1.3))
	appearances.append(_write_appearance(folder, spec.id, "mouth", 15, 3, 1.4))

	var effect_paths = []
	for effect_spec in spec.effects:
		effect_paths.append(_write_effect(folder, effect_spec))

	_write_character_data(folder, spec, effect_paths, appearances)


func _generate_item(spec: Dictionary) -> void:
	var folder = "%s/%s" % [ITEM_ROOT, spec.id]
	_make_dir(folder)
	var colors = spec.colors
	_make_texture("%s/%s_icon" % [folder, spec.id], colors[0], colors[1], "item", spec.id)

	var effect_paths = []
	for effect_spec in spec.effects:
		effect_paths.append(_write_effect(folder, effect_spec))

	_write_item_data(folder, spec, effect_paths)


func _make_dir(path: String) -> void:
	var dir = Directory.new()
	dir.make_dir_recursive(path)


func _write_file(path: String, content: String) -> void:
	var file = File.new()
	var error = file.open(path, File.WRITE)
	if error != OK:
		printerr("Could not write %s (%s)" % [path, error])
		return
	file.store_string(content)
	file.close()


func _make_texture(base_path: String, base: Color, accent: Color, kind: String, id: String = "") -> void:
	var image = Image.new()
	image.create(150, 150, false, Image.FORMAT_RGBA8)
	image.lock()
	_fill(image, Color(0, 0, 0, 0))

	match kind:
		"body":
			if id == "mutation_duelist":
				_circle(image, Vector2(75, 80), 44, base)
				_rect(image, Rect2(75, 36, 44, 88), accent.darkened(0.2))
				_circle_outline(image, Vector2(75, 80), 48, Color(0.92, 0.92, 0.98), 3)
			elif id == "draft_captain":
				_circle(image, Vector2(75, 82), 40, base)
				_rect(image, Rect2(42, 104, 66, 15), base.darkened(0.3))
				_circle_outline(image, Vector2(75, 80), 50, accent, 3)
			elif id == "sun_gardener":
				_circle(image, Vector2(75, 80), 38, base)
				for petal in [Vector2(75, 35), Vector2(75, 125), Vector2(30, 80), Vector2(120, 80)]:
					_circle(image, petal, 16, accent)
			elif id == "streak_broker":
				_circle(image, Vector2(75, 80), 40, base)
				_rect(image, Rect2(43, 47, 64, 66), base.darkened(0.18))
				_circle(image, Vector2(104, 50), 12, accent)
			else:
				_circle(image, Vector2(75, 80), 42, base)
				_circle(image, Vector2(55, 58), 12, accent)
				_circle(image, Vector2(95, 58), 12, accent)
				_rect(image, Rect2(49, 106, 52, 13), base.darkened(0.25))
		"accessory":
			if id == "draft_captain":
				_rect(image, Rect2(38, 34, 74, 13), accent)
				_rect(image, Rect2(50, 23, 50, 18), accent.darkened(0.12))
				_circle(image, Vector2(75, 32), 6, Color(1, 1, 1))
				_rect(image, Rect2(72, 28, 6, 16), base.darkened(0.2))
			elif id == "sun_gardener":
				_circle(image, Vector2(75, 39), 18, accent)
				_circle(image, Vector2(75, 39), 8, base.lightened(0.25))
				_rect(image, Rect2(72, 50, 6, 28), accent.darkened(0.2))
			elif id == "mutation_duelist":
				_rect(image, Rect2(44, 42, 62, 12), accent)
				_rect(image, Rect2(53, 27, 12, 25), accent.lightened(0.1))
				_rect(image, Rect2(86, 27, 12, 25), base.darkened(0.35))
			elif id == "streak_broker":
				_rect(image, Rect2(49, 34, 52, 42), accent.darkened(0.08))
				_rect(image, Rect2(57, 43, 36, 4), Color(0.16, 0.1, 0.04))
				_rect(image, Rect2(57, 54, 36, 4), Color(0.16, 0.1, 0.04))
				_circle(image, Vector2(102, 76), 10, accent.lightened(0.2))
			else:
				_circle_outline(image, Vector2(75, 74), 54, accent, 4)
				_rect(image, Rect2(38, 36, 74, 9), accent)
				_rect(image, Rect2(68, 24, 14, 32), accent.lightened(0.12))
		"eyes":
			_circle(image, Vector2(61, 72), 7, Color(0.08, 0.1, 0.12))
			_circle(image, Vector2(89, 72), 7, Color(0.08, 0.1, 0.12))
			_circle(image, Vector2(63, 69), 2, Color.white)
			_circle(image, Vector2(91, 69), 2, Color.white)
		"mouth":
			_rect(image, Rect2(61, 94, 28, 5), Color(0.12, 0.06, 0.06))
			_rect(image, Rect2(65, 99, 20, 3), accent.darkened(0.2))
		"item":
			_circle(image, Vector2(75, 75), 42, base)
			_circle_outline(image, Vector2(75, 75), 48, accent, 5)
			_rect(image, Rect2(50, 56, 50, 38), accent.darkened(0.12))
			_circle(image, Vector2(75, 75), 14, accent.lightened(0.28))
		_:
			_circle(image, Vector2(75, 80), 42, base)
			_circle_outline(image, Vector2(75, 76), 52, accent, 4)
			_circle(image, Vector2(61, 72), 6, Color(0.08, 0.1, 0.12))
			_circle(image, Vector2(89, 72), 6, Color(0.08, 0.1, 0.12))

	image.unlock()
	var png_path = "%s.png" % base_path
	image.save_png(png_path)

	var texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	ResourceSaver.save("%s_texture.tres" % base_path, texture)


func _fill(image: Image, color: Color) -> void:
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			image.set_pixel(x, y, color)


func _circle(image: Image, center: Vector2, radius: int, color: Color) -> void:
	for x in range(center.x - radius, center.x + radius + 1):
		for y in range(center.y - radius, center.y + radius + 1):
			if x < 0 or y < 0 or x >= image.get_width() or y >= image.get_height():
				continue
			if center.distance_to(Vector2(x, y)) <= radius:
				image.set_pixel(x, y, color)


func _circle_outline(image: Image, center: Vector2, radius: int, color: Color, thickness: int) -> void:
	for x in range(center.x - radius, center.x + radius + 1):
		for y in range(center.y - radius, center.y + radius + 1):
			if x < 0 or y < 0 or x >= image.get_width() or y >= image.get_height():
				continue
			var dist = center.distance_to(Vector2(x, y))
			if dist <= radius and dist >= radius - thickness:
				image.set_pixel(x, y, color)


func _rect(image: Image, rect: Rect2, color: Color) -> void:
	for x in range(rect.position.x, rect.position.x + rect.size.x):
		for y in range(rect.position.y, rect.position.y + rect.size.y):
			if x < 0 or y < 0 or x >= image.get_width() or y >= image.get_height():
				continue
			image.set_pixel(x, y, color)


func _write_appearance(folder: String, id: String, part: String, position: int, priority: int, depth: float) -> String:
	var path = "%s/%s_%s_appearance.tres" % [folder, id, part]
	var content = """[gd_resource type="Resource" load_steps=3 format=2]

[ext_resource path="res://items/global/item_appearance_data.gd" type="Script" id=1]
[ext_resource path="%s/%s_%s_texture.tres" type="Texture" id=2]

[resource]
script = ExtResource( 1 )
sprite = ExtResource( 2 )
position = %s
display_priority = %s
depth = %s
is_character_appearance = true
""" % [folder, id, part, str(position), str(priority), str(depth)]
	_write_file(path, content)
	return path


func _write_effect(folder: String, spec: Dictionary) -> String:
	var path = "%s/%s" % [folder, spec.file]
	if spec.type == "event_stat":
		var content_event = """[gd_resource type="Resource" load_steps=2 format=2]

[ext_resource path="res://effects/items/original_wave_event_stats_effect.gd" type="Script" id=1]

[resource]
script = ExtResource( 1 )
stat = "%s"
value = %s
""" % [spec.stat, str(spec.value)]
		_write_file(path, content_event)
		return path

	var script_path = spec.get("script", "res://items/global/effect.gd")
	var effect_sign_value = spec.get("sign", 3)
	var content_default = """[gd_resource type="Resource" load_steps=2 format=2]

[ext_resource path="%s" type="Script" id=1]

[resource]
script = ExtResource( 1 )
key = "%s"
text_key = ""
value = %s
custom_key = ""
storage_method = 0
effect_sign = %s
custom_args = [  ]
""" % [script_path, spec.key, str(spec.value), str(effect_sign_value)]
	_write_file(path, content_default)
	return path


func _write_character_data(folder: String, spec: Dictionary, effect_paths: Array, appearances: Array) -> void:
	var ext = [
		"""[ext_resource path="res://items/characters/character_data.gd" type="Script" id=1]""",
		"""[ext_resource path="%s/%s_icon_texture.tres" type="Texture" id=2]""" % [folder, spec.id]
	]
	var id_counter = 3
	var effect_ids = []
	for effect_path in effect_paths:
		ext.append("""[ext_resource path="%s" type="Resource" id=%s]""" % [effect_path, str(id_counter)])
		effect_ids.append("ExtResource( %s )" % str(id_counter))
		id_counter += 1

	var weapon_ids = []
	for weapon_path in spec.weapons:
		ext.append("""[ext_resource path="%s" type="Resource" id=%s]""" % [weapon_path, str(id_counter)])
		weapon_ids.append("ExtResource( %s )" % str(id_counter))
		id_counter += 1

	var appearance_ids = []
	for appearance_path in appearances:
		ext.append("""[ext_resource path="%s" type="Resource" id=%s]""" % [appearance_path, str(id_counter)])
		appearance_ids.append("ExtResource( %s )" % str(id_counter))
		id_counter += 1

	var wanted_tags = []
	for tag in spec.wanted_tags:
		wanted_tags.append("\"%s\"" % tag)

	var content = """[gd_resource type="Resource" load_steps=%s format=2]

%s

[resource]
script = ExtResource( 1 )
my_id = "character_%s"
unlocked_by_default = true
can_be_looted = true
icon = ExtResource( 2 )
name = "%s"
tier = 0
value = 1
effects = [ %s ]
tracking_text = ""
is_lockable = true
unlock_codex_descr_after_get_it = 1
is_cursed = false
curse_factor = 0.0
max_nb = -1
item_appearances = [ %s ]
tags = [  ]
wanted_tags = [ %s ]
banned_item_groups = [  ]
banned_items = [  ]
banned_upgrades = [  ]
starting_weapons = [ %s ]
starting_items = [  ]
""" % [
		str(id_counter),
		"\n".join(ext),
		spec.id,
		spec.name,
		", ".join(effect_ids),
		", ".join(appearance_ids),
		", ".join(wanted_tags),
		", ".join(weapon_ids)
	]
	_write_file("%s/%s_data.tres" % [folder, spec.id], content)


func _write_item_data(folder: String, spec: Dictionary, effect_paths: Array) -> void:
	var ext = [
		"""[ext_resource path="%s/%s_icon_texture.tres" type="Texture" id=1]""" % [folder, spec.id],
		"""[ext_resource path="res://items/global/item_data.gd" type="Script" id=2]"""
	]
	var id_counter = 3
	var effect_ids = []
	for effect_path in effect_paths:
		ext.append("""[ext_resource path="%s" type="Resource" id=%s]""" % [effect_path, str(id_counter)])
		effect_ids.append("ExtResource( %s )" % str(id_counter))
		id_counter += 1

	var tags = []
	for tag in spec.tags:
		tags.append("\"%s\"" % tag)

	var content = """[gd_resource type="Resource" load_steps=%s format=2]

%s

[resource]
script = ExtResource( 2 )
my_id = "item_%s"
unlocked_by_default = true
can_be_looted = true
icon = ExtResource( 1 )
name = "%s"
tier = %s
value = %s
effects = [ %s ]
tracking_text = ""
is_lockable = true
unlock_codex_descr_after_get_it = 1
is_cursed = false
curse_factor = 0.0
max_nb = -1
item_appearances = [  ]
tags = [ %s ]
""" % [
		str(id_counter),
		"\n".join(ext),
		spec.id,
		spec.name,
		str(spec.tier),
		str(spec.value),
		", ".join(effect_ids),
		", ".join(tags)
	]
	_write_file("%s/%s_data.tres" % [folder, spec.id], content)
