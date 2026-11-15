class_name PortalIn
extends GridArea2D

@onready var sfx_teleport: AudioStreamPlayer = $sfx_teleport
@onready var sfx_exit_buzz: AudioStreamPlayer = $sfx_exit_buzz
@export var target : PortalOut
@export var is_exit : bool
var players_exiting = 0
signal player_on_exit
# boolean to keep track of the exit sfx, 
# so it dosnt keep playing
var has_exit_buzz_sfx_played : bool = false


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


# Called every physics frame.
# 'delta' is the elapsed time since the previous frame,
#  and should be 1/60 s in most cases.
func _physics_process(delta: float) -> void:
	
	var overlapping_areas = get_overlapping_areas()
	
	var overlapping_players = []
	for area in overlapping_areas:
		if area is Player:
			overlapping_players.append(area)
			
	# If this is an exit, mark status and emit signal
	if is_exit:
		if len(overlapping_players) != players_exiting:
			# Reset the sound flag if the number of players
			#  standing on the exit has changed
			has_exit_buzz_sfx_played = false
			
		players_exiting = len(overlapping_players)
		if players_exiting > 0:
			emit_signal("player_on_exit")
			if  (has_exit_buzz_sfx_played == false):
				sfx_exit_buzz.play()
				has_exit_buzz_sfx_played = true
		return
	
	# If the portal output is covered,
	#  do nothing.
	if target.is_covered():
		return
	
	# Teleport the players to the output
	for area in overlapping_players:
		var offset_vect = target.position - self.position
		area.position = target.position
		area.get_node("SpriteTile").show_teleport(offset_vect)
	
	# Play teleportation sound effect
	if len(overlapping_players) > 0:
		sfx_teleport.play()

# Note when a player leaves the area, if
#  this is an exit tile
func _on_area_exited(area: Area2D) -> void:
	
	# Ignore non-players
	if not area is Player:
		return
	
	if is_exit:
		players_exiting -= 1
		
		# Reset the bool so if the player steps on the exit again, 
		#  the sound effect can play again.
		has_exit_buzz_sfx_played = false
