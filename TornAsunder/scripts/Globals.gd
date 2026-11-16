extends Node

var level_paths = [
	#"res://levels/Playgrounds/playground0.tscn",
	#"res://levels/Playgrounds/playground1.tscn",
	#"res://levels/Playgrounds/playground2.tscn",
	"res://levels/Caves/01 - Just Walk.tscn",
	"res://levels/Caves/02 - Push Through.tscn",
	"res://levels/Caves/04 - Co-op 101.tscn",
	"res://levels/Caves/05 - Working Blind.tscn",
	"res://levels/Caves/06 - Mind the Gap.tscn",
	"res://levels/Caves/07 - Out of the Corner.tscn",
	"res://levels/Caves/08 - Lost.tscn",
	"res://levels/Ruins/11 - Not My Block.tscn",
	"res://levels/Ruins/12 - Know Expectations.tscn",
	"res://levels/Ruins/13 - Rod Construction.tscn",
	"res://levels/Ruins/14 - Ladders.tscn",
	"res://levels/Ruins/15 - Jump Around.tscn",
	"res://levels/Ruins/16 - Cover-up.tscn",
	"res://levels/Ruins/17 - Halberd.tscn",
	"res://levels/Ruins/18 - Flip Flop.tscn",
	"res://levels/Ruins/19 - Hourglass.tscn",
	"res://levels/Bog/21 - Rolling.tscn",
	"res://levels/Bog/22 - Ooze Maker.tscn",
	"res://levels/Bog/23 - A Fresh Coat.tscn",
	"res://levels/Bog/24 - Listening to Paint Dry.tscn",
	"res://levels/Bog/25 - Back to the Start.tscn",
	"res://levels/Bog/26 - Speedy Delivery.tscn",
	"res://levels/Bog/27 - Not-So-Speedy Delivery.tscn",
	"res://levels/Bog/28 - Acupuncture.tscn",
	"res://levels/Bog/29 - Magic Eraser.tscn",
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
