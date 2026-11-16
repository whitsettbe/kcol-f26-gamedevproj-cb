extends Node2D
class_name CutScene

signal level_completed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var timer = get_tree().create_timer(5)
	timer.timeout.connect(level_completed.emit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
