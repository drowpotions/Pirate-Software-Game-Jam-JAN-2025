extends HSlider


@export var player: CharacterBody3D


func _ready() -> void:
	if player == null:
		self.hide()
		%sens.hide()


func _on_value_changed(value: float) -> void:
	%sens.text = "Sensitivity: " + str(value)
	player.mouse_sens = value
