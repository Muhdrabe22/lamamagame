extends CanvasLayer

var state: Node
var phone_panel: PanelContainer
var map_panel: PanelContainer
var status_label: Label
var is_open: bool = false

func setup(game_state: Node) -> void:
    state = game_state
    _build_phone_ui()
    _update_phone_state()

func _build_phone_ui() -> void:
    phone_panel = PanelContainer.new()
    phone_panel.position = Vector2(890, 110)
    phone_panel.custom_minimum_size = Vector2(290, 500)
    add_child(phone_panel)

    var phone_root = VBoxContainer.new()
    phone_panel.add_child(phone_root)

    var top_label = Label.new()
    top_label.text = "LAMAMA PHONE"
    top_label.add_theme_font_size_override("font_size", 24)
    phone_root.add_child(top_label)

    var apps = ["MAP", "BANK", "JOBS", "MESSAGES", "CONTACTS", "INVENTORY"]
    for app_name in apps:
        var button = Button.new()
        button.text = app_name
        button.pressed.connect(_on_app_pressed.bind(app_name))
        phone_root.add_child(button)

    status_label = Label.new()
    status_label.text = "Welcome to Lagos."
    status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    status_label.custom_minimum_size = Vector2(240, 180)
    phone_root.add_child(status_label)

    map_panel = PanelContainer.new()
    map_panel.visible = false
    map_panel.custom_minimum_size = Vector2(250, 200)
    add_child(map_panel)

    var map_root = VBoxContainer.new()
    map_panel.add_child(map_root)

    var map_title = Label.new()
    map_title.text = "CITY MAP"
    map_title.add_theme_font_size_override("font_size", 22)
    map_root.add_child(map_title)

    var map_text = Label.new()
    map_text.text = "YABA\nOSHODI\nIKEJA\nSURULERE"
    map_text.add_theme_font_size_override("font_size", 18)
    map_root.add_child(map_text)

    phone_panel.visible = false

func _on_app_pressed(app_name: String) -> void:
    if app_name == "MAP":
        _show_map()
    elif app_name == "BANK":
        status_label.text = "Bank ready. Balance: ₦%d" % state.bank_balance
    elif app_name == "JOBS":
        status_label.text = "Available jobs: Delivery, Shop Worker, Driver"
    elif app_name == "MESSAGES":
        status_label.text = "Message: 'How far? Check the shop around the corner.'"
    elif app_name == "CONTACTS":
        status_label.text = "Contacts: Aunty Bisi, Musa, Tunde, Ngozi"
    elif app_name == "INVENTORY":
        status_label.text = "Inventory: basic phone, basic clothes, starter cash"

func _show_map() -> void:
    map_panel.position = Vector2(890, 130)
    map_panel.visible = true
    status_label.text = "Map open. Player in YABA."

func toggle_phone() -> void:
    is_open = not is_open
    phone_panel.visible = is_open
    if not is_open:
        map_panel.visible = false
    else:
        _update_phone_state()

func _update_phone_state() -> void:
    if state == null:
        return
    if phone_panel != null:
        status_label.text = "Cash: ₦%d | Area: %s" % [state.money, state.current_area]
