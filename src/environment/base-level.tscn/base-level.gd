extends Node2D

const TRANSITION_SCENE: = preload("res://src/props/transition-effect/transition-effect.tscn")

var _current_transition_instance: TransitionEffect = null 
var _current_respawn_position: Vector2 

onready var player: = $Player
onready var canvasLayer: = $CanvasLayer
onready var respawnPoints: = $RespawnPoints.get_children()
onready var collectables: = $Collectables.get_children()

onready var main: Control = $CanvasLayer/Main

func _ready() -> void:
	ScreenShaker.change_camera(player.camera)
	player.connect("died", self, "_on_player_died")

	for point in respawnPoints:
		point.connect("passed_through", self, "_on_respawnPoint_passed_through")
	_current_respawn_position = respawnPoints[0].global_position

	for item in collectables:
		item.connect("made_contact", self, "_on_collectable_made_contact")

	DialogueGod.set_parent(main)
	DialogueGod.connect("message_requested", self, "_on_DialogueGod_message_requested")
	DialogueGod.connect("finished", self, "_on_DialogueGod_finished") 

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

func _on_respawnPoint_passed_through(position: Vector2) -> void:
	_current_respawn_position = position 

func _on_collectable_made_contact(collectable_id: String) -> void:
	match collectable_id:
		"meathook": 
			player.has_meathook = true
			player.meathook.enabled = true
			player.sprite.texture = player.MH_ANIMS 

func _on_transition_midpoint_reached() -> void: 
	player.position = _current_respawn_position
	player.camera.smoothing_enabled = false
	player.set_process_input(false)
	player.visible = true

func _on_transition_finished() -> void:
	_destroy_current_transition_instance()
	player.camera.smoothing_enabled = true
	player.set_process_input(true)
	player.state = player.change_state_to(player.STATES.IDLE)
	player.killable = true

func _on_DialogueGod_message_requested() -> void:
	player.input_active = false

func _on_DialogueGod_finished() -> void:
	player.input_active = true
