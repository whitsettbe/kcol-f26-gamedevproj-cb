extends TileMapLayer

# Set the position towards which the sprite is drawn
var targ_loc : Vector2
var motion_speed : float # pixels / sec
var alpha_speed : float # 1 / sec

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targ_loc = Vector2.ONE * -self.get_parent().TILE_SIZE / 2
	motion_speed = self.get_parent().TILE_SIZE \
			/ self.get_parent().PUSH_DURATION
	alpha_speed = 1 / self.get_parent().PUSH_DURATION


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Compute the vector separating us from target location
	var offset = position - targ_loc
	var offset_dir = offset.normalized()
	var offset_len = offset.length()
	
	if offset_len > 0:
		# Move closer to the target location
		position -= offset_dir * min(offset_len,
				delta * motion_speed)
	elif self.get_parent().dead:
		modulate.a -= clamp(delta * alpha_speed, 0, modulate.a)
