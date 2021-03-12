extends YSort

onready var player = $Player
onready var enemies = $Enemies

var tile_size = 32
var chunk_size = 16

var entity_render_distance = Vector2.ZERO

func _ready() -> void:
	entity_render_distance = chunk_size * tile_size * 1.5

func _physics_process(delta) -> void:
	for enemy in enemies.get_children():
		if enemy != null and enemy.global_position != null:	
			
			if player.global_position.distance_to(enemy.global_position) > entity_render_distance:
				enemy.queue_free()
