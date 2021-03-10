extends Node2D
class_name Chunk


var chunk_size = 16
var coordinates = Vector2.ZERO

onready var tile_map = $TileMap
onready var tile_size = tile_map.get_cell_size()
onready var playerDetectionLayer = $PlayerDetectionLayer

func _ready() -> void:
	generate_self()

func generate_self() -> void:
	generate_detection_layer()
	generate_floor()

func generate_detection_layer() -> void:
	var chunk_edge_length = (tile_size * chunk_size)
	var ul = Vector2.ZERO
	var ur = Vector2(chunk_edge_length.x, 0) 
	var lr = Vector2(chunk_edge_length.x, chunk_edge_length.y) 
	var ll = Vector2(0, chunk_edge_length.y) 
	playerDetectionLayer.set_polygon([ul, ur,  lr, ll])

func generate_floor() -> void:
	for i in chunk_size:
		for j in chunk_size:
			tile_map.set_cell(i, j, get_random_cell_unif())

func get_random_cell_unif() -> int:
	return randi() % tile_map.tile_set.get_tiles_ids().size()

func get_coordinates() -> Vector2:
	return self.coordinates
	
func set_chunk_size(value: int) -> void:
	self.chunk_size = value
