extends Node2D

class_name Room

signal next_room_portal_entered()
signal previous_room_portal_entered()

onready var snappingPointTop = $SnappingPointTop
onready var snappingPointBottom = $SnappingPointBottom
onready var nextPortal = $NextRoomPortal/CollisionShape
onready var previousPortal = $PreviousRoomPortal/CollisionShape

func _on_PreviousRoomPortal_body_entered(body):
	print('render-back')
	emit_signal("previous_room_portal_entered")


func _on_NextRoomPortal_body_entered(body):
	print('render-forward')
	emit_signal("next_room_portal_entered", self.snappingPointTop.global_position)

func toggle_direction():
	nextPortal.set_deferred('disabled', !nextPortal.disabled)
	previousPortal.set_deferred('disabled', !previousPortal.disabled)
