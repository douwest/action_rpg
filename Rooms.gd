extends Node2D

var current_room: Room
var previous_room: Room
var saved_rooms = []
var current_room_index: int = 0

onready var Room = preload("Rooms/Room.tscn")

func _ready():
	current_room = Room.instance()
	current_room.connect('next_room_portal_entered', self, 'provide_new_room')
	current_room.connect('previous_room_portal_entered', self, 'provide_previous_room')	
	saved_rooms.append(current_room)
	self.call_deferred('add_child', current_room)

#provide a new instance of Room
func provide_new_room(spawn_position: Vector2):
	if current_room_index + 1 >= saved_rooms.size():
		print('discover a new room!')
		construct_new_room(spawn_position)
	else:
		print('been here!')
		provide_visited_room()

func provide_visited_room():
	self.call_deferred('add_child', saved_rooms[current_room_index + 1])
	var new_room = saved_rooms[current_room_index + 1]
	new_room.connect('next_room_portal_entered', self, 'provide_new_room')
	new_room.connect('previous_room_portal_entered', self, 'provide_previous_room')
	self.call_deferred('remove_child', previous_room)
	self.store_current_room_as_previous(current_room)
	current_room = new_room
	current_room_index += 1	
	print(str(current_room_index))

func construct_new_room(spawn_position: Vector2):
	if previous_room != null:
		self.call_deferred('remove_child', previous_room)
		
	var new_room = Room.instance()
	new_room.global_position = spawn_position
	new_room.connect('next_room_portal_entered', self, 'provide_new_room')
	new_room.connect('previous_room_portal_entered', self, 'provide_previous_room')
	
	self.store_current_room_as_previous(current_room)
	self.call_deferred('add_child', new_room);
	
	current_room.toggle_direction()
	if !saved_rooms.has(new_room):
		saved_rooms.append(new_room)
	
	current_room_index += 1
	current_room = new_room
	print('discovered rooms: ' + str(saved_rooms.size()) + ', index:' + str(current_room_index))

#provide a previous instance of room that was already discovered
func provide_previous_room():
	if previous_room != null:
		self.call_deferred('add_child', saved_rooms[current_room_index - 2])
		current_room_index = max(current_room_index - 1, 0)
		current_room = previous_room
		current_room.toggle_direction()
		previous_room = saved_rooms[current_room_index - 1]
		previous_room.connect('next_room_portal_entered', self, 'provide_new_room')
		previous_room.connect('previous_room_portal_entered', self, 'provide_previous_room')
		self.call_deferred('remove_child', saved_rooms[current_room_index + 1])
		
	print(str(current_room_index))

# Store the current room in the previous room variable, and unsubscribe.
func store_current_room_as_previous(current_room: Room) -> void :
	previous_room = current_room
