extends Node

func _ready():
	$WorldGenerator.setup()
	$BaseSpawner.spawn_adventurer_base()
	$BaseSpawner.spawn_mob_base()
	$MobSpawner.spawn_mob()
	
func _on_add_melee_pressed():
	$AdventurerSpawner.spawn_adventurer()
