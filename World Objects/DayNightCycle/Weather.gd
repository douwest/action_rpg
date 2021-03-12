extends Node2D

const day_color = Color(1, 1, 1, 1)
const night_color = Color(0.35, 0.24, 0.21, 1)
const day_night_cycle_duration = 5

onready var light = $Lighting
onready var light_tween = $Lighting/Tween
onready var rainbox = $RainBox

var is_night = false

func _ready():
	animate_weather_day()

func animate_weather_day() -> void:
	is_night = false
	light_tween.interpolate_property(
		light,
		'color',
		day_color,
		night_color,
		day_night_cycle_duration * 0.65,
		Tween.TRANS_QUAD, 
		Tween.EASE_IN_OUT
		)
	light_tween.start()
	
func animate_weather_night() -> void:
	is_night = true
	light_tween.interpolate_property(
		light,
		'color',
		night_color,
		day_color,
		day_night_cycle_duration * 0.35,
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN_OUT
		)
	light_tween.start()

func _on_Tween_tween_all_completed() -> void:
	print('completed!')
	if is_night:
		animate_weather_day()
	else:
		animate_weather_night()

func set_raining(is_raining: bool) -> void:
	rainbox.set_emitting(is_raining)
