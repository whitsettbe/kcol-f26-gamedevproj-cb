extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var layers = DirAccess.get_directories_at("res://levels/layers/")
	var buttons = []
	for i in range(len(layers)):
		buttons.append(Button.new())
		buttons[i].text = layers[i]
		buttons[i].pressed.connect(Callable($level_navigator, "open").bind(layers[i]))
		add_child(buttons[i])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
