extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(InputEvent) -> void:
	if Input.is_action_pressed("esc"):
		get_tree().change_scene_to_file("res://menu/main_menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass