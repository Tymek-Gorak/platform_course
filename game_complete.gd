extends CenterContainer

@export var menu_scene : PackedScene

@onready var menu_button = %MenuButton

func _ready():
	LevelTransition.fade_from_black()
	menu_button.grab_focus()
	


func _on_menu_button_pressed():
	get_tree().change_scene_to_packed(menu_scene)
