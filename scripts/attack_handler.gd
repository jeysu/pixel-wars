extends Node2D

var entity: CharacterBody2D
var collision: KinematicCollision2D
var collider: CharacterBody2D

@export var attack_damage: int
@export var attack_speed: float

var attack_time_elapsed := 0.0
var total_attack_duration: float

signal fighting_state_changed(is_fighting: bool)

func setup(owner_entity) -> void:
	entity = owner_entity
	total_attack_duration = 1 / attack_speed

func update(delta) -> void:
	if not entity:
		return
	if is_fighting():
		fighting_state_changed.emit(true)
		attack_entity(delta)
	else:
		fighting_state_changed.emit(false)
	
func is_fighting():
	for i in range(entity.get_slide_collision_count()):
		collision = entity.get_slide_collision(i)
		if collision.get_collider() is TileMapLayer:
			return
		collider = collision.get_collider()
		if collider in entity.opposing_entities:
			return true
	return false

func attack_entity(delta):
	attack_time_elapsed += delta
	if attack_time_elapsed >= total_attack_duration:
		collider.get_node("HealthHandler").decrease_health(attack_damage)
		attack_time_elapsed = 0
