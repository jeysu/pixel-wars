extends Node2D

@export var mobs: PackedScene
@export var mob_spawn: Marker2D
@export var number_of_mobs := 10
@export var spawn_radius := 50

func spawn_mob():
	for n in number_of_mobs:
		var mob = mobs.instantiate()
		var angle = randf() * TAU
		var distance = randf() * spawn_radius
		var spawn_offset = Vector2(cos(angle), sin(angle)) * distance
		mob.global_position = mob_spawn.global_position + spawn_offset
		add_child(mob)
