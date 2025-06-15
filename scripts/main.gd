extends Node

@export var adventurers: PackedScene
@export var mobs: PackedScene

var number_of_adventurers = 10
var number_of_mobs = 10

func _ready():
	for n in number_of_mobs:
		var mob = mobs.instantiate()
		var mob_spawn_location = $MobSpawnPath/SpawnPoint
		mob_spawn_location.progress_ratio = randf()
		mob.position = mob_spawn_location.position
		add_child(mob)
	
	for n in number_of_adventurers:
		var adventurer = adventurers.instantiate()
		var adventurer_spawn_location = $AdventurerSpawnPath/SpawnPoint
		adventurer_spawn_location.progress_ratio = randf()
		adventurer.position = adventurer_spawn_location.position
		add_child(adventurer)

var dragging = false

func _input(event):
	pass
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
	if event is InputEventMouseMotion and dragging:
		$Camera2D.global_position -= event.relative
