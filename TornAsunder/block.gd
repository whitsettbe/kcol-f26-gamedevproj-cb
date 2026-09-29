extends Area2D

var tile_size = 64

# Set up raycaster to test proximal block
@onready var ray = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Ensure block position is centered on a tile (unshift, round, shift)
	#position -= Vector2.ONE * tile_size / 2
	#position = position.snapped(Vector2.ONE * tile_size)
	#position += Vector2.ONE * tile_size / 2
	pass # assume the block was placed correctly...

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#var cm = can_move(Vector2.DOWN * tile_size)
	#print(self, cm)
	#if cm:
	#	move(Vector2.DOWN * tile_size)
	
func can_move(dir_vect):
	
	ray.target_position = dir_vect
	ray.force_raycast_update() # force the physics engine to check for collisions,
			# even though this is not a physics update call
			
	var collider = ray.get_collider()
	if collider != null:
		#print(collider)
		if collider.has_method("can_move"):
			return collider.can_move(dir_vect)
		else:
			return false
	else:
		return true
		

func move(dir_vect):
	# assumes can_move was valid
	ray.target_position = dir_vect
	ray.force_raycast_update() # force the physics engine to check for collisions,
			# even though this is not a physics update call
			
	var collider = ray.get_collider()
	if collider != null:
		if collider.has_method("move"):
			collider.move(dir_vect)
			
	# After telling successors to move, we can now move
	position += dir_vect
