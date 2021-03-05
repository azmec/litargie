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

var _is_active: = false 
var _is_waiting_for_choice: = false

var _message_stack: = []
var _working_sequence: = {}
var _current_dialogue_instance: Dialogue

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

func _show_dialogue(_message_list: Array) -> void:
	if _is_active:
		return
	_is_active = true

	for message in _message_list:
		var _text: = sequenceParser.get_root_text(message)
		var _branches: = sequenceParser.get_branches(message) 
		var _conditions: = sequenceParser.get_conditions(_branches)

		print('Message: "' + _text + '"')
		print('Conditions: ' + str(_conditions))

func _show_current() -> void:
	pass

func _is_above_character_limit(message: String) -> bool:
	return message.length() > CHARACTER_LIMIT

func _advance_dialogue():
	pass

func _hide() -> void:
	_current_dialogue_instance.disconnect("message_completed", self, "_on_message_completed")
	_current_dialogue_instance.queue_free() 
	_current_dialogue_instance = null
	_is_active = false
	emit_signal("finished") 

func _on_message_completed() -> void:
	pass 

	emit_signal("message_completed") 
	
func _on_condition_choosen(condition: String, text: String, branch: Dictionary) -> void: 
	pass
