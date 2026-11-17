extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not visible:
		return
	
	var cur_level_path = Globals.level_paths[Globals.level_idx]
	if cur_level_path not in Globals.level_paths_reduced:
		return
	var reduced_idx = Globals.level_paths_reduced.find(cur_level_path)

	get_child(3).text = str(reduced_idx + 1) + "/" + str(len(Globals.level_paths_reduced))
	if(reduced_idx >= 0 and reduced_idx < len(Globals.level_paths_reduced)):
		get_child(4).text = cur_level_path.replace("res://levels/", "").replace(".tscn", "")
