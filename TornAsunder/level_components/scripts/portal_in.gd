class_name PortalIn
extends GridArea2D

@onready var sfx_teleport: AudioStreamPlayer = $sfx_teleport
@export var target : PortalOut
@export var is_exit : bool
var players_exiting = 0
signal player_on_exit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(not is_exit or name in ["EXIT_L", "EXIT_R"],
		"Portal {0}, marked exit, must be named 'EXIT_L' or 'EXIT_R'".format([self]))
	assert(is_exit or not name in ["EXIT_L", "EXIT_R"],
		"Portal {0}, marked non-exit, cannot be named 'EXIT_L' nor 'EXIT_R'".format([self]))
	assert(target == null or not is_exit,
		"Portal {0} can't be an exit _and_ have a target".format([self]))
	assert(target != null or is_exit,
		"Portal {0} needs to be an exit or have a target".format([self]))


# Called when an Area2D enters the collision region.
# 'area' is the entering Area2D node.
# Note that this also runs when instancing a scene and
#  an Area2D node is instanced on top of the portal.
func _on_area_entered(area: Area2D) -> void:
	
	# Ignore non-players
	if not area is Player:
		return
		
	# If this is an exit, mark status and emit signal
	if is_exit:
		players_exiting += 1
		emit_signal("player_on_exit")
		return
		
		
	# If the portal output is covered, do nothing
	if target.is_covered():
		return
		
	# Teleport the block to the output
	var offset_vect = target.position - self.position
	area.position = target.position
	area.get_node("SpriteTile").show_teleport(offset_vect)
	#play teleportation sound effect
	sfx_teleport.play()
# Note when a player leaves the area, if
#  this is an exit tile
func _on_area_exited(area: Area2D) -> void:
	
	# Ignore non-players
	if not area is Player:
		return
	
	if is_exit:
		players_exiting -= 1
