extends Control


signal closed
var button: Button


func _ready() -> void:
	var grp = ButtonGroup.new()
	$HBoxContainer/VBoxContainer/File1.button_group = grp
	$HBoxContainer/VBoxContainer/File2.button_group = grp
	$HBoxContainer/VBoxContainer/File3.button_group = grp
	$HBoxContainer/VBoxContainer/File4.button_group = grp
	$HBoxContainer/VBoxContainer/File5.button_group = grp
	
	var j = 0
	for i in Global.zip_files:
		if i == false:
			button = get_node("HBoxContainer/VBoxContainer/File" + str(j+1))
			button.text = "Locked"
			button.disabled = true
		j += 1


func _on_file_1_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		$HBoxContainer/ZipContents/Contents1.show()
	elif toggled_on == false:
		$HBoxContainer/ZipContents/Contents1.hide()


func _on_file_2_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		$HBoxContainer/ZipContents/Contents2.show()
	elif toggled_on == false:
		$HBoxContainer/ZipContents/Contents2.hide()


func _on_file_3_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		$HBoxContainer/ZipContents/Contents3.show()
	elif toggled_on == false:
		$HBoxContainer/ZipContents/Contents3.hide()


func _on_file_4_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		$HBoxContainer/ZipContents/Contents4.show()
	elif toggled_on == false:
		$HBoxContainer/ZipContents/Contents4.hide()


func _on_file_5_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		$HBoxContainer/ZipContents/Contents5.show()
	elif toggled_on == false:
		$HBoxContainer/ZipContents/Contents5.hide()


func _on_back_pressed() -> void:
	self.hide()
	closed.emit()


func _on_visibility_changed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
