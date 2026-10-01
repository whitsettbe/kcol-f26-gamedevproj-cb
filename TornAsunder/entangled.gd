class_name Entangled
extends Block

@export var partner : Entangled
@export var primary : bool

func _ready():
	assert(partner != null,
		"{0} needs a partner".format([self]))
	assert(partner != self,
		"{0} can't be its own partner".format([self]))
	assert(partner.partner == self,
		"{0} must be the partner of its partner".format([self]))
	if primary:
		assert(not partner.primary,
			"{0} and its partner can't both be primary".format([self]))
	else:
		assert(partner.primary,
			"{0} or its partner must be primary".format([self]))
	super()

# Find which objects must move
#  in order for this block to move
func get_successors(
	dir_vect : Vector2,
	as_child : bool = false) -> Array:
		
	if primary:
		# Load this block's usual successors
		# and those of its "child" partner
		var out = Array()
		out += super(dir_vect)
		out += partner.get_successors(dir_vect, true)
		return out
		
	elif as_child:
		# Load only this block's usual successors,
		#  since specifically requested to by its
		#  primary partner
		return super(dir_vect)
		
	else:
		# Delegate to its primary partner
		return partner.get_successors(dir_vect)
		

# Move the block and its partner
func move(dir_vect : Vector2,
		as_child : bool = false):
	
	if primary:
		super(dir_vect)
		partner.move(dir_vect, true)
	
	elif as_child:
		super(dir_vect)
	
	else:
		partner.move(dir_vect)
