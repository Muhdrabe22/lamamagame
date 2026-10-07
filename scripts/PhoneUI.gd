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
    set_name("PhoneUI")

func _build_phone_ui() -> void:
    phone_panel = PanelContainer.new()
    phone_panel.position = Vector2(890, 110)
    phone_panel.custom_minimum_size = Vector2(300, 540)
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
        button.custom_minimum_size = Vector2(250, 40)
        button.pressed.connect(_on_app_pressed.bind(app_name))
        phone_root.add_child(button)

    status_label = Label.new()
    status_label.text = "Welcome to Lagos."
    status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    status_label.custom_minimum_size = Vector2(260, 200)
    phone_root.add_child(status_label)

    map_panel = PanelContainer.new()
    map_panel.visible = false
    map_panel.custom_minimum_size = Vector2(300, 320)
    map_panel.position = Vector2(890, 110)
    add_child(map_panel)

    var map_root = VBoxContainer.new()
    map_panel.add_child(map_root)

    var map_title = Label.new()
    map_title.text = "CITY MAP"
    map_title.add_theme_font_size_override("font_size", 22)
    map_root.add_child(map_title)

    var map_text = Label.new()
    map_text.text = "\nYABA - Students & Tech\nOSHODI - Markets & Transport\nIKEJA - Business & Shopping\nSURULERE - Residential\n"
    map_text.add_theme_font_size_override("font_size", 16)
    map_root.add_child(map_text)

    var current_pos = Label.new()
    current_pos.text = "You are in: YABA"
    current_pos.add_theme_font_size_override("font_size", 18)
    map_root.add_child(current_pos)

    phone_panel.visible = false

func _on_app_pressed(app_name: String) -> void:
    if app_name == "MAP":
        _show_map()
    elif app_name == "BANK":
        status_label.text = "Bank Account\nCash: ₦%d\nSaved: ₦%d\n\nOptions: Deposit, Withdraw" % [state.money, state.bank_balance]
    elif app_name == "JOBS":
        status_label.text = "Job Board\n\nAvailable:\n- Delivery: ₦5,000\n- Shop Worker: ₦3,000\n- Driver: ₦4,500"
    elif app_name == "MESSAGES":
        status_label.text = "Messages:\n\nAunty Bisi: 'How far? Check the shop around the corner.'\n\nMusa: 'Need help in Surulere'"
    elif app_name == "CONTACTS":
        status_label.text = "Contacts:\n\nAunty Bisi - Shop Owner\nMusa - Market Trader\nTunde - Driver\nNgozi - Office Worker\nChief - Recruitment"
    elif app_name == "INVENTORY":
        status_label.text = "Inventory:\n\n- Basic Phone\n- Casual Clothes\n- Starter Cash: ₦20,000\n- ID Card"

func _show_map() -> void:
    map_panel.visible = true
    status_label.text = "Map view active. You are in %s." % state.current_area

func toggle_phone() -> void:
    is_open = not is_open
    phone_panel.visible = is_open
    map_panel.visible = false
    if is_open:
        _update_phone_state()

func _update_phone_state() -> void:
    if state == null:
        return
    if status_label != null:
        status_label.text = "Cash: ₦%d | Area: %s" % [state.money, state.current_area]
