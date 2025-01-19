extends ParallaxBackground


@export var intensity: float = .01


func _process(_delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	
	var viewport_size = get_viewport().get_size()
	
	offset = (mouse_pos - viewport_size * .5) * intensity
	
	scroll_offset = offset
