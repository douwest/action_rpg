extends Control

onready var tween = $Tween

func _ready():
	set_modulate(Color.transparent)

func feather_in():
	tween.interpolate_property(
		self,
		'modulate',
		get_modulate(),
		Color.white,
		3,
		tween.TRANS_LINEAR,
		tween.EASE_IN_OUT
	)
	tween.start()
	
