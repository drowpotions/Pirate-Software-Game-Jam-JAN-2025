extends Camera3D
@onready var dialog = "res://VN Segment/dialogue.dialogue"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(10).timeout
	DialogueManager.show_dialogue_balloon(load("res://VN Segment/dialogue.dialogue"), "start")
	await DialogueManager.dialogue_ended
	var i = 0
	$"../../CanvasLayer/Control/AnimationPlayer".play("fade")
	await $"../../CanvasLayer/Control/AnimationPlayer".animation_finished
	
	get_tree().change_scene_to_file("res://level.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
