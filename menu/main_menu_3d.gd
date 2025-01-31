extends Node3D


func _process(delta: float) -> void:
	if Input.is_action_pressed("esc"):
		get_tree().quit()


func _on_timer_timeout() -> void:
	var streaks = preload("res://menu/streaks.tscn").instantiate()
	get_node("Marker3D").add_child(streaks)
	print("wee")
