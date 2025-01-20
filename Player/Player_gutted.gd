extends CharacterBody3D

@onready var head = $head
@onready var interaction = $"head/Camera Holder/Camera3D/interaction"
@onready var player_collider = $CollisionShape3D
@onready var player_camera = $"head/Camera Holder/Camera3D"
@onready var weapon_holder = $head/Weapon_Holder
@onready var cam_holder = $"head/Camera Holder"
@onready var pickup_radius: Area3D = $PickupRadius

#cam rotation variables
var cam_rotation_amount : float = 0.04


var mouse_rotation_amount :float = 0.01

#variables for breathing
var head_node: Node3D
var head_amplitude: float = 0.0003  # Maximum distance (in meters) the head moves
var weapon_amplitude: float = 0.00003 # Maximum distance (in meters) the head moves
var frequency: float = 0.1  # Breathing cycle frequency (cycles per second)
var time_elapsed: float = 0.0  # Tracks elapsed time

#movement variables
var jump_velocity = 11.0 
var walk_speed = 9.0
var lerp_speed = 45.0

#mouse variables
@export var mouse_sens = 0.4
var mouse_input = Vector2()
var direction = Vector3.ZERO

#STATE MACHINE
var crouching = false
var walking = false
var attacking = false
#fov variables
var Default_FOV = 60
var FOV_Zoom = 50

#crouch variables
const crouch_translate := -1.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# locks mouse movement, hides the mouse
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#Main Input Functions
func _input(event):
	#Handles Camera Movement
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))
		mouse_input = event.relative

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	#breathing headbob
	if head:
		time_elapsed += delta
		# Calculate the breathing offset
		var offset_y = sin(time_elapsed * frequency * TAU) * head_amplitude
		# Apply the offset to the head node
		head.position.y += offset_y

# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forwards", "backwards")
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*lerp_speed)
	if is_on_floor():
		if direction:
			velocity.x = direction.x * walk_speed
			velocity.z = direction.z * walk_speed
		else:
			velocity.x = move_toward(velocity.x, 0, walk_speed)
			velocity.z = move_toward(velocity.z, 0, walk_speed)
	else:
		velocity.x = lerp(velocity.x, direction.x * walk_speed, delta * 1.0)
		velocity.z = lerp(velocity.z, direction.z * walk_speed, delta * 1.0)
		

	move_and_slide()
	menu_features()
	crouch(delta)
	camera_movement(input_dir, delta)
	weapon_sway(delta)
	weapon_crouch_movement(delta)
	weapon_holder_breathing(delta)
	crouch_speed()

#crouching function
@onready var original_capsule_height = player_collider.shape.height
func crouch(delta):
	if Input.is_action_pressed("Crouch"):
		crouching = true
	elif crouching and not self.test_move(self.transform, Vector3(0,1,0)):
		crouching = false
		
		
	head.position.y = lerpf(head.position.y, -crouch_translate if crouching else 1.5, 5.0 * delta)
	$CollisionShape3D.shape.height = original_capsule_height - 1 if crouching else original_capsule_height
	$CollisionShape3D.position.y = $CollisionShape3D.shape.height / 2


func weapon_holder_breathing(delta):
	if weapon_holder:
		time_elapsed += delta
		# Calculate the breathing offset
		var offset_y = sin(time_elapsed * frequency * TAU) * weapon_amplitude
		# Apply the offset to the head node
		weapon_holder.position.y += offset_y

func crouch_speed():
	if crouching == true:
		walk_speed = 4.0
	else: 
		walk_speed = 9.0

#Weapon crouch animation
func weapon_crouch_movement(delta):
	if crouching == true:
		weapon_holder.position.y = lerp(weapon_holder.position.y,-0.0065, 10 * delta)
	else:
		weapon_holder.position.y = lerp(weapon_holder.position.y,0.0, 10 * delta)

#strafing camera
func camera_movement(input_dir, delta):
	if cam_holder:
		cam_holder.rotation.z = lerp(cam_holder.rotation.z, -input_dir.x * cam_rotation_amount, 10 * delta)

#weapon sway
func weapon_sway(delta):
	mouse_input = lerp(mouse_input,Vector2.ZERO,10*delta)
	weapon_holder.rotation.x = lerp(weapon_holder.rotation.x, mouse_input.y * mouse_rotation_amount,10*delta)
	weapon_holder.rotation.y = lerp(weapon_holder.rotation.y, mouse_input.x * mouse_rotation_amount,10*delta)
	weapon_holder.rotation.z = lerp(weapon_holder.rotation.z, mouse_input.x * 0.005,10*delta)
	
#menu interaction
func menu_features():
	if Input.is_action_pressed("esc"):
		get_tree().change_scene_to_file("res://menu/main_menu.tscn")


func _on_pickup_radius_body_entered(body: Node3D) -> void:
	if body.name.begins_with("Ammo"):
		player_camera.pickup_ammo(body.ammo_amt)
		body.hide()
