class_name Block
extends GridArea2D

var dead = false


# Make an enum dropdown for block type
#  (level listens to this and attaches scripts automatically)
@export var blockType : BlockType
@export var blockColor: BlockColor

# Set up raycaster to test proximal block
@onready var ray = $RayCast2D

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
