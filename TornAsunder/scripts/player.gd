class_name Player
extends Block

const inputs = { # mapping pressable actions to translation directions
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
	"move_down": Vector2.DOWN,
	"move_up": Vector2.UP
}


# Query successor blocks to see if they can move,
#  and push them if so;
#  the success status of the move is returned
#  as a boolean for player feedback
func move_if_possible(dir) -> bool:
	
	# Compute successors
	var dir_vect = inputs[dir] * TILE_SIZE
	var successors = get_all_successors(dir_vect, blockColor)
	
	# If some successor was marked unmovable, don't move
	if false in successors.values():
		return false
		
	# Otherwise, move this block and the successors
	move_single(dir_vect)
	for successor in successors:
		successor.move_single(dir_vect)
	return true
