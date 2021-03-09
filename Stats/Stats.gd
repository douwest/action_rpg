extends Node

const XP_GROWTH = 0.4

export(int) var strength = 0
export(float) var health_regen = 0
export(int) var max_health = 5 setget set_max_health
export var current_level = 0 setget set_current_level
var health = 5 setget set_health

var current_experience = 0 setget set_current_experience
var end_experience = 0
var start_experience = 0

signal no_health
signal health_changed()

signal level_up()
signal experience_changed()

func _ready():
	strength = 1
	health = max_health

func _process(delta):
	increaseHealthBy(delta * health_regen)

func set_health(value):
	health = clamp(value, 0, max_health)
	emit_signal("health_changed")
	if(health <= 0):
		emit_signal("no_health")

func increaseExperienceBy(amount):
	set_current_experience(current_experience + amount)

func reduceHealthBy(amount):
	set_health(health - amount)

func increaseHealthBy(amount):
	set_health(health + amount)

func set_max_health(value):
	max_health = max(1, value)

func set_current_level(value: int):
	current_level = max(1, value)

func set_current_experience(value: int):
	emit_signal("experience_changed")
	current_experience = max(0, value)
	current_level = int(XP_GROWTH * sqrt(current_experience))
	start_experience = pow(float(current_level) / XP_GROWTH, 2.0)
	if(current_experience > end_experience):
		emit_signal("level_up")
		set_max_health(max_health + current_level * 2)
		set_health(max_health)
		strength += current_level
	end_experience = pow(float(current_level + 1) / XP_GROWTH, 2.0)

func get_health_percentage() -> float: 
	return (self.health / float(self.max_health)) * 100.0
	
func get_xp_percentage() -> float: 
	# divide the experience we gained this level, by the experience it takes to move from this level to the next.
	self.end_experience = pow(float(current_level + 1) / XP_GROWTH, 2.0)
	return ((self.current_experience - self.start_experience) / float(self.end_experience - self.start_experience)) * 100.0

func get_current_level() -> int:
	return self.current_level

