# This is the interface between dialogueManager and 
# the actual dialogue components. Rather, this where
# we pass on sequence information but actually *position*
# the dialogue and buttons themselves. 

class_name DialogueBox
extends Control

signal message_completed 

const DEVIANT_OFFSET: int = -48
const MOVE_SPEED: float = 0.5

var normal_dialogue_position: Vector2 = Vector2(48, 0) setget _set_normal_dialogue_position

onready var dialogue: Dialogue = $Dialogue
onready var buttonContainer: Control = $ButtonsContainer
onready var moveTween: Tween = $MoveTween

func _ready() -> void:
	dialogue.connect("message_completed", self, "_on_dialogue_message_completed")

# Update the text of the dialogue.
func update_dialogue_text(character_name: String, text: String) -> void:
	dialogue.update_text(text)
	dialogue.set_name(character_name)

# Clear the button container and add new buttons if necessary.
func update_dialogue_options(branches: Array) -> void:
	buttonContainer.clear_buttons()

	for branch in branches:
		buttonContainer.add_button(branch)

func toggle_panel(value: bool) -> void:
	dialogue.toggle_panel(value) 

func move_dialogue(new_position: Vector2) -> void:
	var _current_position = dialogue.rect_position 

	moveTween.interpolate_property(dialogue, "rect_position",
									_current_position, new_position,
									MOVE_SPEED, Tween.TRANS_QUART, Tween.EASE_OUT)
	moveTween.start()

func adjust_for_devaincy() -> void:
	var _deviant_position = Vector2(normal_dialogue_position.x + DEVIANT_OFFSET,
									normal_dialogue_position.y)
	var _current_position = dialogue.rect_position
	if _current_position == _deviant_position:
		return

	move_dialogue(_deviant_position)
	
func _set_normal_dialogue_position(value: Vector2) -> void:
	move_dialogue(value) 
	normal_dialogue_position = value

func _on_dialogue_message_completed() -> void:
	emit_signal("message_completed")
