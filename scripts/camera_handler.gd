extends Node2D

@export var camera: Camera2D
var dragging := false
var zoom_strength := 0.1

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.zoom += Vector2(zoom_strength, zoom_strength)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.zoom -= Vector2(zoom_strength, zoom_strength)
			
	if event is InputEventMouseMotion and dragging:
		camera.global_position -= event.relative
