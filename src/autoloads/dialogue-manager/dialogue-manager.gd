# This node coordinates one or more messages to send to the Dialogue node. 
# It detects user input, allowing us to move to the "next" message on the array. 
# Additionally, it can add or remove dialogue from the tree. 

class_name DialogueManager
extends Node

signal message_requested()
signal message_completed()

signal finished() 

const TEST_SEQUENCE_PATH: = "res://assets/dialogues/test-sequence.json"
const DIALOGUE_SCENE: = preload("res://src/user-interface/dialogue/dialogue.tscn")
const CHARACTER_LIMIT: = 140

var _messages: = [] # contains only ROOT text
var _keys: = [] # keys to text 
var _active_dialogue_offset: = 0 # current step of a sequence
var _is_active: = false # if we are displaying messages
var _current_dialogue_instance: Dialogue # the current diplayed piece of dialogue
var _current_sequence: Dictionary 

onready var sequenceParser: SequenceParser = $SequenceParser
onready var opacityTween: Tween = $OpacityTween

func _ready() -> void:
	sequenceParser.connect("deviance_detected", self, "_on_sequenceParser_deviance_detected")

	yield(get_tree().create_timer(0.5), "timeout")

	var _test_dialogue: Dictionary = sequenceParser.load_dialogue(TEST_SEQUENCE_PATH)
	var _test_message_list: Array = sequenceParser.get_messages(_test_dialogue)

	_show_messages(_test_message_list, get_parent().get_node("DevWorld").dialogueSpot)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and _is_active and _current_dialogue_instance._message_is_fully_visible():
		if _active_dialogue_offset < _messages.size() - 1:
			_active_dialogue_offset += 1 
			_show_current()
		else: 
			_hide()
		
func _show_messages(_message_list: Array, parent: Control) -> void:
	if _is_active:
		return
	_is_active = true
	
	_messages = _message_list
	_active_dialogue_offset = 0
	assert(_dialogue_below_character_limit(_messages) == true)

	var _dialogue: = DIALOGUE_SCENE.instance() 
	_dialogue.connect("message_completed", self, "_on_message_completed")
	parent.add_child(_dialogue)
	
	_current_dialogue_instance = _dialogue

	_show_current()

func _show_current() -> void:
	emit_signal("message_requested")
	var _message: String = _messages[_active_dialogue_offset]
	_current_dialogue_instance.update_text(_message)


func _dialogue_below_character_limit(dialogue: Array) -> bool:
	var _res: = true
	for message in dialogue:
		if message.length() > 140:
			print_debug("Given dialogue is greater than 140 characters!")
			_res = false
	
	return _res

func _hide() -> void:
	_current_dialogue_instance.disconnect("message_completed", self, "_on_message_completed")
	_current_dialogue_instance.queue_free() 
	_current_dialogue_instance = null
	_is_active = false
	emit_signal("finished") 

func _on_message_completed() -> void:
	# Button stuff here.

	emit_signal("message_completed") 
	
func _on_sequenceParser_deviance_detected(root_text: String, conditions: Array) -> void:
	print("Message is: " + root_text)
	print("Choices are: " + str(conditions))
