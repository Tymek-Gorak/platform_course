extends Node

signal level_completed

var game_saver : SaveGame

func _ready():
	write_or_load_save()
	
func write_or_load_save():
	if SaveGame.load_save() != null:
		game_saver = SaveGame.load_save()
	else:
		game_saver = SaveGame.new()
		
		game_saver.highscores = [0.010, 0.100, 0.123, 1.000, 0.000, 23.000, ]
		game_saver.write_save()
		
func save_score(level, score):
	pass
