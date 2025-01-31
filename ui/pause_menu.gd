extends Control


signal dismissed


func show_pause_menu() -> void:
	$CanvasLayer.show()


func _on_resume_button_pressed() -> void:
	$CanvasLayer.hide()
	print("weee")
	dismissed.emit()
	

func _on_options_button_pressed() -> void:
	$Options/CanvasLayer.show()
	$CanvasLayer.hide()
	await $Options.closed
	$CanvasLayer.show()
	

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/Main_Menu_3D.tscn")


func _on_canvas_layer_visibility_changed() -> void:
	if $CanvasLayer.visible == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
