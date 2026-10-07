extends CharacterBody3D

var is_occupied: bool = false
var occupant: Node = null
var steering: float = 0.0
var acceleration: float = 0.0
var speed: float = 0.0
var max_speed: float = 12.0
var steer_strength: float = 2.2
var reverse_max_speed: float = -6.0

func _ready() -> void:
    _build_vehicle()

func _build_vehicle() -> void:
    var collision = CollisionShape3D.new()
    var box_shape = BoxShape3D.new()
    box_shape.size = Vector3(2.4, 1.2, 4.6)
    collision.shape = box_shape
    collision.position = Vector3(0.0, 0.8, 0.0)
    add_child(collision)

    var body_mesh = MeshInstance3D.new()
    var box_mesh = BoxMesh.new()
    box_mesh.size = Vector3(2.4, 1.2, 4.6)
    body_mesh.mesh = box_mesh
    body_mesh.position = Vector3(0.0, 0.8, 0.0)
    add_child(body_mesh)

    for wheel_offset in [Vector3(-1.0, 0.2, -1.5), Vector3(1.0, 0.2, -1.5), Vector3(-1.0, 0.2, 1.5), Vector3(1.0, 0.2, 1.5)]:
        var wheel = MeshInstance3D.new()
        var cyl = CylinderMesh.new()
        cyl.top_radius = 0.35
        cyl.bottom_radius = 0.35
        cyl.height = 0.35
        wheel.mesh = cyl
        wheel.rotation_degrees = Vector3(90.0, 0.0, 0.0)
        wheel.position = wheel_offset
        add_child(wheel)

func occupy(player: Node) -> void:
    is_occupied = true
    occupant = player

func release() -> void:
    is_occupied = false
    occupant = null
    speed = 0.0

func _physics_process(delta: float) -> void:
    if not is_occupied:
        return

    var steer_input = Input.get_axis("move_left", "move_right")
    var throttle_input = Input.get_axis("move_backward", "move_forward")

    if throttle_input > 0.0:
        acceleration = 12.0
    elif throttle_input < 0.0:
        acceleration = -8.0
    else:
        acceleration = 0.0

    speed += acceleration * delta
    speed *= 0.98
    speed = clamp(speed, reverse_max_speed, max_speed)

    if abs(steer_input) > 0.1:
        steering = move_toward(steering, steer_input * steer_strength, delta * 2.8)
    else:
        steering = move_toward(steering, 0.0, delta * 3.5)

    if abs(speed) > 0.01:
        rotation.y += steering * delta * (speed / max_speed)

    var move_vector = -transform.basis.z * speed
    velocity.x = move_vector.x
    velocity.z = move_vector.z
    velocity.y = 0.0
    move_and_slide()

    if occupant != null:
        occupant.global_position = global_position + Vector3(0.0, 1.0, 0.0)
        occupant.rotation.y = rotation.y
