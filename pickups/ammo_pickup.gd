extends RigidBody3D

@onready var sound: AudioStreamPlayer3D = $AudioStreamPlayer

@export var ammo_amt := 16


func _on_visibility_changed() -> void:
	sound.play()
	await sound.finished
	self.queue_free()
