extends Node2D

# Keep track of the undo stack,
#  and the times when states were pushed to it
var level_scene_stack = []
var level_scene_stack_times = [] # seconds
const STACK_DELETION_TIME_WINDOW = 0.03 # seconds
	# indicates how long a stack state is allowed to be removed
	# before it takes an explicit undo to be dropped

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(Globals.level_idx)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

# Load the indicated level, attaching its completion
#  signal to this script.
func load_level(idx : int) -> void:
	Globals.level_scene = load(Globals.level_paths[idx]).instantiate()
	call_deferred("add_child", Globals.level_scene)
	connect_level_signals()
	level_scene_stack = []
	level_scene_stack_times = []


# Connect the level scene's signals to scripts in this file
func connect_level_signals() -> void:
	Globals.level_scene.connect("level_completed",
			_on_level_completed)
	Globals.level_scene.connect("state_push_requested",
			_on_state_push_requested)
	Globals.level_scene.connect("state_drop_requested",
			_on_state_drop_requested)
	Globals.level_scene.connect("state_undo_requested",
			_on_state_undo_requested)
	Globals.level_scene.connect("level_reset_requested",
			_on_level_reset_requested)


# When a level ends, delete it and load the next one,
#  or quit if there is none (temporary behavior)
func _on_level_completed() -> void:
	Globals.level_scene.queue_free()
	Globals.level_idx += 1
	if Globals.level_idx < len(Globals.level_paths):
		load_level(Globals.level_idx)
	else:
		get_tree().quit()


# Push the scene state to the undo stack,
#  but only if no blocks are actively rolling!
func _on_state_push_requested() -> void:
	
	if Globals.level_scene.any_active_rolls():
		return
	
	# Push the state and the current time
	level_scene_stack.push_back(PackedScene.new())
	level_scene_stack.back().pack(level_scene)
	level_scene_stack_times.push_back(
			Time.get_ticks_msec() / 1e3)

# Delete the last entry on the undo stack,
#  but only if it was pushed recently!
func _on_state_drop_requested() -> void:
	var current_time = Time.get_ticks_msec() / 1e3
	if len(level_scene_stack) > 0 \
			and current_time - level_scene_stack_times.back() \
			< STACK_DELETION_TIME_WINDOW:
		level_scene_stack.pop_back()
		level_scene_stack_times.pop_back()


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
		level_scene_stack_times.pop_back()
		call_deferred("add_child", level_scene)
		connect_level_signals()


# Reset the current level
func _on_level_reset_requested() -> void:
	Globals.level_scene.queue_free()
	load_level(Globals.level_idx)
