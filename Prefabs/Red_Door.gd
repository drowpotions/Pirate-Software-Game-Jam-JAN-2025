extends Node3D
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $"../AudioStreamPlayer3D"
@onready var area_3d = %Door_Trigger_Area3D


var open_value = -1.0
var close_value = 0.0
var current_value = 0.0
var target_value = close_value

var door_lock = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%AnimationTree.set("parameters/Blend3/blend_amount", close_value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_value = lerp(current_value, target_value, 5 * delta)
	%AnimationTree.set("parameters/Blend3/blend_amount", current_value)
	
	
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and door_lock == false:
		if target_value != open_value:
			target_value = open_value
			audio_stream_player_3d.play()
	
	
func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") and door_lock == false:
		if target_value != close_value:
			target_value = close_value
			audio_stream_player_3d.play()


func _on_area_3d_red_key_found() -> void:
	door_lock = false
	print("yaaas")
