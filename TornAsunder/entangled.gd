class_name Entangled
extends Block

@export var partner : Entangled
#@export var primary : bool

func _ready():
	assert(partner != null,
		"{0} needs a partner".format([self]))
	assert(partner != self,
		"{0} can't be its own partner".format([self]))
	assert(partner.partner == self,
		"{0} must be the partner of its partner".format([self]))
	super()

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
		
	return out
		

# Move the block and its partner
func move(dir_vect : Vector2,
		as_parent : bool = true):
			
	super(dir_vect)
	if as_parent:
		partner.move(dir_vect, false)
