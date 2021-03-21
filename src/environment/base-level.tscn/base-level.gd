extends Node2D

const TRANSITION_SCENE: = preload("res://src/props/transition-effect/transition-effect.tscn")

var _current_transition_instance: TransitionEffect = null 

onready var player: = $Player
onready var canvasLayer: = $CanvasLayer
onready var respawnPoints: = $RespawnPoints.get_children()

func _ready() -> void:
	player.connect("died", self, "_on_player_died")

func _create_new_transition_instance() -> TransitionEffect: 
	_destroy_current_transition_instance() 

	var _new_transition = TRANSITION_SCENE.instance()
	canvasLayer.add_child(_new_transition)
	_new_transition.connect("midpoint_reached", self, "_on_transition_midpoint_reached")
	_new_transition.connect("finished", self, "_on_transition_finished") 

	return _new_transition

func _destroy_current_transition_instance() -> void:
	if _current_transition_instance != null:
		_current_transition_instance.disconnect("midpoint_reached", self, "_on_transition_midpoint_reached")
		_current_transition_instance.disconnect("finished", self, "_on_transition_finished") 

		_current_transition_instance.queue_free()

func _on_player_died() -> void:
	_current_transition_instance = _create_new_transition_instance()
	_current_transition_instance.start_transition(0)

func _on_transition_midpoint_reached() -> void: 
	player.position = respawnPoints[0].position
	player.camera.smoothing_enabled = false
	player.set_process_input(false)
	player.visible = true

func _on_transition_finished() -> void:
	_destroy_current_transition_instance()
	player.camera.smoothing_enabled = true
	player.set_process_input(true)
	player.state = player.change_state_to(player.STATES.IDLE)
