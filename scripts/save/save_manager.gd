extends Node

signal stats_changed(stats: Dictionary)

const SAVE_PATH := "user://sniper_elite_save.cfg"
const SECTION := "progress"

var stats: Dictionary = {
	"missions_won": 0,
	"total_kills": 0,
	"best_kills": 0,
	"best_time_seconds": 0.0,
}


func _ready() -> void:
	load_game()


func load_game() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		stats_changed.emit(stats.duplicate())
		return
	stats["missions_won"] = int(config.get_value(SECTION, "missions_won", 0))
	stats["total_kills"] = int(config.get_value(SECTION, "total_kills", 0))
	stats["best_kills"] = int(config.get_value(SECTION, "best_kills", 0))
	stats["best_time_seconds"] = float(config.get_value(SECTION, "best_time_seconds", 0.0))
	stats_changed.emit(stats.duplicate())


func record_mission_result(won: bool, kills: int, elapsed_seconds: float) -> void:
	stats["total_kills"] = int(stats["total_kills"]) + kills
	stats["best_kills"] = maxi(int(stats["best_kills"]), kills)
	if won:
		stats["missions_won"] = int(stats["missions_won"]) + 1
		var best_time := float(stats["best_time_seconds"])
		if best_time <= 0.0 or elapsed_seconds < best_time:
			stats["best_time_seconds"] = elapsed_seconds
	_save()


func reset_progress() -> void:
	stats = {
		"missions_won": 0,
		"total_kills": 0,
		"best_kills": 0,
		"best_time_seconds": 0.0,
	}
	_save()


func _save() -> void:
	var config := ConfigFile.new()
	for key in stats:
		config.set_value(SECTION, key, stats[key])
	var error := config.save(SAVE_PATH)
	if error != OK:
		push_warning("Could not save game progress (error %d)." % error)
	stats_changed.emit(stats.duplicate())
