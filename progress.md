Original prompt: 这个是我的游戏项目，但是有很多bug，之前添加了一个 原创角色也是很多bug，你来修复一下，并且让这个游戏更有趣加入我们个人的创意

## 2026-07-04

- Fixed Antigravity's missing real character mechanic by adding Antigravity Charge.
- Antigravity Charge uses `temp_stats_per_interval_while_moving`: while moving, the character gains temporary attack speed and dodge stacks over time.
- Current balance: +6 attack speed and +1 dodge per moving tick, up to 5 stacks, reset when hit.
- Registered the new effect in `Keys`, `RunData`, `ItemService`, player movement timer logic, and translations.
- Godot validation passed with `Godot_v3.7-dev1_win64.exe --path ... --quit --verbose`.

## Notes

- The visual oversized-image issue had already been fixed before this pass with layered 150x150 Antigravity sprites and texture `.tres` resources.
- If the character still needs stronger identity later, good next additions would be a visible charge ring pulse per stack or a short "gravity burst" when max stacks are reached.

## 2026-07-04 Continued

- Replaced the old Blobfish boot entry with a lightweight `ZJY` splash scene.
- New main scene: `res://ui/zjy_splash/zjy_splash.tscn`.
- The zjy splash waits briefly for progress data, can be skipped with accept/cancel, and has a max wait fallback so the game does not depend on the old Blobfish animation finishing.
- Added two original characters:
  - `ZJY Vanguard`: fast movement character with moving charge stacks. Gains attack speed and speed while moving, up to 5 stacks, reset when hit.
  - `Quantum Smith`: engineering economy character. Converts part of end-of-wave materials into Engineering, with harvesting/engineering bonuses and combat tradeoffs.
- Generated small transparent 150x150 layered character sprites and `.tres` texture resources for both characters.
- Registered both characters through `ItemService._register_custom_resource`.
- Godot validation passed after loading the zjy splash texture and both character data resources.

## 2026-07-04 Original Gameplay Pack

- Added three more unlocked original characters:
  - `Void Chef`: consumable/luck/explosion character. Consumables trigger explosions, full-health consumables grow explosion damage, but shop items cost more.
  - `Paper Samurai`: fragile high-crit speed character. Gains temporary crit chance while moving, up to 6 stacks, reset when hit.
  - `Debt King`: risky economy character. Items and weapons are cheaper, luck is higher, but armor/speed are lower and 30% of end-wave materials convert into percent damage.
- Generated small transparent layered 150x150 PNG sprites and exported `.tres` textures for all three characters.
- Registered the new characters through `ItemService._register_custom_resource`.
- Added original random wave events:
  - `Overclocked Swarm`: faster enemies, more enemy materials.
  - `Heavy Gravity`: tougher/slower enemies, more enemy materials.
  - `Glass Horde`: fragile but more dangerous enemies, more enemy materials.
  - `Gold Rush`: faster/dangerous enemies, much more enemy materials.
- Wave events roll after wave 1, are guaranteed every 3rd wave, never apply to the final wave, and restore base enemy scaling at wave end.
- Event names are shown on the wave label, and event material multipliers apply only to enemy material drops.
- Validation passed:
  - Texture export script: `Godot_v3.7-dev1_win64.exe --path ... -s res://import_antigravity_textures.gd`.
  - Project parse/startup: `Godot_v3.7-dev1_win64.exe --path ... --quit --verbose`.
  - Temporary custom character loader checked all six custom character resources and was removed afterward.

## 2026-07-04 Wave Event Upgrade

- Upgraded original wave events from enemy stat modifiers into recognizable level variants.
- Added map-size multipliers, wave-duration multipliers, and temporary player stats per event.
- Expanded the event pool to eight variants:
  - `Overclocked Swarm`: faster enemies, attack-speed boost.
  - `Heavy Gravity`: smaller/tougher wave, armor boost.
  - `Glass Horde`: fragile but high-damage enemies, crit boost.
  - `Gold Rush`: shorter, faster, richer wave, speed boost.
  - `Pocket Arena`: compact high-pressure arena, dodge boost.
  - `Frontier Chase`: wider arena with faster enemies, range boost.
  - `Unstable Reactor`: short high-damage wave, damage and attack-speed boost.
  - `Rich Static`: richer slightly tougher wave, luck boost.
