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
@export var blockColor: BlockColor

# Set up raycaster to test proximal block
@onready var ray = $RayCast2D


# Query successor blocks to see if they can move,
#  and push them if so;
#  the success status of the move is returned
#  as a boolean for player feedback
func move_if_possible(dir_vect : Vector2) -> bool:
	if dead:
		# If the player has already fallen into a hole,
		#  then they can't move...
		return false
	
	# Compute successors
	var successors = get_all_successors(dir_vect, blockColor)
	
	# If some successor was marked unmovable, don't move
	if false in successors.values():
		return false
		
	# Otherwise, move this block and the successors
	move_single(dir_vect)
	for successor in successors:
		successor.move_single(dir_vect)
		
	# Check for holes in need of filling
	fill_hole()
	for successor in successors:
		successor.fill_hole()
		
	# Check for paint in need of wiping
	# (or player-recoloring)
	check_for_paint()
	for successor in successors:
		successor.check_for_paint()
	return true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
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
				successor.pushable_by_color(pusher_color))
		if successor is Block:
			total.merge(successor.get_all_successors(dir_vect, pusher_color))
	
	return total
	

# Determine whether this block is pushable
#  by an agent of a particular color
func pushable_by_color(col : BlockColor):
	if blockColor == BlockColor.NONE:
		return true
	return col == blockColor
	
	
# Move *only* this block by the desired amount
# (assuming such a move has been deemed possible)
#
# To do so, move the entire block and lag the sprite,
# which will automatically try to "catch up"
# (see block_sprite.gd);
func move_single(dir_vect):
	$SpriteTile.position -= dir_vect
	position += dir_vect
	

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
