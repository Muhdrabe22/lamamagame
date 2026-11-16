extends CanvasLayer

@export var player_path: NodePath = ^"../Player"
@export var mission_path: NodePath = ^"../MissionController"

var _player: Node
var _mission: Node
var _health_label: Label
var _ammo_label: Label
var _objective_label: Label
var _result_label: Label
var _move_buttons: Dictionary = {}
var _move_state: Dictionary = {"left": false, "right": false, "up": false, "down": false}


func _ready() -> void:
	_player = get_node_or_null(player_path)
	_mission = get_node_or_null(mission_path)
	_build_ui()
	_connect_game_signals()
	_refresh_labels()


func _build_ui() -> void:
	var frame := MarginContainer.new()
	frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.add_theme_constant_override("margin_left", 24)
	frame.add_theme_constant_override("margin_top", 22)
	frame.add_theme_constant_override("margin_right", 24)
	frame.add_theme_constant_override("margin_bottom", 24)
	add_child(frame)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 12)
	frame.add_child(layout)

	var top_row := HBoxContainer.new()
	layout.add_child(top_row)
	_health_label = _new_label("Health: --", 22)
	_health_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_row.add_child(_health_label)
	_ammo_label = _new_label("Ammo: --", 22)
	_ammo_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_ammo_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_row.add_child(_ammo_label)

	_objective_label = _new_label("Objective: 0 / 3", 20)
	layout.add_child(_objective_label)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(spacer)

	_result_label = _new_label("Tap the screen to aim and fire", 18)
	_result_label.custom_minimum_size = Vector2(0, 42)
	layout.add_child(_result_label)

	var controls := HBoxContainer.new()
	controls.add_theme_constant_override("separation", 8)
	controls.custom_minimum_size = Vector2(0, 76)
	layout.add_child(controls)

	var movement := GridContainer.new()
	movement.columns = 3
	movement.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	controls.add_child(movement)
	_add_empty_cell(movement)
	_add_move_button(movement, "up", "▲")
	_add_empty_cell(movement)
	_add_move_button(movement, "left", "◀")
	_add_move_button(movement, "down", "▼")
	_add_move_button(movement, "right", "▶")

	var actions := VBoxContainer.new()
	actions.custom_minimum_size = Vector2(150, 0)
	controls.add_child(actions)
	var shoot_button := _new_button("FIRE")
	shoot_button.custom_minimum_size = Vector2(150, 42)
	shoot_button.pressed.connect(_on_shoot_pressed)
	actions.add_child(shoot_button)
	var reload_button := _new_button("RELOAD")
	reload_button.custom_minimum_size = Vector2(150, 30)
	reload_button.pressed.connect(_on_reload_pressed)
	actions.add_child(reload_button)


func _new_label(text: String, size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", Color("#f4f3ee"))
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	return label


func _new_button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.add_theme_font_size_override("font_size", 18)
	return button


func _add_empty_cell(grid: GridContainer) -> void:
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(56, 48)
	grid.add_child(spacer)


func _add_move_button(grid: GridContainer, direction: String, text: String) -> void:
	var button := _new_button(text)
	button.custom_minimum_size = Vector2(56, 48)
	button.button_down.connect(_on_move_button_down.bind(direction))
	button.button_up.connect(_on_move_button_up.bind(direction))
	grid.add_child(button)
	_move_buttons[direction] = button


func _connect_game_signals() -> void:
	if is_instance_valid(_player):
		if _player.has_signal("health_changed"):
			_player.health_changed.connect(_on_health_changed)
		if _player.has_signal("died"):
			_player.died.connect(_on_player_died)
		var weapon: Node = _player.get_node_or_null("Weapon")
		if is_instance_valid(weapon) and weapon.has_signal("ammo_changed"):
			weapon.ammo_changed.connect(_on_ammo_changed)
	if is_instance_valid(_mission):
		_mission.objective_updated.connect(_on_objective_updated)
		_mission.mission_completed.connect(_on_mission_completed)
		_mission.mission_failed.connect(_on_mission_failed)


func _refresh_labels() -> void:
	if is_instance_valid(_player):
		_on_health_changed(_player.current_health, _player.max_health)
		var weapon: Node = _player.get_node_or_null("Weapon")
		if is_instance_valid(weapon):
			_on_ammo_changed(weapon.current_ammo, weapon.magazine_size)
	if is_instance_valid(_mission):
		_on_objective_updated(_mission.current_kills, _mission.required_kills)


func _on_health_changed(current: int, maximum: int) -> void:
	_health_label.text = "Health: %d / %d" % [current, maximum]


func _on_ammo_changed(current: int, maximum: int) -> void:
	_ammo_label.text = "Ammo: %d / %d" % [current, maximum]


func _on_objective_updated(current: int, required: int) -> void:
	_objective_label.text = "Eliminate enemies: %d / %d" % [current, required]


func _on_mission_completed() -> void:
	_result_label.text = "MISSION COMPLETE — tap Restart to play again"


func _on_mission_failed() -> void:
	_result_label.text = "MISSION FAILED — player down"


func _on_player_died() -> void:
	_result_label.text = "Player down"


func _on_move_button_down(direction: String) -> void:
	_move_state[direction] = true
	_update_player_movement()


func _on_move_button_up(direction: String) -> void:
	_move_state[direction] = false
	_update_player_movement()


func _update_player_movement() -> void:
	if not is_instance_valid(_player):
		return
	var direction := Vector2.ZERO
	direction.x = float(_move_state["right"]) - float(_move_state["left"])
	direction.y = float(_move_state["down"]) - float(_move_state["up"])
	_player.set_move_input(direction.normalized())


func _on_shoot_pressed() -> void:
	if is_instance_valid(_player):
		_player.fire()


func _on_reload_pressed() -> void:
	if not is_instance_valid(_player):
		return
	var weapon: Node = _player.get_node_or_null("Weapon")
	if is_instance_valid(weapon) and weapon.has_method("reload"):
		weapon.reload()
