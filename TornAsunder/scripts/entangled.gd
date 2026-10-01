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

# Find successors of this block,
#  and its entangled partner (if this is
#  the temporary "parent" of the duo)
func get_successors(
	dir_vect : Vector2,
	as_parent : bool = true) -> Array:
	
	# Load this block's usual successors
	var out = Array()
	out += super(dir_vect)
	
	if as_parent:
		# Request partner's successors, treating it
		# as a child
		out += partner.get_successors(dir_vect, false)
		
	print("get_successors:", self, out)
		
	return out
		

# Move the block and its partner
func move(dir_vect : Vector2,
		as_parent : bool = true):
			
	super(dir_vect)
	if as_parent:
		partner.move(dir_vect, false)
