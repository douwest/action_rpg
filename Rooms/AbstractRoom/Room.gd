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
	for _i in range(number):
		createEnemy()

func _on_PreviousRoomPortal_body_entered(_body):
	emit_signal("previous_room_portal_entered")

func _on_NextRoomPortal_body_entered(_body):
	emit_signal("next_room_portal_entered", snappingPointTop.global_position)

func toggle_direction():
	nextPortal.set_deferred('disabled', !nextPortal.disabled)
	previousPortal.set_deferred('disabled', !previousPortal.disabled)

func _ready():
	randomize()
	var enemies = max(1, floor(rand_range(0, 10.0)))
	spawn_enemies(enemies)

func createEnemy() -> Node:
	var enemy = Bat.instance()
	self.get_node("Enemies").add_child(enemy)		
	enemy.global_position += Vector2(rand_range(-60.0, 60.0), rand_range(-60.0, 60.0))
	enemy.connect("died", get_parent(), "signal_experience_drop")
	return enemy
