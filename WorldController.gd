extends Node2D

export var world_seed = 42690
onready var player = $YSort/Player
onready var world = $YSort/ChunkGenerator

signal experience_dropped(experience)

var current_chunk: Chunk

func _ready():
	seed(world_seed)
	pause_mode = Node.PAUSE_MODE_STOP
	current_chunk = world.generate_chunk(Vector2.ZERO) #origin
	connect_detection_zone(current_chunk)
	var neighbours = world.generate_neighbours(current_chunk)

func connect_detection_zone(chunk: Chunk) -> void:
	chunk.connect("body_entered", self, "delegate")
	
func delegate(body):
	print('on chunk!')
