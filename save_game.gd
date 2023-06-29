class_name SaveGame
extends Resource

const SAVE_FILE_PATH = "user://save_data.tres"

@export var highscores := [2.123, 0.000, 0.125, 1.525, 0.000, 0.000]

func write_save():
	ResourceSaver.save(self, SAVE_FILE_PATH)

static func load_save():
	if ResourceLoader.exists(SAVE_FILE_PATH):
		return load(SAVE_FILE_PATH)
	return null
