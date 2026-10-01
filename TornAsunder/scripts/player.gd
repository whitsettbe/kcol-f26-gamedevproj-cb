class_name Player
extends Block

#@export var sprite_scale : Vector2 :
#	set(new_value):
#		$Sprite2D.scale = new_value
#	get:
#		return $Sprite2D.scale

var inputs = { # mapping pressable actions to translation directions
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
	"move_down": Vector2.DOWN,
	"move_up": Vector2.UP
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super() # call the inherited version of this overridden function
	#$Sprite2D.scale = Vector2.ONE * .5

# Called on input
func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move_if_possible_v2(dir)
	
func move_if_possible(dir):
	var dir_vect = inputs[dir] * TILE_SIZE
	if can_move(dir_vect):
		move(dir_vect)
		
func move_if_possible_v2(dir) -> void:
	
	# Compute successors
	var dir_vect = inputs[dir] * TILE_SIZE
	var successors = get_all_successors(dir_vect)
	
	# If some successor was marked unmovable, don't move
	if false in successors.values():
		return
		
	# Otherwise, move this block and the successors
	move_single(dir_vect)
	for successor in successors:
		successor.move_single(dir_vect)
