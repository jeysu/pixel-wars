extends CharacterBody2D

@export var hp := 100
@export var speed := 100
@export var attack_damage := 10
@export var attack_speed := 1

var wobble_time_elapsed := 0.0
var wobble_speed := 10.0
var degree_of_wobble := 5.0
var attack_time_elapsed := 0.0

var opposing_entities
var target
var collision

func _ready():
	z_index = int(global_position.y)

func _process(delta):
	set_opposing_entities()
	move_to_target(delta)
	flip_sprite()
	play_walking_animation(delta)
	is_fighting(delta)
			
func set_opposing_entities():
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

func flip_sprite():
	if velocity.x > 0:
		$Sprite2D.flip_h = 1
	else:
		$Sprite2D.flip_h = 0

func play_walking_animation(delta):
	if velocity.length() > 0:
		wobble_time_elapsed += delta * wobble_speed
		wobble_time_elapsed = wrapf(wobble_time_elapsed, 0, TAU) # Reset after sin cycle
		$Sprite2D.rotation_degrees = sin(wobble_time_elapsed) * degree_of_wobble # Transition using sin wave

func is_fighting(delta):
	if collision:
		var collided_node = collision.get_collider()
		if collided_node in opposing_entities:
			apply_attack(collided_node, delta)
			play_attack_animation(delta)
			
func get_closest_opposing_entity():
	var closest_distance = INF
	var closest_opposing_entity
	
	if opposing_entities.is_empty():
		return null
	# Compare each distance from a mob and return the closest
	for opposing_entity in opposing_entities:
		var distance = global_position.distance_to(opposing_entity.global_position)
		if (distance < closest_distance):
			closest_distance = distance
			closest_opposing_entity = opposing_entity
	return closest_opposing_entity

func apply_attack(enemy, delta):
	attack_time_elapsed += delta
	if attack_time_elapsed >= 1 / attack_speed:
		enemy.take_attack(attack_damage)

func take_attack(attack_damage):
	hp -= attack_damage
	if hp <= 0:
		queue_free()

func play_attack_animation(delta):
	pass
