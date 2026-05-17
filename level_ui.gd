extends Node2D


func _ready() -> void:
	add_to_group("level_ui")
	$CanvasLayer/level_complete_screen.visible = false
	$CanvasLayer/level_complete_screen/NextButton.pressed.connect(_on_next_pressed)


func show_level_complete() -> void:
	$CanvasLayer/level_complete_screen.visible = true


func _on_next_pressed() -> void:
	get_tree().reload_current_scene()
