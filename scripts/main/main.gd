extends Control

const MISSIONS := [
	{"id": "urban_01", "title": "01  •  URBAN STRIKE", "chapter": "Chapter 1 — Urban", "scene": "res://scenes/missions/UrbanMission.tscn"},
	{"id": "desert_01", "title": "02  •  DESERT WATCH", "chapter": "Chapter 2 — Desert", "scene": "res://scenes/missions/DesertMission.tscn"},
	{"id": "jungle_01", "title": "03  •  JUNGLE RUN", "chapter": "Chapter 3 — Jungle", "scene": "res://scenes/missions/JungleMission.tscn"},
]
const WEAPONS := [
	{"id": "marksman", "name": "MARKSMAN", "description": "Balanced rifle • unlocked"},
	{"id": "scout", "name": "SCOUT", "description": "Fast handling • unlock at 3 total kills"},
	{"id": "heavy", "name": "HEAVY", "description": "High damage • unlock after 2 wins"},
]

var _screen: VBoxContainer
var _selection_message: Label


func _ready() -> void:
	_build_background()
	_show_home()


func _build_background() -> void:
	var background := ColorRect.new()
	background.color = Color("#101820")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	var accent := ColorRect.new()
	accent.color = Color("#e8ad4a")
	accent.anchor_left = 0.0
	accent.anchor_right = 1.0
	accent.anchor_top = 0.0
	accent.anchor_bottom = 0.0
	accent.offset_bottom = 8.0
	accent.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(accent)


func _new_screen(title: String, subtitle: String = "") -> VBoxContainer:
	if is_instance_valid(_screen):
		_screen.queue_free()
	var center := CenterContainer.new()
	center.name = "ScreenCenter"
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	_screen = VBoxContainer.new()
	_screen.custom_minimum_size = Vector2(560, 0)
	_screen.add_theme_constant_override("separation", 14)
	_screen.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(_screen)
	var heading := _label(title, 36)
	_screen.add_child(heading)
	if not subtitle.is_empty():
		var sub := _label(subtitle, 17)
		sub.add_theme_color_override("font_color", Color("#a8c4cc"))
		_screen.add_child(sub)
	return _screen


func _label(text: String, size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", Color("#f4f3ee"))
	return label


func _button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 60)
	button.add_theme_font_size_override("font_size", 19)
	return button


func _show_home() -> void:
	var stats: Dictionary = SaveManager.stats
	var screen := _new_screen("SNIPER ELITE", "TACTICAL MISSIONS • ANDROID PROTOTYPE")
	screen.add_child(_label("Wins: %d     Total kills: %d" % [stats["missions_won"], stats["total_kills"]], 18))
	var chapters := _button("CHAPTER SELECT")
	chapters.pressed.connect(_show_chapters)
	screen.add_child(chapters)
	var weapons := _button("WEAPON ARMORY")
	weapons.pressed.connect(_show_armory)
	screen.add_child(weapons)
	var exit := _button("QUIT")
	exit.pressed.connect(func(): get_tree().quit())
	screen.add_child(exit)


func _show_chapters() -> void:
	var screen := _new_screen("CHAPTER SELECT", "Complete a mission to unlock the next operation.")
	for mission in MISSIONS:
		var mission_id: String = mission["id"]
		var unlocked := SaveManager.is_mission_unlocked(mission_id)
		var completed := SaveManager.is_mission_completed(mission_id)
		var state := "  ✓ COMPLETE" if completed else ("  • READY" if unlocked else "  • LOCKED")
		var button := _button(str(mission["title"]) + state)
		button.disabled = not unlocked
		button.pressed.connect(_launch_mission.bind(mission_id, str(mission["scene"])))
		screen.add_child(button)
	var back := _button("BACK TO MENU")
	back.pressed.connect(_show_home)
	screen.add_child(back)


func _show_armory() -> void:
	var screen := _new_screen("WEAPON ARMORY", "Select an unlocked weapon for your next mission.")
	for weapon in WEAPONS:
		var weapon_id: String = weapon["id"]
		var unlocked := SaveManager.is_weapon_unlocked(weapon_id)
		var selected := SaveManager.selected_weapon_id == weapon_id
		var label_text := str(weapon["name"]) + ("  ✓ EQUIPPED" if selected else "")
		if not unlocked:
			label_text += "\n" + str(weapon["description"])
		var button := _button(label_text)
		button.disabled = not unlocked or selected
		button.pressed.connect(_select_weapon.bind(weapon_id))
		screen.add_child(button)
	var back := _button("BACK TO MENU")
	back.pressed.connect(_show_home)
	screen.add_child(back)


func _select_weapon(weapon_id: String) -> void:
	SaveManager.select_weapon(weapon_id)
	_show_armory()


func _launch_mission(mission_id: String, scene_path: String) -> void:
	if not SaveManager.is_mission_unlocked(mission_id):
		return
	SaveManager.selected_mission_id = mission_id
	var error := get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("Unable to load mission scene: %s (error %d)" % [scene_path, error])
