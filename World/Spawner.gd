extends Node2D

export var max_spawn_distance = 50
export var respawn_time = 2

onready var BatResource = preload("res://Enemies/Bat.tscn")
onready var timer = $Timer

func _ready():
	timer.wait_time = respawn_time
	spawn_bat()

func _on_Timer_timeout():
	spawn_bat()
		
func spawn_bat() -> void:
	timer.stop()
	var bat = BatResource.instance()
	bat.spawn_position = Vector2(randf() * max_spawn_distance, randf() * max_spawn_distance)
	bat.global_position = bat.spawn_position - Vector2(randf() * max_spawn_distance / 2, randf() * max_spawn_distance / 2)
	bat.connect("died", timer, "start")
	get_node('YSort').add_child(bat)
