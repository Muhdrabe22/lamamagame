extends Node3D

var areas: Dictionary = {
    "YABA": {"center": Vector2(-10, -8), "size": Vector2(36, 28)},
    "OSHODI": {"center": Vector2(0, 28), "size": Vector2(26, 24)},
    "IKEJA": {"center": Vector2(36, 10), "size": Vector2(34, 26)},
    "SURULERE": {"center": Vector2(-30, 8), "size": Vector2(32, 28)}
}

func build_world() -> void:
    _build_ground()
    _build_roads()
    _build_city_blocks()
    _build_area_markers()
    _build_basic_buildings()

func _build_ground() -> void:
    var ground = MeshInstance3D.new()
    var plane = PlaneMesh.new()
    plane.size = Vector2(160, 140)
    ground.mesh = plane
    ground.position = Vector3(0.0, -0.05, 0.0)

    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.22, 0.42, 0.26)
    ground.material_override = material
    add_child(ground)

func _build_roads() -> void:
    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.24, 0.24, 0.28)

    var road_specs = [
        [Vector3(0.0, 0.01, 0.0), Vector3(140.0, 0.1, 6.0)],
        [Vector3(0.0, 0.01, 28.0), Vector3(120.0, 0.1, 6.0)],
        [Vector3(-18.0, 0.01, 0.0), Vector3(6.0, 0.1, 70.0)],
        [Vector3(30.0, 0.01, 0.0), Vector3(6.0, 0.1, 70.0)],
        [Vector3(-40.0, 0.01, 0.0), Vector3(6.0, 0.1, 72.0)]
    ]

    for spec in road_specs:
        var road = MeshInstance3D.new()
        var box = BoxMesh.new()
        box.size = spec[1]
        road.mesh = box
        road.position = spec[0]
        road.material_override = material
        add_child(road)

func _build_city_blocks() -> void:
    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.54, 0.52, 0.46)

    for area_name in areas.keys():
        var area = areas[area_name]
        var block = MeshInstance3D.new()
        var box = BoxMesh.new()
        box.size = Vector3(area["size"].x, 0.2, area["size"].y)
        block.mesh = box
        block.position = Vector3(area["center"].x, 0.1, area["center"].y)
        block.material_override = material
        add_child(block)

func _build_area_markers() -> void:
    for area_name in areas.keys():
        var area = areas[area_name]
        var marker = Label3D.new()
        marker.text = area_name
        marker.position = Vector3(area["center"].x, 2.5, area["center"].y)
        marker.modulate = Color(1.0, 1.0, 1.0, 0.9)
        add_child(marker)

func _build_basic_buildings() -> void:
    var colors = [
        Color(0.72, 0.67, 0.64),
        Color(0.80, 0.75, 0.68),
        Color(0.76, 0.79, 0.86),
        Color(0.74, 0.82, 0.75)
    ]

    var positions = [
        Vector3(-18.0, 2.5, -12.0), Vector3(-8.0, 2.5, -12.0), Vector3(0.0, 2.5, -12.0),
        Vector3(12.0, 2.5, -12.0), Vector3(-18.0, 2.5, 8.0), Vector3(-8.0, 2.5, 8.0),
        Vector3(-18.0, 2.5, 20.0), Vector3(-8.0, 2.5, 20.0), Vector3(0.0, 2.5, 20.0),
        Vector3(18.0, 2.5, 12.0), Vector3(28.0, 2.5, 12.0), Vector3(38.0, 2.5, 12.0),
        Vector3(46.0, 2.5, 12.0), Vector3(-36.0, 2.5, 0.0), Vector3(-28.0, 2.5, 0.0),
        Vector3(-42.0, 2.5, 18.0), Vector3(-30.0, 2.5, 18.0), Vector3(-20.0, 2.5, 18.0)
    ]

    for index in range(positions.size()):
        var building = MeshInstance3D.new()
        var box = BoxMesh.new()
        box.size = Vector3(6.0, 5.0, 6.0)
        building.mesh = box
        building.position = positions[index]

        var material = StandardMaterial3D.new()
        material.albedo_color = colors[index % colors.size()]
        building.material_override = material
        add_child(building)
