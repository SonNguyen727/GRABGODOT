extends Node2D

var grabbed_robot = null

func _process(delta):
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	global_position = global_position.lerp(
		get_global_mouse_position(),
		20 * delta
	)

	if Input.is_action_pressed("mouse_left"):
		if grabbed_robot == null:
			try_grab()
	else:
		release_robot()

func try_grab():
	var bodies = $Area2D.get_overlapping_bodies()
	
	for body in bodies:
		if "grabbed" in body:
			grabbed_robot = body
			body.grabbed = true
			body.arm = self
			break

func release_robot():

	if grabbed_robot != null:
		grabbed_robot.grabbed = false
		grabbed_robot.arm = null
		grabbed_robot = null
