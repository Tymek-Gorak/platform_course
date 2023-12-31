extends Node2D

@export var next_level : PackedScene 
@export var level_number : String 

var level_time := 0.0
var start_level_msc

@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var start_countdown = $StartCountdown
@onready var level_time_label = %LevelTimeLabel

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	Events.level_completed.connect(show_level_completed)
	get_tree().paused = true
	start_countdown.play("countdown")
	await LevelTransition.fade_from_black()
	
func _process(delta):
	level_time = Time.get_ticks_msec() - start_level_msc
	level_time_label.text = str(level_time / 1000)
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	

func show_level_completed():
	var level_highscore = Events.game_saver.highscores[int(level_number.left(-1)) - 1]
	level_completed.time_label.text = str(level_time / 1000)
	level_completed.highscore_label.text = str(level_highscore)
	level_time_label.visible = false
	if level_highscore > level_time / 1000 or level_highscore == 0:
		level_completed.highscore_animation_player.play("new_highscore")
		Events.game_saver.highscores[int(level_number.left(-1)) - 1] = level_time / 1000
		Events.save_scores()
		
	
	
	if next_level == null: 
		level_completed.next_level_button.text = "Victory Screen"
		next_level = load("res://game_complete.tscn")
		
	level_completed.show() 
	level_completed.next_level_button.grab_focus()
	get_tree().paused = true
		
func go_to_next_level():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_packed(next_level)
	get_tree().paused = false

func retry():
	get_tree().paused = true
	await LevelTransition.fade_to_black()
	get_tree().reload_current_scene()
	get_tree().paused = false
	

func _on_start_countdown_animation_finished(anim_name):
	start_level_msc = Time.get_ticks_msec()
	get_tree().paused = false


func _on_level_completed_next_level():
	go_to_next_level()


func _on_level_completed_retry():
	retry()
