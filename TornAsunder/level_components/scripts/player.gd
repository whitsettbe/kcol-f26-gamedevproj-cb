class_name Player
extends Block


enum PlayerSide {LeftPlayer, RightPlayer}
@export var side : PlayerSide
@onready var sfx_bump: AudioStreamPlayer = $sfx_bump
@onready var sfx_squish_paint: AudioStreamPlayer = $sfx_squish_paint
@onready var sfx_fall_player: AudioStreamPlayer = $sfx_fall_player


# Ensure player is not "rolling" during the game
func _ready() -> void:
	rolling = false
	

# If a player fails to move, they should
#  "bump" in the desired direction.
func move_if_possible(dir_vect : Vector2) -> bool:
	var successful = super(dir_vect)
	if not successful:
		$SpriteTile.bump(dir_vect)
		if(dead == false):
			sfx_bump.play()
		
	return successful


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
#  align_single_block_design(Block) which will
#  update our sprite to match the new color
func check_for_paint():
	if is_paint(get_tile()):
		
		# Inherit the paint color
		self.blockColor = get_paint_color(get_tile())

		# Request a sprite update from the parent scene
		get_parent().align_single_block_design(self)
		
		#play paint squishh SFX
		sfx_squish_paint.play()
# If *player* falls into a hole,
#  don't fill the hole,
#  instead just dying.
func fill_hole():
	if get_tile() == TILE_IDS["hole"]:
		# Mark the block as "dead"
		# (triggers shrinking of the SpriteTile and
		# disabling of block physics)
		dead = true
		sfx_fall_player.play()
		
