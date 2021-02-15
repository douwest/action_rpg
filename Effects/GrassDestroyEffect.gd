extends Node2D

onready var grassDestroySprite = $AnimatedSprite

func _ready():
	grassDestroySprite.play("GrassDestroyed")

func _on_AnimatedSprite_animation_finished():
	queue_free()
