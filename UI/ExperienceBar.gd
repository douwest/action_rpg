extends Control

onready var experience_bar_progress = $ExperienceBarProgress
onready var current_experience_progress = $CurrentExperienceProgress

func set_experience_level(value):
	current_experience_progress.text = str(value) + "/" + str(PlayerStats.experience_needed)
	var current_level_experience = PlayerStats.current_experience - PlayerStats.current_level_start_experience
	print(str(current_level_experience) + "-----" + str(PlayerStats.current_level_start_experience))
	var factor = float(current_level_experience) / PlayerStats.current_level_experience_needed
	print(factor)
	experience_bar_progress.width = int(300 * factor)
	

func _ready():
	set_experience_level(PlayerStats.current_experience)
	PlayerStats.connect("experience_changed", self, "set_experience_level")
