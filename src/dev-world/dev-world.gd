extends Node2D

const TEST_SEQUENCE_PATH: = "res://assets/dialogues/test-sequence.json"

var _cycles: = 0

onready var player: = $Player
onready var enemy: = $Enemy
onready var boringTileMap: = $BoringTileMap

onready var dialogueContainer: = $CanvasLayer/Main/DialogueContainer
onready var buttonContainer: = $CanvasLayer/Main/DialogueContainer/HBoxContainer/ButtonContainer

onready var fpsLabel: Label = $CanvasLayer/Main/FPSLabel

func _ready() -> void:
	DialogueGod.set_dialogue_container(dialogueContainer, buttonContainer)

	yield(get_tree().create_timer(0.5), "timeout")
	DialogueGod.queue_sequence_to_message_stack(TEST_SEQUENCE_PATH)

	AStarPathfinder.foster_tilemap(boringTileMap)

func _physics_process(delta: float) -> void:
	fpsLabel.text = ("FPS: " + str(Engine.get_frames_per_second()))
	var from = boringTileMap.global_to_tile(enemy.global_position)
	var to = boringTileMap.global_to_tile(player.global_position)
	_cycles += 1
	if _cycles >= 75:
		AStarPathfinder.get_valid_path(boringTileMap, from, to)
		_cycles = 0
