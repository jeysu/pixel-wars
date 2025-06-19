extends Node2D

@export var bases: PackedScene
var base_spawn_location: Marker2D

func spawn_adventurer_base():
	var base = bases.instantiate()
	base.add_to_group("adventurers")
	base_spawn_location = $AdventurerBaseLoc
	base.global_position = base_spawn_location.global_position
	add_child(base)

func spawn_mob_base():
	var base = bases.instantiate()
	base.add_to_group("mobs")
	base_spawn_location = $MobBaseLoc
	base.global_position = base_spawn_location.global_position
	add_child(base)
