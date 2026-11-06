extends VBoxContainer

var tempIdx

var layer_path = ""

var buttons = []

var levels = []

# Called when the node enters the scene tree for the first time.
# Create buttons based on levels in folder
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(len(buttons) == 0 and is_visible_in_tree()):
		layer_path = "res://levels/" + Globals.current_layer_menu + "/"
		create_buttons()
	if(not is_visible_in_tree()):
		for button in buttons:
			button.queue_free()
		buttons = []

# Used to create buttons for each level in a specific layer
func create_buttons():
	if(Globals.current_layer_menu != ""):
		levels = DirAccess.get_files_at(layer_path)
		for i in range(len(levels)):
			buttons.append(Button.new())
			buttons[i].text = levels[i].replace(".tscn", "")
			print(buttons[i].text)
			buttons[i].pressed.connect(Callable(self, "_on_button_pressed").bind(levels[i]))
			add_child(buttons[i])

# Goes to level corresponding to button pressed
func _on_button_pressed(level: Variant) -> void:
	tempIdx = Globals.level_paths.find(layer_path + level)
	if(tempIdx != -1):
		get_tree().paused = false
		if(Globals.level_scene != null):
			Globals.level_scene.queue_free()
		Globals.level_idx = Globals.level_paths.find(layer_path + level)
		get_tree().change_scene_to_file("res://scenes/multilevel.tscn")
	else:
		print(level + " is not in the level_paths array.")
	
