extends SceneTree

const TEXTURES = {
	"res://ui/zjy_splash/zjy_splash.png": "res://ui/zjy_splash/zjy_splash_texture.tres",
	"res://custom_elements/characters/antigravity/antigravity_body.png": "res://custom_elements/characters/antigravity/antigravity_body_texture.tres",
	"res://custom_elements/characters/antigravity/antigravity_belt.png": "res://custom_elements/characters/antigravity/antigravity_belt_texture.tres",
	"res://custom_elements/characters/antigravity/antigravity_eyes.png": "res://custom_elements/characters/antigravity/antigravity_eyes_texture.tres",
	"res://custom_elements/characters/antigravity/antigravity_field.png": "res://custom_elements/characters/antigravity/antigravity_field_texture.tres",
	"res://custom_elements/characters/antigravity/antigravity_goggles.png": "res://custom_elements/characters/antigravity/antigravity_goggles_texture.tres",
	"res://custom_elements/characters/antigravity/antigravity_icon.png": "res://custom_elements/characters/antigravity/antigravity_icon_texture.tres",
	"res://custom_elements/characters/antigravity/antigravity_mouth.png": "res://custom_elements/characters/antigravity/antigravity_mouth_texture.tres",
	"res://custom_elements/items/antigravity_device/antigravity_device_icon.png": "res://custom_elements/items/antigravity_device/antigravity_device_icon_texture.tres",
	"res://custom_elements/characters/zjy_vanguard/zjy_vanguard_aura.png": "res://custom_elements/characters/zjy_vanguard/zjy_vanguard_aura_texture.tres",
	"res://custom_elements/characters/zjy_vanguard/zjy_vanguard_body.png": "res://custom_elements/characters/zjy_vanguard/zjy_vanguard_body_texture.tres",
	"res://custom_elements/characters/zjy_vanguard/zjy_vanguard_eyes.png": "res://custom_elements/characters/zjy_vanguard/zjy_vanguard_eyes_texture.tres",
	"res://custom_elements/characters/zjy_vanguard/zjy_vanguard_icon.png": "res://custom_elements/characters/zjy_vanguard/zjy_vanguard_icon_texture.tres",
	"res://custom_elements/characters/zjy_vanguard/zjy_vanguard_mouth.png": "res://custom_elements/characters/zjy_vanguard/zjy_vanguard_mouth_texture.tres",
	"res://custom_elements/characters/quantum_smith/quantum_smith_body.png": "res://custom_elements/characters/quantum_smith/quantum_smith_body_texture.tres",
	"res://custom_elements/characters/quantum_smith/quantum_smith_coil.png": "res://custom_elements/characters/quantum_smith/quantum_smith_coil_texture.tres",
	"res://custom_elements/characters/quantum_smith/quantum_smith_eyes.png": "res://custom_elements/characters/quantum_smith/quantum_smith_eyes_texture.tres",
	"res://custom_elements/characters/quantum_smith/quantum_smith_icon.png": "res://custom_elements/characters/quantum_smith/quantum_smith_icon_texture.tres",
	"res://custom_elements/characters/quantum_smith/quantum_smith_mouth.png": "res://custom_elements/characters/quantum_smith/quantum_smith_mouth_texture.tres",
	"res://custom_elements/characters/void_chef/void_chef_aura.png": "res://custom_elements/characters/void_chef/void_chef_aura_texture.tres",
	"res://custom_elements/characters/void_chef/void_chef_body.png": "res://custom_elements/characters/void_chef/void_chef_body_texture.tres",
	"res://custom_elements/characters/void_chef/void_chef_eyes.png": "res://custom_elements/characters/void_chef/void_chef_eyes_texture.tres",
	"res://custom_elements/characters/void_chef/void_chef_icon.png": "res://custom_elements/characters/void_chef/void_chef_icon_texture.tres",
	"res://custom_elements/characters/void_chef/void_chef_mouth.png": "res://custom_elements/characters/void_chef/void_chef_mouth_texture.tres",
	"res://custom_elements/characters/paper_samurai/paper_samurai_blade.png": "res://custom_elements/characters/paper_samurai/paper_samurai_blade_texture.tres",
	"res://custom_elements/characters/paper_samurai/paper_samurai_body.png": "res://custom_elements/characters/paper_samurai/paper_samurai_body_texture.tres",
	"res://custom_elements/characters/paper_samurai/paper_samurai_eyes.png": "res://custom_elements/characters/paper_samurai/paper_samurai_eyes_texture.tres",
	"res://custom_elements/characters/paper_samurai/paper_samurai_icon.png": "res://custom_elements/characters/paper_samurai/paper_samurai_icon_texture.tres",
	"res://custom_elements/characters/paper_samurai/paper_samurai_scarf.png": "res://custom_elements/characters/paper_samurai/paper_samurai_scarf_texture.tres",
	"res://custom_elements/characters/debt_king/debt_king_body.png": "res://custom_elements/characters/debt_king/debt_king_body_texture.tres",
	"res://custom_elements/characters/debt_king/debt_king_coins.png": "res://custom_elements/characters/debt_king/debt_king_coins_texture.tres",
	"res://custom_elements/characters/debt_king/debt_king_eyes.png": "res://custom_elements/characters/debt_king/debt_king_eyes_texture.tres",
	"res://custom_elements/characters/debt_king/debt_king_icon.png": "res://custom_elements/characters/debt_king/debt_king_icon_texture.tres",
	"res://custom_elements/characters/debt_king/debt_king_mouth.png": "res://custom_elements/characters/debt_king/debt_king_mouth_texture.tres",
	"res://custom_elements/items/event_contract/event_contract_icon.png": "res://custom_elements/items/event_contract/event_contract_icon_texture.tres",
	"res://custom_elements/items/void_marinade/void_marinade_icon.png": "res://custom_elements/items/void_marinade/void_marinade_icon_texture.tres",
	"res://custom_elements/items/paper_crown/paper_crown_icon.png": "res://custom_elements/items/paper_crown/paper_crown_icon_texture.tres",
	"res://custom_elements/items/pocket_arena_ticket/pocket_arena_ticket_icon.png": "res://custom_elements/items/pocket_arena_ticket/pocket_arena_ticket_icon_texture.tres",
	"res://custom_elements/items/reactor_pebble/reactor_pebble_icon.png": "res://custom_elements/items/reactor_pebble/reactor_pebble_icon_texture.tres",
	"res://custom_elements/characters/storm_cartographer/storm_cartographer_body.png": "res://custom_elements/characters/storm_cartographer/storm_cartographer_body_texture.tres",
	"res://custom_elements/characters/storm_cartographer/storm_cartographer_eyes.png": "res://custom_elements/characters/storm_cartographer/storm_cartographer_eyes_texture.tres",
	"res://custom_elements/characters/storm_cartographer/storm_cartographer_icon.png": "res://custom_elements/characters/storm_cartographer/storm_cartographer_icon_texture.tres",
	"res://custom_elements/characters/storm_cartographer/storm_cartographer_mouth.png": "res://custom_elements/characters/storm_cartographer/storm_cartographer_mouth_texture.tres",
	"res://custom_elements/characters/storm_cartographer/storm_cartographer_orbit.png": "res://custom_elements/characters/storm_cartographer/storm_cartographer_orbit_texture.tres",
	"res://custom_elements/characters/orchard_alchemist/orchard_alchemist_body.png": "res://custom_elements/characters/orchard_alchemist/orchard_alchemist_body_texture.tres",
	"res://custom_elements/characters/orchard_alchemist/orchard_alchemist_eyes.png": "res://custom_elements/characters/orchard_alchemist/orchard_alchemist_eyes_texture.tres",
	"res://custom_elements/characters/orchard_alchemist/orchard_alchemist_flask.png": "res://custom_elements/characters/orchard_alchemist/orchard_alchemist_flask_texture.tres",
	"res://custom_elements/characters/orchard_alchemist/orchard_alchemist_icon.png": "res://custom_elements/characters/orchard_alchemist/orchard_alchemist_icon_texture.tres",
	"res://custom_elements/characters/orchard_alchemist/orchard_alchemist_mouth.png": "res://custom_elements/characters/orchard_alchemist/orchard_alchemist_mouth_texture.tres",
	"res://custom_elements/characters/pocket_brawler/pocket_brawler_body.png": "res://custom_elements/characters/pocket_brawler/pocket_brawler_body_texture.tres",
	"res://custom_elements/characters/pocket_brawler/pocket_brawler_eyes.png": "res://custom_elements/characters/pocket_brawler/pocket_brawler_eyes_texture.tres",
	"res://custom_elements/characters/pocket_brawler/pocket_brawler_gloves.png": "res://custom_elements/characters/pocket_brawler/pocket_brawler_gloves_texture.tres",
	"res://custom_elements/characters/pocket_brawler/pocket_brawler_icon.png": "res://custom_elements/characters/pocket_brawler/pocket_brawler_icon_texture.tres",
	"res://custom_elements/characters/pocket_brawler/pocket_brawler_mouth.png": "res://custom_elements/characters/pocket_brawler/pocket_brawler_mouth_texture.tres",
	"res://custom_elements/characters/reactor_saint/reactor_saint_body.png": "res://custom_elements/characters/reactor_saint/reactor_saint_body_texture.tres",
	"res://custom_elements/characters/reactor_saint/reactor_saint_eyes.png": "res://custom_elements/characters/reactor_saint/reactor_saint_eyes_texture.tres",
	"res://custom_elements/characters/reactor_saint/reactor_saint_halo.png": "res://custom_elements/characters/reactor_saint/reactor_saint_halo_texture.tres",
	"res://custom_elements/characters/reactor_saint/reactor_saint_icon.png": "res://custom_elements/characters/reactor_saint/reactor_saint_icon_texture.tres",
	"res://custom_elements/characters/reactor_saint/reactor_saint_mouth.png": "res://custom_elements/characters/reactor_saint/reactor_saint_mouth_texture.tres",
}


func _init() -> void:
	for source_path in TEXTURES.keys():
		var image = Image.new()
		var load_error = image.load(source_path)
		if load_error != OK:
			printerr("Failed to load source image: %s (%s)" % [source_path, load_error])
			continue

		var texture = ImageTexture.new()
		texture.create_from_image(image, 0)

		var save_path = TEXTURES[source_path]
		var save_error = ResourceSaver.save(save_path, texture)
		if save_error != OK:
			printerr("Failed to save texture resource: %s (%s)" % [save_path, save_error])

	quit()
