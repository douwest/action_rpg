extends Node2D
class_name Chunk


var chunk_size = 16
var coordinates = Vector2.ZERO

export var collision_margin = 2

onready var tile_map = $TileMap
onready var tile_size = tile_map.get_cell_size()
onready var area2D = $Area2D
onready var playerDetectionLayer = $Area2D/PlayerDetectionLayer
onready var simplex_noise = OpenSimplexNoise.new()

onready var TreeBig = preload("res://World Objects/Foliage/TreeBig.tscn")
onready var Enemy = preload("res://Enemies/Bat/Bat.tscn")
signal player_detected(area)

func _ready() -> void:
	generate_self()

func generate_self() -> void:
	generate_detection_layer()
	generate_floor()
	generate_trees()

func generate_detection_layer() -> void:
	var chunk_edge_length = (tile_size * chunk_size)
	var ul = Vector2(collision_margin, collision_margin)
	var ur = Vector2(chunk_edge_length.x - collision_margin, collision_margin) 
	var lr = Vector2(chunk_edge_length.x - collision_margin, chunk_edge_length.y - collision_margin) 
	var ll = Vector2(collision_margin, chunk_edge_length.y - collision_margin) 
	playerDetectionLayer.set_polygon([ul, ur,  lr, ll])

func generate_floor() -> void:
	for i in chunk_size:
		for j in chunk_size:
			tile_map.set_cell(i, j, get_random_cell_unif(i, j))

func generate_trees() -> void: 
	for i in chunk_size:
		for j in chunk_size:
			var x = self.global_position.x + i * tile_size.x
			var y = self.global_position.y + j * tile_size.y
			if simplex_noise.get_noise_2d(x, y) > 0.46:
				var tree = TreeBig.instance()
				tree.position = Vector2(
					i * tile_size.x, 
					j * tile_size.y
				)
				get_node('Foliage').add_child(tree)

func generate_enemies() -> void:
	for i in chunk_size:
		for j in chunk_size:
			var x = self.global_position.x + i * tile_size.x
			var y = self.global_position.y + j * tile_size.y
			if simplex_noise.get_noise_2d(x, y) < -0.47:
				var enemy = Enemy.instance()
				enemy.position = Vector2(
					i * tile_size.x, 
					j * tile_size.y
				)
				get_node('Enemies').add_child(enemy)

func get_random_cell_unif(i: int, j: int) -> int:
	var x = self.global_position.x + i * tile_size.x
	var y = self.global_position.y + j * tile_size.y
	return abs(int(simplex_noise.get_noise_2d(x, y) * 100)) % tile_map.tile_set.get_tiles_ids().size()

func get_coordinates() -> Vector2:
	return self.coordinates
	
func set_chunk_size(value: int) -> void:
	self.chunk_size = value

func overlaps_area(area) -> bool:
	return area2D.overlaps_area(area)

func _on_Area2D_area_entered(area):
	emit_signal('player_detected', area)
