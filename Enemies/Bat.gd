extends KinematicBody2D

enum {
	IDLE,
	WANDER,
	CHASE
}

const MOVEMENT_SPEED = 50
const FRICTION = 400
const KNOCKBACK_SPEED = 150
const ACCELERATION = 35

export var experience = 5

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var state = IDLE
var spawn_position = Vector2.ZERO

signal died(experience)

onready var batStats = $HealthBar/BatStats
onready var batSprite = $AnimatedSprite
onready var flashTimer = $FlashTimer
onready var playerDetectionZone = $PlayerDetectionZone

#Process the movement and physics
func _physics_process(delta):
	if knockback != Vector2.ZERO:
		knockback = move_and_slide(knockback.move_toward(Vector2.ZERO, FRICTION * delta))
		
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)	
			seek_player()		
		WANDER:
			var direction = (spawn_position - self.position).normalized()
			velocity = velocity.move_toward((direction * MOVEMENT_SPEED) / 2, (ACCELERATION * delta) / 2)
			seek_player()
		CHASE:
			if playerDetectionZone.can_see_player():
				var player = playerDetectionZone.player
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MOVEMENT_SPEED, ACCELERATION * delta)
			else:
				seek_player()
	if velocity.x < 0:
		batSprite.flip_h = true	
	else:
		batSprite.flip_h = false

	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
	else:
		state = WANDER

func wander(delta):
	seek_player()

#--------------------------------------------------------------------
#Received hit
func _on_BatHurtbox_area_entered(damagingObject):
	flashSprite()
	batStats.reduceHealthBy(damagingObject.damage)
	knockback = damagingObject.knockback_vector * KNOCKBACK_SPEED

#Receive killing hit
func _on_Stats_no_health():
	print('died!')
	queue_free()
	emit_signal("died", experience)

#Flash the sprite
func flashSprite():
	batSprite.modulate = Color(10,10,10,10)
	flashTimer.set_wait_time(0.15)
	flashTimer.start()

#Return to normal color and stop timer
func _on_FlashTimer_timeout():
	flashTimer.stop()
	batSprite.modulate = Color(1,1,1,1)		
