extends Node3D


@export var index: int 


func _ready() -> void:
	$AnimatedSprite3D2.play("idle")


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if index != 0:
			Global.add_zip_file(index)
		else:
			play_spawn_sound()
			var enemy = preload("res://enemy/enemy.tscn").instantiate()
			get_parent().add_child(enemy)
			enemy.player = body
			enemy.is_zip = true
			enemy.position = $".".global_position
			enemy.position.y += 1
		self.queue_free()


func play_spawn_sound():
	var audio_stream_player := AudioStreamPlayer.new()
	audio_stream_player.stream = load("res://enemy/sounds/ZIP FILE - groan.ogg")
	audio_stream_player.bus = "Sound"
	audio_stream_player.volume_db = linear_to_db(.2)
	get_parent().add_child(audio_stream_player)
	audio_stream_player.play()
	audio_stream_player.finished.connect(func():
		audio_stream_player.queue_free()
	)
