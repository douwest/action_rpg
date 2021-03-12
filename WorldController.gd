extends Node2D

export var use_seed = false
export var world_seed = 333333

onready var player = $World/EntityManager/Player
onready var chunks = $World/ChunkManager

signal experience_dropped(experience)

func _ready():
	if use_seed:
		seed(world_seed)
	else:
		randomize()	
	pause_mode = Node.PAUSE_MODE_STOP
	chunks.generate_from_global_position(player.global_position)

#func _process(delta):
	#weather.global_position = player.global_position + Vector2(0, -120)
