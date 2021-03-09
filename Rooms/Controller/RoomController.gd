extends Node2D

var saved_rooms = []
var current_room_index: int = 0 setget set_current_room_index

onready var Clearing = preload("../ClearingRoom/ClearingRoom.tscn")
onready var Corridor = preload("../CorridorRoom/CorridorRoom.tscn")
onready var LeftBentCorridor = preload("../CorridorRoom/LeftBentCorridorRoom.tscn")
onready var RightBentCorridor = preload("../CorridorRoom/RightBentCorridorRoom.tscn")

signal experience_dropped(experience)
signal current_room_index_changed(current_room_index)
signal rooms_changed(saved_rooms)

func set_current_room_index(index):
	emit_signal('current_room_index_changed', current_room_index)
	emit_signal('rooms_changed', saved_rooms)
	current_room_index = index

func _ready():
	pause_mode = Node.PAUSE_MODE_STOP
	randomize()	
	add_room(Clearing.instance(), Vector2.ZERO)

# Provide a visited or new Room forward
func provide_room_forward(spawn_position: Vector2):
	print('next room @ ' + str(spawn_position))
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
func generate_new_room(old_room_snap_top: Vector2):
	var new_room = get_random_room_type_instance()
	var room_position = old_room_snap_top - new_room.snapPositionBottom
	add_room(new_room, room_position)
	remove_room_by_index(current_room_index - 1)

# Provide an already visited room forward
func provide_visited_room_forwards():
	var room = saved_rooms[current_room_index + 1]
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
	if spawn_position != null:
		room.global_position = spawn_position
	self.call_deferred('add_child', room)
	connect_room(room)
	if !saved_rooms.has(room):
		saved_rooms.append(room)

func get_random_room_type_instance() -> Room:
	randomize()	
	var room
	var random = rand_range(0, 1.0)
	if random < 0.4:
		room = Corridor.instance()
	elif random < 0.6:
		room = Clearing.instance()
	elif random < 0.8:
		room = RightBentCorridor.instance()
	else:
		room = LeftBentCorridor.instance()
	return room

# A child room has had an experience drop, signal up to update player's stats.
func signal_experience_drop(experience: int):
	emit_signal('experience_dropped', experience)
