extends Node


func _ready() -> void:
	connect_buttons(get_tree().root)
	get_tree().node_added.connect(func(node):
			if node is Button:
				connect_to_button(node))


func connect_buttons(root):
	for child in root.get_children():
		if child is Button:
			connect_to_button(child)
		connect_buttons(child)


func connect_to_button(button: Button):
	button.pressed.connect(func():
			play_button_sound())


func play_button_sound():
	var audio_stream_player := AudioStreamPlayer.new()
	audio_stream_player.stream = load("res://autoloads/button_click.wav")
	audio_stream_player.bus = "Sound"
	audio_stream_player.volume_db = linear_to_db(1)
	get_parent().add_child(audio_stream_player)
	audio_stream_player.play()
	audio_stream_player.finished.connect(func():
		audio_stream_player.queue_free()
	)
