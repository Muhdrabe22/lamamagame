extends Node3D

var destination: String = "OSHODI"
var marker: MeshInstance3D

func _ready() -> void:
    _build_bus_stop()

func _build_bus_stop() -> void:
    var stand = MeshInstance3D.new()
    var box = BoxMesh.new()
    box.size = Vector3(2.0, 0.2, 2.0)
    stand.mesh = box
    stand.position = Vector3(0.0, 0.1, 0.0)

    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.9, 0.8, 0.2)
    stand.material_override = material
    add_child(stand)

    marker = Label3D.new()
    marker.text = "BUS"
    marker.position = Vector3(0.0, 1.8, 0.0)
    marker.modulate = Color(1.0, 1.0, 1.0, 1.0)
    add_child(marker)

func set_destination(dest: String) -> void:
    destination = dest
    if marker != null:
        marker.text = dest

func get_destination() -> String:
    return destination
