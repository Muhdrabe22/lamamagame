extends Node3D

var city: Node3D
var player: CharacterBody3D
var time_system: Node
var state: Node
var hud: Control
var player_spawn: Vector3 = Vector3(-18.0, 0.5, 26.0)

func _ready() -> void:
    state = preload("res://scripts/GameState.gd").new()
    add_child(state)

    city = preload("res://scripts/CityBuilder.gd").new()
    add_child(city)
    city.build_world()

    time_system = preload("res://scripts/WorldTime.gd").new()
    add_child(time_system)

    var player_script = preload("res://scripts/Player.gd")
    player = player_script.new()
    player.position = player_spawn
    add_child(player)

    _build_hud()
    _spawn_npcs()
    state.set_current_area("YABA")

func _build_hud() -> void:
    var canvas = CanvasLayer.new()
    add_child(canvas)

    hud = Control.new()
    hud.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    hud.size_flags_vertical = Control.SIZE_EXPAND_FILL
    canvas.add_child(hud)

    var top_panel = PanelContainer.new()
    top_panel.position = Vector2(20, 20)
    top_panel.custom_minimum_size = Vector2(360, 120)
    hud.add_child(top_panel)

    var top_vbox = VBoxContainer.new()
    top_panel.add_child(top_vbox)

    var cash_label = Label.new()
    cash_label.text = "Cash: ₦20,000 | Bank: ₦0"
    cash_label.add_theme_font_size_override("font_size", 22)
    top_vbox.add_child(cash_label)

    var area_label = Label.new()
    area_label.text = "Area: YABA"
    area_label.add_theme_font_size_override("font_size", 18)
    top_vbox.add_child(area_label)

    var mission_label = Label.new()
    mission_label.text = "Mission: Find a job in Yaba"
    mission_label.add_theme_font_size_override("font_size", 16)
    top_vbox.add_child(mission_label)

    var hint_label = Label.new()
    hint_label.text = "Move: WASD | Sprint: Shift | Jump: Space | Interact: E"
    hint_label.position = Vector2(20, 650)
    hint_label.add_theme_font_size_override("font_size", 16)
    hud.add_child(hint_label)

    state.connect_hud(cash_label, area_label, mission_label)

func _spawn_npcs() -> void:
    var routes = [
        [Vector3(-12, 0, -10), Vector3(10, 0, -10), Vector3(10, 0, 12), Vector3(-12, 0, 12)],
        [Vector3(18, 0, 22), Vector3(36, 0, 22), Vector3(36, 0, 42), Vector3(18, 0, 42)],
        [Vector3(-35, 0, 18), Vector3(-20, 0, 18), Vector3(-20, 0, 30), Vector3(-35, 0, 30)],
        [Vector3(-8, 0, 34), Vector3(8, 0, 34), Vector3(8, 0, 50), Vector3(-8, 0, 50)],
    ]

    for index in range(10):
        var npc = CharacterBody3D.new()
        npc.set_script(preload("res://scripts/NPC.gd"))
        add_child(npc)
        npc.global_position = routes[index % routes.size()][0]
        npc.call("set_walk_route", routes[index % routes.size()])
