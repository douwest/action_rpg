extends Node2D

class_name Room

signal next_room_portal_entered()
signal previous_room_portal_entered()

export var snapPositionTop: Vector2 = Vector2.ZERO
export var snapPositionBottom: Vector2 = Vector2.ZERO

onready var Bat = preload("../../Enemies/Bat/Bat.tscn")
onready var StrongBat = preload("../../Enemies/Bat/StrongBat.tscn")
onready var snappingPointTop = $SnappingPointTop
onready var snappingPointBottom = $SnappingPointBottom
onready var nextPortal = $NextRoomPortal/CollisionShape
onready var previousPortal = $PreviousRoomPortal/CollisionShape

func spawn_enemies(number: int):
	for i in range(number):
		var enemy = createEnemy()

func _on_PreviousRoomPortal_body_entered(body):
	emit_signal("previous_room_portal_entered")

func _on_NextRoomPortal_body_entered(body):
	emit_signal("next_room_portal_entered", snappingPointTop.global_position)

func toggle_direction():
	nextPortal.set_deferred('disabled', !nextPortal.disabled)
	previousPortal.set_deferred('disabled', !previousPortal.disabled)

func _ready():
	randomize()
	var enemies = rand_range(0, 1.0)
	if enemies < 0.4:
		return
	elif enemies < 0.7:
		spawn_enemies(1)
	elif enemies < 0.9:
		spawn_enemies(2)
	else:
		spawn_enemies(3)

func createEnemy() -> Node:
	var enemy
	randomize()
	var which_enemy = rand_range(0, 1.0)
	if which_enemy < 0.8:
		enemy = Bat.instance()
	else:
		enemy = StrongBat.instance()
	enemy.global_position += Vector2(rand_range(-60.0, 60.0), rand_range(-60.0, 60.0))
	enemy.connect("died", get_parent(), "signal_experience_drop")
	self.get_node("Enemies").add_child(enemy)
	return enemy
