# Contains other control nodes that we want to "slide"
# and slides them on request.

extends Control

signal slide_started()
signal slide_completed()

export (float) var resting_x_position = get_viewport_rect().size.x * .6
export (float) var sliding_duration: = 0.5
export (float) var sliding_speed: = 0.5 

var is_sliding: bool = false
var is_onscreen: bool = false

var tween_trans: = Tween.TRANS_CUBIC
var tween_ease: = Tween.EASE_OUT

onready var tween: Tween = $Tween

# Container for nodes we want to slide on request.
onready var sliding: Control = $Sliding
onready var sliders: Array = sliding.get_children()

func _ready() -> void:
	tween.connect("tween_all_completed", self, "_on_tween_all_completed") 

func slide_onscreen() -> void:
	if is_sliding: return
	is_sliding = true

func slide_offscreen() -> void:
	if is_sliding: return
	is_sliding = true

func _slide_node(node: Control, offscreen: bool, delay: float) -> void:
	var current_position: = node.rect_position

	var new_position: Vector2
	if offscreen:
		new_position = Vector2(
			get_viewport_rect().size.x, 
			node.rect_position.y		
		)
	else:
		new_position = Vector2(
			resting_x_position,
			node.rect_position.y
		)

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

func _on_tween_all_completed() -> void:
	is_sliding = false
	emit_signal("slide_completed")