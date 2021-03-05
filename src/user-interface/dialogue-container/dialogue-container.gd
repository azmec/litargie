# Control nodes meant to contain the dialogue and any necessary choice selections.
# It should only know whether the message is deviant, where to place the 
# required assets, and the character saying it. It shouldn't interfere with
# the relationship of Dialogue, DialogueManager, or DialogueButton 

class_name DialogueContainer
extends Control

onready var dialogueBoxContainer: Control = $HBoxContainer/DialogueBoxContainer
onready var buttonContainer: VBoxContainer = $HBoxContainer/ButtonContainer

# All I want this thing to do is place shit on the screen.
# That means it should have ZERO clue as to the dialogue itself. 
# Which means the dialogue manager has to handle the filling of data. 
func _ready() -> void:
	pass

func get_dialogueBox_container() -> Control:
	return dialogueBoxContainer

func get_buttonContainer() -> VBoxContainer:
	return buttonContainer
