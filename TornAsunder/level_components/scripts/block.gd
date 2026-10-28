class_name Block
extends GridArea2D


const inputs = {
	# mapping pressable actions to translation directions
	"L_right": Vector2.RIGHT,
	"L_left": Vector2.LEFT,
	"L_down": Vector2.DOWN,
	"L_up": Vector2.UP,
	"R_right": Vector2.RIGHT,
	"R_left": Vector2.LEFT,
	"R_down": Vector2.DOWN,
	"R_up": Vector2.UP
}

# Indicate whether a block should disappear
var dead = false
var death_anim_done = false

# Make enum dropdowns for block type and color
#  (level listens to this and attaches scripts automatically)
@export var blockType : BlockType
@export var blockColor : BlockColor

# Track roll-ability
@export var rolling : bool
var roll_direction = Vector2.ZERO

# Keep track of when the last motion step was made
var last_move_time = 0 # sec

# Set up raycaster to test proximal block
@onready var ray = $RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# If we re-enter after an undo, make sure we keep rolling
	#  by re-trying to roll several times (gives a chance
	#  for intervening blocks to move out of the way
	#  in advance for us, since the loading of blocks into
	#  the scene will not have a well-defined order)
	var old_roll_direction = roll_direction
	if old_roll_direction != Vector2.ZERO:
		for i in range(NUM_REROLL_ATTEMPTS):
			if last_move_time != 0:
				break
			roll(old_roll_direction, false)
			await get_tree().create_timer(
				TOTAL_REROLL_TIME / NUM_REROLL_ATTEMPTS
			).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CollisionShape2D.disabled = dead


# Track which properties should be saved as the game runs
func _get_property_list() -> Array[Dictionary]:
	# Declare array of property data with strictly-specified
	#  type Array[Dictionary], so parse-time typing checks
	#  will recognize the variable type
	var serializable: Array[Dictionary] = [
		{
			"name": "dead",
			"usage": PropertyUsageFlags.PROPERTY_USAGE_NO_EDITOR,
			"type": TYPE_BOOL,
		},
		{
			"name": "death_anim_done",
			"usage": PropertyUsageFlags.PROPERTY_USAGE_NO_EDITOR,
			"type": TYPE_BOOL,
		},
		{
			"name": "roll_direction",
			"usage": PropertyUsageFlags.PROPERTY_USAGE_NO_EDITOR,
			"type": TYPE_VECTOR2,
		},
	]
	return serializable


# Query successor blocks to see if they can move,
#  and push them if so;
#  the success status of the move is returned
#  as a boolean for player feedback.
func move_if_possible(dir_vect : Vector2) -> bool:
	if dead:
		# Rolling also stops if we can't move
		roll_direction = Vector2.ZERO
		# If this block has already fallen into a hole,
		#  then it can't move...
		return false
	
	# Compute successors list
	# (note that there could be duplicates,
	#  but since we have a timeout to prevent double-motion,
	#  each block is automatically moved only once)
	var successors = get_all_successors(dir_vect, blockColor)

	# DEBUG
	print(Time.get_ticks_usec(), self, successors)
	
	# If some unmovable successor was found, don't move
	if null in successors:
		# Rolling also stops if we can't move
		roll_direction = Vector2.ZERO
		
		return false
		
	# Enure two rolls of this block are not happening at once,
	#  in case of being pushed while already rolling
	#  (we set the time immediately to decrease the chance
	#  of a race condition)
	var now = Time.get_ticks_msec() / 1000.0
	if now - last_move_time < MOVE_LOCKOUT_TIME:
		return true
	last_move_time = now
		
	# Move this block's successors
	# (skipping double-motion through the move_single timeout)
	for successor in successors:
		successor.move_single(dir_vect)
	
	# Move self, and override timing checks
	#  (since `last_move_time` was just set
	#  a few instructions ago)
	self.move_single(dir_vect, true)
	
	# Involve self in other moving-adjacent mechanics
	# (note that we wait to do this step so the
	#  timing override is possible, since we want
	#  to reduce race condition risks in the timeout)
	successors.push_back(self)

	# Check for holes in need of filling
	for successor in successors:
		successor.fill_hole()
		
	# Check for paint in need of wiping
	# (or player-recoloring)
	for successor in successors:
		successor.check_for_paint()
		
	return true

	
