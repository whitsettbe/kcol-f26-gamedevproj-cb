class_name PortalOut
extends GridArea2D


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
