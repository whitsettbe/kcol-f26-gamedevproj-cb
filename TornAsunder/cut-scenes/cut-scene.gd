extends Node2D
class_name CutScene

signal level_completed

@export var scroll_speed = 100 # pixels/sec

@onready var viewport_height = \
	get_viewport_rect().end.y
@onready var text_height = \
	$Scrolling_Elements.get_bound_minimum_size().y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Scrolling_Elements.position.y = viewport_height


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Scrolling_Elements.position.y -= delta * scroll_speed
	if $Scrolling_Elements.position.y < -text_height:
		level_completed.emit()
