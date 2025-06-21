extends CharacterBody2D

var target = CharacterBody2D
var opposing_entities = {}
var behaviors = {}

func _ready():
	set_opposing_entities()
	for child in get_children():
		if child.is_in_group("behavior"):
			behaviors[child.name.to_lower()] = child
			if behaviors[child.name.to_lower()].has_method("setup"):
				behaviors[child.name.to_lower()].setup(self)

func _process(delta):
	if opposing_entities.is_empty():
		target = null
	else:
		target = get_closest_target()
		
	for behavior in behaviors.values():
		if behavior and behavior.has_method("update"):
			behavior.update(delta)

func get_closest_target() -> CharacterBody2D:
	var closest_distance = INF
	var closest_opposing_entity
	
	for opposing_entity in opposing_entities:
		var distance = global_position.distance_to(opposing_entity.global_position)
		if (distance < closest_distance):
			closest_distance = distance
			closest_opposing_entity = opposing_entity
	return closest_opposing_entity
	
func set_opposing_entities() -> void:
	if is_in_group("adventurers"):
		opposing_entities = get_tree().get_nodes_in_group("mobs")
	elif is_in_group("mobs"):
		opposing_entities = get_tree().get_nodes_in_group("adventurers")
