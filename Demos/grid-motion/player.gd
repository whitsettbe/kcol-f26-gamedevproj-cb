extends Area2D

var tile_size = 64
var inputs = { # mapping pressable actions to translation directions
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
	"move_down": Vector2.DOWN,
	"move_up": Vector2.UP
}

# Set up raycaster to test proximal block
@onready var ray = $RayCast2D

# Define rules for animating smooth movement
var animation_speed = 5
var moving = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Ensure player position is centered on a tile (unshift, round, shift)
	position -= Vector2.ONE * tile_size / 2
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Called on input
func _unhandled_input(event):
	if moving:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)
			
func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update() # force the physics engine to check for collisions,
			# even though this is not a physics update call
	if !ray.is_colliding():
		var tween = create_tween()
		tween.tween_property(self, "position",
			position + inputs[dir] * tile_size,
			1.0 / animation_speed
		).set_trans(Tween.TRANS_SINE)
		moving = true
		await tween.finished
		moving = false
