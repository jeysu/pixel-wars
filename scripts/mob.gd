extends CharacterBody2D

var speed = 100
var adventurers
	
func _process(delta):
	adventurers = get_tree().get_nodes_in_group("adventurers")
	var target = get_closest_adventurer()
	if target:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		move_and_slide()

func get_closest_adventurer():
	var closest_distance = INF
	var closest_adventurer
	
	if adventurers.is_empty():
		return null
	else:
		for adventurer in adventurers:
			var distance = global_position.distance_to(adventurer.global_position)
			if (distance < closest_distance):
				closest_distance = distance
				closest_adventurer = adventurer
		return closest_adventurer
