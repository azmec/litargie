extends Node2D

var _cycles: = 0

onready var player: = $Player
onready var enemy: = $Enemy
onready var boringTileMap: = $BoringTileMap

onready var dialogueSpot: Control = $CanvasLayer/Main/DialogueSpot
onready var fpsLabel: Label = $CanvasLayer/Main/FPSLabel

func _ready() -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	DialogueGod.show_messages([
		"This is a [wave amplitude=10]test message[/wave].", 
		"We're [shake rate=20 level = 10]limited[/shake] to only {p=0.5}two lines.",
		"We should find out how many approximate characters...", 
		"that is. "
	], dialogueSpot)
	AStarPathfinder.foster_tilemap(boringTileMap)
	#print(enemy.global_position)
	#print(player.global_position)
	
	#print("FROM: " + str(from))
	#print("TO: " + str(to))
	#print("MAP LIMITS: " + str(boringTileMap.map_size))
	#AStarPathfinder.get_valid_path(boringTileMap, from, to)

func _physics_process(delta: float) -> void:
	fpsLabel.text = ("FPS: " + str(Engine.get_frames_per_second()))
	var from = boringTileMap.global_to_tile(enemy.global_position)
	var to = boringTileMap.global_to_tile(player.global_position)
	_cycles += 1
	if _cycles >= 75:
		AStarPathfinder.get_valid_path(boringTileMap, from, to)
		_cycles = 0
