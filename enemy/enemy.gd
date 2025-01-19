extends CharacterBody3D

@onready var dmg_pos: Marker3D = $Marker3D
@onready var detection_area: Area3D = $Area3D

var following := false
var speed := 5.0
var stop_distance = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var player: CharacterBody3D
@export var health := 10


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if following == true:
		look_at(player.global_position)
		var direction = (player.global_transform.origin - global_transform.origin)
		var distance = direction.length()
		
		if distance > stop_distance:
			direction = direction.normalized()
			velocity = direction * speed
		else:
			velocity = Vector3.ZERO
	
	move_and_slide()


func hit(damage):
	if player.player_camera.shooting == true:
		#show_hit_label(damage)
		show_particles()
		health -= damage
		if health == 0:
			self.queue_free()


func show_hit_label(damage):
	var label: Label3D = preload("res://enemy/dmg_label.tscn").instantiate()
	get_parent().add_child(label)
	label.global_position = dmg_pos.global_position
	label.look_at(player.global_position)
	label.text = "-" + str(damage)
	await get_tree().create_timer(1).timeout
	label.queue_free()


func show_particles():
	var particles: GPUParticles3D = preload("res://enemy/enemy_blood.tscn").instantiate()
	get_parent().add_child(particles)
	particles.global_position = self.global_position
	particles.position.y = self.position.y + .9
	particles.emitting = true
	await particles.finished
	particles.queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		following = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		following = false
