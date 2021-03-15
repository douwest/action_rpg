extends StaticBody2D
class_name AbstractRoom

var depth = 0
export var room_spawn_rate = 60

onready var collisionShape: CollisionShape2D = $CollisionShape
onready var floorTiles: TileMap = $FloorTiles 
onready var snappingPoints: Node2D = $SnappingPoints


func _ready():
	for pos in snappingPoints.get_children():
		attempt_to_generate(pos, depth)
		
func attempt_to_generate(pos: Position2D, depth: int) -> void:
	if depth < 5:
		var r = randi() % 100
		match pos.get_name():
			'North':
				print('North!')
				if r > room_spawn_rate:
					var new_room = AbstractRoom.instance()
					new_room.global_position = self.global_position 
					new_room.connecting_from = 'North'
					add_child()
			'South':
				if r > room_spawn_rate:
					print('South!')
			'East':
				if r > room_spawn_rate:
					print('East!')
			'West':
				if r > room_spawn_rate:
					print('West')
