extends Node

var player: Node3D
var state: Node
var inventory: Node
var home: Node3D
var clothing_system: Node
var action_label: Label
var interactables: Array = []
var action_index: int = -1

func setup(world: Node, player_node: Node3D, game_state: Node, inventory_node: Node, home_node: Node3D, clothing_node: Node) -> void:
    player = player_node
    state = game_state
    inventory = inventory_node
    home = home_node
    clothing_system = clothing_node
    set_name("InteractionManager")

func set_action_label(label: Label) -> void:
    action_label = label

func register_interactable(name: String, position: Vector3, type: String, node: Node = null) -> void:
    interactables.append({"name": name, "position": position, "type": type, "node": node})

func _process(_delta: float) -> void:
    if player == null:
        return

    var nearest_name = ""
    var nearest_dist = INF
    var found_index = -1
    for i in range(interactables.size()):
        var entry = interactables[i]
        var dist = player.global_position.distance_to(entry["position"])
        if dist < 3.2 and dist < nearest_dist:
            nearest_dist = dist
            nearest_name = entry["name"]
            found_index = i

    action_index = found_index

    if action_label != null:
        if nearest_name != "":
            var type_name = interactables[action_index]["type"]
            if type_name == "vehicle":
                var vehicle = interactables[action_index]["node"]
                if vehicle != null and vehicle.is_occupied:
                    action_label.text = "Press E to exit vehicle"
                else:
                    action_label.text = "Press E to enter vehicle"
            elif type_name == "bus_stop":
                var stop = interactables[action_index]["node"]
                var dest = stop.get_destination() if stop != null and stop.has_method("get_destination") else "OSHODI"
                action_label.text = "Press E to take bus to %s" % dest
            elif type_name == "bank":
                action_label.text = "Press E to bank or withdraw cash"
            elif type_name == "friend":
                action_label.text = "Press E to talk with Musa"
            elif type_name == "home_upgrade":
                action_label.text = "Press E to upgrade your home"
            elif type_name == "clothing_store":
                action_label.text = "Press E to buy a new outfit"
            elif type_name == "store":
                action_label.text = "Press E to shop for goods"
            else:
                action_label.text = "Press E to interact with %s" % nearest_name
        else:
            action_label.text = ""

func try_interact() -> void:
    if player == null or action_index == -1:
        return

    var target = interactables[action_index]
    var type_name = target["type"]

    if type_name == "job":
        var current_mission = state.get_current_mission()
        if not current_mission.is_empty() and current_mission["id"] == "first_job":
            state.complete_mission("first_job")
            if action_label != null:
                action_label.text = "Job accepted! Deliver package to Oshodi. Earned ₦5,000."
    elif type_name == "shop":
        if state.pay_money(1200):
            if action_label != null:
                action_label.text = "You bought phone top-up and data. Spent ₦1,200."
        else:
            if action_label != null:
                action_label.text = "Not enough cash. You need ₦1,200."
    elif type_name == "home":
        if action_label != null:
            action_label.text = "You rested at home and saved progress."
        var save_system = player.get_parent().get_node_or_null("SaveSystem")
        if save_system != null:
            save_system.save_state(state, inventory, home, clothing_system)
    elif type_name == "bank":
        state.deposit_money(2000)
        if action_label != null:
            action_label.text = "You deposited ₦2,000 into the bank."
    elif type_name == "market":
        var current_mission = state.get_current_mission()
        if not current_mission.is_empty() and current_mission["id"] == "market_run":
            state.complete_mission("market_run")
            if action_label != null:
                action_label.text = "Market delivery complete! Earned ₦2,500."
        else:
            state.add_money(500)
            if action_label != null:
                action_label.text = "Bought some goods from market. +₦500 profit."
    elif type_name == "friend":
        if action_label != null:
            action_label.text = "Musa: 'You fit help my shop. I no get hands today.'"
        if state.get_current_mission().get("id", "") == "help_friend":
            state.complete_mission("help_friend")
            if action_label != null:
                action_label.text = "Musa: 'You did well. Here is your money.'"
    elif type_name == "vehicle":
        var vehicle = target["node"]
        if vehicle != null:
            if vehicle.is_occupied:
                if player.has_method("exit_vehicle"):
                    player.exit_vehicle()
                    if action_label != null:
                        action_label.text = "You exited the vehicle."
            else:
                if player.has_method("enter_vehicle"):
                    player.enter_vehicle(vehicle)
                    if action_label != null:
                        action_label.text = "Driving... WASD to steer, move forward/back to accelerate."
    elif type_name == "bus_stop":
        var stop = target["node"]
        if stop != null and stop.has_method("get_destination"):
            var destination = stop.get_destination()
            state.set_current_area(destination)
            if action_label != null:
                action_label.text = "You boarded a bus and travelled to %s." % destination
            if state.get_current_mission().get("id", "") == "market_run":
                state.add_money(800)
    elif type_name == "home_upgrade":
        if home != null and home.has_method("upgrade"):
            if home.upgrade():
                if action_label != null:
                    action_label.text = "Home upgraded: %s" % home.get_current_level_name()
            else:
                if action_label != null:
                    action_label.text = "Your home is already at the max level."
    elif type_name == "clothing_store":
        if clothing_system != null and clothing_system.can_buy("casual", state.money):
            state.pay_money(1500)
            clothing_system.set_outfit("casual")
            if inventory != null:
                inventory.set_outfit("casual")
            if action_label != null:
                action_label.text = "You changed into smart casual clothes."
        else:
            if action_label != null:
                action_label.text = "You cannot afford a new outfit yet."
    elif type_name == "store":
        var shop = target["node"]
        if shop != null and shop.has_method("buy_item"):
            if shop.buy_item("starter_package"):
                if action_label != null:
                    action_label.text = "You bought a starter package from the shop."
            else:
                if action_label != null:
                    action_label.text = "You cannot afford this item."
