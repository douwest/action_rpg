extends Node2D

var current_room
var previous_room

onready var Room = preload("Rooms/Room.tscn")

func _ready():
	current_room = Room.instance()
	current_room.connect('next_room_portal_entered', self, 'provide_new_room')
	self.add_child(current_room)

#provide a new instance of Room
func provide_new_room(spawn_position: Vector2):
	if previous_room != null:
		previous_room.queue_free()
	self.store_current_room_as_previous(current_room)
	
	var new_room = Room.instance()
	new_room.global_position = spawn_position
	new_room.connect('next_room_portal_entered', self, 'provide_new_room')
	self.add_child(new_room)	
	
	current_room = new_room

# Store the current room in the previous room variable, and unsubscribe.
func store_current_room_as_previous(current_room: Room) -> void :
	current_room.disconnect('next_room_portal_entered', self, 'provide_new_room')
	previous_room = current_room
	#current_room.queue_free()
