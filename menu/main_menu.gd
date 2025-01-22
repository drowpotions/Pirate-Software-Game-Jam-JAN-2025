extends Control


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = false


func _on_lucy_button_pressed() -> void:
	get_tree().change_scene_to_file("res://lucy_greybox.tscn")


func _on_charlie_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Charlie Greybox/Charlie Grey Box.tscn")


func _on_world_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Test_World/Demo_Scene.tscn")

func _on_intro_pressed() -> void:
	get_tree().change_scene_to_file("res://VN Segment/Intro.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
