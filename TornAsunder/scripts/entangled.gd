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
	super()


# Find all successors of this block (and partner),
#  as dictionary keys (values are "is this movable?")
func get_all_successors(
	dir_vect : Vector2,
	pusher_color : Block.BlockColor,
	as_parent : bool = true) -> Dictionary:
	
	var out = Dictionary()
	out.merge(super(dir_vect, pusher_color))
	if as_parent:
		out[partner] = true # partner had better be a block
				# of the same color as this one :)
		out.merge(partner.get_all_successors(dir_vect, pusher_color, false))
	return out


# Fill a hole under this tile,
#  or petrify it if the partner filled a hole
func fill_hole():
	if not dead:
		super()
		if dead:
			partner.fill_hole()
			# alert partner that something changed
	
	if not dead and partner.dead:
		# petrify self in response to partner death
		set_tile(TILE_IDS["wall"], PUSH_DURATION)
		$CollisionShape2D.disabled = true
		dead = true
	
	# If this block filled a hole, check with its partner
	#if as_parent and dead:
	#	partner.fill_hole(false)
		
		# If the partner did not become a hole,
		#  turn it into a wall
	#	if not partner.dead:
	#		partner.set_tile(TILE_IDS["wall"], PUSH_DURATION)
	#		partner.get_node("CollisionShape2D").disabled = true
	#		partner.dead = true
