extends Control

export var portraitFrameIndex: int = 0

onready var hpBar = $HPBarRect
onready var xpBar = $XPBarRect
onready var lvlLabel = $LevelLabel
onready var playerPortrait = $PortraitRect/PortraitSprites

signal current_level_changed
signal current_experience_changed

func _ready():
	pass
	#self.playerPortrait.frame = portraitFrameIndex
	#lvlLabel.set_text(str(stats.current_level))	
	#update_hp_bar()
	#update_xp_bar()
	#PlayerStats.connect("health_changed", self, "update_hp_bar")
	#PlayerStats.connect("experience_changed", self, "update_xp_bar")
	#PlayerStats.connect("level_up", self, "update_level")

func update_hp_bar():
	pass#hpBar.set_value(PlayerStats.get_health_percentage())

func update_xp_bar():
	pass#xpBar.set_value(PlayerStats.get_xp_percentage())

func update_level():
	pass#lvlLabel.set_text(str(PlayerStats.get_current_level()))
