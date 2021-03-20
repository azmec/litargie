extends Control

# We're not using Godot's containers because those seem to only 
# cause problems for me. 

signal game_started 

onready var HORIZONTAL_CONSTANT: = get_viewport_rect().size.x * .6

onready var playGameButton: = $PlayGame
onready var settingsButton: = $Settings
 
onready var tween: = $MoveTween 

func _ready() -> void:
	playGameButton.connect("pressed", self, "_on_playGameButton_pressed")

	playGameButton.rect_position.x = HORIZONTAL_CONSTANT

func _on_playGameButton_pressed() -> void: 
	emit_signal("game_started")

	_move_offscreen(playGameButton)
	_move_offscreen(settingsButton, 0.05)

# Move the given Control to the minimum position 
# offscreen *to the right*.
func _move_offscreen(rect: Control, delay: float = 0.0) -> void: 
	var _current_position = rect.rect_position 
	var _new_position = Vector2(
		get_viewport_rect().size.x,
		_current_position.y
	)

	tween.interpolate_property(rect, "rect_position", _current_position, _new_position, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT, delay)
	tween.start()

func _move_inscreen(rect: Control, delay: float = 0.0) -> void: 
	var _current_position = rect.rect_position 
	var _new_position = Vector2(HORIZONTAL_CONSTANT, _current_position.y) 

	tween.interpolate_property(rect, "rect_position", _current_position, _new_position, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT, delay)
	tween.start()
