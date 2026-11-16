extends Node

signal objective_updated(current_kills: int, required_kills: int)
signal mission_completed
signal mission_failed

@export var required_kills: int = 3

var current_kills := 0
var is_active := false
var is_finished := false
var _registered_enemies: Dictionary = {}


func _ready() -> void:
	start_mission()
	for enemy in get_tree().get_nodes_in_group("mission_enemies"):
		register_enemy(enemy)
	for player in get_tree().get_nodes_in_group("players"):
		register_player(player)


func start_mission() -> void:
	current_kills = 0
	is_finished = false
	is_active = true
	objective_updated.emit(current_kills, required_kills)


func register_enemy(enemy: Node) -> void:
	if not is_instance_valid(enemy) or not enemy.has_signal("died"):
		return
	var enemy_id := enemy.get_instance_id()
	if _registered_enemies.has(enemy_id):
		return
	_registered_enemies[enemy_id] = true
	var callback := Callable(self, "_on_enemy_died")
	if not enemy.is_connected("died", callback):
		enemy.connect("died", callback)


func register_player(player: Node) -> void:
	if not is_instance_valid(player) or not player.has_signal("died"):
		return
	var callback := Callable(self, "_on_player_died")
	if not player.is_connected("died", callback):
		player.connect("died", callback)


func _on_enemy_died(enemy: Node) -> void:
	if not is_active or is_finished:
		return
	if is_instance_valid(enemy):
		var enemy_id := enemy.get_instance_id()
		if not _registered_enemies.has(enemy_id):
			return
		_registered_enemies.erase(enemy_id)
	current_kills += 1
	objective_updated.emit(current_kills, required_kills)
	if current_kills >= required_kills:
		is_finished = true
		is_active = false
		mission_completed.emit()


func _on_player_died() -> void:
	if not is_active or is_finished:
		return
	is_finished = true
	is_active = false
	mission_failed.emit()
