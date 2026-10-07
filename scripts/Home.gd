extends Node3D

var current_level_index: int = 0
var levels: Array = [
    "Single Room",
    "Self Contained",
    "1 Bedroom",
    "2 Bedroom",
    "Luxury Apartment"
]

func _ready() -> void:
    _build_home()

func _build_home() -> void:
    var home_body = MeshInstance3D.new()
    var box = BoxMesh.new()
    box.size = Vector3(4.5, 3.0, 4.5)
    home_body.mesh = box
    home_body.position = Vector3(0.0, 1.5, 0.0)
    add_child(home_body)

    var label = Label3D.new()
    label.text = "HOME"
    label.position = Vector3(0.0, 3.5, 0.0)
    label.modulate = Color(1.0, 1.0, 1.0, 1.0)
    add_child(label)

func get_current_level_name() -> String:
    return levels[current_level_index]

func upgrade() -> bool:
    if current_level_index < levels.size() - 1:
        current_level_index += 1
        return true
    return false
