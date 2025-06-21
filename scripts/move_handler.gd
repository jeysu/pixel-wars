extends Node2D

@export var speed: int
@export var wobble_speed: int
@export var degree_of_wobble: int
var wobble_time_elapsed: float
var is_fighting: bool

var entity: CharacterBody2D

func setup(parent):
	entity = parent
	entity.z_index = int(entity.global_position.y)

func update(delta):
	if not entity:
		return
	if entity.target and not is_fighting:
		move_to_target(delta, entity.target)
	else:
		entity.velocity = Vector2.ZERO * delta
		entity.move_and_slide()
	flip_sprite_to_direction(entity.get_node("AnimationHandler/Sprite2D"))
	
	# Play walking animation if moving
	if entity.velocity.length() > 0:
		play_walking_animation(delta, entity.get_node("AnimationHandler/Sprite2D"))
	
func move_to_target(delta, target):
	var direction = (target.global_position - entity.global_position).normalized()
	entity.velocity = direction * speed
	entity.move_and_slide()

func flip_sprite_to_direction(sprite):
	if abs(entity.velocity.x) > 0.1:
		sprite.flip_h = entity.velocity.x > 0

func play_walking_animation(delta, sprite):
	wobble_time_elapsed += delta * wobble_speed
	wobble_time_elapsed = wrapf(wobble_time_elapsed, 0, TAU) # Reset after sin cycle
	sprite.rotation_degrees = sin(wobble_time_elapsed) * degree_of_wobble # Transition using sin wave

func _on_attack_handler_fighting_state_changed(is_fighting) -> void:
	self.is_fighting = is_fighting
