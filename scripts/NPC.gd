extends CharacterBody3D

var walk_speed: float = 1.8
var target_points: Array = []
var current_index: int = 0
var body_mesh: MeshInstance3D
var npc_name: String = "Pedestrian"
var dialogue: String = "Hello, how far?"

func _ready() -> void:
    _build_body()
    if target_points.is_empty():
        target_points = [Vector3(-10.0, 0.0, 0.0), Vector3(10.0, 0.0, 0.0)]

func _build_body() -> void:
    var collision = CollisionShape3D.new()
    var shape = CapsuleShape3D.new(); shape.radius = 0.4; shape.height = 1.6
    collision.shape = shape
    collision.position = Vector3(0.0, 1.0, 0.0)
    add_child(collision)

    var capsule = CapsuleMesh.new(); capsule.radius = 0.4; capsule.height = 1.6
    body_mesh = MeshInstance3D.new(); body_mesh.mesh = capsule
    body_mesh.position = Vector3(0.0, 1.0, 0.0)
    add_child(body_mesh)

func set_walk_route(points: Array) -> void:
    target_points = points
    current_index = 0

func _physics_process(delta: float) -> void:
    if target_points.is_empty():
        return

    var target: Vector3 = target_points[current_index]
    var direction = target - global_position
    direction.y = 0.0
    if direction.length() < 0.75:
        current_index = (current_index + 1) % target_points.size()
        return

    var motion = direction.normalized() * walk_speed
    velocity.x = motion.x
    velocity.z = motion.z
    velocity.y = 0.0
    move_and_slide()

    if direction.length() > 0.1:
        rotation.y = atan2(direction.x, direction.z)
