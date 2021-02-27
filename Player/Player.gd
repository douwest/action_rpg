extends KinematicBody2D

enum {
	MOVE,
	ROLL,
	ATTACK
}

const ACCELERATION = 400
const FRICTION = 500
const MAX_SPEED = 500
const ROLL_SPEED = 125

var state = MOVE
var velocity = Vector2.ZERO
var direction_vector = Vector2.DOWN #instantiate to player direction

onready var camera = $ZoomingCamera2D
onready var hurtTimer = $HurtTimer
onready var playerSprite = $PlayerSprite
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var stats = $Stats

func _ready():
	setAnimationTo("Idle")
	animationTree.set("parameters/Idle/blend_position", direction_vector)
	animationTree.active = true
	swordHitbox.knockback_vector = direction_vector

func _physics_process(delta):
	match state:
		MOVE: move_state(delta)
		ROLL: roll_state(delta)
		ATTACK: attack_state(delta)

func move_state(delta):
	var input_vector = getInputVector()
	
	if input_vector != Vector2.ZERO:
		direction_vector = input_vector
		swordHitbox.knockback_vector = direction_vector
		updateBlendPositions(input_vector)	
		setAnimationTo("Run")
		moveToward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		setAnimationTo("Idle")		
		moveToward(Vector2.ZERO, FRICTION * delta)
		
	moveAndSlide()
	
	if Input.is_action_just_pressed("ui_attack"):
		setState(ATTACK)
		
	if Input.is_action_just_pressed("ui_roll"):
		setState(ROLL)
	
func attack_state(delta):
	resetVelocity()
	setAnimationTo("Attack")
	
func roll_state(delta):
	velocity = direction_vector * ROLL_SPEED
	moveAndSlide()
	setAnimationTo("Roll")
	
func attack_end():
	setState(MOVE)
	
func roll_end():
	setState(MOVE)

func moveAndSlide():
	velocity = move_and_slide(velocity)

func moveToward(to, speed):
	velocity = velocity.move_toward(to, speed)

func setAnimationTo(string):
	animationState.travel(string)
	
func setState(state):
	self.state = state

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
