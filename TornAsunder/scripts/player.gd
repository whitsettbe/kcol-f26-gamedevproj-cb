class_name Player
extends Block


enum PlayerSide {LeftPlayer, RightPlayer}
@export var side : PlayerSide


# Ensure player is not "rolling" during the game
func _ready() -> void:
	rolling = false


# Player should be pushable by any color agent,
#  and players don't "roll" so direction comparison
#  isn't important
func pushable_by_color_in_dir(
		col : BlockColor,
		dir_vect : Vector2
	) -> bool:
	
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
