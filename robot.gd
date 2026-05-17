class_name Robot
extends CharacterBody2D

const MOVE_SPEED := 50.0

var speed := MOVE_SPEED
var grabbed := false
var arm: Node2D = null

var _throw_velocity := Vector2.ZERO
var _hold_position := Vector2.ZERO

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	add_to_group("robot")


func _physics_process(_delta: float) -> void:
	if grabbed and arm != null:
		anim.play("idle")
		global_position = _hold_position
		_throw_velocity = Vector2.ZERO
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if _throw_velocity != Vector2.ZERO:
		anim.play("moving")
		velocity = _throw_velocity
		move_and_slide()
		if get_slide_collision_count() > 0:
			clear_throw()
		return

	anim.play("moving")
	velocity = Vector2(MOVE_SPEED, 0.0)
	move_and_slide()


func begin_hold() -> void:
	_hold_position = global_position
	clear_throw()


func throw(direction: Vector2, throw_speed: float) -> void:
	_throw_velocity = direction.normalized() * throw_speed


func clear_throw() -> void:
	_throw_velocity = Vector2.ZERO
	velocity = Vector2.ZERO
