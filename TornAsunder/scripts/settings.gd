extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Takes you to the audio settings
func _on_audio_pressed() -> void:
	Globals.menu_stack.append("res://scenes/settings.tscn")
	get_tree().change_scene_to_file("res://scenes/audio.tscn")

# Takes you to the previous screen. Currently hard coded to main menu.
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(Globals.menu_stack.pop_back())
