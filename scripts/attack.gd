extends Node2D

var entity: CharacterBody2D
var collision: KinematicCollision2D
var collider: CharacterBody2D

var attack_time_elapsed := 0.0
var degree_of_attack := 15

func setup(owner_entity):
	entity = owner_entity

func update(delta):
	if not entity:
		return
	# Trigger events if fighting
	if is_fighting():
		apply_attack(delta)
		play_attack_animation(delta)
		
func is_fighting():
	for i in range(entity.get_slide_collision_count()):
		collision = entity.get_slide_collision(i)
		collider = collision.get_collider()
		if collider in entity.opposing_entities:
			return true
	return false

func apply_attack(delta):
	attack_time_elapsed += delta
	if attack_time_elapsed >= 1 / entity.attack_speed:
		take_attack(entity.attack_damage)
		attack_time_elapsed = 0

func take_attack(enemy_attack_damage):
	entity.hp -= enemy_attack_damage
	entity.get_node("Control/HealthBar").value = entity.hp
	if entity.hp <= 0:
		entity.queue_free()

func play_attack_animation(delta):
	var peak_animation := 0.9
	var attack_time_normalized
	var flipped = -1 if entity.get_node("Sprite2D").flip_h else 1
	if attack_time_elapsed < peak_animation / entity.attack_speed:
		attack_time_normalized = attack_time_elapsed / peak_animation
		entity.get_node("Sprite2D").rotation_degrees = lerp(0, degree_of_attack * flipped, attack_time_normalized)
	else:
		attack_time_normalized = (attack_time_elapsed - peak_animation) / (1 - peak_animation)
		entity.get_node("Sprite2D").rotation_degrees = lerp(degree_of_attack * flipped, 0, attack_time_normalized)
