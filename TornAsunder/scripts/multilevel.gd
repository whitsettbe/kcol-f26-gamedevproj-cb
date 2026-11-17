extends Node2D

# Keep track of the undo stack,
#  and the times when states were pushed to it
var level_scene_stack = []
var level_scene_stack_times = [] # seconds
var current_layer
	# The current layer the level being played is. 
	#  Used to keep track of layer changes, so 
	#  the playlist can change too. 
const STACK_DELETION_TIME_WINDOW = 0.03 # seconds
	# indicates how long a stack state is allowed to be removed
	# before it takes an explicit undo to be dropped
const MAX_LEVEL_SIZE_FACTOR = 1.0
	# Maximum fraction of viewport width/height which a level
	#  can take up. This contains the first set of walls
	#  around the level, but not the outermost set of walls.
	#  Those can be outside of the "level" space, and they will
	#  be covered up by the frame.
const LEVEL_CHANGE_DUR = 1.0 # seconds

var level_fading = false # indicate whether a fade is in progress

@onready var caves_playlist: AudioStreamPlayer = $caves_playlist
@onready var ruins_playlist: AudioStreamPlayer = $ruins_playlist
@onready var bog_playlist: AudioStreamPlayer = $bog_playlist
@onready var false_reverie: AudioStreamPlayer = $false_reverie
@onready var sfx_restart: AudioStreamPlayer = $sfx_restart
@onready var sfx_undo: AudioStreamPlayer = $sfx_undo
@onready var sfx_level_fade_out: AudioStreamPlayer = $sfx_level_fade_out
@onready var sfx_level_fade_in: AudioStreamPlayer = $sfx_level_fade_in



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(Globals.level_idx)
	fadein()


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
	
	if Globals.level_scene is Level:
		# These things don't make sense for cut scenes

		compute_level_transform()
		
		# Check to see if the playlist should be changed,
		#  or if the final level audio should play. 
		check_for_layer_change(Globals.level_scene.layer)
		check_for_final_level()
	
	
	# Hide HUD etc. if on a cut scene
	for ui_element in [$LevelFrame, $HUD]:
		ui_element.visible = (Globals.level_scene is Level)
	for ui_element in [$CutHUD]:
		ui_element.visible = (Globals.level_scene is CutScene)


# Connect the level scene's signals to scripts in this file
func connect_level_signals() -> void:
	Globals.level_scene.connect("level_completed",
			_on_level_completed)
	if Globals.level_scene is not CutScene:
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

	# If there is already a fade happening,
	#  don't advance a second time
	if not fade_is_complete():
		return
	
	await fadeout()
	Globals.level_scene.queue_free()
	Globals.level_idx += 1
	if Globals.level_idx < len(Globals.level_paths):
		load_level(Globals.level_idx)
		await fadein()
	else:
		# Go back to main menu and reset progress
		Globals.level_idx = 0
		get_tree().change_scene_to_file("res://UI/scenes/main_menu.tscn")
		

# Fade out the level
func fadeout() -> void:
	
	# Play_level_transition SFX
	sfx_level_fade_out.play()

	level_fading = true
	$TransitionCanvas/Cover.modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property($TransitionCanvas/Cover, "modulate:a",
			1, LEVEL_CHANGE_DUR / 2)
	await tween.finished
	

# Fade into the level
func fadein() -> void:
	sfx_level_fade_in.play()
	$TransitionCanvas/Cover.modulate.a = 1
	var tween = get_tree().create_tween()
	tween.tween_property($TransitionCanvas/Cover, "modulate:a",
			0, LEVEL_CHANGE_DUR / 2)
	await tween.finished
	level_fading = false
	

# Indicate whether the fade animation is complete
func fade_is_complete() -> bool:
	return level_fading == false


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
		
		# Undo sfx
		sfx_undo.play()


# Reset the current level
func _on_level_reset_requested() -> void:
	Globals.level_scene.queue_free()
	load_level(Globals.level_idx)
	
	# Restart sfx
	sfx_restart.play()


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


# Checks to see if layers have changed between
#  levels. If they have, then the Playlist of music corrosponding 
#  to the approproate layer plays.
#  
#  NOTE: Currently, this function is called when you use the level
#  navigator to go to a level in the layer you are already in, 
#  this is less than ideal but works good enough for now. 
func check_for_layer_change(newLayer) -> void:
	if (newLayer != current_layer):
		
		# Stop previous playlist
		caves_playlist.stop()
		ruins_playlist.stop()
		bog_playlist.stop()
		
		# Play correct playlist
		if (newLayer == 0):
			caves_playlist.play()
		if (newLayer == 1):
			ruins_playlist.play()
		if(newLayer == 2):
			bog_playlist.play()
		
		# Update layer
		current_layer = newLayer

# Checks to see if the level is the final level,
#  If so, play the finale music.
func check_for_final_level()-> void:
		if(Globals.level_scene.is_final == true):
			
			# Stop music currently playing
			caves_playlist.stop()
			ruins_playlist.stop()
			bog_playlist.stop()
			
			# Play false reverie
			false_reverie.play()
		
