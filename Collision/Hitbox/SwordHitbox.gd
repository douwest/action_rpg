extends Area2D

var knockback_vector = Vector2.ZERO
export var damage = 1

func disable():
	$CollisionShape2D.set_disabled(true)
