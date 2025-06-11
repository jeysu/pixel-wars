extends CharacterBody2D

var speed = 100 # Speed of character

# Factors for wobble animation
var wobble_time_elapsed := 0.0
var wobble_speed := 10.0
var degree_of_wobble := 5.0

var mobs # To store instances of mobs in group "mobs"
	
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
	
	mobs = get_tree().get_nodes_in_group("mobs") # Store instances of mobs in group "mobs"
	var target = get_closest_mob() # Find the closest mob from the mobs array
	# Walk towards mob if there is a mob
	if target:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		move_and_slide()

func get_closest_mob():
	var closest_distance = INF # Set to infinity 
	var closest_mob
	
	if mobs.is_empty():
		return null
	else:
		# Compare each distance from a mob and return the closest mob
		for mob in mobs:
			var distance = global_position.distance_to(mob.global_position)
			if (distance < closest_distance):
				closest_distance = distance
				closest_mob = mob
		return closest_mob
