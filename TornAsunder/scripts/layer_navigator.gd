extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Opens crypt level navigator
func _on_crypt_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/crypt_navigator.tscn")

# Opens ruins level navigator. Not implemented yet
func _on_ruins_pressed() -> void:
	pass # Replace with function body.

# Opens Bog level navigator. Not implemented yet.
func _on_bog_pressed() -> void:
	pass # Replace with function body.

# Opens previous page. Currently hard coded to main menu
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
