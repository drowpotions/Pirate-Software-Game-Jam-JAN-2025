extends CharacterBody3D


func _process(delta: float) -> void:
	await get_tree().create_timer(3).timeout
	self.queue_free()


func _physics_process(delta: float) -> void:
	move_and_slide()


func go_to_target(target):
	var direction = (target.global_transform.origin - global_transform.origin)
	direction = direction.normalized()
	velocity = direction * 10
