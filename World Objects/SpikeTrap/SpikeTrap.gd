extends Node2D

export var frequency = 1
export var time_offset = 0.1

onready var timer = $Timer
onready var animated_sprite = $AnimatedSprite
onready var collision_shape = $Hitbox/CollisionShape2D
onready var audio_player = $AudioStreamPlayer2D

func _ready():
	timer.set_wait_time(time_offset)
	timer.start()
	animated_sprite.set_animation('default')


func _on_Timer_timeout():
	animated_sprite.set_animation('active')
	collision_shape.set_disabled(false)
	audio_player.play()

func _on_AnimatedSprite_animation_finished():
	if animated_sprite.get_animation() == 'active':
		animated_sprite.set_animation('default')
		collision_shape.set_disabled(true)
		timer.set_wait_time(frequency)
		timer.start()
	else:
		pass
