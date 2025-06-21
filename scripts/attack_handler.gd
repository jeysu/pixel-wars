extends Node2D

var entity: CharacterBody2D
var collision: KinematicCollision2D
var collider: CharacterBody2D

@export var attack_damage: int
@export var attack_speed: float

var attack_time_elapsed := 0.0
var degree_of_attack := 15
var total_attack_duration := 1 / attack_speed

signal fighting_state_changed(is_fighting: bool)
signal passed_attack(enemy_entity: int)

func setup(owner_entity) -> void:
	entity = owner_entity

func update(delta) -> void:
	if not entity:
		return
	if is_fighting():
		fighting_state_changed.emit(true)
		attack_entity(delta)
		play_attack_animation(delta)
	else:
		fighting_state_changed.emit(false)
	
func is_fighting():
	print(entity.get_slide_collision_count())
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

func play_attack_animation(delta):
	var peak_animation_ratio := 0.9
	var attack_time_normalized := 0.0
	var time_since_peak := 0.0
	var return_duration := 0.0
	var flipped = -1 if entity.get_node("Sprite2D").flip_h else 1
	
	if attack_time_elapsed < peak_animation_ratio * total_attack_duration:
		attack_time_normalized = attack_time_elapsed / (peak_animation_ratio * total_attack_duration)
		entity.get_node("Sprite2D").rotation_degrees = lerp(0, degree_of_attack * flipped, attack_time_normalized)
	else:
		time_since_peak = attack_time_elapsed - (peak_animation_ratio * total_attack_duration)
		return_duration = (1 - peak_animation_ratio) * total_attack_duration
		attack_time_normalized = time_since_peak / return_duration
		entity.get_node("Sprite2D").rotation_degrees = lerp(degree_of_attack * flipped, 0, attack_time_normalized)
