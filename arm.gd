extends Node2D

const MIN_THROW_SPEED := 80.0
const MAX_THROW_SPEED := 280.0
const FORCE_CHARGE_SPEED := 0.65
const AIM_DEADZONE := 4.0
const ARROW_ANCHOR_OFFSET := Vector2(0.0, 0.0)
const FORCE_BAR_OFFSET := Vector2(-18.0, -22.0)

const COLOR_ARROW_ON := Color(0.93, 0.91, 0.82, 1.0)
const COLOR_ARROW_OFF := Color(0.93, 0.91, 0.82, 0.25)

var grabbed_robot: Robot = null
var aim_direction: Vector2 = Vector2.RIGHT
var throw_force: float = 0.0

@onready var _aim_arrows: Node2D = $AimArrows
@onready var _arrow_up: Sprite2D = $AimArrows/ArrowUp
@onready var _arrow_down: Sprite2D = $AimArrows/ArrowDown
@onready var _arrow_left: Sprite2D = $AimArrows/ArrowLeft
@onready var _arrow_right: Sprite2D = $AimArrows/ArrowRight
@onready var _force_bar: ForceBar = $ForceBarLayer/ForceBar


func _ready() -> void:
	_aim_arrows.visible = false
	_force_bar.visible = false


func _process(delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	global_position = global_position.lerp(
		get_global_mouse_position(),
		20.0 * delta
	)

	if grabbed_robot != null:
		_update_hold_aim(delta)
	else:
		_aim_arrows.visible = false
		_force_bar.visible = false

	if Input.is_action_pressed("mouse_left"):
		if grabbed_robot == null:
			try_grab()
	else:
		release_robot()


func try_grab() -> void:
	var bodies: Array[Node2D] = $Area2D.get_overlapping_bodies()

	for body in bodies:
		if not body is Robot:
			continue
		var robot: Robot = body
		grabbed_robot = robot
		robot.grabbed = true
		robot.arm = self
		robot.begin_hold()
		throw_force = 0.0
		aim_direction = _snap_throw_direction(get_global_mouse_position() - robot.global_position)
		_update_hold_aim(0.0)
		break


func release_robot() -> void:
	if grabbed_robot == null:
		return

	var robot: Robot = grabbed_robot
	var direction: Vector2 = aim_direction
	var speed: float = lerpf(MIN_THROW_SPEED, MAX_THROW_SPEED, throw_force)
	grabbed_robot = null
	robot.grabbed = false
	robot.arm = null
	robot.throw(direction, speed)
	throw_force = 0.0
	_aim_arrows.visible = false
	_force_bar.visible = false


func _update_hold_aim(delta: float) -> void:
	_aim_arrows.visible = true
	_force_bar.visible = true

	throw_force = minf(1.0, throw_force + delta * FORCE_CHARGE_SPEED)
	_force_bar.global_position = grabbed_robot.global_position + FORCE_BAR_OFFSET
	_force_bar.set_ratio(throw_force)

	_aim_arrows.global_position = grabbed_robot.global_position + ARROW_ANCHOR_OFFSET
	aim_direction = _snap_throw_direction(get_global_mouse_position() - grabbed_robot.global_position)
	_set_arrow_highlight(_arrow_up, aim_direction == Vector2.UP)
	_set_arrow_highlight(_arrow_down, aim_direction == Vector2.DOWN)
	_set_arrow_highlight(_arrow_left, aim_direction == Vector2.LEFT)
	_set_arrow_highlight(_arrow_right, aim_direction == Vector2.RIGHT)


func _set_arrow_highlight(arrow: Sprite2D, active: bool) -> void:
	arrow.modulate = COLOR_ARROW_ON if active else COLOR_ARROW_OFF
	arrow.scale = Vector2(1.2, 1.2) if active else Vector2.ONE


func _snap_throw_direction(aim: Vector2) -> Vector2:
	if aim.length_squared() < AIM_DEADZONE * AIM_DEADZONE:
		return aim_direction

	var angle := aim.angle()
	if angle >= -PI / 4.0 and angle < PI / 4.0:
		return Vector2.RIGHT
	if angle >= PI / 4.0 and angle < 3.0 * PI / 4.0:
		return Vector2.DOWN
	if angle >= -3.0 * PI / 4.0 and angle < -PI / 4.0:
		return Vector2.UP
	return Vector2.LEFT
