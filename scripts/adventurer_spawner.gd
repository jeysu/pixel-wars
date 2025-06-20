extends Node2D

@export var adventurers: PackedScene
@export var adventurer_spawn: Marker2D
@export var spawn_radius := 50

func spawn_adventurer():
	var adventurer = adventurers.instantiate()
	var angle = randf() * TAU
	var distance = randf() * spawn_radius
	var spawn_offset = Vector2(cos(angle), sin(angle)) * distance
	adventurer.global_position = adventurer_spawn.global_position + spawn_offset
	add_child(adventurer)
