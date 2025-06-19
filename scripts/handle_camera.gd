extends Node2D

@export var camera: Camera2D
var dragging := false

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
	if event is InputEventMouseMotion and dragging:
		camera.global_position -= event.relative
