extends Node2D

@export var bases: PackedScene
@export var world_generator: Node2D
var base_spawn: Marker2D
var base_spawn_location: Vector2

func spawn_adventurer_base():
	var base = bases.instantiate()
	base.add_to_group("adventurers")
	base_spawn_location = get_random_location()
	base_spawn = $AdventurerBaseLoc
	base_spawn.global_position = base_spawn_location
	base.global_position = base_spawn.global_position
	add_child(base)

func spawn_mob_base():
	var base = bases.instantiate()
	base.add_to_group("mobs")
	base_spawn_location = get_random_location()
	base_spawn = $MobBaseLoc
	base_spawn.global_position = base_spawn_location
	base.global_position = base_spawn.global_position
	add_child(base)

func get_random_location():
	var random_tiles = world_generator.ground_tiles
	var base_tile = random_tiles[randi() % random_tiles.size()]
	var base_tile_position = world_generator.ground_layer.to_global(world_generator.ground_layer.map_to_local(Vector2(base_tile)))
	return base_tile_position
