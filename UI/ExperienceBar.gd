extends Control

onready var experience_bar_progress = $ExperienceBarProgress
onready var current_experience_progress = $CurrentExperienceProgress

func set_experience_level(value):
	current_experience_progress.text = str(value - PlayerStats.current_level_start_experience) + "/" + str(PlayerStats.experience_needed - PlayerStats.current_level_start_experience)
	var factor = float(PlayerStats.total_experience - PlayerStats.current_level_start_experience) / (PlayerStats.experience_needed - PlayerStats.current_level_start_experience)
	experience_bar_progress.width = int(300 * factor)
	

func _ready():
	set_experience_level(PlayerStats.total_experience)
	PlayerStats.connect("experience_changed", self, "set_experience_level")
