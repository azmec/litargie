# Root node to handle some logic with. 

class_name Game 
extends Node 

onready var currentLevel: = $BaseLevel
onready var mainMenu: = $CanvasLayer/MainMenu 

onready var player: Player = currentLevel.player

func _ready() -> void:
	mainMenu.connect("game_started", self, "_on_mainMenu_game_started") 
	mainMenu.connect("finished_transition", self, "_on_mainMenu_finished_transition")

	player.active = false 
	player.visible = false

func _on_mainMenu_game_started() -> void:
	player.active = true
	player.visible = true

func _on_mainMenu_finished_transition(values: Array) -> void:
	if values.size() != 2: return

	var showing_main_menu = values[0]
	var showing_settings = values[1]

	# Everything is offscreen
	if not showing_main_menu and not showing_settings:
		mainMenu.visible = false
