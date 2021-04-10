extends Control

# We're not using Godot's containers because those seem to only 
# cause problems for me. 

signal game_started 

# The array we passed is structured like this:
# res: = [
#	main_menu: bool,
#	settings: bool
# ]
# Should settings be false, we either moved the main_menu inscreen or everything offscreen. 
signal finished_transition(array)

onready var HORIZONTAL_CONSTANT: = get_viewport_rect().size.x * .6

onready var playGameButton: = $PlayGame
onready var settingsButton: = $Settings
onready var main_buttons: = [playGameButton, settingsButton]

onready var languageOptions: = $Language
onready var backButton: = $Back
onready var settings_buttons: = [languageOptions, backButton]
 
onready var tween: = $MoveTween 

onready var hoverSFX: = $HoverSFX 
onready var selectSFX: = $SelectSFX


func _ready() -> void:
	tween.connect("tween_all_completed", self, "_on_tween_all_completed") 

	playGameButton.connect("pressed", self, "_on_playGameButton_pressed")
	settingsButton.connect("pressed", self, "_on_settingsButton_pressed")

	languageOptions.connect("item_selected", self, "_on_languageOptions_item_selected")
	backButton.connect("pressed", self, "_on_backButton_pressed") 

	for button in main_buttons:
		button.connect("mouse_entered", self, "_on_button_mouse_entered")
	for button in settings_buttons:
		button.connect("mouse_entered", self, "_on_button_mouse_entered")
	
	languageOptions.add_item("LAN_EN")
	languageOptions.add_item("LAN_ES")

	playGameButton.rect_position.x = HORIZONTAL_CONSTANT

func _move_button_set_offscreen(button_set: Array) -> void:
	var _delay: = 0.0
	for button in button_set: 
		_move_offscreen(button, _delay)
		_delay += 0.05 

func _move_button_set_inscreen(button_set: Array) -> void:
	var _delay = 0.0
	for button in button_set:
		_move_inscreen(button, _delay)
		_delay += 0.05 
	
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

func _on_tween_all_completed() -> void:
	var showing_menu: bool = main_buttons[0].rect_position.x == HORIZONTAL_CONSTANT
	var showing_settings: bool = settings_buttons[0].rect_position.x == HORIZONTAL_CONSTANT
	emit_signal("finished_transition", [showing_menu, showing_settings])

func _on_playGameButton_pressed() -> void: 
	selectSFX.play()
	emit_signal("game_started")

	_move_button_set_offscreen(main_buttons)

func _on_settingsButton_pressed() -> void:
	selectSFX.play()

	_move_button_set_offscreen(main_buttons)
	_move_button_set_inscreen(settings_buttons)

func _on_languageOptions_item_selected(index: int) -> void:
	selectSFX.play()

	if index == 0:
		TranslationServer.set_locale("en")
	elif index == 1:
		TranslationServer.set_locale("es")

func _on_backButton_pressed() -> void:
	selectSFX.play()

	_move_button_set_offscreen(settings_buttons)
	_move_button_set_inscreen(main_buttons)

func _on_button_mouse_entered() -> void:
	hoverSFX.play()
