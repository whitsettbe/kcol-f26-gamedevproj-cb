extends Node2D

# Keep track of the undo stack,
#  and the times when states were pushed to it
var level_scene_stack = []
var level_scene_stack_times = [] # seconds
const STACK_DELETION_TIME_WINDOW = 0.03 # seconds
	# indicates how long a stack state is allowed to be removed
	# before it takes an explicit undo to be dropped
const MAX_LEVEL_SIZE_FACTOR = 1.0
	# Maximum fraction of viewport width/height which a level
	#  can take up. This contains the first set of walls
	#  around the level, but not the outermost set of walls.
	#  Those can be outside of the "level" space, and they will
	#  be covered up by the frame.

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
	compute_level_transform()


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
	level_scene_stack.back().pack(Globals.level_scene)
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
		Globals.level_scene.queue_free()
		Globals.level_scene = level_scene_stack.pop_back().instantiate()
		level_scene_stack_times.pop_back()
		call_deferred("add_child", Globals.level_scene)
		connect_level_signals()


# Reset the current level
func _on_level_reset_requested() -> void:
	Globals.level_scene.queue_free()
	load_level(Globals.level_idx)


# Translate and scale the level to center it on the screen
#  and maximize its size. Canvas elements are also arranged
#  to cover the region outside of the level.
func compute_level_transform() -> void:
	
	# Compute the pixel rectangle containing the map,
	#  excluding its extra bounding walls.
	var tilemap : TileMapLayer = \
			Globals.level_scene.get_node("FloorOverlays")
	var grid_rect = tilemap.get_used_rect()
	var grid_rect_contracted = Rect2i(
		grid_rect.position + Vector2i.ONE,
		grid_rect.size - 2 * Vector2i.ONE
	)
	var rect_contracted = Rect2(
		grid_rect_contracted.position * GridArea2D.TILE_SIZE,
		grid_rect_contracted.size * GridArea2D.TILE_SIZE
	) # pixels
	
	# Determine how to scale the level
	var viewport_size = get_viewport().get_visible_rect().size
	var scale_ratios = viewport_size / rect_contracted.size
	var scale_ratio = min(scale_ratios.x, scale_ratios.y)
	scale_ratio *= MAX_LEVEL_SIZE_FACTOR
	
	# Set the level scale
	Globals.level_scene.scale = Vector2.ONE * scale_ratio
	var rect_rescaled = Rect2(
		rect_contracted.position * scale_ratio,
		rect_contracted.size * scale_ratio
	)
	
	# Determine the translation to the screen center
	var viewport_center = viewport_size / 2
	var level_center = rect_rescaled.position + rect_rescaled.size / 2
	var offset_needed = viewport_center - level_center
	
	# Apply the translation
	Globals.level_scene.position = offset_needed
	var rect_recentered = Rect2(
		rect_rescaled.position + offset_needed,
		rect_rescaled.size
	)
	
	# Compute the amount of the screen that needs to be covered
	#  on each side
	var open_top = rect_recentered.position.y
	var open_left = rect_recentered.position.x
	var open_right = viewport_size.x - rect_recentered.end.x
	var open_bottom = viewport_size.y - rect_recentered.end.y
	
	# Position the frame boxes to cover up the region
	#  outside of the level
	#  (assumes the frame boxes all have the same size
	#  as the viewport!)
	$LevelFrame/Top.position = \
			Vector2(0, -viewport_size.y + open_top)
	$LevelFrame/Left.position = \
			Vector2(-viewport_size.x + open_left, 0)
	$LevelFrame/Right.position = \
			Vector2(viewport_size.x - open_right, 0)
	$LevelFrame/Bottom.position = \
			Vector2(0, viewport_size.y - open_bottom)
