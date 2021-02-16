extends Label

onready var level = 1

func set_level():
	level = PlayerStats.current_level
	self.set_text(str(level))

func _ready():
	set_level()
	PlayerStats.connect("level_up", self, "set_level")
