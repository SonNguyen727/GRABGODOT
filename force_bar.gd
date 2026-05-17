class_name ForceBar
extends Control

const BAR_WIDTH := 36.0
const BAR_HEIGHT := 5.0
const COLOR_BG := Color(0.07, 0.09, 0.14, 1.0)
const COLOR_FILL := Color(0.93, 0.91, 0.82, 1.0)

@onready var _fill: ColorRect = $Fill


func set_ratio(ratio: float) -> void:
	var clamped: float = clampf(ratio, 0.0, 1.0)
	_fill.offset_right = BAR_WIDTH * clamped


func _ready() -> void:
	custom_minimum_size = Vector2(BAR_WIDTH, BAR_HEIGHT)
	$Bg.offset_right = BAR_WIDTH
	$Bg.offset_bottom = BAR_HEIGHT
	_fill.offset_bottom = BAR_HEIGHT
	set_ratio(0.0)
