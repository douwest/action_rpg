extends YSort

export var chunk_size = 16
export var tile_size = 32

onready var chunkManager = $ChunkManager
onready var entityManager = $EntityManager

func _ready():
	chunkManager.chunk_size = self.chunk_size
	chunkManager.tile_size = self.tile_size
	entityManager.chunk_size = self.chunk_size
	entityManager.tile_size = self.tile_size
