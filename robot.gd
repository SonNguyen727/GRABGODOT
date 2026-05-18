class_name Robot
extends CharacterBody2D

const MOVE_SPEED := 50.0
const THROW_DISTANCE_SCALE := 0.28

var speed := MOVE_SPEED
var grabbed := false
var arm: Node2D = null

var _throw_velocity := Vector2.ZERO
var _throw_distance_left := 0.0
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
		_throw_distance_left -= velocity.length() * _delta
		if _throw_distance_left <= 0.0:
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
	_throw_distance_left = throw_speed * THROW_DISTANCE_SCALE


func clear_throw() -> void:
	_throw_velocity = Vector2.ZERO
	_throw_distance_left = 0.0
	velocity = Vector2.ZERO
