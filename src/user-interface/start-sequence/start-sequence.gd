# Performs a few splash screens meant to be shown at the 
# start of the game.  

class_name StartSequence
extends Control

const START_SEQUENCE: String = "res://assets/dialogues/start-sequence.json"

func _ready() -> void:
	DialogueGod.set_parent(self)
	DialogueGod.queue_sequence_to_message_stack(START_SEQUENCE)

	var _dialogueBox: DialogueBox = DialogueGod.get_dialogueBox()
	_dialogueBox.rect_position.y -= 50

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		self.queue_free()
		DialogueGod._hide()
