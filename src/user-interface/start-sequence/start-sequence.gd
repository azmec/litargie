# Performs a few splash screens meant to be shown at the 
# start of the game.  

class_name StartSequence
extends Control

const START_SEQUENCE: String = "res://assets/dialogues/start-sequence.json"

func _ready() -> void:
	DialogueGod.set_parent(self)
	DialogueGod.queue_sequence_to_message_stack(START_SEQUENCE)
