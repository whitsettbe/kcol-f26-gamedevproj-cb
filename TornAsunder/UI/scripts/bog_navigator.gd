extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open():
	get_parent().get_child(1).hide()
	Globals.current_layer_menu = "Bog"
	show()

# Opens previous page.
func _on_back_pressed() -> void:
	hide()
	get_parent().get_child(1).show()
	Globals.current_layer_menu = ""
	get_parent().get_child(1).get_child(1).grab_focus()
