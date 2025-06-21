extends Node2D

var entity: CharacterBody2D

@export var wobble_speed: int
@export var degree_of_wobble: int
var wobble_time_elapsed := 0

var degree_of_attack := 15

func setup(parent):
	entity = parent

func update(delta):
	if abs(entity.velocity.x) > 0.1:
		flip_sprite_to_direction()
	if entity.velocity.length() > 0:
		play_walking_animation(delta)

func flip_sprite_to_direction():
	entity.get_node("Sprite2D").flip_h = entity.velocity.x > 0

func play_walking_animation(delta):
	wobble_time_elapsed += delta * wobble_speed
	wobble_time_elapsed = wrapf(wobble_time_elapsed, 0, TAU)
	entity.get_node("Sprite2D").rotation_degrees = sin(wobble_time_elapsed) * degree_of_wobble
	
func play_attack_animation(delta):
	var peak_animation_ratio := 0.9
	var attack_time_normalized := 0.0
	var time_since_peak := 0.0
	var return_duration := 0.0
	var flipped = -1 if entity.get_node("Sprite2D").flip_h else 1
	
	if entity.get_node("AttackHandler").attack_time_elapsed < peak_animation_ratio * entity.get_node("AttackHandler").total_attack_duration:
		attack_time_normalized = entity.get_node("AttackHandler").attack_time_elapsed / (peak_animation_ratio * entity.get_node("AttackHandler").total_attack_duration)
		entity.get_node("Sprite2D").rotation_degrees = lerp(0, degree_of_attack * flipped, attack_time_normalized)
	else:
		time_since_peak = entity.get_node("AttackHandler").attack_time_elapsed - (peak_animation_ratio * entity.get_node("AttackHandler").total_attack_duration)
		return_duration = (1 - peak_animation_ratio) * entity.get_node("AttackHandler").total_attack_duration
		attack_time_normalized = time_since_peak / return_duration
		entity.get_node("Sprite2D").rotation_degrees = lerp(degree_of_attack * flipped, 0, attack_time_normalized)
