extends Node2D

var entity
var wobble_time_elapsed = 0
var wobble_speed = 10
var degree_of_wobble = 5

func setup(owner_entity):
	entity = owner_entity

func update(delta):
	if not entity:
		return
		
	# Set opposing entities
	if entity.is_in_group("adventurers"):
		set_opposing_entities("mobs")
	elif entity.is_in_group("mobs"):
		set_opposing_entities("adventurers")
	
	# Set closest opposing entity as target
	if entity.opposing_entities.is_empty():
		entity.target = null
	else:
		set_target_to_closest()
	
	# Move to target if there is one and is currently not fighting
	if entity.target and not entity.behaviors["attack"].is_fighting():
		move_to_target(delta)
	else:
		entity.velocity = Vector2.ZERO * delta
	flip_sprite_to_direction()
	
	# Play walking animation if moving
	if entity.velocity.length() > 0:
		play_walking_animation(delta)
		
func set_opposing_entities(opposing_group):
	entity.opposing_entities = get_tree().get_nodes_in_group(opposing_group)

func set_target_to_closest():
	var closest_distance = INF
	var closest_opposing_entity
	# Compare each distance from a mob and return the closest
	for opposing_entity in entity.opposing_entities:
		var distance = global_position.distance_to(opposing_entity.global_position)
		if (distance < closest_distance):
			closest_distance = distance
			closest_opposing_entity = opposing_entity
	entity.target = closest_opposing_entity
	
func move_to_target(delta):
	var direction = (entity.target.global_position - entity.global_position).normalized()
	entity.velocity = direction * entity.speed * delta
	entity.move_and_slide()

func flip_sprite_to_direction():
	if abs(entity.velocity.x) > 0.1:
		entity.get_node("Sprite2D").flip_h = entity.velocity.x > 0

func play_walking_animation(delta):
	wobble_time_elapsed += delta * wobble_speed
	wobble_time_elapsed = wrapf(wobble_time_elapsed, 0, TAU) # Reset after sin cycle
	entity.get_node("Sprite2D").rotation_degrees = sin(wobble_time_elapsed) * degree_of_wobble # Transition using sin wave
