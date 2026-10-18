class_name PortalOut
extends GridArea2D


# Indicate if teleportation to this portal is
#  currently prevented, checking for overlapping areas
#  and wall tiles
func is_covered() -> bool:
	if has_overlapping_areas():
		return true
	if get_tile() == TILE_IDS["wall"]:
		return true
	return false
