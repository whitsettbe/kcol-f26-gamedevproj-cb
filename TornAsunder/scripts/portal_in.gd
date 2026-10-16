class_name PortalIn
extends GridArea2D

@export var target : PortalOut


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(target != null,
		"Portal {0} needs a target".format([self]))


# Called when an Area2D enters the collision region.
# 'area' is the entering Area2D node
func _on_area_entered(area: Area2D) -> void:
	
	# Ignore non-players
	if not area is Player:
		return
		
	# If the portal output is covered, do nothing
	if target.is_covered():
		return
		
	# Teleport the block to the output
	area.position += (target.position - self.position)
