extends Area2D
class_name GridArea2D

# Class containing info on grid dimensions and
#  important identification rules shared between
#  blocks and other gridded Area2D nodes (e.g. portals)

# Grid dimensions/motion parameters
const TILE_SIZE = 32 # pixels
const PUSH_DURATION = 0.05 # seconds
const FADE_DURATION = 0.4 # seconds
const ROLL_DELAY = 0.05 # seconds
const MOVE_LOCKOUT_TIME = 0.01 # seconds

# Declare enums for block data
enum BlockType {BLOCK, PLAYER, ENTANGLED}
enum BlockColor {NONE, BLUE, RED}

# Indicate how to identify different tile types
const TILE_IDS = {
	"hole": Vector2i(3,3),
	"floor": Vector2i(-1,-1), # empty overlay
	"wall": Vector2i(5,3),
	"filled": Vector2i(6,3)
}
func is_paint(t:Vector2i) -> bool:
	return t.x == 6 and 0 <= t.y and t.y <= 2
func get_paint_color(t:Vector2i) -> BlockColor:
	return t.y


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Get the current floor map identifier
func get_tile() -> Vector2i:
	var grid_pos = (position / TILE_SIZE) - Vector2.ONE / 2
	grid_pos = Vector2i(grid_pos.round())
	return get_parent().get_node(
		"FloorOverlays").get_cell_atlas_coords(grid_pos)
	
	
# Set the currently stood-upon tile
#  to the provided atlas coordinates.
#
# 1. Copy the current floor overlay tile to a temporary
#    ("false") overlay node visible to the user.
# 2. Replace the actual floor tile with the requested one.
# 3. After a time delay, remove the temporary overlay tile.
# 
# Assumption: the parent scene has TileMapLayer nodes
#    named Floor, FalseOverlays, and FloorOverlays
func set_tile(atlas_coords : Vector2i, delay_sec : float = 0):
	var Floor = get_parent().get_node("Floor")
	var FalseOverlays = get_parent().get_node("FalseOverlays")
	var FloorOverlays = get_parent().get_node("FloorOverlays")
	
	# Compute the grid position for the new tile
	var grid_pos = (position / TILE_SIZE) - Vector2.ONE / 2
	grid_pos = Vector2i(grid_pos.round())
	
	# Copy the old tile to a false overlay
	var old_tile = FloorOverlays.get_cell_atlas_coords(grid_pos)
	if old_tile == Vector2i.ONE * -1:
		# If there's nothing there, use the underlying
		#  floor tile as cover instead
		old_tile = Floor.get_cell_atlas_coords(grid_pos)
	FalseOverlays.set_cell(
		grid_pos, 0, old_tile
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
