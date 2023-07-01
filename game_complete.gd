extends CenterContainer

var dev_times = [5.899, 7.699, 5.784, 13.981, 9.184, 14.700, ]

@export var menu_scene : PackedScene

@onready var menu_button = %MenuButton
@onready var grid_container = %GridContainer
@onready var dev_times_container = %DevTimesContainer


func _ready():
	Events.save_scores()
	RenderingServer.set_default_clear_color(Color.BLACK)
	LevelTransition.fade_from_black()
	menu_button.grab_focus()
	
	for level in grid_container.get_children():
		if level.get_index() % 2 == 1:
			level.text = str(Events.game_saver.highscores[level.get_index()/2])
			if Events.game_saver.highscores[level.get_index()/2] <= dev_times[level.get_index()/2]:
				level.get_child(0).play("change_color")
			
	for level in dev_times_container.get_children():
		level.text = str(dev_times[level.get_index()])
	


func _on_menu_button_pressed():
	get_tree().change_scene_to_packed(menu_scene)
