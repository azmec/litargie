class_name ConnectionPoint
extends Node2D

const LINK_SCENCE: = preload("res://src/props/link/link.tscn")

export var sequence_path: String 

var _current_link_instance: Line2D = null 

onready var playerDetector: = $PlayerDetector
onready var linkDetector: = $LinkDetector

func _ready() -> void:
	playerDetector.connect("object_entered_zone", self, "_on_playerDetector_entered_zone")
	playerDetector.connect("object_left_zone", self, "_on_playerDetector_exited_zone")

	linkDetector.connect("area_entered", self, "_on_linkDetector_area_entered")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and playerDetector.detects_body():
		if linkDetector.detects_area():
			print("AAA")
			# SCUFFED CODE
			var _detected_area = linkDetector.get_area()
			var _detected_link = _detected_area.get_parent() 

			if not _detected_link.is_linked():
				if _detected_area.name == "StartingPointArea2D":
					_detected_link.starting_point_parent = self
				elif _detected_area.name == "EndingPointArea2D":
					_detected_link.ending_point_parent = self

				DialogueGod.queue_sequence_to_message_stack(sequence_path)
		else:
			_create_link()

func _create_link() -> void:
	if _current_link_instance:
		return
	
	var _link: = LINK_SCENCE.instance()
	get_parent().add_child(_link)
	
	_link.global_position = self.global_position
	_link.starting_point_parent = self
	_link.ending_point_parent = playerDetector.get_body()
