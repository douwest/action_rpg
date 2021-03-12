extends Node2D


export var emitting = false

onready var rain_emitter = $RainEmitter

# Called when the node enters the scene tree for the first time.
func _ready():
	self.rain_emitter.set_emitting(emitting)

func set_emitting(value) -> void:
	self.rain_emitter.set_emitting(value)

func set_extents(extents: Vector2):
	self.rain_emitter.get_process_material().get_emission_shape().set_extents(extents)
