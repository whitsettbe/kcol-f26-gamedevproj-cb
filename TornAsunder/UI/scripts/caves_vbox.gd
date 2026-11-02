extends VBoxContainer

var tempIdx

# Called when the node enters the scene tree for the first time.
# Create buttons based on levels in folder
func _ready() -> void:
	var levels = DirAccess.get_files_at("res://levels/Caves/")
	var buttons = []
	for i in range(len(levels)):
		buttons.append(Button.new())
		buttons[i].text = levels[i].replace(".tscn", "")
		print(buttons[i].text)
		buttons[i].pressed.connect(Callable(self, "_on_button_pressed").bind(levels[i]))
		add_child(buttons[i])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Goes to 
func _on_button_pressed(level: Variant) -> void:
	tempIdx = Globals.level_paths.find("res://levels/Caves/" + level)
	if(tempIdx != -1):
		get_tree().paused = false
		if(Globals.level_scene != null):
			Globals.level_scene.queue_free()
		Globals.level_idx = Globals.level_paths.find("res://levels/Caves/" + level)
		get_tree().change_scene_to_file("res://scenes/multilevel.tscn")
	else:
		print(level + " is not in the level_paths array.")
	
