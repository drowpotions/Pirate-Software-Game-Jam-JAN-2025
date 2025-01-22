extends Control


signal closed


func _on_back_button_pressed() -> void:
	$CanvasLayer.hide()
	closed.emit()


func _on_visibility_changed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
