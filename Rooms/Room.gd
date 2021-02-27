extends Node2D

class_name Room

signal next_room_portal_entered()
signal previous_room_portal_entered()

export var snapPositionTop: Vector2 = Vector2.ZERO
export var snapPositionBottom: Vector2 = Vector2.ZERO

onready var BatScene = preload("../Enemies/Bat.tscn")
onready var snappingPointTop = $SnappingPointTop
onready var snappingPointBottom = $SnappingPointBottom
onready var nextPortal = $NextRoomPortal/CollisionShape
onready var previousPortal = $PreviousRoomPortal/CollisionShape

func spawn_bats(number: int):
	for i in range(number):
		var bat = createEnemy()
		print('spawned ' + str(number) + ' bats!')

func _on_PreviousRoomPortal_body_entered(body):
	emit_signal("previous_room_portal_entered")

func _on_NextRoomPortal_body_entered(body):
	emit_signal("next_room_portal_entered", snappingPointTop.global_position)

func toggle_direction():
	nextPortal.set_deferred('disabled', !nextPortal.disabled)
	previousPortal.set_deferred('disabled', !previousPortal.disabled)

func _ready():
	randomize()
	var bats = rand_range(0, 1.0)
	if bats < 0.45:
		return
	elif bats < 0.75:
		spawn_bats(1)
	elif bats < 0.95:
		spawn_bats(2)
	else:
		spawn_bats(3)

func createEnemy() -> Node:
	var bat = BatScene.instance()
	bat.global_position += Vector2(rand_range(-60.0, 60.0), rand_range(-60.0, 60.0))
	bat.connect("died", get_parent(), "signal_experience_drop")
	self.get_node("Enemies").add_child(bat)
	return bat
