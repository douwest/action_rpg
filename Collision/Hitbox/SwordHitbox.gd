extends Area2D

var knockback_vector = Vector2.ZERO
export var damage = 1
onready var collisionShape = $CollisionShape2D

func disable():
	collisionShape.set_disabled(true)

func has_collisions() -> bool:
	return self.get_overlapping_bodies().size() > 0
