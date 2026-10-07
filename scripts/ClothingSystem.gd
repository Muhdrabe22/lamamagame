extends Node

var outfit_options: Dictionary = {
    "basic": {"name": "Basic", "price": 0},
    "casual": {"name": "Casual", "price": 1500},
    "smart": {"name": "Smart", "price": 3500},
    "sport": {"name": "Sport", "price": 2500}
}

var current_outfit: String = "basic"

func set_outfit(name: String) -> void:
    if outfit_options.has(name):
        current_outfit = name

func get_current_outfit() -> String:
    return current_outfit

func get_outfit_name() -> String:
    if outfit_options.has(current_outfit):
        return outfit_options[current_outfit]["name"]
    return "Basic"

func can_buy(name: String, money: int) -> bool:
    if not outfit_options.has(name):
        return false
    return money >= int(outfit_options[name]["price"])
