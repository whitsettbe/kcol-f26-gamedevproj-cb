@tool
extends Node2D


const scripts = {
	Block.BlockType.BLOCK : preload("res://scripts/block.gd"),
	Block.BlockType.PLAYER : preload("res://scripts/player.gd"),
	Block.BlockType.ENTANGLED : preload("res://scripts/entangled.gd")
}
const scales = {
	Block.BlockType.BLOCK : 0.4,
	Block.BlockType.PLAYER : 0.5,
	Block.BlockType.ENTANGLED : -0.4
}


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
			
			node.get_node("Sprite2D").scale = \
					Vector2.ONE * scales[blockType]
