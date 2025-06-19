extends CharacterBody2D

@export var hp := 100
@export var speed := 10000
@export var attack_damage := 10
@export var attack_speed := 1.0

var target = CharacterBody2D
var opposing_entities = {}
var behaviors = {}

func _ready():
	for child in get_children():
		if child.is_in_group("behavior"):
			behaviors[child.name.to_lower()] = child
			if behaviors[child.name.to_lower()].has_method("setup"):
				behaviors[child.name.to_lower()].setup(self)
	$Control/HealthBar.max_value = hp
	$Control/HealthBar.value = hp

func _process(delta):
	z_index = int(global_position.y) # Set z position to mimic depth
	for behavior in behaviors.values():
		if behavior and behavior.has_method("update"):
			behavior.update(delta)
