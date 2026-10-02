@tool
class_name SuperBlock
extends Node2D

enum BlockType {BLOCK, PLAYER, ENTANGLED}
@export var block_type : BlockType = BlockType.BLOCK : set=_set_block_type
var partner : SuperBlock = null : set=_set_partner


const scripts = {
	BlockType.BLOCK : preload("res://scripts/block.gd"),
	BlockType.PLAYER : preload("res://scripts/player.gd"),
	BlockType.ENTANGLED : preload("res://scripts/entangled.gd")
}
const scales = {
	BlockType.BLOCK : 0.4,
	BlockType.PLAYER : 0.5,
	BlockType.ENTANGLED: -0.4
}


func soft_assert(bool_val, message):
	if Engine.is_editor_hint():
		if not bool_val:
			push_warning(message)
	else:
		assert(bool_val)


func _set_partner(new_partner : SuperBlock):
	assert(new_partner == null
			or new_partner.block_type == BlockType.ENTANGLED,
			"{0} must have an ENTANGLED partner".format(self))
	
	partner = new_partner
	$Block.partner = partner.get_child(0)
	
	if block_type == BlockType.ENTANGLED:
		soft_assert(partner != null,
			"{0} needs a partner".format([self]))
		soft_assert(partner != self,
			"{0} can't be its own partner".format([self]))
		soft_assert(partner.partner == self,
			"{0} must be the partner of its partner".format([self]))


func _set_block_type(new_type : BlockType):
	block_type = new_type
	_update_sprite()
	notify_property_list_changed()


func _update_sprite() -> void:
	$Block/Sprite2D.scale = Vector2.ONE * scales[block_type]
	$Block.set_script(scripts[block_type])


func _get_property_list():
	var out = []
	if Engine.is_editor_hint():
		if block_type == BlockType.ENTANGLED:
			out.append({
				"name": "partner",
				"class_name": &"SuperBlock",
				"type": 24,
				"hint": 34,
				"hint_string": "SuperBlock",
				"usage": 4102 })
	return out

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	print( get_script().get_script_property_list() )
	#pass # Replace with function body.
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
