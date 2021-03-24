# Root node to handle some logic with. 

class_name Game 
extends Node 

onready var currentLevel: = $FreudianHook
onready var mainMenu: = $CanvasLayer/MainMenu 

onready var player: Player = currentLevel.player

func _ready() -> void:
	mainMenu.connect("game_started", self, "_on_mainMenu_game_started") 

	player.active = false 

func _on_mainMenu_game_started() -> void:
	player.active = true
