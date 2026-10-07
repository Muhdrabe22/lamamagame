extends CharacterBody3D

var walk_speed: float = 1.8
var target_points: Array = []
var current_index: int = 0
var body: MeshInstance3D

func _ready() -> void:
    _build_body()
    if target_points.is_empty():
        target_points = [
            Vector3(-12.0, 0.0, -10.0),
            Vector3(10.0, 0.0, -10.0),
            Vector3(10.0, 0.0, 12.0),
            Vector3(-12.0, 0.0, 12.0)
        ]

func _build_body() -> void:
    var collision = CollisionShape3D.new()
    var shape = CapsuleShape3D.new()
    shape.radius = 0.38
    shape.height = 1.6
    collision.shape = shape
    collision.position = Vector3(0.0, 1.0, 0.0)
    add_child(collision)

    var mesh = CapsuleMesh.new()
    mesh.radius = 0.38
    mesh.height = 1.6

    body = MeshInstance3D.new()
    body.mesh = mesh
    body.position = Vector3(0.0, 1.0, 0.0)
    add_child(body)

func set_walk_route(points: Array) -> void:
    target_points = points
    current_index = 0

func _physics_process(_delta: float) -> void:
    if target_points.is_empty():
        return

    var target: Vector3 = target_points[current_index]
    var direction = target - global_position
    direction.y = 0.0

    if direction.length() < 0.75:
        current_index = (current_index + 1) % target_points.size()
        return

    var move_vector = direction.normalized() * walk_speed
    velocity.x = move_vector.x
    velocity.z = move_vector.z
    velocity.y = 0.0
    move_and_slide()

    if direction.length() > 0.1:
        rotation.y = atan2(direction.x, direction.z)
