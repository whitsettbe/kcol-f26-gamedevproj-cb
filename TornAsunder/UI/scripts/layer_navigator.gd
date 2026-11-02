extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Opens the layer menu	
func open():
	show()

# Closes the layer menu
func _on_back_pressed() -> void:
	hide()
