extends Node

var player: Node3D
var state: Node
var action_label: Label
var interactables: Array = []
var action_index: int = -1

func setup(world: Node, player_node: Node3D, game_state: Node) -> void:
    player = player_node
    state = game_state
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
            if interactables[action_index]["type"] == "vehicle":
                var vehicle = interactables[action_index]["node"]
                if vehicle != null and vehicle.is_occupied:
                    action_label.text = "Press E to exit vehicle"
                else:
                    action_label.text = "Press E to enter vehicle"
            elif interactables[action_index]["type"] == "bus_stop":
                var stop = interactables[action_index]["node"]
                var dest = stop.get_destination() if stop != null and stop.has_method("get_destination") else "OSHODI"
                action_label.text = "Press E to take bus to %s" % dest
            else:
                action_label.text = "Press E to interact with %s" % nearest_name
        else:
            action_label.text = ""

func try_interact() -> void:
    if player == null or action_index == -1:
        return

    var target = interactables[action_index]

    if target["type"] == "job":
        var current_mission = state.get_current_mission()
        if not current_mission.is_empty() and current_mission["id"] == "first_job":
            state.complete_mission("first_job")
            if action_label != null:
                action_label.text = "Job accepted! Deliver package to Oshodi. Earned ₦5,000."
    elif target["type"] == "shop":
        if state.pay_money(1200):
            if action_label != null:
                action_label.text = "You bought phone top-up and data. Spent ₦1,200."
        else:
            if action_label != null:
                action_label.text = "Not enough cash. You need ₦1,200."
    elif target["type"] == "home":
        if action_label != null:
            action_label.text = "You rested at home and saved progress."
        var save_system = player.get_parent().get_node_or_null("SaveSystem")
        if save_system != null:
            save_system.save_state(state)
    elif target["type"] == "market":
        var current_mission = state.get_current_mission()
        if not current_mission.is_empty() and current_mission["id"] == "market_run":
            state.complete_mission("market_run")
            if action_label != null:
                action_label.text = "Market delivery complete! Earned ₦2,500."
        else:
            state.add_money(500)
            if action_label != null:
                action_label.text = "Bought some goods from market. +₦500 profit."
    elif target["type"] == "vehicle":
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
    elif target["type"] == "bus_stop":
        var stop = target["node"]
        if stop != null and stop.has_method("get_destination"):
            var destination = stop.get_destination()
            state.set_current_area(destination)
            if action_label != null:
                action_label.text = "You boarded a bus and travelled to %s." % destination
            if state.get_current_mission().get("id", "") == "market_run":
                state.add_money(800)
