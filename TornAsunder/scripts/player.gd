class_name Player
extends Block

const inputs = { # mapping pressable actions to translation directions
	"L_right": Vector2.RIGHT,
	"L_left": Vector2.LEFT,
	"L_down": Vector2.DOWN,
	"L_up": Vector2.UP,
	"R_right": Vector2.RIGHT,
	"R_left": Vector2.LEFT,
	"R_down": Vector2.DOWN,
	"R_up": Vector2.UP
}

enum PlayerSide {LeftPlayer, RightPlayer}
@export var side : PlayerSide


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
