extends CharacterBody2D

@export var hp := 100
@export var speed := 100
@export var attack := 10
@export var attack_speed := 1

var wobble_time_elapsed := 0.0
var wobble_speed := 10.0
var degree_of_wobble := 5.0
var attack_time_elapsed := 0.0

var opposing_entities
var target
var collision
	
func _process(delta):
	get_opposing_entities()
	move_to_target(delta)
	play_walking_animation(delta)
	flip_sprite()
	
	if collision:
		var collided_node = collision.get_collider()
		if collided_node in opposing_entities:
			apply_attack(collided_node, delta)
			
func get_opposing_entities():
	if is_in_group("adventurers"):
		opposing_entities = get_tree().get_nodes_in_group("mobs")
	elif is_in_group("mobs"):
		opposing_entities = get_tree().get_nodes_in_group("adventurers")

func move_to_target(delta):
	target = get_closest_opposing_entity()
	if target:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed * delta
	else:
		velocity = Vector2.ZERO * delta
	collision = move_and_collide(velocity)

func play_walking_animation(delta):
	if velocity.length() > 0:
		wobble_time_elapsed += delta * wobble_speed
		wobble_time_elapsed = wrapf(wobble_time_elapsed, 0, TAU) # Reset wobble_time_elapsed to 0 after sin cycle
		$Sprite2D.rotation_degrees = sin(wobble_time_elapsed) * degree_of_wobble # Smooth transition using sin wave

func flip_sprite():
	if velocity.x > 0:
		$Sprite2D.flip_h = 1
	else:
		$Sprite2D.flip_h = 0
	
func get_closest_opposing_entity():
	var closest_distance = INF
	var closest_opposing_entity
	
	if opposing_entities.is_empty():
		return null
	# Compare each distance from a mob and return the closest mob
	for opposing_entity in opposing_entities:
		var distance = global_position.distance_to(opposing_entity.global_position)
		if (distance < closest_distance):
			closest_distance = distance
			closest_opposing_entity = opposing_entity
	return closest_opposing_entity

func apply_attack(enemy, delta):
	attack_time_elapsed += delta
	if attack_time_elapsed >= 1 / attack_speed:
		enemy.take_damage(attack)

func take_damage(attack):
	hp -= attack
	if hp <= 0:
		queue_free()
