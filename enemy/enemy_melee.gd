extends Node3D


signal finished
@onready var swing_anim: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	await get_tree().create_timer(.5).timeout
	finished.emit()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.hit(1)
