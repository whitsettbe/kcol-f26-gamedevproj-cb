class_name Entangled
extends Block

@export var partner : Entangled

func _ready():
	assert(partner != null,
		"{0} needs a partner".format([self]))
	assert(partner != self,
		"{0} can't be its own partner".format([self]))
	assert(partner.partner == self,
		"{0} must be the partner of its partner".format([self]))
	super()
	
# Find all successors of this block (and partner),
#  as dictionary keys (values are "is this movable?")
func get_all_successors(
	dir_vect : Vector2,
	as_parent : bool = true) -> Dictionary:
	
	var out = Dictionary()
	out.merge(super(dir_vect))
	if as_parent:
		out[partner] = true # partner had better be a block :) 
		out.merge(partner.get_all_successors(dir_vect, false))
	return out
