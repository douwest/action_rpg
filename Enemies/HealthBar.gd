extends Line2D

onready var stats = $BatStats
onready var timer = $HealthBarVisibilityTimer
var startLength = 10.0 #px
var lineLength = startLength
var pixelsPerDamageUnit

func _ready():
	visible = false
	pixelsPerDamageUnit = startLength / stats.max_health
	timer.set_wait_time(2.0)

func _on_Timer_timeout():
	visible = false

func _on_Stats_health_changed(value):
	visible = true
	lineLength = startLength - (pixelsPerDamageUnit * (stats.max_health - stats.health))
	timer.start()
	set_point_position(1, Vector2(lineLength, 0)) #update length of health bar
