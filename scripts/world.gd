extends Node2D

@onready var tile_map: TileMap = $TileMap
@export var noise_tree_texture: NoiseTexture2D
@export var noise_rock_texture: NoiseTexture2D
@export var noise_chest_texture: NoiseTexture2D
var tree_noise: Noise
var rock_noise: Noise
var map_noise: Noise
var chest_noise: Noise
var width = 100
var height = 100
@onready var noise_generator: NoiseGenerator = $NoiseGenerator
var TILE_SIZE := 16

var count = 0
var noise_val_arr = []

var resource_data = {}

var rock_resource = preload("res://scenes/resources/Rock.tscn")
var tree_resource = preload("res://scenes/resources/Tree.tscn")
var chest_resource = preload("res://scenes/resources/Chest.tscn")
			
func generate_resources() -> void:
	for x in range(width):
		for y in range(height):
			var tree_noise_val: float = tree_noise.get_noise_2d(x, y)
			var rock_noise_val: float = rock_noise.get_noise_2d(x, y)
			var chest_noise_val: float = chest_noise.get_noise_2d(x, y)
			var map_noise_val: float = map_noise.get_noise_2d(x, y)
			noise_val_arr.append(tree_noise_val)
			if map_noise_val >= 0.2:
				if tree_noise_val >= 0.4:
					#count = count + 1
					var tree_instance = tree_resource.instantiate()
					tree_instance.position = Vector2i(x * TILE_SIZE, y * TILE_SIZE)
					add_child(tree_instance)
				if rock_noise_val >= 0.3:
					#count = count +1
					var rock_instance = rock_resource.instantiate()
					rock_instance.position = Vector2i(x * TILE_SIZE, y * TILE_SIZE)
					add_child(rock_instance)
				if chest_noise_val >= 0.3:
					count = count + 1
					var chest_instance = chest_resource.instantiate()
					chest_instance.position = Vector2i(x * TILE_SIZE, y * TILE_SIZE)
					add_child(chest_instance)
				#tile_map.set_cell(2, Vector2i(x, y), 2, Vector2i(1,1))
	print(count, " ", noise_val_arr.max(), " ", noise_val_arr.min())


func _on_noise_generator_generation_finished() -> void:
	map_noise = noise_generator.settings.noise
	#noise_tree_texture.noise.seed = map_noise.seed
	#noise_rock_texture.noise.seed = map_noise.seed
	tree_noise = noise_tree_texture.noise
	rock_noise = noise_rock_texture.noise
	chest_noise = noise_chest_texture.noise
	generate_resources()


func _on_noise_generator_chunk_generation_finished(chunk_position: Vector2i) -> void:
#	Move asset generation here, use chunk size and position as width/height
#	Will need to figure out a way to retain asset position on exit
	#print(chunk_position, " generated")
	pass
