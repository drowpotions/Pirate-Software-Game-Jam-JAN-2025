extends Node3D


func _ready() -> void:
	await get_tree().create_timer(10).timeout
	self.queue_free()
