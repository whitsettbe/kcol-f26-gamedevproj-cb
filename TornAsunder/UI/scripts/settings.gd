extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# opens settings menu
func open():
	show()

# Closes settings menu
func _on_back_pressed() -> void:
	hide()
