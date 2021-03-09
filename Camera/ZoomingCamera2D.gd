extends Camera2D
# Lower cap for the `_zoom_level`.
export var min_zoom := 0.5
# Upper cap for the `_zoom_level`.
export var max_zoom := 1.5
# Controls how much we increase or decrease the `_zoom_level` on every turn of the scroll wheel.
export var zoom_factor := 0.1
# Duration of the zoom's tween animation.
export var zoom_duration := 0.2

export var max_distance_from_player = 60

const CAMERA_MOVE_DURATION = 1.0
# The camera's target zoom level.
var _zoom_level := 2.0 setget _set_zoom_level

# We store a reference to the scene's tween node.
onready var tween: Tween = $Tween

func _set_zoom_level(value: float) -> void:
	# audioStream.volume_db = -7 * _zoom_level
	# We limit the value between `min_zoom` and `max_zoom`
	_zoom_level = clamp(value, min_zoom, max_zoom)
	# Then, we ask the tween node to animate the camera's `zoom` property from its current value
	# to the target zoom level.
	var _intpl = tween.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(_zoom_level, _zoom_level),
		zoom_duration,
		tween.TRANS_SINE,
		# Easing out means we start fast and slow down as we reach the target value.
		tween.EASE_OUT
	)
	var _start = tween.start()

func _unhandled_input(event):
	if event is InputEventMagnifyGesture:
		_set_zoom_level(_zoom_level * event.factor)
	if event.is_action_pressed("ui_zoom_in"):
		_set_zoom_level(_zoom_level - zoom_factor)
	if event.is_action_pressed("ui_zoom_out"):
		_set_zoom_level(_zoom_level + zoom_factor)
		
func moveCamera(input_vector: Vector2, _delta: float):
	var _intpl = tween.interpolate_property(
		self,
		"offset",
		self.offset,
		input_vector * max_distance_from_player,
		CAMERA_MOVE_DURATION,
		tween.EASE_IN,
		# Easing out means we start fast and slow down as we reach the target value.
		tween.EASE_OUT
	)
	var _start = tween.start()
