@tool
extends Node2D


const scripts = {
	Block.BlockType.BLOCK : preload("res://level_components/scripts/block.gd"),
	Block.BlockType.PLAYER : preload("res://level_components/scripts/player.gd"),
	Block.BlockType.ENTANGLED : preload("res://level_components/scripts/entangled.gd")
}
const tiles = {
	Block.BlockType.BLOCK : Vector2i(0,0),
	Block.BlockType.PLAYER: Vector2i(4,0),
	Block.BlockType.ENTANGLED: Vector2i(1,0)
}
signal level_completed
signal state_push_requested
signal state_drop_requested
signal state_undo_requested
signal level_reset_requested
var solid_invariant_tracker : int

# Set up timeouts for input duplication
var input_timeouts = Dictionary()
	# direction action -> seconds until usable
const INPUT_ECHO_DELAY = 0.5 # seconds for which a key
		# must be held to trigger echo motion (i.e. running)
		# Note that if a key has been *available* for
		#  this long, then we consider a run to have
		#  ended.
const INPUT_RUN_INTERVAL = 0.15 # seconds between
		# running motions (repeated motion during
		# key-holding)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		align_block_designs()
		solid_invariant_tracker = get_solid_invariant()
		
		# Listen for when players land on the exits
		$EXIT_L.connect("player_on_exit", _on_player_on_exit)
		$EXIT_R.connect("player_on_exit", _on_player_on_exit)
		
		# Set up input timeouts
		for dir in Block.inputs.keys():
			# Enforce a short delay before key
			#  input is accepted at level load
			#  (this will only affect keys which
			#   are pressed at level load, as other
			#   keys are marked immediately usable
			#   in _process() )
			input_timeouts[dir] = INPUT_ECHO_DELAY


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		align_block_designs()
	else:
		# While the level is in an unsafe state
		#  (say, if multiple blocks are in the same place),
		#  roll back the level state
		if not state_is_safe():
			emit_signal("state_undo_requested")
			
		# Update time until each input is usable
		for dir in Block.inputs.keys():
			if Input.is_action_pressed(dir):
				input_timeouts[dir] -= delta
			else:
				# Mark this input as usable,
				#  but not part of a run (looks to not have
				#  been pressed in a while, with
				#  -INPUT_ECHO_DELAY as the sentinel value)
				input_timeouts[dir] = -INPUT_ECHO_DELAY
			
		# Check for player inputs, if the tree is not paused
		if Input.is_anything_pressed() and not get_tree().paused:
			handle_key_input()


# Pass keyboard inputs to the player (during game)
func handle_key_input() -> void:
	
	var state_pushed = false
	var move_succeeded = false
	
	if not Engine.is_editor_hint():
		for dir in Block.inputs.keys():
			if Input.is_action_pressed(dir):
				# If not allowed to process this action yet,
				#  skip it.
				if input_timeouts[dir] > 0:
					continue
				
				# Reset the input timer, with quicker timing
				#  if the key seems to have been held down.
				if input_timeouts[dir] <= -INPUT_ECHO_DELAY:
					input_timeouts[dir] = INPUT_ECHO_DELAY
				else:
					input_timeouts[dir] = INPUT_RUN_INTERVAL
				
				# Push the current state to the undo stack
				if not state_pushed:
					state_pushed = true
					emit_signal("state_push_requested")
				
				for node in get_children():
					if node is Player:
						# Check if the event is for
						# this player in particular
						var isLeftPlayer = (node.side
								== Player.PlayerSide.LeftPlayer)
						var isLeftMotion = (dir[0] == "L")
						if isLeftPlayer == isLeftMotion:
							move_succeeded = move_succeeded or \
								node.move_if_possible(Block.inputs[dir]
								* GridArea2D.TILE_SIZE)
								
		# If moves were attempted but did not succeed,
		#  delete the pushed state;
		#  Note that the drop is time-limited not to drop
		#  old states, which may still be at the top of the
		#  stack if the state push triggered earlier in this
		#  function was unsuccessful
		if state_pushed and not move_succeeded:
			emit_signal("state_drop_requested")
			
		# Handle undo if requested by user
		if Input.is_action_just_pressed("undo"):
			emit_signal("state_undo_requested")
			
		# Handle level restart if requested by user
		if Input.is_action_just_pressed("restart"):
			emit_signal("level_reset_requested")


# Ensure child properties align with their block type
func align_block_designs():
			
	for node in get_children():
		if node is Block:
			align_single_block_design(node)
			
# Ensure Block properties align with its type
func align_single_block_design(node : Block):
	
	var blockType = node.blockType
	var blockColor = node.blockColor
	if node.get_script() != scripts[blockType]:
		node.set_script(scripts[blockType])
		node.blockType = blockType # prevent reset on script reload
	
	node.get_node("SpriteTile").set_cell(
		Vector2i(0,0), 0,
		tiles[blockType]
		+ Vector2i(0, blockColor)
			# change row based on color
		+ Vector2i(node.side if node is Player else 0, 0)
			# change column for Roy (default player is Leonard)
		+ Vector2i(2 if node.rolling else 0, 0)
	)


# When a player stands on an exit,
#  check if both exits have players on them.
#  (this script is connected to the relevant signals
#  at runtime - see self._ready() )
func _on_player_on_exit() -> void:
	if $EXIT_L.players_exiting > 0 \
			and $EXIT_R.players_exiting > 0:
		emit_signal("level_completed")
		

# Indicate whether the level is in a safe state,
#  by checking whether the solid invariant has changed
func state_is_safe() -> bool:
	return get_solid_invariant() == solid_invariant_tracker
	

# Calculate the difference between the number of "solid"
#  grid squares (i.e. containing walls or visible blocks)
#  and the number of holes, which should be invariant
#  over the level
func get_solid_invariant() -> int:
	var solid_squares = []
	var hole_squares = []
	
	# Recognize squares where there are active blocks
	for node in get_children():
		if node is Block and not node.dead:
			solid_squares.append(
				GridArea2D.pos_to_tile_coords(node.position)
			)
	
	# Add walls and holes to the tracked arrays
	solid_squares.append_array($FloorOverlays.get_used_cells_by_id(
		-1, GridArea2D.TILE_IDS.wall
	))
	hole_squares.append_array($FloorOverlays.get_used_cells_by_id(
		-1, GridArea2D.TILE_IDS.hole
	))
	
	# Convert arrays to dictionaries for counting the
	#  de-duplicated squares
	var solid_squares_dict = {}
	var hole_squares_dict = {}
	for s_sq in solid_squares:
		solid_squares_dict[s_sq] = true
	for h_sq in hole_squares:
		hole_squares_dict[h_sq] = true
	
	# The difference should be invariant
	return len(solid_squares_dict) - len(hole_squares_dict)


# Indicate whether any blocks in the level are currently
#  in the middle of a roll
func any_active_rolls() -> bool:
	for node in get_children():
		if node is Block and not node.dead \
				and node.roll_direction != Vector2.ZERO:
			# the check for dead should be unnecessary...
			
			return true
	return false
