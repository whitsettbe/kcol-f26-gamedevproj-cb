class_name Entangled
extends Block

@export var partner : Entangled

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(partner != null,
		"{0} needs a partner".format([self]))
	assert(partner != self,
		"{0} can't be its own partner".format([self]))
	assert(partner.partner == self,
		"{0} must be the partner of its partner".format([self]))
	assert(partner.blockColor == blockColor,
		"{0} and its partner should have the same color".format([self]))
	assert(partner.rolling == rolling,
		"{0} and its partner should have the same rolling status".format([self]))
	assert(partner.rolling == rolling,
		"{0} and its partner should have distinct names".format([self]))
	super()
	

# Ensure that if rolling stopped for one block,
#  the other one is also marked "free to move
#  in any direction" again.
func move_if_possible(dir_vect : Vector2) -> bool:
	var out = super(dir_vect)
	if not out:
		partner.roll_direction = Vector2.ZERO
	return out


# Find all successors of this block (and partner),
#  as array entries (or null if something was unpushable),
#  where each block appears after the objects which must move
#  before it
func get_all_successors(
	dir_vect : Vector2,
	pusher_color : Block.BlockColor,
	as_parent : bool = true) -> Array:
	
	var out = []
	out.append_array(super(dir_vect, pusher_color))
	if as_parent:
		out.append_array(partner.get_all_successors(dir_vect, pusher_color, false))
		out.append(partner)
	return out
	

# Since both this block and its partner will be
#  asked to roll, only one needs to do so.
#  Assumes distinct names.
func roll(dir_vect : Vector2):
	# Ensure both entangled blocks appear to be rolling,
	#  though only one will be managing the roll
	roll_direction = dir_vect
	
	# Compare nodes by reference
	if self.name < partner.name:
		super(dir_vect)


# Fill a hole under this tile,
#  or petrify it if the partner filled a hole
func fill_hole():
	if not dead:
		super()
		if dead:
			partner.fill_hole()
			# alert partner that something changed
	
	if not dead and partner.dead:
		# petrify self in response to partner hole-filling
		set_tile(TILE_IDS["wall"], PUSH_DURATION)
		$CollisionShape2D.disabled = true
		dead = true
