extends Node

var sun: DirectionalLight3D
var time_of_day: float = 7.0

func _ready() -> void:
    _build_sun()

func _build_sun() -> void:
    sun = DirectionalLight3D.new()
    sun.position = Vector3(0.0, 18.0, 0.0)
    sun.rotation_degrees = Vector3(-40.0, 30.0, 0.0)
    sun.light_energy = 1.2
    add_child(sun)

func _process(delta: float) -> void:
    time_of_day += delta * 0.12
    if time_of_day > 24.0:
        time_of_day -= 24.0

    var cycle = (time_of_day / 24.0) * 2.0 * PI
    var sun_angle = sin(cycle)
    sun.rotation_degrees.x = -60.0 + sun_angle * 70.0
    sun.rotation_degrees.y = 30.0 + cos(cycle) * 30.0

    if time_of_day >= 18.0 or time_of_day <= 6.0:
        sun.light_energy = 0.55
    else:
        sun.light_energy = 1.2
