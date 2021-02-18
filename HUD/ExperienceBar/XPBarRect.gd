extends TextureProgress

export var flash_alpha: float = 0.75
export var flash_strength: float = 2.0
export var flash_duration: float = 0.25

onready var timer: Timer = $FlashTimer

func _on_XPBarRect_value_changed(value):
	self.set_tint_progress(Color(
		flash_strength, 
		flash_strength, 
		flash_strength, 
		flash_alpha
		)
	)
	timer.start(flash_duration)

func _on_FlashTimer_timeout():
	self.set_tint_progress(Color(1, 1, 1, 1))
	timer.stop()
