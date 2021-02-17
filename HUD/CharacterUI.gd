extends Control

const HEALTHBAR_SIZE = 100
const XP_GROWTH = 0.4

var health = 4 setget set_health
var max_health = 4 setget set_max_health
var current_level = 1 setget set_current_level
var current_experience = 0 setget set_current_experience
var end_experience = 0
var start_experience = 0

onready var hpBar = $HPBarRect
onready var xpBar = $XPBarRect

signal current_level_changed
signal current_experience_changed

func set_health(value):
	health = clamp(value, 0, max_health)
	if hpBar != null:
		hpBar.set_value(get_health_percentage())
		
func set_max_health(value):
	max_health = max(1, value)

func set_current_level(value: int):
	current_level = max(1, value)

func set_current_experience(value: int):
	current_experience = max(0, value)
	current_level = int(XP_GROWTH * sqrt(current_experience))
	start_experience = pow(float(current_level) / XP_GROWTH, 2.0)
	end_experience = pow(float(current_level + 1) / XP_GROWTH, 2.0)
	if xpBar != null:
		xpBar.set_value(get_xp_percentage())
	logForTesting()

func _ready():
	self.max_health = PlayerStats.max_health
	self.health = PlayerStats.health
	self.current_experience = PlayerStats.total_experience
	self.current_level = PlayerStats.current_level	
	hpBar.set_value(get_health_percentage())
	xpBar.set_value(get_xp_percentage())
	PlayerStats.connect("health_changed", self, "set_health")
	PlayerStats.connect("experience_changed", self, "set_current_experience")

func get_health_percentage() -> float: 
	return (self.health / float(self.max_health)) * 100.0
	
func get_xp_percentage() -> float: 
	# divide the experience we gained this level, by the experience it took to move from this level to the next.
	return ((self.current_experience - self.start_experience) / float(self.end_experience - self.start_experience)) * 100.0
	
func logForTesting() -> void: 
	print("current_xp: " + str(current_experience))	
	print("current_level: " + str(current_level))
	print("xp to next lv: " + str(end_experience - current_experience))
