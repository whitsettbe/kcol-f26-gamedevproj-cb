extends Block

var tile_size = 64
var inputs = { # mapping pressable actions to translation directions
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
	"move_down": Vector2.DOWN,
	"move_up": Vector2.UP
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super() # call the inherited version of this overridden function
	$Sprite2D.scale = Vector2.ONE * .5

# Called on input
func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move_if_possible(dir)
	
func move_if_possible(dir):
	var dir_vect = inputs[dir] * tile_size
	if can_move(dir_vect):
		move(dir_vect)
