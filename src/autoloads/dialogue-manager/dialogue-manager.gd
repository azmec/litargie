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

var _dialogue_container = null
var _button_container = null

var _messages: = [] 
var _keys: = []  

var _is_active: = false 
var _is_waiting_for_choice: = false

var _working_sequence: = {}
var _active_dialogue_offset: = 0 # current step of a sequence
var _current_dialogue_instance

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

func start_dialogue(json_path: String) -> void:
	# Resetting
	_messages = []
	_active_dialogue_offset = 0 

	_working_sequence = sequenceParser.load_dialogue(json_path) 
	_keys = _working_sequence.keys()

	for root in _working_sequence:
		var _text: String = sequenceParser.get_root_text(_working_sequence[root])
		_messages.append(_text)
	
	_show_dialogue(_messages) 

func _show_dialogue(_message_list: Array) -> void:
	if _is_active:
		return
	_is_active = true

	if !_dialogue_below_character_limit(_messages):
		print_debug("Given message is above the character limit and will not display correctly!") 
	
	var _dialogue: = DIALOGUE_SCENE.instance()
	_dialogue.connect("message_completed", self, "_on_message_completed")
	_dialogue_container.add_child(_dialogue)

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

func _advance_dialogue():
	if _active_dialogue_offset < _messages.size() - 1:
		_active_dialogue_offset += 1 
		_show_current()
	else: 
		_hide()

func _hide() -> void:
	_current_dialogue_instance.disconnect("message_completed", self, "_on_message_completed")
	_current_dialogue_instance.queue_free() 
	_current_dialogue_instance = null
	_is_active = false
	emit_signal("finished") 

func _on_message_completed() -> void:
	var _current_root: Dictionary = _working_sequence[_keys[_active_dialogue_offset]]
	var _branches: = sequenceParser.get_branches(_current_root) 
	var _branch_keys: = _branches.keys() 

	if sequenceParser.root_is_deviant(_current_root):
		var _conditions: Array = sequenceParser.get_conditions(_current_root.branches)
		
		for condition in _conditions:
			for key in _branch_keys:
				var _button: = DIALOGUE_BUTTON_SCENCE.instance()

				var _current_deviant_branch: Dictionary = _branches[key]
				_button.initialize(_current_deviant_branch)

				_button.connect("condition_choosen", self, "_on_condition_choosen")
				_button_container.add_child(_button)


		_is_waiting_for_choice = true


	emit_signal("message_completed") 
	
func _on_condition_choosen(condition: String, text: String, branch: Dictionary) -> void: 
	_is_waiting_for_choice = false
	print(branch)
	_messages.insert(_active_dialogue_offset + 1, text)
	_advance_dialogue()
