extends Node2D

var level_paths = [
	"res://levels/playground1.tscn",
	"res://levels/playground2.tscn"
]
var level_idx = 0
var level_scene
var level_scene_stack = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(level_idx)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

# Load the indicated level, attaching its completion
#  signal to this script
func load_level(idx : int) -> void:
	level_scene = load(level_paths[idx]).instantiate()
	call_deferred("add_child", level_scene)
	level_scene.connect("level_completed", _on_level_completed)
	level_scene_stack = []


func _on_level_completed() -> void:
	level_scene.queue_free()
	level_idx += 1
	if level_idx < len(level_paths):
		load_level(level_idx)
	else:
		get_tree().quit()


func _on_push_progress_requested() -> void:
	level_scene_stack.push_back(PackedScene.new())
	level_scene_stack.back().pack(level_scene)
	
func _on_pop_progress_requested() -> void:
	if len(level_scene_stack) > 0:
		level_scene.queue_free()
		level_scene = level_scene_stack.pop_back().instantiate()
		call_deferred("add_child", level_scene)
		level_scene.connect("level_completed", _on_level_completed)
