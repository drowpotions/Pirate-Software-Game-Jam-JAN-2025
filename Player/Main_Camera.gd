extends Camera3D

@onready var Hit_Label = $"../../../CanvasLayer/Control/Hit_Label"
@onready var shoot_anim_sprite: AnimatedSprite3D = $"../../Weapon_Holder/AnimatedSprite3D"
@onready var cam_anim = $"../../../AnimationPlayer"

var shooting = false

var ray_range = 2000

func _input(_event):
	if Input.is_action_just_pressed("Fire"):
		shoot_sound()
		shoot_anim()
		get_camera_collision()

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
	
	if result and result.has("collider"):
		print(result.collider.name)
		Hit_Label.show()
	else:
		print("nothing")
		Hit_Label.hide()

func shoot_anim():
	shoot_anim_sprite.play("shoot")
	cam_anim.play("cam_shake_shoot")
	shooting = true
	await shoot_anim_sprite.animation_finished
	shooting = false
	shoot_anim_sprite.play("default")

func shoot_sound():
	if shooting == false:
		var audio_stream_player := AudioStreamPlayer.new()
		audio_stream_player.stream = load("res://Player/PH_shoot.wav")
		audio_stream_player.bus = "Sound"
		audio_stream_player.volume_db = linear_to_db(1)
		get_parent().add_child(audio_stream_player)
		audio_stream_player.play()
		audio_stream_player.finished.connect(func():
			audio_stream_player.queue_free()
		)
