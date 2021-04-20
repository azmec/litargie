extends Control

const END_MESSAGES: = [
	"This was a game for{p=0.5} Games For Change.",
	"Thanks for Playing!{p=0.5} Please,{p=0.2} stay safe!"
]

onready var colorRect: = $ColorRect
onready var animationPlayer: = $AnimationPlayer
onready var dialogueBox: = $HBoxContainer/VBoxContainer/Dialogue
onready var waitTimer: = $WaitTimer

func _ready() -> void:
	dialogueBox.connect("message_completed", self, "_on_dialogueBox_message_completed")
	waitTimer.connect("timeout", self, "_on_waitTimer_timeout")
	
	dialogueBox.update_text(END_MESSAGES[0]) 
	
func _process(_delta: float) -> void: 
	pass
	
func _on_dialogueBox_message_completed() -> void:
	waitTimer.start(2.0) 
	
func _on_waitTimer_timeout() -> void:
	get_tree().reload_current_scene()
