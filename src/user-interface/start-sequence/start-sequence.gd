# Performs a few splash screens meant to be shown at the 
# start of the game.  

class_name StartSequence
extends Control

const START_SEQUENCE: String = "res://assets/dialogues/start-sequence.json"

onready var dialogueContainer: = $DialogueContainer

func _ready() -> void:
	DialogueGod.set_dialogue_container(
		dialogueContainer.get_dialogueBox_container(),
		dialogueContainer.get_buttonContainer()
	)

	DialogueGod.normal_dialogue_position = Vector2(56, 20)
	DialogueGod.queue_sequence_to_message_stack(START_SEQUENCE)