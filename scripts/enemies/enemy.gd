extends Area2D

signal health_changed(current_health: int, maximum_health: int)
signal died(enemy: Node)

@export var max_health: int = 100

var current_health: int
var _is_dead := false


func _ready() -> void:
	current_health = max_health
	add_to_group("mission_enemies")
	health_changed.emit(current_health, max_health)


func take_damage(amount: int, _source: Node = null) -> void:
	if _is_dead or amount <= 0:
		return
	current_health = maxi(0, current_health - amount)
	health_changed.emit(current_health, max_health)
	if current_health == 0:
		_is_dead = true
		died.emit(self)
		queue_free()
