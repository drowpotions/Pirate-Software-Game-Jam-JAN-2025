extends CharacterBody3D

@onready var dmg_pos: Marker3D = $Marker3D
@onready var proj_pos: Marker3D	= $ProjSpawnPoint
@onready var detection_area: Area3D = $Area3D
@onready var los: RayCast3D = $LoS
@onready var sprite: Sprite3D = $Sprite3D
@onready var atk_timer: Timer = $AttackTimer
@onready var nav: NavigationAgent3D = $NavigationAgent3D

var following := false
var attacking := false
var speed := 5.0
var stop_distance = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var max_health: int
var dead := false

@export var player: Node3D
@export var health := 20
@export var los_distance: float = 20.0
@export var is_melee: bool = false
@export var is_zip: bool = false



func _ready() -> void:
	if is_zip:
		is_melee = false
		$AnimatedSprite3D2.play("zip_default")
		$AnimatedSprite3D2.position.y = .15
		atk_timer.start(1)
	elif is_melee:
		stop_distance = 1.0
		atk_timer.wait_time = 3
		$AnimatedSprite3D2.play("melee_default")
		atk_timer.start(3)
	else:
		$AnimatedSprite3D2.play("ranged_default")
		atk_timer.start(1)
		

	atk_timer.paused = true
	los.target_position = Vector3(0,0,-los_distance)
	max_health = health


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
		
	if following == true and dead == false:
		var direction = Vector3()
	
		nav.target_position = player.global_position
		look_at(player.global_position)
		
		direction = nav.get_next_path_position() - global_position
		var distance = direction.length()
		direction = direction.normalized()
		if distance > stop_distance:
			velocity = velocity.lerp(direction * speed, 10 * delta)
		else:
			velocity.x = 0
			velocity.z = 0
		
			
	
	move_and_slide()


func hit(damage, type):
	if player.player_camera.shooting == true:
		following = true
		attacking = true
		look_at(player.global_position)
		#show_hit_label(damage)
		show_particles()
		flash()
		if type == "melee":
			melee_sound()
		
		if health <= max_health/5 and type == "melee":
			health = 0
		else:
			health -= damage
		execute_check()
		if health == 0:
			dead = true
			atk_timer.paused = true
			if is_zip == true:
				$AnimatedSprite3D2.play("zip_death")
			elif is_melee:
				$AnimatedSprite3D2.play("melee_death")
			else:
				$AnimatedSprite3D2.play("ranged_death")
			velocity = Vector3.ZERO
			await get_tree().create_timer(5).timeout
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


func flash():
	sprite.modulate = Color.RED
	await get_tree().create_timer(.5).timeout
	sprite.modulate = Color.WHITE


func execute_check():
	if health  <= max_health/5:
		$ExecuteSprite.show()


func melee_sound():
	var audio_stream_player := AudioStreamPlayer3D.new()
	audio_stream_player.stream = load("res://enemy/PUNCH.ogg")
	audio_stream_player.bus = "Sound"
	audio_stream_player.volume_db = linear_to_db(.7)
	add_child(audio_stream_player)
	audio_stream_player.play()
	audio_stream_player.finished.connect(func():
		audio_stream_player.queue_free()
	)


func attack_sound():
	var audio_stream_player := AudioStreamPlayer3D.new()
	if is_zip:
		audio_stream_player.stream = load("res://enemy/sounds/ZIP FILE - electric.ogg")
	else:
		audio_stream_player.stream = load("res://enemy/sounds/WORM - slither crushed.ogg")
	audio_stream_player.bus = "Sound"
	audio_stream_player.volume_db = linear_to_db(.7)
	add_child(audio_stream_player)
	audio_stream_player.play()
	audio_stream_player.finished.connect(func():
		audio_stream_player.queue_free()
	)


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
						atk_timer.paused = false #attack player if in LoS
					else:
						los.debug_shape_custom_color = Color.RED 
						atk_timer.paused = true #dont attack player if not in LoS


func _on_attack_timer_timeout() -> void:
	if dead == false:
		attack_sound()
		if !is_melee:
			var projectile: CharacterBody3D = preload("res://enemy/projectile.tscn").instantiate()
			get_parent().add_child(projectile)
			if is_zip:
				$AnimatedSprite3D2.play("zip_attack")
			else:
				$AnimatedSprite3D2.play("ranged_attack")
			projectile.global_position = proj_pos.global_position
			projectile.go_to_target(player.head)
			await get_tree().create_timer(.5).timeout
			if is_zip:
				$AnimatedSprite3D2.play("zip_default")
			else:
				$AnimatedSprite3D2.play("ranged_default")
		elif is_melee:
			var melee_arm: Node3D = preload("res://enemy/enemy_melee.tscn").instantiate()
			add_child(melee_arm)
			$AnimatedSprite3D2.play("melee_attack")
			await melee_arm.finished
			melee_arm.queue_free()
			$AnimatedSprite3D2.play("melee_default")
		
	
	
