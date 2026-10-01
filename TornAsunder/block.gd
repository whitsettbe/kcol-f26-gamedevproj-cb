class_name Block
extends Area2D

# Set up raycaster to test proximal block
@onready var ray = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Find which objects must move
#  in order for this block to move
func get_successors(dir_vect : Vector2) -> Array:
	
	var out = Array()
	
	# Get the directly intervening raycast
	ray.target_position = dir_vect
	ray.force_raycast_update()
	var collider = ray.get_collider()
	if collider != null:
		out.push_back(collider)
	
	return out

# Check if this block is allowed to move
#  by the requested offset
#  (assumption: one grid square away)
func can_move(dir_vect):
	
	var successors = get_successors(dir_vect)
	for succ in successors:
		if not (succ.has_method("can_move") \
				and succ.can_move(dir_vect)):
			return false
	return true
		
# Move the block by the requested offset
#  (assumption: one grid square away)
#  (assumption: can_move(dir_vect) == True)
func move(dir_vect):
	
	# Move successors
	var successors = get_successors(dir_vect)
	for succ in successors:
		if succ.has_method("move"):
			succ.move(dir_vect)
			
	# After telling successors to move, we can now move
	position += dir_vect
