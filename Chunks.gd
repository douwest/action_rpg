extends YSort

const neighbours = [
	Vector2(0,1),
	Vector2(0,-1),
	Vector2(1,0),
	Vector2(-1,0),
	Vector2(1,1),
	Vector2(-1,1),
	Vector2(1,-1),
	Vector2(-1,-1),
]

var chunk_size = 16
var tile_size = 32

var current_chunk setget set_current_chunk
var chunks = []

onready var Chunk = preload("res://World Objects/Chunks/Chunk.tscn")

#Generate a chunk at top left corner #pos
func generate_chunk(coords: Vector2) -> Chunk:
	var chunk = Chunk.instance()
	chunk.set_chunk_size(chunk_size)
	chunk.coordinates = coords
	chunk.global_position = Vector2(
		coords.x * chunk_size * tile_size, 
		coords.y * chunk_size * tile_size
	)
	call_deferred('add_child', chunk)	
	return chunk

func generate_neighbours(coords: Vector2) -> Array:
	var result = []
	for n in neighbours:
		result.append(generate_chunk(coords + n))
	return result

func generate_from(coords: Vector2):
	remove_old_chunks()
	set_current_chunk(generate_chunk(coords))
	chunks.append(current_chunk)
	var neighbours = generate_neighbours(coords)
	for n in neighbours:
		chunks.append(n)
		n.connect('player_detected', self, 'render_next_chunks')
	return chunks
	
func generate_from_global_position(pos: Vector2):
	generate_from(
		Vector2(
			floor(pos.x / (chunk_size * tile_size)), 
			floor(pos.y / (chunk_size * tile_size))
		)
	)
	
func get_chunks() -> Array:
	return chunks

func remove_old_chunks() -> void:
	for chunk in chunks:
		call_deferred('remove_child', chunk)
		chunk.queue_free()
	chunks.clear()	

func set_current_chunk(chunk):
	current_chunk = chunk

func find_player_current_chunk(area) -> Chunk:
	for c in chunks:
		if c.overlaps_area(area):
			return c
	return null
	
func render_next_chunks(area) -> void:
	current_chunk = find_player_current_chunk(area)
	generate_from(current_chunk.coordinates)
