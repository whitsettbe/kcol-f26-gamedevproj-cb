@tool
extends Node2D


const scripts = {
	Block.BlockType.BLOCK : preload("res://scripts/block.gd"),
	Block.BlockType.PLAYER : preload("res://scripts/player.gd"),
	Block.BlockType.ENTANGLED : preload("res://scripts/entangled.gd")
}
const tiles = {
	Block.BlockType.BLOCK : Vector2i(2,0),
	Block.BlockType.PLAYER: Vector2i(8,1),
	Block.BlockType.ENTANGLED: Vector2i(1,1)
}
#const scales = {
#	Block.BlockType.BLOCK : 1.0,
#	Block.BlockType.PLAYER : 1.0,
#	Block.BlockType.ENTANGLED : 1.0
#}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		align_block_designs()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		align_block_designs()
		
# Ensure child properties align with their block type
func align_block_designs():
			
	for node in get_children():
		if node is Block:
			var blockType = node.blockType
			if node.get_script() != scripts[blockType]:
				node.set_script(scripts[blockType])
				node.blockType = blockType # prevent reset on script reload
			
			#node.get_node("Sprite2D").scale = \
			#		Vector2.ONE * scales[blockType]
			node.get_node("TileMapLayer").set_cell(
				Vector2i(0,0), 0, tiles[blockType]
			)
