extends CharacterBody2D

var speed = 100 # Speed of character

# Factors for wobble animation
var wobble_time_elapsed := 0.0
var wobble_speed := 10.0
var degree_of_wobble := 5.0

var adventurers # To store instances of adventurers in group "adventurers"

func _process(delta):
	# Play wobble animation when character is moving
	if velocity.length() > 0:
		wobble_time_elapsed += fmod(delta * wobble_speed, TAU) # Reset wobble_time_elapsed to 0 after sin cycle
		$Sprite2D.rotation_degrees = sin(wobble_time_elapsed) * degree_of_wobble # Smooth transition using sin wave
	
	# Flip sprite depending on direction
	if velocity.x > 0:
		$Sprite2D.flip_h = 1
	else:
		$Sprite2D.flip_h = 0
	
	adventurers = get_tree().get_nodes_in_group("adventurers") # Store instances of adventurers in group "adventurers"
	var target = get_closest_adventurer() # Find the closest mob from the mobs array
	# Walk towards adventurer if there is an adventurer
	if target:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		move_and_slide()

func get_closest_adventurer():
	var closest_distance = INF # Set to infinity
	var closest_adventurer
	
	if adventurers.is_empty():
		return null
	else:
		# Compare each distance from an adventurer and return the closest adventurer
		for adventurer in adventurers:
			var distance = global_position.distance_to(adventurer.global_position)
			if (distance < closest_distance):
				closest_distance = distance
				closest_adventurer = adventurer
		return closest_adventurer
