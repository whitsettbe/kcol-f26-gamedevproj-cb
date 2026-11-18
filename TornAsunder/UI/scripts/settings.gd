extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# opens settings menu
func open():
	if(get_parent().get_node("PanelContainer") != null):
		get_parent().get_node("PanelContainer").hide()
	show()
	$Button_manager.get_child(0).grab_focus()
	

# Closes settings menu
func _on_back_pressed() -> void:
	hide()
	if(get_parent().get_node("PanelContainer") != null):
		get_parent().get_node("PanelContainer").show()
		get_parent().get_child(0).get_child(0).get_child(0).grab_focus()
	else:
		get_parent().get_child(1).get_child(0).grab_focus()
