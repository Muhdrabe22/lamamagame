extends CharacterBody3D

const WALK_SPEED := 5.0
const SPRINT_SPEED := 8.5
const JUMP_VELOCITY := 5.0
const GRAVITY := 18.0

var move_speed: float = WALK_SPEED
var yaw: float = 0.0
var camera_pivot: Node3D
var camera: Camera3D
var interaction_manager: Node

func _ready() -> void:
    _build_character()
    _build_camera()
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    interaction_manager = get_parent().get_node("InteractionManager")

func _build_character() -> void:
    var collision = CollisionShape3D.new()
    var capsule = CapsuleShape3D.new()
    capsule.radius = 0.42
    capsule.height = 1.8
    collision.shape = capsule
    collision.position = Vector3(0.0, 1.0, 0.0)
    add_child(collision)

    var mesh = CapsuleMesh.new()
    mesh.radius = 0.42
    mesh.height = 1.8

    var mesh_instance = MeshInstance3D.new()
    mesh_instance.mesh = mesh
    mesh_instance.position = Vector3(0.0, 1.0, 0.0)
    add_child(mesh_instance)

func _build_camera() -> void:
    camera_pivot = Node3D.new()
    camera_pivot.position = Vector3(0.0, 1.6, 0.0)
    add_child(camera_pivot)

    camera = Camera3D.new()
    camera.position = Vector3(0.0, 3.8, 8.2)
    camera.rotation_degrees.x = -22.0
    camera_pivot.add_child(camera)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        yaw -= event.relative.x * 0.0035
        camera_pivot.rotation.y = yaw

func _physics_process(delta: float) -> void:
    var input_dir := Vector2(
        Input.get_axis("move_left", "move_right"),
        Input.get_axis("move_forward", "move_backward")
    )

    if Input.is_action_pressed("sprint"):
        move_speed = SPRINT_SPEED
    else:
        move_speed = WALK_SPEED

    if not is_on_floor():
        velocity.y -= GRAVITY * delta
    else:
        if Input.is_action_just_pressed("jump"):
            velocity.y = JUMP_VELOCITY

    var direction := Vector3.ZERO
    if input_dir.length() > 0.1:
        var camera_basis = camera.global_transform.basis
        var forward = -camera_basis.z
        forward.y = 0.0
        if forward.length() > 0.0:
            forward = forward.normalized()

        var right = camera_basis.x
        right.y = 0.0
        if right.length() > 0.0:
            right = right.normalized()

        direction = (forward * input_dir.y + right * input_dir.x).normalized()

    if direction.length() > 0.0:
        rotation.y = atan2(direction.x, direction.z) + PI
        velocity.x = direction.x * move_speed
        velocity.z = direction.z * move_speed
    else:
        velocity.x = move_toward(velocity.x, 0.0, move_speed)
        velocity.z = move_toward(velocity.z, 0.0, move_speed)

    move_and_slide()
    camera_pivot.rotation.y = yaw

    if Input.is_action_just_pressed("interact"):
        if interaction_manager != null:
            interaction_manager.try_interact()

    if global_position.y < -10.0:
        global_position = Vector3(-18.0, 0.5, 26.0)
