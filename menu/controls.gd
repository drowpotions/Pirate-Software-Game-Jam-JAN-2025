extends Control


signal closed


func _on_back_pressed() -> void:
	self.hide()
	closed.emit()


func _on_visibility_changed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
