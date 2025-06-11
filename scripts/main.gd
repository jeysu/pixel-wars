extends Node

@export var adventurers: PackedScene
@export var mobs: PackedScene

# Number of entities
var number_of_adventurers = 10
var number_of_mobs = 5

func _ready():
	# Instantiate a mob depending on number_of_mobs
	for n in number_of_mobs:
		var mob = mobs.instantiate()
		var mob_spawn_location = $MobSpawnPath/SpawnPoint
		mob_spawn_location.progress_ratio = randf() # Randomize spawn
		mob.position = mob_spawn_location.position
		add_child(mob)
	
	# Instantiate an adventurer depending on number_of_adventurers
	for n in number_of_adventurers:
		var adventurer = adventurers.instantiate()
		var adventurer_spawn_location = $AdventurerSpawnPath/SpawnPoint
		adventurer_spawn_location.progress_ratio = randf() # Randomize spawn
		adventurer.position = adventurer_spawn_location.position
		add_child(adventurer)
