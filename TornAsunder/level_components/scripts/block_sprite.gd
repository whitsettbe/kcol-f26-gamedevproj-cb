extends TileMapLayer

# Set the position towards which the sprite is drawn
var base_targ_loc : Vector2
var targ_loc : Vector2
var base_motion_speed : float # pixels / sec
var motion_speed : float # pixels / sec
var alpha_speed : float # 1 / sec
var scale_speed : float # 1 / sec
const CLOSE_VALUE : float = 1e-3 # unitless


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_targ_loc = Vector2.ONE * -self.get_parent().TILE_SIZE / 2
	targ_loc = base_targ_loc
	base_motion_speed = self.get_parent().TILE_SIZE \
			/ self.get_parent().PUSH_DURATION
	motion_speed = base_motion_speed
	alpha_speed = 1 / self.get_parent().FADE_DURATION
	scale_speed = 1 / self.get_parent().FALL_DURATION
	
	# Reset the shadow tile (used in teleportation)
	$ShadowTile.self_modulate.a = 0
	$ShadowTile.show()
	
	# Check if the death animation should
	#  have completed already
	if get_parent().death_anim_done:
		hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	# Compute the vector separating us from target location
	var offset = position - targ_loc
	var offset_dir = offset.normalized()
	var offset_len = offset.length()
	
	# Check if the death animation should
	#  have completed already
	if get_parent().death_anim_done:
		hide()
	
	if offset_len > CLOSE_VALUE:
		# Move closer to the target location
		position -= offset_dir * min(offset_len,
				delta * motion_speed)
	
	
	if self.get_parent().dead:
		# Hide the shadow tile
		$ShadowTile.self_modulate.a = 0

		if get_parent() is Player:
			# Shrink the sprite to show death
			#  (at the same speed as the alpha)
			scale -= Vector2.ONE * clamp(delta * scale_speed, 0, scale.x)
			targ_loc = base_targ_loc * scale.x

			# If the scale has reached ~zero,
			#  inform the parent that this animation is done
			if abs(scale.x) < CLOSE_VALUE:
				get_parent().death_anim_done = true
				
		else:
			# Decrease the alpha to show death
			self_modulate.a -= clamp(delta * alpha_speed, 0, self_modulate.a)
			
			# If the alpha has reached zero,
			#  inform the parent that this animation is done
			if self_modulate.a == 0:
				get_parent().death_anim_done = true
			
	else:
		# Increase the alpha, in case it was decreased
		self_modulate.a += clamp(delta * alpha_speed, 0, 1 - self_modulate.a)
		
		# Update the shadow tile while alive
		$ShadowTile.self_modulate.a = 1 - self_modulate.a
		$ShadowTile.set_cell(
			Vector2i(0,0), 0,
			self.get_cell_atlas_coords(Vector2i(0,0))
			)
		
		
# Move the tile opposite the direction of motion
func shift_back(dir_vect : Vector2) -> void:
	motion_speed = base_motion_speed
	self_modulate.a = 1
	position -= dir_vect


# "Bump" in the desired direction,
#  if the current animation is complete
func bump(dir_vect : Vector2) -> void:
	if (position - targ_loc).length() > CLOSE_VALUE:
		# Currently moving, so don't mess with speed
		return
	
	var bump_dist = get_parent().BUMP_DISTANCE
	var push_time = get_parent().PUSH_DURATION
	
	# Flip the speed to move us away from the center
	motion_speed = -base_motion_speed * (2 * bump_dist)
	position += dir_vect / 1e3
	await get_tree().create_timer(push_time/2).timeout
	
	if motion_speed == base_motion_speed:
		# already stopped the bump, say by moving
		#  another direction.
		return
	
	# Flip the speed back to usual direction
	motion_speed = base_motion_speed * (2 * bump_dist)
	await get_tree().create_timer(push_time/2).timeout
	
	# Reset the speed magnitude
	motion_speed = base_motion_speed


# Show teleportation by activating the shadow tile
func show_teleport(offset_vect : Vector2) -> void:
	$ShadowTile.position = -offset_vect
	self_modulate.a = 0
