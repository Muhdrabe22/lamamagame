extends Node

var save_path: String = "user://lamama_save.cfg"

func save_state(game_state: Node) -> void:
    var config = ConfigFile.new()
    config.set_value("player", "money", game_state.money)
    config.set_value("player", "bank_balance", game_state.bank_balance)
    config.set_value("player", "current_area", game_state.current_area)
    config.set_value("mission", "current_index", 0)
    config.save(save_path)

func load_state(game_state: Node) -> void:
    var config = ConfigFile.new()
    if config.load(save_path) != OK:
        return
    if config.has_section_key("player", "money"):
        game_state.money = int(config.get_value("player", "money"))
    if config.has_section_key("player", "bank_balance"):
        game_state.bank_balance = int(config.get_value("player", "bank_balance"))
    if config.has_section_key("player", "current_area"):
        game_state.current_area = String(config.get_value("player", "current_area"))
