extends Node

const COLOR_BG := Color(0.050980393, 0.074509804, 0.16862746)
const COLOR_FG := Color(0.93, 0.91, 0.82)

@onready var _menu: VBoxContainer = $CanvasLayer/UI/CenterContainer/MenuButtons
@onready var _settings: Control = $CanvasLayer/UI/SettingsPanel


func _ready() -> void:
	_apply_two_color_theme()
	_settings.visible = false


func _apply_two_color_theme() -> void:
	var button_style := StyleBoxFlat.new()
	button_style.bg_color = COLOR_BG
	button_style.border_color = COLOR_FG
	button_style.set_border_width_all(2)
	button_style.set_content_margin_all(4)

	var button_hover := button_style.duplicate()
	button_hover.bg_color = COLOR_FG

	for node in get_tree().get_nodes_in_group("menu_ui"):
		if node is Label:
			var label: Label = node
			label.add_theme_color_override("font_color", COLOR_FG)
		elif node is Button:
			var button: Button = node
			button.add_theme_stylebox_override("normal", button_style)
			button.add_theme_stylebox_override("hover", button_hover)
			button.add_theme_stylebox_override("pressed", button_hover)
			button.add_theme_stylebox_override("focus", button_style)
			button.add_theme_color_override("font_color", COLOR_FG)
			button.add_theme_color_override("font_hover_color", COLOR_BG)
			button.add_theme_color_override("font_pressed_color", COLOR_BG)
			button.add_theme_color_override("font_focus_color", COLOR_FG)


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn")


func _on_settings_pressed() -> void:
	_menu.visible = false
	_settings.visible = true


func _on_settings_back_pressed() -> void:
	_settings.visible = false
	_menu.visible = true


func _on_exit_pressed() -> void:
	get_tree().quit()
