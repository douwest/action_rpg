extends Control

export var portraitFrameIndex: int = 0

onready var hpBar = $HPBarRect
onready var xpBar = $XPBarRect
onready var lvlLabel = $LevelLabel
onready var playerPortrait = $PortraitRect/PortraitSprites

func _ready():
	self.playerPortrait.frame = portraitFrameIndex
	#set_lvl_label(1)

func set_lvl_label(level: int):
	lvlLabel.set_text(str(level))
