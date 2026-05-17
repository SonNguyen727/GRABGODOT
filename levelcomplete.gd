extends Area2D

@export var collect_on_enter := true


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if not collect_on_enter:
		return
	if not body.is_in_group("robot"):
		return
	if body.grabbed:
		return

	_collect(body)


func _collect(_robot: Node2D) -> void:
	set_deferred("monitoring", false)
	$Sprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)

	for ui in get_tree().get_nodes_in_group("level_ui"):
		if ui.has_method("show_level_complete"):
			ui.show_level_complete()
			return
