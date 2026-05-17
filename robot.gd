extends CharacterBody2D

var speed = 200

var grabbed = false
var arm = null

@onready var anim = $AnimatedSprite2D

func _process(delta):

	if grabbed and arm != null:

		anim.play("idle")

		global_position = global_position.lerp(
			arm.global_position,
			15 * delta
		)

		return

	anim.play("moving")

	position.x += speed * delta
