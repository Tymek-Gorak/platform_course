extends CenterContainer

@export var menu_scene : PackedScene

@onready var menu_button = %MenuButton
@onready var grid_container = %GridContainer


func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	LevelTransition.fade_from_black()
	menu_button.grab_focus()
	
	for level in grid_container.get_children():
		if level.get_index() % 2 == 1:
			Events.game_saver.highscores[level.get_index()/2]
			level.text = str(Events.game_saver.highscores[level.get_index()/2])
	


func _on_menu_button_pressed():
	get_tree().change_scene_to_packed(menu_scene)
