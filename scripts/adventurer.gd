extends CharacterBody2D

var speed = 100
var mobs
	
func _process(delta):
	mobs = get_tree().get_nodes_in_group("mobs")
	var target = get_closest_mob()
	if target:
		var direction = (target.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		move_and_slide()

func get_closest_mob():
	var closest_distance = INF
	var closest_mob
	
	if mobs.is_empty():
		return null
	else:
		for mob in mobs:
			var distance = global_position.distance_to(mob.global_position)
			if (distance < closest_distance):
				closest_distance = distance
				closest_mob = mob
		return closest_mob
