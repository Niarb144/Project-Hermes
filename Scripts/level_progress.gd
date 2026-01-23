extends Node

const SAVE_PATH := "user://progress.cfg"

var highest_unlocked_level := 1

func load_progress():
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		highest_unlocked_level = config.get_value("progress", "highest_level", 1)

func save_progress(level: int):
	if level > highest_unlocked_level:
		highest_unlocked_level = level
		
	var config := ConfigFile.new()
	config.set_value("progress", "highest_level", highest_unlocked_level)
	config.save(SAVE_PATH)
