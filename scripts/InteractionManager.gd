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
            else:
                action_label.text = "Press E to interact with %s" % nearest_name
        else:
            action_label.text = ""

func try_interact() -> void:
    if player == null or action_index == -1:
        return

    var target = interactables[action_index]
    if target["type"] == "job":
        if state.missions.size() > 0:
            state.missions[0]["done"] = true
            state.add_money(5000)
            if action_label != null:
                action_label.text = "Job accepted: deliver package in Yaba. Earned ₦5,000."
    elif target["type"] == "shop":
        if state.pay_money(1200):
            if action_label != null:
                action_label.text = "You bought a phone top-up and data bundle."
        else:
            if action_label != null:
                action_label.text = "Not enough cash for this purchase."
    elif target["type"] == "home":
        if action_label != null:
            action_label.text = "You rest at home and save your progress."
        var save_system = player.get_parent().get_node_or_null("SaveSystem")
        if save_system != null:
            save_system.save_state(state)
    elif target["type"] == "market":
        state.add_money(2500)
        if action_label != null:
            action_label.text = "Market run complete. You earned ₦2,500 from local trade."
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
                        action_label.text = "You are driving the vehicle."

    if state.missions.size() > 0 and state.missions[0]["id"] == "first_job" and state.missions[0]["done"]:
        state.missions.remove_at(0)
        state.missions.insert(0, {"id": "market_run", "title": "Market Run", "objective": "Collect goods in Oshodi and deliver them to Yaba", "done": false})
