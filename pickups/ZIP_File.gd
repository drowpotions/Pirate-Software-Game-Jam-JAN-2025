extends Node3D

@onready var root = $".."
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

const ZIP_1 = preload("res://ZIP_1.dialogue")




func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		DialogueManager.show_dialogue_balloon(ZIP_1, "start")
		audio_stream_player_3d.play()
		await audio_stream_player_3d.finished
