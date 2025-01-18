extends Control


func _on_lucy_button_pressed() -> void:
	get_tree().change_scene_to_file("res://lucy_greybox.tscn")


func _on_charlie_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Charlie Grey Box.tscn")


func _on_world_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Test_World/world.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
