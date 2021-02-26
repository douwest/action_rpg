extends Node2D

class_name Room

signal next_room_portal_entered()
signal previous_room_portal_entered()

onready var snappingPointTop = $SnappingPointTop
onready var snappingPointBottom = $SnappingPointBottom

func _on_PreviousRoomPortal_body_entered(body):
	emit_signal("previous_room_portal_entered")


func _on_NextRoomPortal_body_entered(body):
	emit_signal("next_room_portal_entered", self.snappingPointTop.global_position)
