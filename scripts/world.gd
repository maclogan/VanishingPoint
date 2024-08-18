extends Node2D

@onready var tile_map: TileMap = $TileMap
@export var noise_tree_texture: NoiseTexture2D
var tree_noise: Noise
var map_noise: Noise
var tree_atlas = [Vector2i(1,1)] 
var width = 100
var height = 100
@onready var noise_generator: NoiseGenerator = $NoiseGenerator

var tree_tiles_arr = []
var count = 0
var noise_val_arr = []
			
func generate_resources() -> void:
	for x in range(width):
		for y in range(height):
			var tree_noise_val: float = tree_noise.get_noise_2d(x, y)
			var map_noise_val: float = map_noise.get_noise_2d(x, y)
			noise_val_arr.append(tree_noise_val)
			if map_noise_val >= 0.2 and tree_noise_val >= 0.4:
				count = count + 1
				tile_map.set_cell(2, Vector2i(x, y), 2, Vector2i(1,1))
	print(count, noise_val_arr.max(), noise_val_arr.min())


func _on_noise_generator_generation_finished() -> void:
	map_noise = noise_generator.settings.noise
	noise_tree_texture.noise.seed = map_noise.seed
	print (map_noise.seed, noise_tree_texture.noise.seed)
	tree_noise = noise_tree_texture.noise
	generate_resources()


func _on_noise_generator_chunk_generation_finished(chunk_position: Vector2i) -> void:
#	Move asset generation here, use chunk size and position as width/height
#	Will need to figure out a way to retain asset position on exit
	pass # Replace with function body.
