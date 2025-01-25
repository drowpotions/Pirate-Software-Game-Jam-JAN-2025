extends Node3D


@export var index: int 


func _ready() -> void:
	$AnimatedSprite3D2.play("idle")


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if index != 0:
			Global.add_zip_file(index)
		else:
			var enemy = preload("res://enemy/enemy.tscn").instantiate()
			get_parent().add_child(enemy)
			enemy.player = body
			enemy.is_zip = true
			enemy.global_position = global_position
		self.queue_free()
