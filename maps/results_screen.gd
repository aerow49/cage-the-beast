extends Control

const WON_TEXT := 'You caged that beast'
const LOST_TEXT := 'The beast won'

var nextScene:Resource

func win(nexScene:Resource):
	visible = true
	$VBoxContainer/HBoxContainer/nextLevel.visible = true
	$VBoxContainer/Label.text = WON_TEXT
	nextScene = nexScene
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func lost():
	visible = true
	$VBoxContainer/Label.text = LOST_TEXT
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_next_level_pressed():
	get_tree().change_scene_to_packed(nextScene)


func _on_main_menu_pressed():
	get_tree().change_scene_to_file('res://maps/main_menu.tscn')
