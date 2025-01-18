extends Camera3D

var ray_range = 2000

func _input(event):
	if Input.is_action_just_pressed("Fire"):
		get_camera_collision()

func get_camera_collision():
	var screen_center = get_viewport().get_size() / 2
	var ray_origin = project_ray_origin(screen_center)
	var ray_end = ray_origin + project_ray_normal(screen_center) * ray_range
	
	var query = PhysicsRayQueryParameters3D.new()
	query.from = ray_origin
	query.to = ray_end
	
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(query)
	
	if not result.is_empty():
		print(result.collider.name)
	else:
		print("nothing")
