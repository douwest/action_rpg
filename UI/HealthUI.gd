extends Control

const HEART_SIZE = 15#px

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * HEART_SIZE 
	
func set_max_hearts(value):
	max_hearts = max(1, value)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * HEART_SIZE

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
