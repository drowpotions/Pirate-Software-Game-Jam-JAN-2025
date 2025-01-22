extends RigidBody3D


@onready var sound: AudioStreamPlayer3D = $AudioStreamPlayer3D

@export var health_amt := 1


func _on_visibility_changed() -> void:
	sound.play()
	await sound.finished
	self.queue_free()
	pass
