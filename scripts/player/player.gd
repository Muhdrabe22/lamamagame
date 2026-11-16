extends CharacterBody2D

signal health_changed(current_health: int, maximum_health: int)
signal died

@export var move_speed: float = 240.0
@export var max_health: int = 100
@export var weapon_path: NodePath = ^"Weapon"

var current_health: int
var _move_input: Vector2 = Vector2.ZERO
var _weapon: Node
var _is_dead := false


func _ready() -> void:
	current_health = max_health
	add_to_group("players")
	_weapon = get_node_or_null(weapon_path)
	health_changed.emit(current_health, max_health)


func _physics_process(_delta: float) -> void:
	if _is_dead:
		velocity = Vector2.ZERO
		return

	var direction := _move_input
	if direction.is_zero_approx():
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction.normalized() * move_speed
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if _is_dead:
		return

	if event is InputEventMouseMotion:
		aim_at(get_global_mouse_position())
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		aim_at(get_global_mouse_position())
		fire()
	elif event is InputEventScreenTouch and event.pressed:
		var touch_position := get_global_transform_with_canvas().affine_inverse() * event.position
		aim_at(to_global(touch_position))
		fire()
	elif event is InputEventScreenDrag:
		var drag_position := get_global_transform_with_canvas().affine_inverse() * event.position
		aim_at(to_global(drag_position))


func set_move_input(input_vector: Vector2) -> void:
	_move_input = input_vector.limit_length(1.0)


func aim_at(world_position: Vector2) -> void:
	if is_instance_valid(_weapon) and _weapon is Node2D:
		(_weapon as Node2D).global_rotation = (world_position - (_weapon as Node2D).global_position).angle()


func fire() -> void:
	if is_instance_valid(_weapon) and _weapon.has_method("fire"):
		_weapon.call("fire")


func take_damage(amount: int) -> void:
	if _is_dead or amount <= 0:
		return
	current_health = maxi(0, current_health - amount)
	health_changed.emit(current_health, max_health)
	if current_health == 0:
		_is_dead = true
		velocity = Vector2.ZERO
		died.emit()
