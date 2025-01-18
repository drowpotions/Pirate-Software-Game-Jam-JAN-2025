extends Camera3D

@onready var Hit_Label = $"../../../CanvasLayer/Control/Hit_Label"
var ray_range = 2000

func _input(event):
	if Input.is_action_just_pressed("Fire"):
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
