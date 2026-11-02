extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Checks for pause input each frame
func _process(delta: float) -> void:
	pauseInput()

# Unpauses the game and hides the pause menu
func resume():
	get_tree().paused = false
	hide()

# Pauses the game and shows the pause menu
func pause():
	get_tree().paused = true
	show()

# This will go in the _process function so the player can unpause with these buttons in the pause menu
func pauseInput():
	if((Input.is_action_just_pressed("L_pause") or Input.is_action_just_pressed("R_pause")) and get_tree().paused):
		resume()
	elif((Input.is_action_just_pressed("L_pause") or Input.is_action_just_pressed("R_pause")) and not get_tree().paused):
		pause()

# Resumes the game
func _on_resume_pressed() -> void:
	resume()
	
	
# Opens the title screen
func _on_title_screen_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/scenes/main_menu.tscn")
