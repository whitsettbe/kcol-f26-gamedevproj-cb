extends Node

var level_paths = [
	"res://levels/Playgrounds/playground0.tscn",
	"res://levels/Playgrounds/playground1.tscn",
	"res://levels/Playgrounds/playground2.tscn",
	"res://levels/Caves/01 - Just Walk.tscn",
	"res://levels/Caves/02 - Push Through.tscn",
	"res://levels/Caves/04 - Co-op 101.tscn",
	"res://levels/Caves/06 - Mind the Gap.tscn",
	"res://levels/Caves/07 - Out of the Corner.tscn",
	"res://levels/Caves/10 - Acupuncture.tscn",
	"res://levels/Ruins/11 - Not My Block.tscn",
	"res://levels/Ruins/12 - Know Expectations.tscn",
	"res://levels/Ruins/13 - Rod Construction.tscn",
	"res://levels/Ruins/14 - Jump Around.tscn",
	"res://levels/Ruins/16 - Cover-up.tscn",
	"res://levels/Bog/21 - Rolling.tscn",
	"res://levels/Bog/24 - A Fresh Coat.tscn",
	"res://levels/Bog/26 - Speedy Delivery.tscn",
	"res://levels/Bog/28 - Magic Eraser.tscn",
	"res://levels/Bog/30 - Leroy.tscn"
	]
	
var level_idx = 0

var level_scene

var current_layer_menu = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Debug: confirm that the level paths are
	#  all valid.
	for path in level_paths:
		assert(ResourceLoader.exists(path),
			"Path \"{0}\" not found.".format([path]))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
