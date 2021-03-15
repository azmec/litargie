class_name ConnectionPoint
extends Node2D

const LINK_SCENCE: = preload("res://src/props/link/link.tscn")

var _current_link: Line2D = null 

onready var playerDetector: = $PlayerDetector

func _ready() -> void:
	playerDetector.connect("object_entered_zone", self, "_on_playerDetector_entered_zone")
	playerDetector.connect("object_left_zone", self, "_on_playerDetector_exited_zone")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_meathook") and playerDetector.detects_body():
		_create_link()

func _create_link() -> void:
	if not _current_link:
		return
	
	# do stuff

