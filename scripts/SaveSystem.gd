extends Node

var save_path: String = "user://lamama_save.cfg"

func save_state(game_state: Node, inventory: Node = null, home: Node = null, clothing_system: Node = null) -> void:
    var config = ConfigFile.new()
    config.set_value("player", "money", game_state.money)
    config.set_value("player", "bank_balance", game_state.bank_balance)
    config.set_value("player", "current_area", game_state.current_area)
    if game_state.has_method("get_weather"):
        config.set_value("player", "current_weather", game_state.get_weather())
    elif game_state.has("current_weather"):
        config.set_value("player", "current_weather", game_state.current_weather)

    if inventory != null and inventory.has("inventory"):
        var inventory_data: Dictionary = inventory.inventory
        for key in inventory_data.keys():
            config.set_value("inventory", key, int(inventory_data[key]))
        if inventory.has_method("get_outfit"):
            config.set_value("inventory", "current_outfit", inventory.get_outfit())

    if home != null and home.has_method("get_current_level_name"):
        config.set_value("home", "name", home.get_current_level_name())

    if clothing_system != null and clothing_system.has_method("get_current_outfit"):
        config.set_value("clothing", "current_outfit", clothing_system.get_current_outfit())

    config.save(save_path)

func load_state(game_state: Node, inventory: Node = null, home: Node = null, clothing_system: Node = null) -> void:
    var config = ConfigFile.new()
    if config.load(save_path) != OK:
        return

    if config.has_section_key("player", "money"):
        game_state.money = int(config.get_value("player", "money"))
    if config.has_section_key("player", "bank_balance"):
        game_state.bank_balance = int(config.get_value("player", "bank_balance"))
    if config.has_section_key("player", "current_area"):
        game_state.current_area = String(config.get_value("player", "current_area"))
    if config.has_section_key("player", "current_weather"):
        if game_state.has("current_weather"):
            game_state.current_weather = String(config.get_value("player", "current_weather"))

    if inventory != null and inventory.has("inventory"):
        for key in inventory.inventory.keys():
            if config.has_section_key("inventory", key):
                inventory.inventory[key] = int(config.get_value("inventory", key))
        if config.has_section_key("inventory", "current_outfit"):
            inventory.set_outfit(String(config.get_value("inventory", "current_outfit")))

    if home != null and home.has_method("upgrade"):
        var target_home_level = 0
        if config.has_section_key("inventory", "home_level"):
            target_home_level = int(config.get_value("inventory", "home_level"))
        while home.current_level_index < target_home_level:
            home.upgrade()

    if clothing_system != null and clothing_system.has_method("set_outfit"):
        if config.has_section_key("clothing", "current_outfit"):
            clothing_system.set_outfit(String(config.get_value("clothing", "current_outfit")))
