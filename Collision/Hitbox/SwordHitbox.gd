extends Area2D

var knockback_vector = Vector2.ZERO
export var damage = 1
onready var collisionShape = $CollisionShape2D

func disable():
	collisionShape.set_disabled(true)
