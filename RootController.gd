extends Node

onready var player = $Player
onready var uiController = $UIController
onready var camera = $Player/ZoomingCamera2D

onready var scene_tree = get_tree()
var paused = false setget set_paused

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS #keeps input handling active when paused
	uiController.init(player.stats)
	player.stats.connect('health_changed', self, 'delegate_to_controller')
	player.stats.connect('experience_changed', self, 'delegate_to_controller')
	player.stats.connect('level_up', self, 'delegate_to_controller')

func delegate_to_controller():
	uiController.update(player.stats)

func _on_RoomController_experience_dropped(experience: int):
	player.stats.increaseExperienceBy(experience)
	delegate_to_controller()

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		self.paused = not paused
		uiController.play_pause_sound()
		scene_tree.set_input_as_handled()

func _physics_process(delta):
	self.moveCamera(player.getInputVector(), delta)

func set_paused(value: bool):
	paused = value
	scene_tree.paused = value

func _on_Player_died():
	uiController.show_death_screen()

func moveCamera(input_vector: Vector2, delta):
	camera.moveCamera(input_vector, delta)
