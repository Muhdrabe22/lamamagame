extends CharacterBody2D

signal health_changed(current_health: int, maximum_health: int)
signal died

@export var max_health: int = 100
@export var patrol_speed: float = 55.0
@export var chase_speed: float = 90.0
@export var detection_range: float = 520.0
@export var attack_range: float = 300.0
@export var attack_damage: int = 10
@export var attack_interval: float = 1.5
@export var patrol_points: Array[Vector2] = []

var current_health: int
var _is_dead := false
var _player: Node2D
var _patrol_origin := Vector2.ZERO
var _patrol_index := 0
var _attack_cooldown := 0.0


func _ready() -> void:
	current_health = max_health
	add_to_group("mission_enemies")
	_patrol_origin = global_position
	if patrol_points.is_empty():
		patrol_points = [Vector2(-55, 0), Vector2(55, 0)]
	_find_player()
	health_changed.emit(current_health, max_health)


func _physics_process(delta: float) -> void:
	if _is_dead:
		return
	_attack_cooldown = maxf(0.0, _attack_cooldown - delta)
	if not is_instance_valid(_player):
		_find_player()

	if is_instance_valid(_player):
		var distance := global_position.distance_to(_player.global_position)
		if distance <= detection_range:
			if distance > attack_range:
				_move_toward_position(_player.global_position, chase_speed)
			else:
				velocity = Vector2.ZERO
				_attack_player()
			move_and_slide()
			return

	_patrol(delta)
	move_and_slide()


func _find_player() -> void:
	var players := get_tree().get_nodes_in_group("players")
	if not players.is_empty() and players[0] is Node2D:
		_player = players[0] as Node2D


func _patrol(_delta: float) -> void:
	if patrol_points.is_empty():
		velocity = Vector2.ZERO
		return
	var target := _patrol_origin + patrol_points[_patrol_index]
	if global_position.distance_to(target) < 8.0:
		_patrol_index = (_patrol_index + 1) % patrol_points.size()
		target = _patrol_origin + patrol_points[_patrol_index]
	_move_toward_position(target, patrol_speed)


func _move_toward_position(target: Vector2, speed: float) -> void:
	var direction := global_position.direction_to(target)
	velocity = direction * speed


func _attack_player() -> void:
	if _attack_cooldown > 0.0 or not is_instance_valid(_player):
		return
	_attack_cooldown = attack_interval
	if _player.has_method("take_damage"):
		_player.call("take_damage", attack_damage)


func take_damage(amount: int, _source: Node = null) -> void:
	if _is_dead or amount <= 0:
		return
	current_health = maxi(0, current_health - amount)
	health_changed.emit(current_health, max_health)
	if current_health == 0:
		_is_dead = true
		velocity = Vector2.ZERO
		died.emit(self)
		queue_free()
