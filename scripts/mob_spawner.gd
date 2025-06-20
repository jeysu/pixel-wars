extends Node2D

@export var mobs: PackedScene
@export var mob_spawn: Marker2D
var number_of_mobs := 10

func spawn_mob():
	for n in number_of_mobs:
		var mob = mobs.instantiate()
		mob.global_position = mob_spawn.global_position
		add_child(mob)
