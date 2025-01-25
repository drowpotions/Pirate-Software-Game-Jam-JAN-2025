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


func _on_options_button_pressed() -> void:
	var options = preload("res://ui/options.tscn").instantiate()
	add_child(options)
	await options.closed
	options.queue_free()


func _on_files_pressed() -> void:
	var zip_files = preload("res://menu/zip_files.tscn").instantiate()
	add_child(zip_files)
	await zip_files.closed
	zip_files.queue_free()
