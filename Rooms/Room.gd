extends Node2D

class_name Room

signal next_room_portal_entered()
signal previous_room_portal_entered()

export var snapPositionTop: Vector2 = Vector2.ZERO
export var snapPositionBottom: Vector2 = Vector2.ZERO

onready var snappingPointTop = $SnappingPointTop
onready var snappingPointBottom = $SnappingPointBottom
onready var nextPortal = $NextRoomPortal/CollisionShape
onready var previousPortal = $PreviousRoomPortal/CollisionShape

func _on_PreviousRoomPortal_body_entered(body):
	emit_signal("previous_room_portal_entered")

func _on_NextRoomPortal_body_entered(body):
	emit_signal("next_room_portal_entered", self.snappingPointTop.global_position)

func toggle_direction():
	nextPortal.set_deferred('disabled', !nextPortal.disabled)
	previousPortal.set_deferred('disabled', !previousPortal.disabled)