- Added event-tinted background gradients so special waves are visible immediately, not only in the wave label.
- Validation passed with `Godot_v3.7-dev1_win64.exe --path ... --quit --verbose`.

## 2026-07-04 Original Item Pack

- Added special-wave clear rewards: clearing an original wave event now grants extra materials based on the current wave and event difficulty.
- Added `original_wave_event_reward` as a new effect key with a custom display script.
- Added five unlocked original items:
  - `Event Contract`: +50% special wave clear rewards, +Luck, small Speed tradeoff.
  - `Void Marinade`: consumables can trigger smaller void explosions, with consumable healing and Luck.
  - `Paper Crown`: high Crit Chance and Crit Damage, with a Max HP tradeoff.
  - `Pocket Arena Ticket`: smaller maps, more Dodge, and more enemy material drops.
  - `Reactor Pebble`: more Damage and Attack Speed, with an Armor tradeoff.
- Generated original item icons and exported them as `.tres` textures.
- Registered all five items through `ItemService._register_custom_resource`.
- Validation passed:
  - Texture export script: `Godot_v3.7-dev1_win64.exe --path ... -s res://import_antigravity_textures.gd`.
  - Project parse/startup: `Godot_v3.7-dev1_win64.exe --path ... --quit --verbose`.
  - Temporary original item loader checked all five item resources and was removed afterward.

## 2026-07-04 Original Character Pack 2

- Added two small reusable mechanics:
  - `original_wave_event_chance`: increases the chance for original special waves to appear.
  - `stats_on_fruit_effect`: lets fruit permanently grant configured stats with a configurable chance.
- Updated original special wave rolling to respect `original_wave_event_chance`.
- Added four more unlocked original characters:
  - `Storm Cartographer`: special-wave specialist. Greatly increases special wave chance and special wave rewards, with faster enemies as the tradeoff.
  - `Orchard Alchemist`: fruit-growth character. Fruit grants permanent Elemental Damage and can grant Luck, with lower starting percent damage.
  - `Pocket Brawler`: compact arena pressure character. Smaller map, more enemies, more Dodge, moving Attack Speed, and end-wave materials for living enemies.
  - `Reactor Saint`: overcharged engineering character. Engineering, structure attack speed, attack speed, low armor, and converts end-wave materials into Attack Speed.
- Generated small transparent layered 150x150 PNG sprites and exported `.tres` textures for all four characters.
- Registered all four characters through `ItemService._register_custom_resource`.
- Validation passed:
  - Texture export script: `Godot_v3.7-dev1_win64.exe --path ... -s res://import_antigravity_textures.gd`.
  - Project parse/startup: `Godot_v3.7-dev1_win64.exe --path ... --quit --verbose`.
  - Temporary custom character loader checked all ten custom character resources and was removed afterward.

## 2026-07-04 PvZ-Inspired Enemy Mutation Pass

- Added original special-wave enemy mutations inspired by the "variant enemy" style common in tower-defense mods.
- Mutations are rolled alongside original special wave events and shown in the wave label as `EVENT / MUTATION`.
- Added six mutation variants:
  - `Armored`: higher health, slower enemies, slightly higher rewards.
  - `Frenzy`: lower health but higher damage/speed and higher rewards.
  - `Golden`: moderate all-around danger with much higher rewards.
  - `Mini`: smaller, faster, weaker enemies with extra rewards.
  - `Bulwark`: large slow durable enemies with better rewards.
  - `Static`: faster, harder-hitting enemies with reactor-green tint.
- Mutations visually tint and scale enemies when they spawn or respawn.
- Mutation material multipliers now stack with original special-wave material multipliers and clear rewards.
- Validation passed with `Godot_v3.7-dev1_win64.exe --path ... --quit --verbose`.
