extends Node

onready var player = $RoomController/Player
onready var uiController = $UIController

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

func set_paused(value: bool):
	paused = value
	scene_tree.paused = value
