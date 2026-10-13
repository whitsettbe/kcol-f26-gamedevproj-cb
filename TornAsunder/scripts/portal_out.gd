extends Area2D
class_name PortalOut

# ** These constants are copied from block.gd **
# ** they should be refactored to a shared    **
# ** location at some point...                **

const TILE_SIZE = 32

# Indicate how to identify different tile types
const TILE_IDS = {
	"hole" : Vector2i(3,3),
	"floor": Vector2i(-1,-1), # empty overlay
	"wall": Vector2i(5,3)
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Indicate if teleportation to this portal is
#  currently prevented, checking for overlapping areas
#  and wall tiles
func is_covered() -> bool:
	if has_overlapping_areas():
		return true
	if get_tile() == TILE_IDS["wall"]:
		return true
	return false


# Get the current floor map identifier
func get_tile() -> Vector2i:
	var grid_pos = (position / TILE_SIZE) - Vector2.ONE / 2
	grid_pos = Vector2i(grid_pos.round())
	return get_parent().get_node(
		"FloorOverlays").get_cell_atlas_coords(grid_pos)
