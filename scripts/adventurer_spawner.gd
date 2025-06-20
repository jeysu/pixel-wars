extends Node2D

@export var adventurers: PackedScene
@export var adventurer_spawn: Marker2D

func spawn_adventurer():
	var adventurer = adventurers.instantiate()
	adventurer.global_position = adventurer_spawn.global_position
	add_child(adventurer)
