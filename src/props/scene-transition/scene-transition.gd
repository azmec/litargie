extends CanvasLayer

const TRANSITION_SCENE: = preload("res://src/props/transition-effect/transition-effect.tscn")

var _current_transition_instance: TransitionEffect = null 

var _current_root_scene: Node = null
var _current_scene_from: Node = null
var _current_scene_to: Resource = null

var active: = false

func start_scene_transition(root_scene: Node, scene_from: Node, scene_to: Resource) -> void:
	if self.active: return
	self.active = true

	_current_root_scene = root_scene
	_current_scene_from = scene_from
	_current_scene_to = scene_to
	_current_transition_instance = _create_new_transition_instance()
	_current_transition_instance.start_transition(0)

func _create_new_transition_instance() -> TransitionEffect: 
	_destroy_current_transition_instance() 

	var _new_transition = TRANSITION_SCENE.instance()
	_current_root_scene.add_child(_new_transition)
	_new_transition.connect("midpoint_reached", self, "_on_transition_midpoint_reached")
	_new_transition.connect("finished", self, "_on_transition_finished") 

	return _new_transition

func _destroy_current_transition_instance() -> void:
	if _current_transition_instance != null:
		_current_transition_instance.disconnect("midpoint_reached", self, "_on_transition_midpoint_reached")
		_current_transition_instance.disconnect("finished", self, "_on_transition_finished") 

		_current_transition_instance.queue_free()

func _on_transition_midpoint_reached() -> void:
	_current_scene_from.queue_free()
	var _new_scene = _current_scene_to.instance()
	_current_root_scene.add_child(_new_scene) 

func _on_transition_finsihed() -> void:
	_destroy_current_transition_instance() 
	_current_root_scene = null
	_current_scene_from = null
	_current_scene_to = null 

	self.active = false

