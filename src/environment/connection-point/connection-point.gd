class_name ConnectionPoint
extends Node2D

const LINK_SCENCE: = preload("res://src/props/link/link.tscn")

var _current_link_instance: Line2D = null 

onready var playerDetector: = $PlayerDetector

func _ready() -> void:
	playerDetector.connect("object_entered_zone", self, "_on_playerDetector_entered_zone")
	playerDetector.connect("object_left_zone", self, "_on_playerDetector_exited_zone")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_meathook") and playerDetector.detects_body():
		_create_link()

func _create_link() -> void:
	if _current_link_instance:
		return
	
	var _link: = LINK_SCENCE.instance()
	get_parent().add_child(_link)
	
	_link.global_position = self.global_position
	_link.starting_point_parent = self
	_link.ending_point_parent = playerDetector.get_body()

