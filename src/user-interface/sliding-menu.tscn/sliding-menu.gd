# Contains other control nodes that we want to "slide"
# and slides them on request.

extends Control

signal slide_started()
signal slide_completed()

export (float) var resting_x_position = get_viewport_rect().size.x * .6
export (float) var sliding_duration: = 0.5
export (float) var sliding_speed: = 0.5 

var is_sliding: bool = false

var tween_trans: = Tween.TRANS_CUBIC
var tween_ease: = Tween.EASE_OUT

onready var tween: Tween = $Tween

# Container for nodes we want to slide on request.
onready var sliding: Control = $Sliding
onready var sliders: Array = sliding.get_children()

func _ready() -> void:
	tween.connect("tween_all_completed", self, "_on_tween_all_completed") 

# You'll notice there's little difference between
# slide_(on/off)screen; I just need what I'm doing
# to be *explicit* in whatever nodes I call this in.

func slide_onscreen() -> void:
	if is_sliding: return
	is_sliding = true
	
	var delay: = 0.0
	for node in sliders:
		_slide(node, false, delay)
		delay += sliding_speed

	emit_signal("slide_started")

func slide_offscreen() -> void:
	if is_sliding: return
	is_sliding = true

	var delay: = 0.0
	for node in sliders:
		_slide(node, true, delay)
		delay += sliding_speed

	emit_signal("slide_started") 
	
func is_on_onscreen() -> bool:
	return sliders[0].rect_position.x == get_viewport_rect().size.x

func _slide(node: Control, offscreen: bool, delay: float) -> void:
	var current_position: = node.rect_position

	var new_position: = Vector2(0, node.rect_position.y)
	if offscreen:
		new_position.x = get_viewport_rect().size.x
	else:
		new_position.x = resting_x_position

	tween.interpolate_property(
		node,
		"rect_position", 
		current_position, 
		new_position,
		sliding_duration,
		tween_trans,
		tween_ease,
		delay
	)
	tween.start()

func _on_tween_all_completed() -> void:
	is_sliding = false
	emit_signal("slide_completed")