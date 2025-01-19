extends CharacterBody3D

@onready var dmg_pos: Marker3D = $Marker3D
@onready var detection_area: Area3D = $Area3D
@onready var los: RayCast3D = $LoS

var following := false
var speed := 5.0
var stop_distance = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var player: Node3D
@export var health := 10
@export var los_distance: float = 20.0


func _ready() -> void:
	los.target_position = Vector3(0,0,-los_distance)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		
	if following == true:
		look_at(player.global_position)
		var direction = (player.global_transform.origin - global_transform.origin)
		var distance = direction.length()
		
		#stop following when within stopping distance of player
		if distance > stop_distance:
			direction = direction.normalized()
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		#stop following when player is out of LoS range (TODO: FIX, IT DOESNT WORK!!!!)
		elif distance > -1*los_distance:
			velocity.x = 0
			velocity.z = 0
			following = false
		else:
			velocity.x = 0
			velocity.z = 0
			
	
	move_and_slide()


func hit(damage):
	if player.player_camera.shooting == true:
		following = true
		look_at(player.global_position)
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


func _on_los_timer_timeout() -> void:
	var overlaps = detection_area.get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			if overlap.is_in_group("player"):
				var player_pos = player.global_transform.origin
				los.look_at(player_pos, Vector3.UP)
				los.force_raycast_update()
				
				if los.is_colliding():
					var collider = los.get_collider()
					
					if collider.is_in_group("player"):
						los.debug_shape_custom_color = Color.GREEN
						following = true
					else:
						los.debug_shape_custom_color = Color.RED
