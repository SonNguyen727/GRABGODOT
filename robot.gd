extends CharacterBody2D

var speed = 200

func _process(delta):
	position.x += speed * delta
