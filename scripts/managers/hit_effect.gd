extends Node2D


func flash(color: Color = Color.WHITE, duration: float = 0.16) -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate", color, 0.04)
	tween.tween_property(self, "modulate", Color.WHITE, duration)


func burst(color: Color = Color(1.0, 0.78, 0.35, 1.0)) -> void:
	var particles := CPUParticles2D.new()
	particles.amount = 12
	particles.lifetime = 0.35
	particles.one_shot = true
	particles.explosiveness = 1.0
	particles.direction = Vector2.UP
	particles.spread = 180.0
	particles.initial_velocity_min = 45.0
	particles.initial_velocity_max = 130.0
	particles.gravity = Vector2(0, 80)
	particles.scale_amount_min = 2.0
	particles.scale_amount_max = 5.0
	particles.color = color
	particles.position = global_position
	get_tree().current_scene.add_child(particles)
	particles.emitting = true
	get_tree().create_timer(particles.lifetime + 0.1).timeout.connect(particles.queue_free)
