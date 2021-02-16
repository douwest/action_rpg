extends Node2D

onready var BatResource = preload("res://Enemies/Bat.tscn")
onready var timer = $Timer

func _on_Timer_timeout():
	var bat = BatResource.instance()
	get_node('YSort').add_child(bat)
	timer.start()
		
