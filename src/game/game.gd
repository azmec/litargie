# Root node to handle some logic with. 

class_name Game 
extends Node 

onready var currentLevel: = $BaseLevel
onready var mainMenu: = $CanvasLayer/FullMenuSet

onready var player: Player = currentLevel.player

func _ready() -> void:
	mainMenu.connect("playButton_pressed", self, "_on_mainMenu_playButton_pressed")
	mainMenu.connect("pause_requested", self, "_on_mainMenu_pause_requested") 
	mainMenu.connect("pause_exited", self, "_on_mainMenu_pause_exited") 

	player.active = false 
	player.visible = false

func _on_mainMenu_playButton_pressed() -> void:
	player.active = true
	player.visible = true

func _on_mainMenu_pause_requested() -> void:
	get_tree().paused = true

func _on_mainMenu_pause_exited() -> void:
	get_tree().paused = false
