# This node coordinates one or more messages to send to the Dialogue node. 
# It detects user input, allowing us to move to the "next" message on the array. 
# Additionally, it can add or remove dialogue from the tree. 

class_name DialogueManager
extends Node

signal message_requested()
signal message_completed()

signal finished() 

const DIALOGUE_SCENE: = preload("res://src/user-interface/dialogue/dialogue.tscn")

onready var opacityTween: Tween = $OpacityTween

var _messages: = []
var _active_dialogue_offset: = 0
var _is_active: = false 
var _current_dialogue_instance: Dialogue

func _input(event: InputEvent) -> void:
    if (
        event.is_pressed() and 
        !event.is_echo() and 
        event in InputEventKey and (
        event as InputEventKey).scancode == KEY_ENTER and
        _is_active and 
        _current_dialogue_instance.message_is_fully_visible()
        ):
        if _active_dialogue_offset < _messages.size() - 1:
            _active_dialogue_offset += 1 
            _show_current()
        else: 
            _hide() 


func show_messages(message_list: Array, position: Vector2) -> void:
    if _is_active:
        return
    _is_active = true

    _messages = message_list
    _active_dialogue_offset = 0

    var _dialogue: = DIALOGUE_SCENE.instance() 
    _dialogue.connect("message_completed", self, "_on_message_completed")
    get_tree().get_root().add_child(_dialogue)
    
    _current_dialogue_instance = _dialogue

    _show_current()

func _show_current() -> void:
    emit_signal("message_requested")
    var _message: String = _messages[_active_dialogue_offset]
    _current_dialogue_instance.update_text(_message)

func _hide() -> void:
    _current_dialogue_instance.disconnect("message_completed", self, "_on_message_completed")
    _current_dialogue_instance.queue_free() 
    _current_dialogue_instance = null
    _is_active = false
    emit_signal("finished") 

func _on_message_completed() -> void:
    emit_signal("message_completed") 
    