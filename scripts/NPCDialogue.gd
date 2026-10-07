extends Node

var lines: Array = [
    "Hello, how far?",
    "You fit check the shop around the corner.",
    "No wahala, carry go.",
    "I dey find work o."
]

var npc_name: String = "Trader"

func set_name_value(name_text: String) -> void:
    npc_name = name_text

func get_random_line() -> String:
    return lines[randi() % lines.size()]
