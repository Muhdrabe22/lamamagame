extends Node

var money: int = 20000
var bank_balance: int = 0
var current_area: String = "YABA"
var mission_index: int = 0
var missions: Array = []
var cash_label: Label
var area_label: Label
var mission_label: Label

func _ready() -> void:
    missions = [
        {"id": "first_job", "title": "First Day", "objective": "Find a job in Yaba", "reward": 5000, "done": false},
        {"id": "market_run", "title": "Market Run", "objective": "Collect goods in Oshodi and deliver them to Yaba", "reward": 2500, "done": false},
        {"id": "help_friend", "title": "Help a Friend", "objective": "Meet Musa in Surulere and help with his shop", "reward": 3500, "done": false}
    ]
    _refresh_hud()

func connect_hud(cash: Label, area: Label, mission: Label) -> void:
    cash_label = cash
    area_label = area
    mission_label = mission
    _refresh_hud()

func set_current_area(area_name: String) -> void:
    current_area = area_name
    _refresh_hud()

func add_money(amount: int) -> void:
    if amount > 0:
        money += amount
        _refresh_hud()

func pay_money(amount: int) -> bool:
    if amount <= money:
        money -= amount
        _refresh_hud()
        return true
    return false

func deposit_money(amount: int) -> void:
    if pay_money(amount):
        bank_balance += amount
        _refresh_hud()

func withdraw_money(amount: int) -> void:
    if amount <= bank_balance:
        bank_balance -= amount
        add_money(amount)

func complete_mission(mission_id: String) -> void:
    for mission in missions:
        if mission["id"] == mission_id:
            mission["done"] = true
            add_money(mission.get("reward", 0))
            break
    advance_mission()
    _refresh_hud()

func get_current_mission() -> Dictionary:
    if missions.is_empty():
        return {}
    return missions[mission_index]

func advance_mission() -> void:
    if missions.size() > 1:
        for i in range(missions.size()):
            if not missions[i]["done"]:
                mission_index = i
                break
    _refresh_hud()

func _refresh_hud() -> void:
    if cash_label != null:
        cash_label.text = "Cash: ₦%d | Bank: ₦%d" % [money, bank_balance]
    if area_label != null:
        area_label.text = "Area: %s" % current_area
    if mission_label != null and missions.size() > 0:
        var current = get_current_mission()
        if not current.is_empty():
            mission_label.text = "Mission: %s" % current["objective"]
