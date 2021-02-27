extends Node2D

var saved_rooms = []
var current_room_index: int = 0

onready var Room = preload("Rooms/Room.tscn")
onready var Clearing = preload("Rooms/ClearingRoom/ClearingRoom.tscn")
onready var Corridor = preload("Rooms/CorridorRoom/CorridorRoom.tscn")

func _ready():
	randomize()	
	add_room(Clearing.instance(), Vector2.ZERO)

# Provide a visited or new Room forward
func provide_room_forward(spawn_position: Vector2):
	if current_room_index + 1 >= saved_rooms.size():
		generate_new_room(spawn_position)
	else:
		provide_visited_room_forwards()
	
	saved_rooms[current_room_index].toggle_direction()
	current_room_index += 1	

# Provide an already visited Room backward
func provide_room_backward():
	if current_room_index - 2 >= 0:
		var tail_room = saved_rooms[current_room_index - 2]
		add_room(tail_room, null)
		remove_room_by_index(current_room_index + 2)
		
	current_room_index = max(0, current_room_index - 1)		
	saved_rooms[current_room_index].toggle_direction()

# Generate a new room
func generate_new_room(spawn_position: Vector2):
	var new_room
	if rand_range(0, 1) > 0.25:
		new_room = Corridor.instance()
	else:
		new_room = Clearing.instance()
	var room_position = spawn_position + new_room.snapPositionTop
	print('spawn, topsnap: ', str(spawn_position), str(saved_rooms[current_room_index].snapPositionBottom))
	print('roompos: ', str(room_position))
	add_room(new_room, room_position)
	remove_room_by_index(current_room_index - 1)

# Provide an already visited room forward
func provide_visited_room_forwards():
	var room = saved_rooms[current_room_index]
	add_room(room, null)
	remove_room_by_index(current_room_index - 2)

# Connect portal signals of room
func connect_room(room: Room): 
	room.connect('next_room_portal_entered', self, 'provide_room_forward')
	room.connect('previous_room_portal_entered', self, 'provide_room_backward')	

# Remove a room by reference
func remove_room(room: Room):
	if room != null:
		self.call_deferred('remove_child', room)

# Remove a room from the scene by array index
func remove_room_by_index(index: int):
	if index >= 0 and index < saved_rooms.size():
		self.call_deferred('remove_child', saved_rooms[index])

# Add a new room and add to saved rooms if not earlier encountered.
func add_room(room: Room, spawn_position):
	if(spawn_position != null):
		room.global_position = spawn_position
	self.call_deferred('add_child', room)
	connect_room(room)
	if !saved_rooms.has(room):
		saved_rooms.append(room)
