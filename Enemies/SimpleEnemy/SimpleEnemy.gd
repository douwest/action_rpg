extends KinematicBody2D

enum {
	IDLE,
	WANDER,
	CHASE
}

export var MOVEMENT_SPEED = 50
export var FRICTION = 400
export var KNOCKBACK_SPEED = 150
export var ACCELERATION = 35
export var XP_PER_HP = 1.5


var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var state = IDLE
var spawn_position = Vector2.ZERO

signal died(experience)

onready var stats = $HealthBar/Stats
onready var sprite = $AnimatedSprite
onready var flashTimer = $FlashTimer
onready var playerDetectionZone = $PlayerDetectionZone
onready var hitBox = $Hitbox
onready var experience = stats.max_health * XP_PER_HP

func _ready():
	if stats.strength == 0:
		stats.strength = stats.current_level + 1
	hitBox.set_damage(stats.strength)

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
		sprite.flip_h = true	
	else:
		sprite.flip_h = false

	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
	else:
		state = WANDER

func wander(_delta):
	seek_player()

#Received hit
func _on_Hurtbox_area_entered(damagingObject):
	flashSprite()
	stats.reduceHealthBy(damagingObject.damage)
	knockback = damagingObject.knockback_vector * KNOCKBACK_SPEED

#Receive killing hit
func _on_Stats_no_health():
	queue_free()
	emit_signal("died", experience)

#Flash the sprite
func flashSprite():
	sprite.modulate = Color(10,10,10,10)
	flashTimer.set_wait_time(0.15)
	flashTimer.start()

#Return to normal color and stop timer
func _on_FlashTimer_timeout():
	flashTimer.stop()
	sprite.modulate = Color(1,1,1,1)
