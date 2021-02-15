extends Node

export(int) var max_health = 1
export(int) var current_level = 1
export(int) var current_experience = 0 setget set_experience
export(int) var current_level_start_experience = 0
export(int) var experience_needed = 10

export(int) var current_level_experience_needed = experience_needed - current_level_start_experience

onready var health = max_health setget set_health

signal no_health
signal health_changed(value)

signal level_up(value)
signal experience_changed(value)

func set_health(value):
	health = value
	emit_signal("health_changed", value)
	if(health <= 0):
		emit_signal("no_health")

func set_experience(value):
	current_experience = value
	emit_signal("experience_changed", value)
	if(current_experience >= experience_needed):
		current_level += 1
		current_level_start_experience = experience_needed
		experience_needed += experience_needed * current_level
		emit_signal("level_up", current_level)

func increaseExperienceBy(amount):
	set_experience(current_experience + amount)

func reduceHealthBy(amount):
	set_health(health - amount)

func increaseHealthBy(amount):
	set_health(health + amount)
