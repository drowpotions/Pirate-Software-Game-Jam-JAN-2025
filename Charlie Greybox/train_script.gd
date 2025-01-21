extends Area3D
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $"../AudioStreamPlayer3D"
@onready var trains: Node3D = $".."


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		animation_player.play("train_move")
		audio_stream_player_3d.play()
		await get_tree().create_timer(5).timeout
		trains.queue_free()
