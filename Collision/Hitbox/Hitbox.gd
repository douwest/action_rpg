extends Area2D

export var damage = 1
onready var collisionShape = $CollisionShape2D

func set_damage(value):
	self.damage = value

func disable():
	collisionShape.call_deferred('set_disabled', true)
