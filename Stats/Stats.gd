extends Node

export(int) var base_health = 2
export(int) var current_level = 1
export(int) var max_health = base_health + current_level
export(int) var total_experience = 0 setget set_experience
export(int) var experience_needed = 10
export(int) var current_level_start_experience = 0

onready var health = max_health setget set_health

signal no_health
signal health_changed(value)

signal level_up
signal experience_changed(value)

func set_health(value):
	health = value
	emit_signal("health_changed", value)
	if(health <= 0):
		emit_signal("no_health")

func set_experience(value):
	total_experience = value
	if(total_experience >= experience_needed):
		current_level += 1
		current_level_start_experience = experience_needed
		experience_needed *= 3
		max_health = base_health + current_level
		emit_signal("level_up")
	emit_signal("experience_changed", value)

func increaseExperienceBy(amount):
	set_experience(total_experience + amount)

func reduceHealthBy(amount):
	set_health(health - amount)

func increaseHealthBy(amount):
	set_health(health + amount)
