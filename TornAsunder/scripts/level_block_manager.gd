@tool
extends Node2D


const scripts = {
	Block.BlockType.BLOCK : preload("res://scripts/block.gd"),
	Block.BlockType.PLAYER : preload("res://scripts/player.gd"),
	Block.BlockType.ENTANGLED : preload("res://scripts/entangled.gd")
}
const tiles = {
	Block.BlockType.BLOCK : Vector2i(0,0),
	Block.BlockType.PLAYER: Vector2i(4,0),
	Block.BlockType.ENTANGLED: Vector2i(1,0)
}


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
	
	if not Engine.is_editor_hint() \
			and not still_animating():
		for dir in Player.inputs.keys():
			if event.is_action_pressed(dir):
				for node in get_children():
					if node is Player:
						node.move_if_possible(dir)


# Ensure child properties align with their block type
func align_block_designs():
			
	for node in get_children():
		if node is Block:
			var blockType = node.blockType
			var blockColor = node.blockColor
			if node.get_script() != scripts[blockType]:
				node.set_script(scripts[blockType])
				node.blockType = blockType # prevent reset on script reload
			
			node.get_node("TileMapLayer").set_cell(
				Vector2i(0,0), 0,
				tiles[blockType] + Vector2i(0, blockColor)
			)


# Determine whether any of the children blocks
#  are in the middle of an animation
func still_animating() -> bool:
	for node in get_children():
		if node is Block:
			if node.still_animating():
				return true
	return false
