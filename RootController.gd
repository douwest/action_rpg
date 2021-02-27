extends Node

onready var player = $Player
onready var uiController = $UIController

func _ready():
	uiController.init(player.stats)
	player.stats.connect('health_changed', self, 'delegate_to_controller')
	player.stats.connect('experience_changed', self, 'delegate_to_controller')
	player.stats.connect('level_up', self, 'delegate_to_controller')
	
func delegate_to_controller():
	print(str(player.stats.health))
	print(str(player.stats.current_level))
	print(str(player.stats.current_experience))
	uiController.update(player.stats)

func _on_RoomController_experience_dropped(experience: int):
	player.stats.increaseExperienceBy(experience)
	delegate_to_controller()
