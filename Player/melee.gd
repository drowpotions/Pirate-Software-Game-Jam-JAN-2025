extends Node3D


@onready var swing_anim: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	await swing_anim.animation_finished
	self.queue_free()
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		body.hit(3, "melee")
		print("Yeowch")
