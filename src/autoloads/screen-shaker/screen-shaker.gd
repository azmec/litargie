# There has to be a better way to do this but we're making
# screenshake something any node can access and start for 
# ease of use. 

extends Node

var TRANS: = Tween.TRANS_SINE
var EASE: = Tween.EASE_IN_OUT

var enabled: = false

var amplitude: float = 0
var duration: float = 0.8 setget _set_duration
var damp_easing: float = 1.0
var shaking: bool = false setget _set_shaking

var _current_camera: Camera2D = null

onready var timer: Timer = $Timer 

func _ready() -> void:
	timer.connect("timeout", self, "_on_timer_timeout") 

func _process(_delta: float) -> void:
	var damping: = ease(timer.time_left / timer.wait_time, damp_easing) 
	_current_camera.offset = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping
	)

func start(amp: float, dur: float, damp: float) -> void:
	if _current_camera == null: return
	
	self.amplitude = amp
	self.duration = dur
	self.damp_easing = damp

	self.shaking = true


func change_camera(new_camera: Camera2D) -> void:
	_current_camera = new_camera 

func _set_duration(value: float) -> void:
	duration = value
	timer.wait_time = duration

func _set_shaking(value: bool) -> void:
	shaking = value
	self.set_process(shaking)
	_current_camera.offset = Vector2.ZERO
	if shaking:
		timer.start() 

func _on_timer_timeout() -> void:
	self.shaking = false
