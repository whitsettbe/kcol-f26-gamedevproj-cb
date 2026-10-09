class_name Block
extends Area2D

const TILE_SIZE = 32
const PUSH_DURATION = 0.05 # seconds
var dead = false

const TILE_IDS = {
	"hole" : Vector2i(3,3),
	"floor": Vector2i(-1,-1), # empty overlay
	"wall": Vector2i(5,3)
}

# Make an enum dropdown for block type
#  (level listens to this and attaches scripts automatically)
enum BlockType {BLOCK, PLAYER, ENTANGLED}
@export var blockType : BlockType
enum BlockColor {NONE, BLUE, RED}
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
				successor.blockColor in [BlockColor.NONE, pusher_color])
		if successor is Block:
			total.merge(successor.get_all_successors(dir_vect, pusher_color))
	
	return total
	
	
# Move *only* this block by the desired amount
# (assuming such a move has been deemed possible)
#
# To do so, move the entire block and lag the sprite,
# which will automatically try to "catch up"
# (see block_sprite.gd);
#
# Also trigger hole-filling.
func move_single(dir_vect):
	$SpriteTile.position -= dir_vect
	position += dir_vect
	fill_hole()
	

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
	
	
# Get the current floor map identifier
func get_tile() -> Vector2i:
	var grid_pos = (position / TILE_SIZE) - Vector2.ONE / 2
	grid_pos = Vector2i(grid_pos.round())
	return get_parent().get_node(
		"FloorOverlays").get_cell_atlas_coords(grid_pos)
	
	
# Set the currently stood-upon tile
#  to the provided atlas coordinates,
#  delaying the visual change if requested
func set_tile(atlas_coords : Vector2i, delay_sec : float = 0):
	var FalseOverlays = get_parent().get_node("FalseOverlays")
	var FloorOverlays = get_parent().get_node("FloorOverlays")
	
	# Compute the grid position for the new tile
	var grid_pos = (position / TILE_SIZE) - Vector2.ONE / 2
	grid_pos = Vector2i(grid_pos.round())
	
	# Copy the old tile to a false overlay
	FalseOverlays.set_cell(
		grid_pos, 0, FloorOverlays.get_cell_atlas_coords(grid_pos)
	)
	
	# Replace the underlying tile
	FloorOverlays.set_cell(
		grid_pos, 0, atlas_coords
	)
	
	# Hide the false tile after the delay has passed
	await get_tree().create_timer(delay_sec).timeout
	FalseOverlays.set_cell(
		grid_pos, 0, -Vector2i.ONE
	)
