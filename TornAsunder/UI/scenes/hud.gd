extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_child(3).text = str(Globals.level_idx) + "/" + str(len(Globals.level_paths))
	get_child(4).text = Globals.level_paths[Globals.level_idx].replace("res://levels/", "").replace(".tscn", "")
