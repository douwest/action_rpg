extends Label

func _ready():
	PlayerStats.connect("no_health", self, "show")
	
func show():
	self.visible = true
	
