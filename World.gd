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

export var chunk_size = 16
export var tile_size = 32

var chunks = []

onready var Chunk = preload("res://World Objects/Chunks/Chunk.tscn")

#Generate a chunk at top left corner #pos
func generate_chunk(pos: Vector2) -> Chunk:
	var chunk = Chunk.instance()
	chunk.set_chunk_size(chunk_size)
	chunk.global_position = Vector2(
		pos.x * chunk_size * tile_size, 
		pos.y * chunk_size * tile_size
	)
	self.chunks.append(chunk)
	self.call_deferred('add_child', chunk)	
	return chunk

func generate_neighbours(chunk: Chunk) -> Array:
	var result = []
	var chunk_coords = chunk.get_coordinates()
	for n in neighbours:
		result.append(generate_chunk(chunk_coords + n))
	print(str(result))
	return result

func get_chunks():
	return self.chunks
