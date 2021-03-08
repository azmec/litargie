# This node coordinates one or more messages to send to the Dialogue node. 
# It detects user input, allowing us to move to the "next" message on the array. 
# Additionally, it can add or remove dialogue from the tree. 

class_name DialogueManager
extends Node

signal message_requested()
signal message_completed()

signal finished() 

const DIALOGUE_SCENE: = preload("res://src/user-interface/dialogue/dialogue.tscn")
const DIALOGUE_BUTTON_SCENCE: = preload("res://src/user-interface/dialogue-button/dialogue-button.tscn")

const NORMAL_POSITION: = Vector2(56, 128)
const DEVIANT_POSTIION: = Vector2(16, 128)

const CHARACTER_LIMIT: = 140

var show_panel: bool = true setget _set_show_panel
var show_name: bool = true setget _set_show_name

var _dialogue_container: Control
var _button_container: Control

var _is_active: bool = false 
var _is_waiting_for_choice: bool = false

var _message_stack: Array = []
var _working_sequence: Dictionary = {}

var _current_dialogue_instance: Dialogue
var _active_dialogue_offset: int = 0

onready var sequenceParser: SequenceParser = $SequenceParser
onready var moveTween: Tween = $MoveTween

func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and _is_active and _current_dialogue_instance.message_is_fully_visible() and !_is_waiting_for_choice:
		_advance_dialogue()

# Sets the container that the dialogue_instance will be added to. Necessary for the
# dialogue system to work properly.
func set_dialogue_container(dContainer: Control, bContainer: Control) -> void: 
	_dialogue_container = dContainer
	_button_container = bContainer

# Translates the given JSON into a Dictionary, breaks it into roots, and queues
# them to the message stack. 
func queue_sequence_to_message_stack(json_path: String) -> void:
	_working_sequence = sequenceParser.load_dialogue(json_path)
	var _stack: Array = sequenceParser.split_sequence(_working_sequence)
	for root in _stack:
		_queue_root_to_message_stack(root)

	_show_dialogue(_message_stack)

# Queues the given root to the message stack.
func _queue_root_to_message_stack(root: Dictionary) -> void:
	var _message: = sequenceParser.get_root_text(root)
	if _is_above_character_limit(_message):
		print_debug('Message: "' + _message + '" is above the character limit!') 
		return
	
	_message_stack.push_back(root)

# Start the dialogue process and spawn the dialogue instance. 
func _show_dialogue(_message_list: Array) -> void:
	if _is_active:
		return
	_is_active = true

	_active_dialogue_offset = 0

	var _dialogue: = DIALOGUE_SCENE.instance()
	_dialogue.connect("message_completed", self, "_on_message_completed")
	_dialogue_container.add_child(_dialogue)

	_current_dialogue_instance = _dialogue

	_show_current()

# Iterate along the message_stack and display the text and applicable choices.
func _show_current() -> void:
	emit_signal("message_requested")

	var _current_trunk: Dictionary = _message_stack[_active_dialogue_offset]

	if sequenceParser.root_is_deviant(_current_trunk):
		_move_dialogue_instance(DEVIANT_POSTIION)
	else:
		_move_dialogue_instance(NORMAL_POSITION)
	
	var _message: = sequenceParser.get_root_text(_current_trunk)
	_current_dialogue_instance.update_text(_message)
	_current_dialogue_instance.set_name(_current_trunk.character)

# Loops through the branches of the current root and
# spawns the correlated amount of buttons with the
# appropiate "conditions."
func _show_dialogue_options(branches: Dictionary) -> void:
	_clear_button_container() 

	var _branches: Array = sequenceParser.split_sequence(branches)
	for branch in _branches:
		var _button: = DIALOGUE_BUTTON_SCENCE.instance()
		_button.initialize(branch)
		_button.connect("condition_choosen", self, "_on_condition_choosen")

		_button_container.add_child(_button)

# Iterates the dialogues stack and shows the next piece of
# dialogue.
func _advance_dialogue():
	if _active_dialogue_offset < _message_stack.size() - 1:
		_active_dialogue_offset += 1
		_show_current()
	else:
		_hide()

# Loops through and deletes all children in the current
# button container.
func _clear_button_container() -> void:
	var _buttons: = _button_container.get_children()
	for button in _buttons:
		button.disconnect("condition_choosen", self, "_on_condition_choosen")
		button.queue_free()

# Returns if the given message is above the character limit.
# Note, this is meant to be *after* filtering any BBCode or
# custom tags.
func _is_above_character_limit(message: String) -> bool:
	return message.length() > CHARACTER_LIMIT

# Tweens the position of the current dialogue instance from 
# its current position to the given position.
func _move_dialogue_instance(position: Vector2) -> void:
	if _current_dialogue_instance == null:
		return

	moveTween.interpolate_property(_current_dialogue_instance,
									"rect_position",
									_current_dialogue_instance.rect_position,
									position,
									0.5, Tween.TRANS_QUART, Tween.EASE_OUT)
	moveTween.start()
									


# Hides the current dialogue instance and resets private
# properties for the next sequence.
func _hide() -> void:
	_current_dialogue_instance.disconnect("message_completed", self, "_on_message_completed")
	_current_dialogue_instance.queue_free() 
	_current_dialogue_instance = null

	_clear_button_container()

	_is_active = false

	emit_signal("finished") 

# =========================================================
# SETTERS
# =========================================================
func _set_show_panel(value: bool) -> void:

	show_panel = value

func _set_show_name(value: bool) -> void:
	show_name = value

# =========================================================
# SIGNALS
# =========================================================

func _on_message_completed() -> void:
	var _current_trunk: Dictionary = _message_stack[_active_dialogue_offset]

	if sequenceParser.root_is_deviant(_current_trunk):
		_is_waiting_for_choice = true
	
		var _branches: = sequenceParser.get_branches(_current_trunk)
		_show_dialogue_options(_branches)

	emit_signal("message_completed") 
	
func _on_condition_choosen(branch: Dictionary) -> void: 
	_is_waiting_for_choice = false
	
	var _message: = sequenceParser.get_root_text(branch)
	if _is_above_character_limit(_message):
		print_debug('Message: "' + _message + '" is above the character limit!') 
		return
	
	_clear_button_container() 

	_message_stack.insert(_active_dialogue_offset + 1, branch)
	_advance_dialogue()
