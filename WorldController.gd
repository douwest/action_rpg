extends Node2D

export var world_seed = 42069
onready var player = $YSort/ChunkGenerator/Player
onready var world = $YSort/ChunkGenerator

signal experience_dropped(experience)

func _ready():
	seed(world_seed)
	pause_mode = Node.PAUSE_MODE_STOP
	world.generate_from(player.global_position)
