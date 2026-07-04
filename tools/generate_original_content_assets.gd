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
			{"file": "luck_effect.tres", "type": "default", "key": "stat_luck", "value": 10},
			{"file": "xp_effect.tres", "type": "default", "key": "xp_gain", "value": 10},
			{"file": "event_reward_effect.tres", "type": "default", "script": "res://effects/items/original_wave_event_reward_effect.gd", "key": "original_wave_event_reward", "value": 35},
			{"file": "special_range_effect.tres", "type": "event_stat", "stat": "stat_range", "value": 25},
			{"file": "enemy_health_tradeoff_effect.tres", "type": "default", "key": "enemy_health", "value": 12, "sign": 1}
		],
		"wanted_tags": ["stat_luck", "stat_range", "economy"]
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
		_make_texture("%s/%s_%s" % [folder, spec.id, part], colors[0], colors[1], part)

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
	_make_texture("%s/%s_icon" % [folder, spec.id], colors[0], colors[1], "item")

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


func _make_texture(base_path: String, base: Color, accent: Color, kind: String) -> void:
	var image = Image.new()
	image.create(150, 150, false, Image.FORMAT_RGBA8)
	image.lock()
	_fill(image, Color(0, 0, 0, 0))

	match kind:
		"body":
			_circle(image, Vector2(75, 80), 42, base)
			_circle(image, Vector2(55, 58), 12, accent)
			_circle(image, Vector2(95, 58), 12, accent)
			_rect(image, Rect2(49, 106, 52, 13), base.darkened(0.25))
		"accessory":
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
