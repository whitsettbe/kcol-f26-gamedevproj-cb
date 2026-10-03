class_name Block
extends Area2D

const TILE_SIZE = 32
const PUSH_DURATION = 0.05 # seconds
var tween : Tween

# Make an enum dropdown for block type
#  (level listens to this and attaches scripts automatically)
enum BlockType {BLOCK, PLAYER, ENTANGLED}
@export var blockType : BlockType

# Set up raycaster to test proximal block
@onready var ray = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Find the complete set of objects which must move
#  with the player.
#
# Return: dictionary of [intervening object] -> [is movable object type?]
func get_all_successors(dir_vect: Vector2) -> Dictionary:
	
	var immediate = Dictionary()
	var total = Dictionary()
	
	# Get the directly intervening raycast
	ray.target_position = dir_vect
	ray.force_raycast_update()
	var collider = ray.get_collider()
	if collider != null:
		immediate[collider] = (collider is Block)
		
	# Add successors of later blocks
	for successor in immediate:
		total[successor] = (successor is Block)
		if successor is Block:
			total.merge(successor.get_all_successors(dir_vect))
	
	return total
	
	
# Move *only* this block by the desired amount
# (assuming such a move has been deemed possible)
func move_single(dir_vect):
	tween = create_tween()
	tween.tween_property(self, "position",
			position + dir_vect, PUSH_DURATION
	).set_ease(Tween.EASE_IN_OUT)


# Indicate whether the movement tween is running
func still_animating():
	return (tween and tween.is_running())
