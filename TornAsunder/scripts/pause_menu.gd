extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Resumes the game. Not implemented yet.
func _on_resume_pressed() -> void:
	pass # Replace with function body.

# Provides a hint for the current level. Not implemented yet.
func _on_hint_pressed() -> void:
	pass # Replace with function body.

# Opens level navigation.
func _on_levels_pressed() -> void:
	Globals.menu_stack.append("res://scenes/pause_menu.tscn")
	get_tree().change_scene_to_file("res://scenes/layer_navigator.tscn")

# Opens settings menu
func _on_settings_pressed() -> void:
	Globals.menu_stack.append("res://scenes/pause_menu.tscn")
	get_tree().change_scene_to_file("res://scenes/settings.tscn")

# Opens the title screen
func _on_title_screen_pressed() -> void:
	Globals.menu_stack.clear()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
