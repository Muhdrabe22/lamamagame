extends Control

const ROUND_LENGTH := 30.0
const TARGET_SIZE := Vector2(84.0, 84.0)

var score := 0
var misses := 0
var time_left := ROUND_LENGTH
var round_running := false
var target_button: Button
var score_label: Label
var time_label: Label
var status_label: Label
var arena: Control
var start_button: Button
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()
	_build_ui()
	_show_menu()


func _process(delta: float) -> void:
	if not round_running:
		return
	time_left = maxf(0.0, time_left - delta)
	time_label.text = "Time: %02d" % int(ceil(time_left))
	if time_left <= 0.0:
		_finish_round()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color("#101820")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var menu := Control.new()
	menu.name = "MenuScreen"
	menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(menu)

	var menu_box := VBoxContainer.new()
	menu_box.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	menu_box.position = Vector2(-220.0, -180.0)
	menu_box.size = Vector2(440.0, 360.0)
	menu_box.add_theme_constant_override("separation", 20)
	menu_box.alignment = BoxContainer.ALIGNMENT_CENTER
	menu.add_child(menu_box)

	var title := _make_label("SNIPER ELITE", 38)
	menu_box.add_child(title)
	var subtitle := _make_label("ARCADE TARGET PRACTICE", 18)
	subtitle.add_theme_color_override("font_color", Color("#a8c4cc"))
	menu_box.add_child(subtitle)
	var instructions := _make_label("Tap the targets. Score as many points as you can in 30 seconds.", 17)
	instructions.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	menu_box.add_child(instructions)

	start_button = _make_button("Start")
	start_button.pressed.connect(_start_game)
	menu_box.add_child(start_button)

	var game := Control.new()
	game.name = "GameScreen"
	game.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	game.visible = false
	add_child(game)

	var layout := VBoxContainer.new()
	layout.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layout.add_theme_constant_override("separation", 12)
	layout.add_theme_constant_override("margin_left", 24)
	layout.add_theme_constant_override("margin_top", 24)
	layout.add_theme_constant_override("margin_right", 24)
	layout.add_theme_constant_override("margin_bottom", 24)
	game.add_child(layout)

	var header := HBoxContainer.new()
	header.custom_minimum_size = Vector2(0.0, 56.0)
	layout.add_child(header)
	score_label = _make_label("Score: 0", 22)
	score_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(score_label)
	time_label = _make_label("Time: 30", 22)
	time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	time_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(time_label)

	arena = Control.new()
	arena.name = "TargetArena"
	arena.size_flags_vertical = Control.SIZE_EXPAND_FILL
	arena.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	arena.mouse_filter = Control.MOUSE_FILTER_STOP
	arena.gui_input.connect(_on_arena_input)
	layout.add_child(arena)

	var arena_background := ColorRect.new()
	arena_background.color = Color("#192a32")
	arena_background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	arena_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	arena.add_child(arena_background)

	target_button = _make_button("◎")
	target_button.custom_minimum_size = TARGET_SIZE
	target_button.size = TARGET_SIZE
	target_button.add_theme_font_size_override("font_size", 38)
	var target_style := StyleBoxFlat.new()
	target_style.bg_color = Color("#e8ad4a")
	target_style.corner_radius_top_left = 42
	target_style.corner_radius_top_right = 42
	target_style.corner_radius_bottom_left = 42
	target_style.corner_radius_bottom_right = 42
	target_button.add_theme_stylebox_override("normal", target_style)
	var target_hover := target_style.duplicate() as StyleBoxFlat
	target_hover.bg_color = Color("#ffd27a")
	target_button.add_theme_stylebox_override("hover", target_hover)
	target_button.add_theme_color_override("font_color", Color("#17242b"))
	target_button.add_theme_color_override("font_hover_color", Color("#17242b"))
	target_button.pressed.connect(_on_target_hit)
	arena.add_child(target_button)

	var footer := HBoxContainer.new()
	footer.custom_minimum_size = Vector2(0.0, 60.0)
	layout.add_child(footer)
	status_label = _make_label("Tap the target!", 18)
	status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	footer.add_child(status_label)
	var replay_button := _make_button("Restart")
	replay_button.custom_minimum_size = Vector2(150.0, 56.0)
	replay_button.pressed.connect(_start_game)
	footer.add_child(replay_button)
	var menu_button := _make_button("Menu")
	menu_button.custom_minimum_size = Vector2(120.0, 56.0)
	menu_button.pressed.connect(_show_menu)
	footer.add_child(menu_button)


func _make_label(text: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color("#f4f3ee"))
	return label


func _make_button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0.0, 64.0)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 20)
	return button


func _show_menu() -> void:
	$MenuScreen.visible = true
	$GameScreen.visible = false
	round_running = false


func _start_game() -> void:
	score = 0
	misses = 0
	time_left = ROUND_LENGTH
	round_running = true
	$MenuScreen.visible = false
	$GameScreen.visible = true
	score_label.text = "Score: 0"
	time_label.text = "Time: 30"
	status_label.text = "Tap the target!"
	start_button.text = "Start"
	call_deferred("_move_target")


func _move_target() -> void:
	if not is_instance_valid(target_button) or arena.size.x <= 0.0 or arena.size.y <= 0.0:
		return
	var max_x: float = maxf(8.0, arena.size.x - TARGET_SIZE.x - 8.0)
	var max_y: float = maxf(8.0, arena.size.y - TARGET_SIZE.y - 8.0)
	target_button.position = Vector2(rng.randf_range(8.0, max_x), rng.randf_range(8.0, max_y))


func _on_target_hit() -> void:
	if not round_running:
		return
	score += 1
	score_label.text = "Score: %d" % score
	status_label.text = "Nice shot!"
	_move_target()


func _on_arena_input(event: InputEvent) -> void:
	if not round_running:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		misses += 1
		status_label.text = "Misses: %d" % misses


func _finish_round() -> void:
	round_running = false
	target_button.hide()
	status_label.text = "Time! Final score: %d  ·  Misses: %d" % [score, misses]
	start_button.text = "Play again"
	$MenuScreen.visible = true
