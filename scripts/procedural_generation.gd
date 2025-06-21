extends Node2D

@export var water_layer: TileMapLayer
@export var ground_layer: TileMapLayer
@export var grass_layer: TileMapLayer
@export var noise_texture: NoiseTexture2D
var water_tiles: Array
var ground_tiles: Array
var grass_tiles: Array

var noise: Noise
var width := 50
var height := 50

func setup():
	water_tiles.clear()
	ground_tiles.clear()
	grass_tiles.clear()
	
	noise = noise_texture.noise
	noise.seed = randi()
	for x in width:
		for y in height:
			var noise_value = noise.get_noise_2d(x, y)
			if noise_value > -1:
				water_tiles.append(Vector2(x, y))
			if noise_value > 0:
				ground_tiles.append(Vector2(x, y))
			if noise_value > 0.25:
				grass_tiles.append(Vector2(x, y))
				
	water_layer.set_cells_terrain_connect(water_tiles, 0, 0)
	ground_layer.set_cells_terrain_connect(ground_tiles, 0, 0)
	grass_layer.set_cells_terrain_connect(grass_tiles, 0, 0)
