extends Node

# Stack to hold previous menus
var menu_stack = []

var level_paths = [
	"res://levels/Playgrounds/playground1.tscn",
	"res://levels/Playgrounds/playground2.tscn"
	]
	
var level_idx = 0

var level_scene

var level_scene_stack = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
