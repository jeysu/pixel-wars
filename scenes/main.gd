extends Node

@export var adventurers: PackedScene

func _ready():
	var adventurer = adventurers.instantiate()
	var adventurer_spawn_location = $SpawnPath/SpawnPoint
	adventurer_spawn_location.progress_ratio = randf()
	adventurer.position = adventurer_spawn_location.position
	add_child(adventurer)
