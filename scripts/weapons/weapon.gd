extends Node2D

signal ammo_changed(current_ammo: int, maximum_ammo: int)
signal shot_fired(hit: bool, target: Object)
signal reloaded

@export var damage: int = 34
@export var max_range: float = 1200.0
@export var fire_interval: float = 0.45
@export var magazine_size: int = 5
@export var reload_seconds: float = 1.2
@export_flags_2d_physics var hit_mask: int = 1

var current_ammo: int
var _cooldown_remaining := 0.0
var _is_reloading := false


func _ready() -> void:
	current_ammo = magazine_size
	ammo_changed.emit(current_ammo, magazine_size)


func _process(delta: float) -> void:
	_cooldown_remaining = maxf(0.0, _cooldown_remaining - delta)


func fire() -> void:
	if _is_reloading or _cooldown_remaining > 0.0:
		return
	if current_ammo <= 0:
		reload()
		return
	current_ammo -= 1
	_cooldown_remaining = fire_interval
	ammo_changed.emit(current_ammo, magazine_size)
	AudioManager.play_sfx("shoot")

	var end_position := global_position + Vector2.RIGHT.rotated(global_rotation) * max_range
	var query := PhysicsRayQueryParameters2D.create(global_position, end_position, hit_mask)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	var exclusions: Array[RID] = []
	if get_parent() is CollisionObject2D:
		exclusions.append((get_parent() as CollisionObject2D).get_rid())
	query.exclude = exclusions
	var result := get_world_2d().direct_space_state.intersect_ray(query)
	var target: Object = result.get("collider")
	var hit_position: Vector2 = result.get("position", end_position)
	_show_tracer(global_position, hit_position, not result.is_empty())
	if is_instance_valid(target):
		if target.has_method("take_damage"):
			target.call("take_damage", damage, get_parent())
			AudioManager.play_sfx("hit")
		elif target is Node and (target as Node).get_parent() != null and (target as Node).get_parent().has_method("take_damage"):
			(target as Node).get_parent().call("take_damage", damage, get_parent())
			AudioManager.play_sfx("hit")
	shot_fired.emit(not result.is_empty(), target)


func _show_tracer(from: Vector2, to: Vector2, hit: bool) -> void:
	var tracer := Line2D.new()
	tracer.width = 3.0 if hit else 1.5
	tracer.default_color = Color(1.0, 0.78, 0.35, 0.9) if hit else Color(0.85, 0.92, 1.0, 0.55)
	tracer.add_point(from)
	tracer.add_point(to)
	get_tree().current_scene.add_child(tracer)
	var tween := tracer.create_tween()
	tween.tween_property(tracer, "modulate:a", 0.0, 0.12)
	tween.tween_callback(tracer.queue_free)


func reload() -> void:
	if _is_reloading or current_ammo == magazine_size:
		return
	_is_reloading = true
	AudioManager.play_sfx("reload")
	await get_tree().create_timer(reload_seconds).timeout
	if not is_inside_tree():
		return
	current_ammo = magazine_size
	_is_reloading = false
	ammo_changed.emit(current_ammo, magazine_size)
	reloaded.emit()
