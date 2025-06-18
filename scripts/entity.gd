extends CharacterBody2D

@export var hp = 100
@export var speed = 2500
@export var attack_damage = 10
@export var attack_speed = 1

var wobble_time_elapsed = 0
var wobble_speed = 10
var degree_of_wobble = 5

var attack_time_elapsed = 0
var degree_of_attack = 15

var opposing_entities
var target
var collision
var collider

func _ready():
	$Control/HealthBar.max_value = hp
	$Control/HealthBar.value = hp

func _process(delta):
	z_index = int(global_position.y) # Set z position to mimic depth
	
	# Set opposing entities
	if is_in_group("adventurers"):
		set_opposing_entities("mobs")
	elif is_in_group("mobs"):
		set_opposing_entities("adventurers")
	
	# Set closest opposing entity as target
	if opposing_entities.is_empty():
		target = null
	else:
		set_target_to_closest()
	
	# Move to target if there is one and is currently not fighting
	if target and not is_fighting():
		move_to_target(delta)
	else:
		velocity = Vector2.ZERO * delta
	flip_sprite_to_direction()
	
	# Play walking animation if moving
	if velocity.length() > 0:
		play_walking_animation(delta)
	
	# Trigger events if fighting
	if is_fighting():
		apply_attack(delta)
		play_attack_animation(delta)
			
func set_opposing_entities(opposing_group):
	opposing_entities = get_tree().get_nodes_in_group(opposing_group)

func set_target_to_closest():
	var closest_distance = INF
	var closest_opposing_entity
	# Compare each distance from a mob and return the closest
	for opposing_entity in opposing_entities:
		var distance = global_position.distance_to(opposing_entity.global_position)
		if (distance < closest_distance):
			closest_distance = distance
			closest_opposing_entity = opposing_entity
	target = closest_opposing_entity
	
func move_to_target(delta):
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * speed * delta
	move_and_slide()

func flip_sprite_to_direction():
	if abs(velocity.x) > 0.1:
		$Sprite2D.flip_h = velocity.x > 0

func play_walking_animation(delta):
	wobble_time_elapsed += delta * wobble_speed
	wobble_time_elapsed = wrapf(wobble_time_elapsed, 0, TAU) # Reset after sin cycle
	$Sprite2D.rotation_degrees = sin(wobble_time_elapsed) * degree_of_wobble # Transition using sin wave

func is_fighting():
	for i in range(get_slide_collision_count()):
		collision = get_slide_collision(i)
		collider = collision.get_collider()
		if collider in opposing_entities:
			return true
	return false

func apply_attack(delta):
	attack_time_elapsed += delta
	if attack_time_elapsed >= 1 / attack_speed:
		collider.take_attack(attack_damage)
		attack_time_elapsed = 0

func take_attack(enemy_attack_damage):
	hp -= enemy_attack_damage
	$Control/HealthBar.value = hp
	if hp <= 0:
		queue_free()

func play_attack_animation(delta):
	var peak_animation := 0.9
	var attack_time_normalized
	var flipped = -1 if $Sprite2D.flip_h else 1
	if attack_time_elapsed < peak_animation / attack_speed:
		attack_time_normalized = attack_time_elapsed / peak_animation
		$Sprite2D.rotation_degrees = lerp(0, degree_of_attack * flipped, attack_time_normalized)
	else:
		attack_time_normalized = (attack_time_elapsed - peak_animation) / (1 - peak_animation)
		$Sprite2D.rotation_degrees = lerp(degree_of_attack * flipped, 0, attack_time_normalized)
