extends Node2D

@export var mobs: PackedScene
@export var mob_spawn_location = PathFollow2D
var number_of_mobs := 10

func spawn_mob():
	for n in number_of_mobs:
		var mob = mobs.instantiate()
		mob_spawn_location.progress_ratio = randf()
		mob.global_position = mob_spawn_location.global_position
		add_child(mob)
