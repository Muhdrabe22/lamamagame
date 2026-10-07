extends Node

var inventory: Dictionary = {
    "basic_phone": 1,
    "basic_clothes": 1,
    "starter_cash": 20000,
    "food": 2,
    "keys": 1
}

var current_outfit: String = "basic"
var current_level: int = 0
var upgrade_levels: Array = [
    "Single Room",
    "Self Contained",
    "1 Bedroom",
    "2 Bedroom",
    "Luxury Apartment"
]

func _ready() -> void:
    pass

func add_item(item_name: String, amount: int = 1) -> void:
    if inventory.has(item_name):
        inventory[item_name] += amount
    else:
        inventory[item_name] = amount

func remove_item(item_name: String, amount: int = 1) -> bool:
    if inventory.has(item_name) and inventory[item_name] >= amount:
        inventory[item_name] -= amount
        return true
    return false

func has_item(item_name: String) -> bool:
    return inventory.has(item_name) and inventory[item_name] > 0

func get_summary() -> String:
    var text = "Inventory:\n"
    for key in inventory.keys():
        text += "- %s: %d\n" % [key, inventory[key]]
    return text

func set_outfit(name: String) -> void:
    current_outfit = name

func get_outfit() -> String:
    return current_outfit

func upgrade_home() -> bool:
    if current_level < upgrade_levels.size() - 1:
        current_level += 1
        return true
    return false

func get_current_level_name() -> String:
    return upgrade_levels[current_level]
