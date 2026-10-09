extends TileMapLayer

# Set the position towards which the sprite is drawn
var targ_loc : Vector2
var speed : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targ_loc = Vector2.ONE * -self.get_parent().TILE_SIZE / 2
	speed = self.get_parent().TILE_SIZE \
			/ self.get_parent().PUSH_DURATION


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Compute the vector separating us from target location
	var offset = position - targ_loc
	var offset_dir = offset.normalized()
	var offset_len = offset.length()
	
	# Move closer to the target location
	position -= offset_dir * min(offset_len, delta * speed)
