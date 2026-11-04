extends Node

var level_paths = [
	"res://levels/Playgrounds/playground0.tscn",
	"res://levels/Playgrounds/playground1.tscn",
	"res://levels/Playgrounds/playground2.tscn",
	"res://levels/Caves/1 - Just Walk.tscn",
	"res://levels/Caves/2 - Push Through.tscn",
	"res://levels/Caves/4 - Co-op 101.tscn",
	"res://levels/Caves/7 - Out of the Corner.tscn"
	]
	
var level_idx = 0

var level_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Debug: confirm that the level paths are
	#  all valid.
	for path in level_paths:
		assert(ResourceLoader.exists(path),
			"Path \"{0}\" not found.".format([path]))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
