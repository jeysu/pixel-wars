extends CharacterBody2D

var speed = 100 # Speed of character

# Factors for wobble animation
var wobble_time_elapsed := 0.0
var wobble_speed := 10.0
var degree_of_wobble := 5.0

var attack_time_elapsed := 0.0

var opposing_entities # To store instances of opposing_entities
	
func _process(delta):
	# Play wobble animation when character is moving
	if velocity.length() > 0:
		wobble_time_elapsed += delta * wobble_speed
		wobble_time_elapsed = wrapf(wobble_time_elapsed, 0, TAU) # Reset wobble_time_elapsed to 0 after sin cycle
		$Sprite2D.rotation_degrees = sin(wobble_time_elapsed) * degree_of_wobble # Smooth transition using sin wave
	
	# Flip sprite depending on direction
	if velocity.x > 0:
		$Sprite2D.flip_h = 1
	else:
		$Sprite2D.flip_h = 0
	
	if is_in_group("adventurers"):
		opposing_entities = get_tree().get_nodes_in_group("mobs") # Store instances of opposing_entities
	elif is_in_group("mobs"):
		opposing_entities = get_tree().get_nodes_in_group("adventurers") # Store instances of opposing_entities
	
	var target = get_closest_opposing_entity() # Find the closest opposing_entity from the mobs array
	# Walk towards opposing_entity if there is one
	if target:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		move_and_slide()

func get_closest_opposing_entity():
	var closest_distance = INF # Set to infinity 
	var closest_opposing_entity
	
	if opposing_entities.is_empty():
		return null
	else:
		# Compare each distance from a mob and return the closest mob
		for opposing_entity in opposing_entities:
			var distance = global_position.distance_to(opposing_entity.global_position)
			if (distance < closest_distance):
				closest_distance = distance
				closest_opposing_entity = opposing_entity
		return closest_opposing_entity
