extends Control

@export var health_bar: ProgressBar
@export var hp: int

var entity: CharacterBody2D

func setup(parent):
	entity = parent
	health_bar.max_value = hp
	health_bar.value = hp

func decrease_health(amount):
	hp -= amount
	health_bar.value = hp
	if hp <= 0:
		entity.queue_free()
