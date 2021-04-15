# Contains other control nodes that we want to "slide"
# and slides them on request.

extends Control

signal slide_started()
signal slide_completed()

const RIGHT_EDGE = 320
export (bool) var start_onscreen: bool = true
export (float) var resting_x_position = 0
export (float) var sliding_duration: = 0.5
export (float) var sliding_speed: = 0.05

var is_sliding: bool = false

var tween_trans: = Tween.TRANS_CUBIC
var tween_ease: = Tween.EASE_OUT

onready var tween: Tween = $Tween

# Container for nodes we want to slide on request.
onready var sliding: VBoxContainer = $Sliding
onready var sliders: Array = _get_sliding_children()

func _ready() -> void:
	tween.connect("tween_started", self, "_on_tween_started")
	tween.connect("tween_completed", self, "_on_tween_completed")

	if start_onscreen:
		_set_sliders_positions(resting_x_position)
	else:
		_set_sliders_positions(RIGHT_EDGE)
		
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

# Checks if the bottom-most slider is off the screen.
func is_onscreen() -> bool:
	return sliders[-1].rect_position.x == RIGHT_EDGE

# We assume whatever nodes we add under "Sliders" contains
# additional, *useful* nodes too; we also assume that the 
# container node exacts its own behavior, so we're really 
# only looking to slide its children.
func _get_sliding_children() -> Array:
	var res: = []
	for container in sliding.get_children():
		for node in container.get_children():
			res.append(node)
	
	return res

# Tweens the positions of the node to the right.
func _slide(node: Control, offscreen: bool, delay: float) -> void:
	var current_position: = node.rect_position

	var new_position: = Vector2(0, node.rect_position.y)
	if offscreen:
		new_position.x = RIGHT_EDGE
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

# Rapidly tweens the positions of the sliders to give the
# illusion of instantly being put wherever.
func _set_sliders_positions(x_position: float) -> void:
	for node in sliders:
		tween.interpolate_property(
			node,
			"rect_position:x",
			node.rect_position.x,
			x_position,
			0.1,
			tween_trans,
			tween_ease
		)
	tween.start()

func _on_tween_completed(node: Control, _key: NodePath):
	if node.rect_position.x == RIGHT_EDGE:
		self.visible = false
	
	is_sliding = false

func _on_tween_started(node: Control, _key: NodePath):
	if node.rect_position.x == RIGHT_EDGE:
		self.visible = true