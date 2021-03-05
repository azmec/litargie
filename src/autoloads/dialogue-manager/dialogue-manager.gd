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

const CHARACTER_LIMIT: = 140

var _dialogue_container: Control
var _button_container: Control

var _is_active: bool = false 
var _is_waiting_for_choice: bool = false

var _message_stack: Array = []
var _working_sequence: Dictionary = {}

var _current_dialogue_instance: Dialogue
var _active_dialogue_offset: int = 0

onready var sequenceParser: SequenceParser = $SequenceParser
onready var opacityTween: Tween = $OpacityTween

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
	var _message: = sequenceParser.get_root_text(_current_trunk)
	_current_dialogue_instance.update_text(_message)

func _show_dialogue_options(branches: Dictionary) -> void:
	_clear_button_container() 

	var _branches: Array = sequenceParser.split_sequence(branches)
	for branch in _branches:
		var _button: = DIALOGUE_BUTTON_SCENCE.instance()
		_button.initialize(branch)
		_button.connect("condition_choosen", self, "_on_condition_choosen")

		_button_container.add_child(_button)

func _clear_button_container() -> void:
	var _buttons: = _button_container.get_children()
	for button in _buttons:
		print(button.name)
		button.disconnect("condition_choosen", self, "_on_condition_choosen")
		button.queue_free()

func _is_above_character_limit(message: String) -> bool:
	return message.length() > CHARACTER_LIMIT

func _advance_dialogue():
	if _active_dialogue_offset < _message_stack.size() - 1:
		_active_dialogue_offset += 1
		_show_current()
	else:
		_hide()

func _hide() -> void:
	_current_dialogue_instance.disconnect("message_completed", self, "_on_message_completed")
	_current_dialogue_instance.queue_free() 
	_current_dialogue_instance = null

	_clear_button_container()

	_is_active = false

	emit_signal("finished") 

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