extends VBoxContainer

var layer_path = ""

var buttons = []

# Called when the node enters the scene tree for the first time.
# Create buttons based on levels in folder
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(len(buttons) == 0 and is_visible_in_tree()):
		layer_path = "res://levels/" + Globals.current_layer_menu + "/"
		create_buttons()
		move_child($Back, len(get_children()) - 1)
		get_child(0).grab_focus()
	if(not is_visible_in_tree()):
		for button in buttons:
			button.queue_free()
		buttons = []

# Used to create buttons for each level in a specific layer
func create_buttons():
	var levels = []
	if(Globals.current_layer_menu != ""):
		levels = DirAccess.get_files_at(layer_path)
		for i in range(len(levels)):
			buttons.append(Button.new())
			buttons[i].text = levels[i].replace(".tscn", "") \
					.replace(".remap", "")
			print(buttons[i].text)
			buttons[i].pressed.connect(Callable(self, "_on_button_pressed") \
					.bind(levels[i].replace(".remap", "")))
			buttons[i].add_theme_font_override("font", load("res://Fonts/Minecraft.ttf"))
			buttons[i].add_theme_font_size_override("font_size", 24)
			buttons[i].add_theme_constant_override("outline_size", 16)
			add_child(buttons[i])

# Goes to level corresponding to button pressed
func _on_button_pressed(level: Variant) -> void:
	var tempIdx = Globals.level_paths.find(layer_path + level)
	if(tempIdx != -1):
		get_tree().paused = false
		if(Globals.level_scene != null):
			Globals.level_scene.queue_free()
		Globals.level_idx = Globals.level_paths.find(layer_path + level)
		get_tree().change_scene_to_file("res://scenes/multilevel.tscn")
	else:
		print(level + " is not in the level_paths array.")
	
