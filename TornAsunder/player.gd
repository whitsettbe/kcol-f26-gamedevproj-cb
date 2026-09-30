extends Node2D

var tile_size = 64
var inputs = { # mapping pressable actions to translation directions
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
	"move_down": Vector2.DOWN,
	"move_up": Vector2.UP
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Block/Sprite2D.scale = Vector2.ONE * .5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Called on input
func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move_if_possible(dir)
	
func move_if_possible(dir):
	var dir_vect = inputs[dir] * tile_size
	if $Block.can_move(dir_vect):
		$Block.move(dir_vect)
