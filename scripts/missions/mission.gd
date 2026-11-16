extends Node

signal objective_updated(current_kills: int, required_kills: int)
signal mission_completed
signal mission_failed

@export var mission_id: String = "urban_01"
@export var required_kills: int = 3

var current_kills := 0
var is_active := false
var is_finished := false
var elapsed_seconds := 0.0
var _registered_enemies: Dictionary = {}
var _result_recorded := false


func _ready() -> void:
	start_mission()
	for enemy in get_tree().get_nodes_in_group("mission_enemies"):
		register_enemy(enemy)
	for player in get_tree().get_nodes_in_group("players"):
		register_player(player)


func _process(delta: float) -> void:
	if is_active:
		elapsed_seconds += delta


func start_mission() -> void:
	current_kills = 0
	elapsed_seconds = 0.0
	_result_recorded = false
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
		_finish_mission(true)


func _on_player_died() -> void:
	if is_active and not is_finished:
		_finish_mission(false)


func _finish_mission(won: bool) -> void:
	if is_finished:
		return
	is_finished = true
	is_active = false
	for enemy in get_tree().get_nodes_in_group("mission_enemies"):
		enemy.set_physics_process(false)
	if not _result_recorded:
		_result_recorded = true
		SaveManager.record_mission_result(won, current_kills, elapsed_seconds, mission_id)
	if won:
		AudioManager.play_sfx("enemy_down")
		mission_completed.emit()
	else:
		AudioManager.play_sfx("hurt")
		mission_failed.emit()
