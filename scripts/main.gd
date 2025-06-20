extends Node

func _ready():
	$ProceduralGeneration.setup()
	$BaseSpawner.spawn_adventurer_base()
	$BaseSpawner.spawn_mob_base()
	$MobSpawner.spawn_mob()
	
func _input(event):
	pass

func _on_add_melee_pressed():
	$AdventurerSpawner.spawn_adventurer()
