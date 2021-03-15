extends KinematicBody2D

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK
}

export var MOVEMENT_SPEED = 40
export var FRICTION = 1500
export var KNOCKBACK_SPEED = 89
export var ACCELERATION = 25
export var XP_PER_HP = 1.5
export var attack_range = 25

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var state = IDLE
var spawn_position = Vector2.ZERO

signal died(experience)

onready var stats = $HealthBar/Stats
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var flashTimer = $FlashTimer
onready var playerDetectionZone = $PlayerDetectionZone
onready var hitBox = $Hitbox
onready var hurtBox = $Hurtbox/CollisionShape2D
onready var bloodParticles = $BloodParticles
onready var experience = stats.max_health * XP_PER_HP
onready var softCollision = $SoftCollision
onready var hurtSound = $HurtSound

func _ready():
	animationPlayer.play("Idle")
	if stats.strength == 0:
		stats.strength = stats.current_level + 1
	hitBox.set_damage(stats.strength)

#Process the movement and physics
func _physics_process(delta):
	if stats.health <= 0:
		return
		
		
	if (playerDetectionZone.player != null && global_position.direction_to(playerDetectionZone.player.global_position).x < 0):
		sprite.flip_h = true	
	else:
		sprite.flip_h = false

	
	if knockback != Vector2.ZERO:
		knockback = move_and_slide(knockback.move_toward(Vector2.ZERO, FRICTION * delta))
		
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)	
			seek_player()	
		WANDER:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)	
			seek_player()		
		CHASE:
			if playerDetectionZone.can_see_player():
				var player = playerDetectionZone.player
				var direction = (player.global_position - global_position).normalized()				
				if self.global_position.distance_to(player.global_position) < attack_range:
					state = ATTACK
				else:
					velocity = velocity.move_toward(direction * MOVEMENT_SPEED, ACCELERATION * delta)
			else:
				seek_player()
		ATTACK:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)	
			attack()
			

	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 100
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		animationPlayer.play("Walk")
		state = CHASE
	else:
		animationPlayer.play("Idle")
		state = WANDER

func attack():
	animationPlayer.play("Attack")

func wander(_delta):
	seek_player()

#Received hit
func _on_Hurtbox_area_entered(damagingObject):
	flashSprite()
	stats.reduceHealthBy(damagingObject.damage)
	knockback = damagingObject.knockback_vector * KNOCKBACK_SPEED
	hurtSound.play()
	emit_blood(knockback)

func emit_blood(direction: Vector2):
	bloodParticles.process_material.initial_velocity = max(abs(direction.x), abs(direction.y)) / 3
	bloodParticles.process_material.set_direction(Vector3(direction.x, direction.y, 0))
	bloodParticles.set_emitting(true)

#Receive killing hit
func _on_Stats_no_health():
	animationPlayer.play("Death")
	hitBox.disable()
	velocity = Vector2.ZERO

func death_animation_finished():
	emit_signal("died", experience)
	queue_free()

#Flash the sprite
func flashSprite():
	sprite.modulate = Color(10,10,10,10)
	flashTimer.set_wait_time(0.25)
	hurtBox.call_deferred("set_disabled", true)
	flashTimer.start()

#Return to normal color and stop timer
func _on_FlashTimer_timeout():
	flashTimer.stop()
	hurtBox.set_disabled(false)
	sprite.modulate = Color(1,1,1,1)

func attack_finished():
	state = IDLE
	seek_player()
