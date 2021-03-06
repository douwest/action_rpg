extends TextureProgress

export var flash_alpha = 0.75
export var flash_strength = 2.0
export var flash_duration: float = 0.25

onready var timer: Timer = $FlashTimer
var old_value = -1

func _on_FlashTimer_timeout():
	self.set_tint_progress(Color(1, 1, 1, 1))
	timer.stop()

func _on_HPBarRect_value_changed(value):
	if value < old_value:
		self.set_tint_progress(Color(
			flash_strength, 
			flash_strength, 
			flash_strength, 
			flash_alpha
			)
		)
		timer.start(flash_duration)
	old_value = value
