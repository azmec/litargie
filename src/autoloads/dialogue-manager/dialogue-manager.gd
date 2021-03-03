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

var _messages: = {}
var _keys: = []
var _active_dialogue_offset: = 0
var _is_active: = false 
var _current_dialogue_instance: Dialogue

<<<<<<< HEAD
onready var sequenceParser: SequenceParser = $SequenceParser
onready var opacityTween: Tween = $OpacityTween

func _ready() -> void:
	var _test_dialogue: = sequenceParser._load_dialogue(TEST_SEQUENCE_PATH)


=======
func _ready() -> void:
	_load_dialogue(TEST_
>>>>>>> 870f606... required commit
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and _is_active and _current_dialogue_instance._message_is_fully_visible():
		if _active_dialogue_offset < _messages.size() - 1:
			_active_dialogue_offset += 1 
			_show_current()
		else: 
			_hide()
		
func show_messages(sequence_string: String, parent: Control) -> void:
	if _is_active:
		return
	_is_active = true

	_messages = _load_dialogue(sequence_string)
	_keys = _messages.keys()
	_active_dialogue_offset = 0
	assert(_dialogue_below_character_limit(_messages) == true)

	var _dialogue: = DIALOGUE_SCENE.instance() 
	_dialogue.connect("message_completed", self, "_on_message_completed")
	parent.add_child(_dialogue)
	
	_current_dialogue_instance = _dialogue

	_show_current()

func _show_current() -> void:
	emit_signal("message_requested")
	var _message: String = _messages[_keys[_active_dialogue_offset]].text
	_current_dialogue_instance.update_text(_message)


func _dialogue_below_character_limit(dialogue: Dictionary) -> bool:
	var _res: = true
	for _k in dialogue:
		if dialogue[_k].text.length() > 140:
			print_debug("Given dialogue is greater than 140 characters!")
			_res = false
	
	return _res

func _hide() -> void:
	_current_dialogue_instance.disconnect("message_completed", self, "_on_message_completed")
	_current_dialogue_instance.queue_free() 
	_current_dialogue_instance = null
	_is_active = false
	emit_signal("finished") 

func _extract_messages(sequence_set: Dictionary) -> void:
	for sequence in sequence_set:
		if sequence.branches:
			print("This sequence has branches!")
		else:
			print("This sequence has no branches.")

func _on_message_completed() -> void:
	emit_signal("message_completed") 
	
