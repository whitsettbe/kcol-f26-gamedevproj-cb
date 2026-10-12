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


# If *player* stands on paint,
#  don't destroy the paint,
#  rather taking on the paint's color
#
# Assumption: parent scene has a script defining
#  align_block_design(Block) which will
#  update our sprite to match the new color
func check_for_paint():
	if is_paint(get_tile()):
		
		# Inherit the paint color
		self.blockColor = get_paint_color(get_tile())
		
		# Request a sprite update from the parent scene
		get_parent().align_block_design(self)
