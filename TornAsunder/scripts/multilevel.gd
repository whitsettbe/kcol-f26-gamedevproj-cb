extends Node2D

var level_paths = [
	"res://levels/pj_back_to_the_start.tscn",
	"res://levels/playground1.tscn",
	"res://levels/playground2.tscn",
	
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
#  signal to this script.
func load_level(idx : int) -> void:
	level_scene = load(level_paths[idx]).instantiate()
	call_deferred("add_child", level_scene)
	connect_level_signals()
	level_scene_stack = []


# Connect the level scene's signals to scripts in this file
func connect_level_signals() -> void:
	level_scene.connect("level_completed",
			_on_level_completed)
	level_scene.connect("state_push_requested",
			_on_state_push_requested)
	level_scene.connect("state_drop_requested",
			_on_state_drop_requested)
	level_scene.connect("state_undo_requested",
			_on_state_undo_requested)
	level_scene.connect("level_reset_requested",
			_on_level_reset_requested)


# When a level ends, delete it and load the next one,
#  or quit if there is none (temporary behavior)
func _on_level_completed() -> void:
	level_scene.queue_free()
	level_idx += 1
	if level_idx < len(level_paths):
		load_level(level_idx)
	else:
		get_tree().quit()


# Push the scene state to the undo stack,
#  but only if no blocks are actively rolling!
func _on_state_push_requested() -> void:
	
	if level_scene.any_active_rolls():
		return
	
	level_scene_stack.push_back(PackedScene.new())
	level_scene_stack.back().pack(level_scene)


# Delete the last entry on the undo stack
func _on_state_drop_requested() -> void:
	if len(level_scene_stack) > 0:
		level_scene_stack.pop_back()


# Load the last entry on the undo stack
#
# Note that instantiation can cause error messages
#  about duplicate signals. This is unintended behavior
#  on the part of Godot. See discussion at
#  github.com/godotengine/godot/issues/85372.
func _on_state_undo_requested() -> void:
	if len(level_scene_stack) > 0:
		level_scene.queue_free()
		level_scene = level_scene_stack.pop_back().instantiate()
		call_deferred("add_child", level_scene)
		connect_level_signals()


# Reset the current level
func _on_level_reset_requested() -> void:
	level_scene.queue_free()
	load_level(level_idx)