# Find the complete set of objects which must move
#  with the pusing agent, given the pusher color
#
# Return: array of intervening object references (if pushable)
#  and null references (for unpushable);
#  each block will come AFTER those on which its ability to move
#  depends;
func get_all_successors(
	dir_vect: Vector2,
	pusher_color: BlockColor
	) -> Array:
		
	# If this block has already moved but
	#  physics have not picked up on it yet,
	#  then it effectively has no successors,
	#  because it doesn't need to push anything!
	var now = Time.get_ticks_msec() / 1000.0
	if now - last_move_time < MOVE_LOCKOUT_TIME:
		return []
	
	var immediate = []
	var total = []
	
	# Get the directly intervening raycast
	ray.target_position = dir_vect
	ray.force_raycast_update()
	var collider = ray.get_collider()
	if collider != null:
		immediate.push_back(collider 
				if collider is Block else null)
	
	# Add successors of later blocks
	for successor in immediate:
		var validated_successor = (
			null if successor == null else
			(successor if successor.pushable_by_color_in_dir(
				pusher_color, dir_vect) else 
			null)
		)
			
		if validated_successor != null:
			total.append_array(successor.get_all_successors(
				dir_vect,
				pusher_color)
				)
				
		total.push_back(validated_successor)
	
	return total
	

# Determine whether this block is pushable
#  by an agent of a particular color
func pushable_by_color_in_dir(
		col : BlockColor,
		dir_vect : Vector2
	) -> bool:
	
	# If this block has already moved but
	#  physics have not picked up on it yet,
	#  then it should not block anything!
	var now = Time.get_ticks_msec() / 1000.0
	if now - last_move_time < MOVE_LOCKOUT_TIME:
		return true
	
	if not roll_direction in [Vector2.ZERO, dir_vect]:
		return false
	if blockColor == BlockColor.NONE:
		return true
	return col == blockColor
	
	
# Move this block by the desired amount
# (assuming such a move has been deemed possible)
#
# To do so, move the entire block and lag the sprite,
# which will automatically try to "catch up"
# (see block_sprite.gd);
#
# A move will not be animated if another move has
# been made recently, unless an override is passed
func move_single(
	dir_vect : Vector2,
	timing_override = false
	):
	
	if not timing_override:
		# Enure two rolls are not happening at once,
		#  in case of being pushed while already rolling
		var now = Time.get_ticks_msec() / 1000.0
		if now - last_move_time < MOVE_LOCKOUT_TIME:
			return true
		last_move_time = now
	
	
	$SpriteTile.position -= dir_vect
	position += dir_vect
	
	# If a rolling block, try to move again
	if rolling:
		roll(dir_vect)
		
# Trigger another motion after a timeout
func roll(dir_vect : Vector2,
		do_timeout : bool = true):
	
	# Lock motion except in the desired direction,
	#  then wait to initiate another move attempt
	roll_direction = dir_vect
	if do_timeout:
		await get_tree().create_timer(ROLL_DELAY).timeout
	move_if_possible(dir_vect)


# Replace the current tile with a floor
# if it is a hole, making this block
# inactive if so
func fill_hole():
	if get_tile() == TILE_IDS["hole"]:
		
		# Replace the floor tile, delaying a visual change
		#  until the push is over
		set_tile(TILE_IDS["filled"], PUSH_DURATION)
		
		# Mark the block as "dead"
		# (triggers fade-out by the SpriteTile and
		# disabling of block physics)
		dead = true


# Replace the current tile with just floor
# if it is paint, leaving this block unaffected.
func check_for_paint():
	if is_paint(get_tile()):
		# Replace the floor tile, delaying a visual change
		#  until the push is over
		set_tile(TILE_IDS["floor"], PUSH_DURATION)
