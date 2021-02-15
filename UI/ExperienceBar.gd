extends Control

onready var experience_bar_progress = $ExperienceBarProgress
onready var current_experience_progress = $CurrentExperienceProgress

func set_experience_level(value):
	current_experience_progress.text = str(value) + "/" + str(PlayerStats.experience_needed)
	var current_level_experience = PlayerStats.experience_needed - PlayerStats.current_experience
	var factor = current_level_experience / PlayerStats.current_level_experience_needed
	experience_bar_progress.width = int(300 * factor)
	

func _ready():
	set_experience_level(PlayerStats.current_experience)
	PlayerStats.connect("experience_changed", self, "set_experience_level")
