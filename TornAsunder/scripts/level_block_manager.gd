@tool
extends Node2D


const scripts = {
	Block.BlockType.BLOCK : preload("res://level_components/scripts/block.gd"),
	Block.BlockType.PLAYER : preload("res://level_components/scripts/player.gd"),
	Block.BlockType.ENTANGLED : preload("res://level_components/scripts/entangled.gd")
}
const tiles = {
	Block.BlockType.BLOCK : Vector2i(0,0),
	Block.BlockType.PLAYER: Vector2i(4,0),
	Block.BlockType.ENTANGLED: Vector2i(1,0)
}
signal level_completed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		align_block_designs()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		align_block_designs()


# Pass inputs to the player (during game)
func _unhandled_input(event):
	
	if not Engine.is_editor_hint():
		for dir in Block.inputs.keys():
			if event.is_action_pressed(dir):
				for node in get_children():
					if node is Player:
						# Check if the event is for
						# this player in particular
						var isLeftPlayer = (node.side
								== Player.PlayerSide.LeftPlayer)
						var isLeftMotion = (dir[0] == "L")
						if isLeftPlayer == isLeftMotion:
							node.move_if_possible(Block.inputs[dir]
							* GridArea2D.TILE_SIZE)


# Ensure child properties align with their block type
func align_block_designs():
			
	for node in get_children():
		if node is Block:
			align_block_design(node)
			
# Ensure Block properties align with its type
func align_block_design(node : Block):
	
	var blockType = node.blockType
	var blockColor = node.blockColor
	if node.get_script() != scripts[blockType]:
		node.set_script(scripts[blockType])
		node.blockType = blockType # prevent reset on script reload
	
	node.get_node("SpriteTile").set_cell(
		Vector2i(0,0), 0,
		tiles[blockType]
		+ Vector2i(0, blockColor)
			# change row based on color
		+ Vector2i(node.side if node is Player else 0, 0)
			# change column for Roy (default player is Leo)
		+ Vector2i(2 if node.rolling else 0, 0)
	)


# When a player stands on an exit,
#  check if both exits have players on them.
func _on_player_on_exit() -> void:
	if $EXIT_L.players_exiting > 0 \
			and $EXIT_R.players_exiting > 0:
		emit_signal("level_completed")


func _on_level_completed() -> void:
	get_tree().quit()
