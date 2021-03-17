extends Node2D

onready var tilemap = $TileMap
onready var player = $Player
var width
var height

export var min_size = Vector2(10,10)
export var max_size = Vector2(20,20)

enum {
	FOREST
}

enum {
	GRASS,
	SNOW,
	WALL,
	FLOOR
}

func _ready():
	generate_room()

func generate_room():
	randomize()
	width = int(min_size.x) + randi() % int(max_size.x)
	height = int(min_size.y) + randi() % int(max_size.y)
	generate_floor()
	generate_border()
	generate_walls()
	generate_doors()
	place_player()

func generate_floor():
	for i in width:
		for j in height:
			tilemap.set_cell(i, j, FLOOR)

func generate_border():
	for i in width:
		for j in [0, height - 1]:
			tilemap.set_cell(i, j, GRASS)
	for j in height:
		for i in [0, width - 1]:
			tilemap.set_cell(i, j, GRASS)
			
func generate_doors():
	#left
	var rand_left = 1 + (randi() % (height - 2))
	generate_door(0, rand_left)
	
	#right
	var rand_right = 1 + (randi() % (height - 2)) #[2, height - 2]
	generate_door(width - 1, rand_right)
	
func generate_door(x: int, y: int):
	tilemap.set_cell(x, y, WALL)
	tilemap.set_cell(x, y + 1, FLOOR)

func generate_walls():
	for i in width:
		for j in height:
			if tilemap.get_cell(i, j) == GRASS && tilemap.get_cell(i, j + 1) == FLOOR:
				tilemap.set_cell(i, j + 1, WALL)

func place_player():
	player.global_position = Vector2(width * 32 / 2 + 128, height * 32 / 2 + 128)

func _on_Button_pressed():
	tilemap.clear()
	generate_room()

