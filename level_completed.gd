extends ColorRect

signal retry()
signal next_level()

@onready var next_level_button = %NextLevelButton
@onready var time_label = %TimeLabel
@onready var highscore_label = %HighscoreLabel
@onready var highscore_animation_player = $CenterContainer/VBoxContainer/HighscoreAnimationPlayer

func _on_retry_button_pressed():
	retry.emit()


func _on_next_level_button_pressed():
	next_level.emit()
