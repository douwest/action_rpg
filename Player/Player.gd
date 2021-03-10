extends KinematicBody2D

enum {
	MOVE,
	ROLL,
	ATTACK,
	CHARGE,
	CHARGE_ATTACK
}

const ACCELERATION = 400
const FRICTION = 600
const MAX_SPEED = 115
const ROLL_SPEED = 1.25 * MAX_SPEED
const ATTACK_MOVE_DISTANCE = 12
const ATTACK_RANGE = 22

var state = MOVE setget set_state
var velocity = Vector2.ZERO
var direction_vector = Vector2.DOWN #instantiate to player direction
var ticks_start = 0
var ticks_elapsed_since_attack_start = 0
var combo_counter: int = 0

export var charge_time: int = 600
export var charge_delay: int = 150

onready var camera = $ZoomingCamera2D
onready var hurtTimer = $HurtTimer
onready var playerSprite = $PlayerSprite
onready var animationTree = $AnimationTree
onready var swordHitbox = $BodyPivot/SwordHitbox
onready var pivot = $BodyPivot
onready var stats = $Stats
onready var hurtBoxCollisionShape = $Hurtbox/CollisionShape2D
onready var tween = $ZoomingCamera2D/Tween
onready var raycast = $RayCast2D

onready var animationState = animationTree.get("parameters/playback")

var simplex_noise = OpenSimplexNoise.new()

func _ready():
	animationTree.set("parameters/Idle/blend_position", direction_vector)
	animationTree.active = true
	setAnimationTo("Idle")
	swordHitbox.knockback_vector = direction_vector
	swordHitbox.damage = max(1, stats.strength)
	swordHitbox.disable()

func _physics_process(delta):
	process_attack_inputs()	
	match state:
		MOVE: move_state(delta)
		ROLL: roll_state(delta)
		ATTACK: attack_state(delta)
		CHARGE: charge_state(delta)
		CHARGE_ATTACK: charge_attack_state(delta)

func move_state(delta):
	var gaze_vector = self.global_position.direction_to(get_global_mouse_position()).normalized()
	pivot.set_rotation_degrees(rad2deg(Vector2.ZERO.angle_to_point(gaze_vector) + PI))
	raycast.set_cast_to(gaze_vector)
	var input_vector = getInputVector()
	
	if input_vector != Vector2.ZERO:
		updateBlendPositions(input_vector)	
		setAnimationTo("Run")
		direction_vector = input_vector
		moveToward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		updateBlendPositions(gaze_vector)		
		setAnimationTo("Idle")		
		direction_vector = gaze_vector.normalized()		
		moveToward(Vector2.ZERO, FRICTION * delta)
	
	if Input.is_action_just_pressed("ui_attack"):
		self.position += direction_vector.normalized() * ATTACK_MOVE_DISTANCE
		set_state(ATTACK)
	elif Input.is_action_just_pressed("ui_roll"):
		set_state(ROLL)
		
	camera.moveCamera(input_vector, delta)
	moveAndSlide()

func attack_state(_delta):
	ticks_elapsed_since_attack_start = 0
	resetVelocity()	
	if Input.is_action_just_pressed("ui_roll"):
		set_state(ROLL)

	if combo_counter % 2 == 0:
		setAnimationTo("Attack")
	else:
		setAnimationTo("Attack2")
		
func charge_state(_delta: float):
	if ticks_elapsed_since_attack_start > charge_time:
		flashSprite()
		charge_end()
	else:
		var alpha = get_random_simplex_value_1d()	
		playerSprite.modulate = Color(0.987, alpha, 0.761, alpha)
		setAnimationTo("Charge")

func charge_attack_state(_delta: float):
	ticks_elapsed_since_attack_start = 0
	resetVelocity()	
	setAnimationTo("ChargeAttackRight")

func roll_state(_delta):
	velocity = direction_vector * ROLL_SPEED
	hurtBoxCollisionShape.disabled = true
	swordHitbox.disable()
	moveAndSlide()
	setAnimationTo("Roll")

func attack_end():
	swordHitbox.damage = max(1, stats.strength)	
	set_state(MOVE)
	
func roll_end():
	hurtBoxCollisionShape.disabled = false
	set_state(MOVE)

func charge_end():
	swordHitbox.damage = max(1, 2 * stats.strength)
	set_state(CHARGE_ATTACK)

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

func flashSprite():
	playerSprite.modulate = Color(10,10,10,10)
	hurtTimer.set_wait_time(0.15)
	hurtTimer.start()

func update_attack_ticks_start():
	if state != ATTACK and state != CHARGE and state != CHARGE_ATTACK:
		ticks_start = OS.get_ticks_msec()

func updateBlendPositions(input_vector):
	animationTree.set("parameters/Idle/blend_position", input_vector)
	animationTree.set("parameters/Run/blend_position", input_vector)
	animationTree.set("parameters/Attack/blend_position", input_vector)		
	animationTree.set("parameters/Attack2/blend_position", input_vector)		
	animationTree.set("parameters/Roll/blend_position", input_vector)		

func getInputVector():
	var vector = Vector2.ZERO
	vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	vector = vector.normalized()
	return vector

func process_attack_inputs():
	update_attack_ticks_start()
	if Input.is_action_pressed("ui_attack"):
		ticks_elapsed_since_attack_start = OS.get_ticks_msec() - ticks_start	
	if ticks_elapsed_since_attack_start > charge_delay:
		set_state(CHARGE)
	if Input.is_action_just_released("ui_attack"):
		playerSprite.modulate = Color(1, 1, 1, 1)
		ticks_elapsed_since_attack_start = OS.get_ticks_msec() - ticks_start
		if ticks_elapsed_since_attack_start > charge_time:
			swordHitbox.knockback_vector = direction_vector	* 2		
			set_state(CHARGE_ATTACK)
		else:
			swordHitbox.knockback_vector = direction_vector
			combo_counter += 1
			set_state(ATTACK)

func get_random_simplex_value_1d() -> float:
	randomize()
	var value = randi() % 1000000
	simplex_noise.period = 16
	return ((simplex_noise.get_noise_1d(value) + 1)/ 2.0) + 0.5

### SIGNALS
func _on_Hurtbox_area_entered(area):
	flashSprite()
	stats.health -= area.damage

func _on_HurtTimer_timeout():
	playerSprite.modulate = Color(1,1,1,1)	
	hurtTimer.stop()

func _on_Stats_no_health():
	print('You should have died!')
	queue_free()

func _on_Stats_level_up():
	swordHitbox.damage += self.stats.strength
