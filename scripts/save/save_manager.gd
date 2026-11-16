extends Node

signal stats_changed(stats: Dictionary)

const SAVE_PATH := "user://sniper_elite_save.cfg"
const SECTION := "progress"
const MISSION_ORDER := ["urban_01", "desert_01", "jungle_01"]
const WEAPON_ORDER := ["marksman", "scout", "heavy"]

var selected_mission_id := "urban_01"
var selected_weapon_id := "marksman"
var stats: Dictionary = {
	"missions_won": 0,
	"total_kills": 0,
	"best_kills": 0,
	"best_time_seconds": 0.0,
	"completed_missions": [],
	"unlocked_missions": ["urban_01"],
	"unlocked_weapons": ["marksman"],
}


func _ready() -> void:
	load_game()


func load_game() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		stats["missions_won"] = int(config.get_value(SECTION, "missions_won", 0))
		stats["total_kills"] = int(config.get_value(SECTION, "total_kills", 0))
		stats["best_kills"] = int(config.get_value(SECTION, "best_kills", 0))
		stats["best_time_seconds"] = float(config.get_value(SECTION, "best_time_seconds", 0.0))
		stats["completed_missions"] = _string_array(config.get_value(SECTION, "completed_missions", []))
		stats["unlocked_missions"] = _string_array(config.get_value(SECTION, "unlocked_missions", ["urban_01"]))
		stats["unlocked_weapons"] = _string_array(config.get_value(SECTION, "unlocked_weapons", ["marksman"]))
	if not is_mission_unlocked("urban_01"):
		stats["unlocked_missions"].append("urban_01")
	if not is_weapon_unlocked("marksman"):
		stats["unlocked_weapons"].append("marksman")
	if not is_weapon_unlocked(selected_weapon_id):
		selected_weapon_id = "marksman"
	stats_changed.emit(stats.duplicate(true))


func _string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if value is Array or value is PackedStringArray:
		for item in value:
			result.append(str(item))
	return result


func is_mission_unlocked(mission_id: String) -> bool:
	return mission_id in stats["unlocked_missions"]


func is_mission_completed(mission_id: String) -> bool:
	return mission_id in stats["completed_missions"]


func is_weapon_unlocked(weapon_id: String) -> bool:
	return weapon_id in stats["unlocked_weapons"]


func select_weapon(weapon_id: String) -> bool:
	if not is_weapon_unlocked(weapon_id):
		return false
	selected_weapon_id = weapon_id
	return true


func record_mission_result(won: bool, kills: int, elapsed_seconds: float, mission_id: String = "urban_01") -> void:
	stats["total_kills"] = int(stats["total_kills"]) + kills
	stats["best_kills"] = maxi(int(stats["best_kills"]), kills)
	if won:
		stats["missions_won"] = int(stats["missions_won"]) + 1
		if not is_mission_completed(mission_id):
			stats["completed_missions"].append(mission_id)
		var best_time := float(stats["best_time_seconds"])
		if best_time <= 0.0 or elapsed_seconds < best_time:
			stats["best_time_seconds"] = elapsed_seconds
		var mission_index := MISSION_ORDER.find(mission_id)
		if mission_index >= 0 and mission_index + 1 < MISSION_ORDER.size():
			_unlock_mission(MISSION_ORDER[mission_index + 1])
	_refresh_weapon_unlocks()
	_save()


func _unlock_mission(mission_id: String) -> void:
	if not is_mission_unlocked(mission_id):
		stats["unlocked_missions"].append(mission_id)


func _refresh_weapon_unlocks() -> void:
	if int(stats["total_kills"]) >= 3:
		_unlock_weapon("scout")
	if int(stats["missions_won"]) >= 2:
		_unlock_weapon("heavy")


func _unlock_weapon(weapon_id: String) -> void:
	if not is_weapon_unlocked(weapon_id):
		stats["unlocked_weapons"].append(weapon_id)


func reset_progress() -> void:
	stats = {
		"missions_won": 0,
		"total_kills": 0,
		"best_kills": 0,
		"best_time_seconds": 0.0,
		"completed_missions": [],
		"unlocked_missions": ["urban_01"],
		"unlocked_weapons": ["marksman"],
	}
	selected_weapon_id = "marksman"
	_save()


func _save() -> void:
	var config := ConfigFile.new()
	for key in stats:
		config.set_value(SECTION, key, stats[key])
	var error := config.save(SAVE_PATH)
	if error != OK:
		push_warning("Could not save game progress (error %d)." % error)
	stats_changed.emit(stats.duplicate(true))
