extends CharacterBody2D

var speed = 50
var grabbed = false
var arm = null

@onready var anim = $AnimatedSprite2D


func _physics_process(delta):

	if grabbed and arm != null:

		anim.play("idle")


		var target_position = arm.global_position
		velocity = (target_position - global_position) * 15
		

		move_and_slide()
		return


	anim.play("moving")


	velocity.x = speed
	velocity.y = 0
	

	move_and_slide()
