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
#  then try to do so with entangled partner,
#  then petrify it (convert it to a wall) if needed
func fill_hole(as_parent: bool = true):
	super()
	
	# If this block filled a hole, check with its partner
	if as_parent \
			and $CollisionShape2D.disabled:
		partner.fill_hole(false)
			# ASSUMPTION: partner is close enough to
			#  finishing their motion tween
			#  that their position will be converted
			#  accurately
		
		# If the partner did not become a hole,
		#  turn it into a wall
		if not partner.get_node("CollisionShape2D").disabled:
			partner.set_tile(TILE_IDS["wall"])
			partner.hide()
			partner.get_node("CollisionShape2D").disabled = true
