extends KinematicBody2D

enum {
	MOVE,
	ROLL,
	ATTACK
}

const ACCELERATION = 400
const FRICTION = 600
const MAX_SPEED = 115
const ROLL_SPEED = 1.25 * MAX_SPEED
const MAX_CAMERA_DISTANCE = 60
const CAMERA_MOVE_DURATION = 1.0

var state = MOVE setget set_state
var velocity = Vector2.ZERO
var direction_vector = Vector2.DOWN #instantiate to player direction

onready var camera = $ZoomingCamera2D
onready var hurtTimer = $HurtTimer
onready var playerSprite = $PlayerSprite
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var stats = $Stats
onready var hurtBoxCollisionShape = $Hurtbox/CollisionShape2D
onready var tween = $ZoomingCamera2D/Tween
onready var raycast = $RayCast2D

func _ready():
	setAnimationTo("Idle")
	animationTree.set("parameters/Idle/blend_position", direction_vector)
	animationTree.active = true
	swordHitbox.knockback_vector = direction_vector
	swordHitbox.damage = max(1, stats.strength)

func _physics_process(delta):

	match state:
		MOVE: move_state(delta)
		ROLL: roll_state(delta)
		ATTACK: attack_state(delta)

func move_state(delta):
	var gaze_vector = (get_global_mouse_position() - self.global_position)
	raycast.set_cast_to(gaze_vector)
	
	var input_vector = getInputVector()
	
	if input_vector != Vector2.ZERO:
		direction_vector = input_vector
		swordHitbox.knockback_vector = direction_vector
		
		updateBlendPositions(input_vector)	
		setAnimationTo("Run")
		moveToward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		setAnimationTo("Idle")		
		#direction_vector = get_viewport().get_mouse_position()
		moveToward(Vector2.ZERO, FRICTION * delta)
		updateBlendPositions(gaze_vector)
		direction_vector = gaze_vector.normalized()
		swordHitbox.knockback_vector = direction_vector
		
	moveCamera(input_vector, delta)
	moveAndSlide()
	
	if Input.is_action_just_pressed("ui_attack"):
		set_state(ATTACK)
		
	if Input.is_action_just_pressed("ui_roll"):
		set_state(ROLL)

func moveCamera(input_vector: Vector2, delta: float):
	tween.interpolate_property(
		camera,
		"offset",
		camera.offset,
		input_vector * MAX_CAMERA_DISTANCE,
		CAMERA_MOVE_DURATION,
		tween.EASE_IN,
		# Easing out means we start fast and slow down as we reach the target value.
		tween.EASE_OUT
	)
	tween.start()

func attack_state(_delta):
	resetVelocity()
	setAnimationTo("Attack")
	
func roll_state(_delta):
	velocity = direction_vector * ROLL_SPEED
	hurtBoxCollisionShape.disabled = true
	moveAndSlide()
	setAnimationTo("Roll")
	
func attack_end():
	set_state(MOVE)
	
func roll_end():
	hurtBoxCollisionShape.disabled = false
	set_state(MOVE)

func moveAndSlide():
	velocity = move_and_slide(velocity)

func moveToward(to, speed):
	velocity = velocity.move_toward(to, speed)

func setAnimationTo(string):
	animationState.travel(string)
	
func set_state(value):
	state = value

func resetVelocity():
	velocity = Vector2.ZERO

func updateBlendPositions(input_vector):
	animationTree.set("parameters/Idle/blend_position", input_vector)
	animationTree.set("parameters/Run/blend_position", input_vector)
	animationTree.set("parameters/Attack/blend_position", input_vector)		
	animationTree.set("parameters/Roll/blend_position", input_vector)		
		
func getInputVector():
	var vector = Vector2.ZERO
	vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	vector = vector.normalized()
	return vector

func _on_Hurtbox_area_entered(area):
	flashSprite()
	stats.health -= area.damage

#Flash the sprite
func flashSprite():
	playerSprite.modulate = Color(10,10,10,10)
	hurtTimer.set_wait_time(0.15)
	hurtTimer.start()

func _on_HurtTimer_timeout():
	playerSprite.modulate = Color(1,1,1,1)	
	hurtTimer.stop()

func _on_Stats_no_health():
	print('ouch')
	queue_free()


func _on_Stats_level_up(playerStats):
	swordHitbox.damage += playerStats.strength
