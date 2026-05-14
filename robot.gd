extends CharacterBody2D

var speed = 200

var grabbed = false
var arm = null

func _process(delta):
	if grabbed and arm != null:
		global_position = global_position.lerp(
			arm.global_position,
			15 * delta
		)
		return

	position.x += speed * delta
