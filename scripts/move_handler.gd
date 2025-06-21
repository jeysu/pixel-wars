extends Node2D

@export var speed: int
var is_fighting: bool

var entity: CharacterBody2D

func setup(parent):
	entity = parent
	entity.z_index = int(entity.global_position.y)

func update(delta):
	if not entity:
		return
	if entity.target and not is_fighting:
		move_to_target(delta, entity.target)
	else:
		entity.velocity = Vector2.ZERO * delta
		entity.move_and_slide()
	
func move_to_target(delta, target):
	var direction = (target.global_position - entity.global_position).normalized()
	entity.velocity = direction * speed
	entity.move_and_slide()

func set_fighting_state(is_fighting) -> void:
	self.is_fighting = is_fighting
