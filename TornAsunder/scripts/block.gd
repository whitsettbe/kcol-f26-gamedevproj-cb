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


var dead = false


# Make an enum dropdown for block type
#  (level listens to this and attaches scripts automatically)
@export var blockType : BlockType

@export var blockColor : BlockColor
@export var rolling : bool

var roll_direction = Vector2.ZERO

# Keep track of when the last rolling step was made
var last_roll_time = 0 # sec

# Set up raycaster to test proximal block
@onready var ray = $RayCast2D


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
	
	# Compute successors
	var successors = get_all_successors(dir_vect, blockColor)
	successors[self] = true
	
	# If some successor was marked unmovable, don't move
	if false in successors.values():
		# Rolling also stops if we can't move
		roll_direction = Vector2.ZERO
		
		return false
		
	# Otherwise, move this block and the successors
	for successor in successors:
		successor.move_single(dir_vect)
		
	# Check for holes in need of filling
	for successor in successors:
		successor.fill_hole()
		
	# Check for paint in need of wiping
	# (or player-recoloring)
	for successor in successors:
		successor.check_for_paint()
		
	return true

	
# Find the complete set of objects which must move
#  with the player, given the player color
#
# Return: dictionary of [intervening object] ->
#  [is movable given the pusher?]
func get_all_successors(
	dir_vect: Vector2,
	pusher_color: BlockColor
	) -> Dictionary:
	
	var immediate = Dictionary()
	var total = Dictionary()
	
	# Get the directly intervening raycast
	ray.target_position = dir_vect
	ray.force_raycast_update()
	var collider = ray.get_collider()
	if collider != null:
		immediate[collider] = (collider is Block)
		
	# Add successors of later blocks
	for successor in immediate:
		total[successor] = (successor is Block and
				successor.pushable_by_color_in_dir(pusher_color, dir_vect))
		if total[successor]:
			total.merge(successor.get_all_successors(dir_vect, pusher_color))
	
	return total
	

# Determine whether this block is pushable
#  by an agent of a particular color
func pushable_by_color_in_dir(
		col : BlockColor,
		dir_vect : Vector2
	) -> bool:
	
	if not roll_direction in [Vector2.ZERO, dir_vect]:
		return false
	if blockColor == BlockColor.NONE:
		return true
	return col == blockColor
	
	
# Move *only* this block by the desired amount
# (assuming such a move has been deemed possible)
#
# To do so, move the entire block and lag the sprite,
# which will automatically try to "catch up"
# (see block_sprite.gd);
func move_single(dir_vect : Vector2):
	$SpriteTile.position -= dir_vect
	position += dir_vect
	
	# If a rolling block, try to move again
	if rolling:
		roll(dir_vect)
		
# Trigger another motion after a timeout
func roll(dir_vect : Vector2):
	
	# First, enure two rolls are not happening at once,
	#  in case of being pushed while already rolling,
	#  e.g. if there is a rolling block behind this one
	var now = Time.get_ticks_msec() / 1000.0
	if now - last_roll_time < ROLL_LOCKOUT_TIME:
		return
	last_roll_time = now
	
	# Lock motion except in the desired direction,
	#  then wait to initiate another move attempt
	roll_direction = dir_vect
	await get_tree().create_timer(ROLL_DELAY).timeout
	move_if_possible(dir_vect)
	

# Replace the current tile with a floor
# if it is a hole, making this block
# inactive if so
func fill_hole():
	if get_tile() == TILE_IDS["hole"]:
		
		# Replace the floor tile, delaying a visual change
		#  until the push is over
		set_tile(TILE_IDS["floor"], PUSH_DURATION)
		
		# Disable block physics and mark the block as "dead"
		# (triggers fade-out by the SpriteTile)
		$CollisionShape2D.disabled = true
		dead = true


# Replace the current tile with just floor
# if it is paint, leaving this block unaffected.
func check_for_paint():
	if is_paint(get_tile()):
		# Replace the floor tile, delaying a visual change
		#  until the push is over
		set_tile(TILE_IDS["floor"], PUSH_DURATION)
