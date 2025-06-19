extends Node2D

@export var adventurers: PackedScene
@export var adventurer_spawn_location: PathFollow2D

func spawn_adventurer():
	var adventurer = adventurers.instantiate()
	adventurer_spawn_location.progress_ratio = randf()
	adventurer.global_position = adventurer_spawn_location.global_position
	add_child(adventurer)
