extends Area3D

@onready var root = $".."
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $"../AudioStreamPlayer3D"


signal red_key_found

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		emit_signal("red_key_found")
		audio_stream_player_3d.play()
		await audio_stream_player_3d.finished
		root.queue_free()
