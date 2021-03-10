# Performs a few splash screens meant to be shown at the 
# start of the game.  

class_name StartSequence
extends Control

const START_SEQUENCE: String = "res://assets/dialogues/start-sequence.json"
const REWORK_SEQUENCE: String = "res://assets/dialogues/rework-sequence.json"

func _ready() -> void:
	DialogueGod.set_parent(self)
	DialogueGod.queue_sequence_to_message_stack(REWORK_SEQUENCE)

	var _dialogueBox: DialogueBox = DialogueGod.get_dialogueBox()
	_dialogueBox.toggle_panel(false)
