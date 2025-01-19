extends Camera3D

@onready var Hit_Label = $"../../../CanvasLayer/Control/Hit_Label"
@onready var shoot_anim_sprite: AnimatedSprite3D = $"../../Weapon_Holder/AnimatedSprite3D"
@onready var cam_anim = $"../../../AnimationPlayer"
@onready var ammo_label: Label = $"../../../CanvasLayer/Control/AmmoLabel"

@export var shooting = false

var ray_range = 2000

#weapon vars
@export var fire_rate := 16.0
@export var damage := 1
@export var ammo := 8


func _input(_event):
	if Input.is_action_just_pressed("Fire") and shooting == false:
		#weapon fires if ammo is not 0
		if ammo != 0:
			shooting = true
			ammo -= 1
			ammo_label.text = "Ammo: " + str(ammo) + "/8"
			shoot_sound()
			shoot_anim()
			get_camera_collision()
			print("Ammo left: " + str(ammo))
		#weapon reloads if ammo is 0
		elif ammo == 0:
			reload_anim()
		else:
			print("This should never appear, if it does something is wrong")
	
	#manual reload input, only reload if ammo is not full
	if Input.is_action_just_pressed("reload") and shooting == false:
		if ammo < 8:
			reload_anim()
		elif ammo == 8:
			print("Ammo full!")
		
	jump_shake()

func get_camera_collision():
	# Get the updated viewport size
	var viewport_size = get_viewport().get_visible_rect().size
	var screen_center = viewport_size / 2
	
	var ray_origin = project_ray_origin(screen_center)
	var ray_end = ray_origin + project_ray_normal(screen_center) * ray_range
	
	var query = PhysicsRayQueryParameters3D.new()
	query.from = ray_origin
	query.to = ray_end
	
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(query)
	
	#check for collider
	if result and result.has("collider"):
		print(result.collider.name)
		Hit_Label.show()
		#if collider is a target, change its properties
		if result.collider.is_in_group("target"):
			Hit_Label.text = "Target Hit!"
			result.collider.material.albedo_color = Color.GREEN
			await get_tree().create_timer(3).timeout
			result.collider.material.albedo_color = Color.RED
		#if collider is an enemy, damage its health
		elif result.collider.is_in_group("enemy"):
			Hit_Label.text = "Enemy Hit!"
			result.collider.hit(damage)
			print("Enemy has " + str(result.collider.health) + " remaining")
		#every other case
		else:
			Hit_Label.text = "Hit!"
		await get_tree().create_timer(.5).timeout
		Hit_Label.hide()
	else:
		#no colliders
		print("nothing")
		Hit_Label.hide()


#wait for shoot anim to finish before shooting again
func shoot_anim():
	shoot_anim_sprite.get_sprite_frames().set_animation_speed("shoot", fire_rate)
	shoot_anim_sprite.play("shoot")
	cam_anim.play("cam_shake_shoot")
	await shoot_anim_sprite.animation_finished
	shooting = false
	shoot_anim_sprite.play("default")


#wait for reload anim to finish before shooting again
func reload_anim():
	shooting = true
	shoot_anim_sprite.modulate = Color.BLACK
	ammo_label.text = "Reloading..."
	await get_tree().create_timer(2).timeout
	ammo = 8
	ammo_label.text = "Ammo: " + str(ammo) + "/8"
	shooting = false
	shoot_anim_sprite.modulate = Color.WHITE


func jump_shake():
	if Input.is_action_pressed("jump"):
		cam_anim.play("cam_jump_shake")


func shoot_sound():
	#if shooting == false:
	var audio_stream_player := AudioStreamPlayer.new()
	audio_stream_player.stream = load("res://Player/PH_shoot.wav")
	audio_stream_player.bus = "Sound"
	audio_stream_player.volume_db = linear_to_db(1)
	get_parent().add_child(audio_stream_player)
	audio_stream_player.play()
	audio_stream_player.finished.connect(func():
		audio_stream_player.queue_free()
	)
