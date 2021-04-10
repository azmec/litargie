class_name ConnectionPoint
extends Node2D

const LINK_SCENCE: = preload("res://src/props/link/link.tscn")

export var sequence_path: String 

var _current_link_instance: Line2D = null 

onready var sprite: = $Sprite
onready var playerDetector: = $PlayerDetector
onready var linkDetector: = $LinkDetector

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and playerDetector.detects_body():
		if linkDetector.detects_area():
			sprite.frame = 1
			# SCUFFED CODE
			var _detected_area = linkDetector.get_area()
			var _detected_link = _detected_area.get_parent() 

			if not _detected_link.is_linked():
				if _detected_area.name == "StartingPointArea2D":
					_detected_link.starting_point_parent = self
				elif _detected_area.name == "EndingPointArea2D":
					_detected_link.ending_point_parent = self
				
				if sequence_path != "":
					DialogueGod.queue_sequence_to_message_stack(sequence_path)
		else:
			_create_link()
			sprite.frame = 1

func _create_link() -> void:
	if _current_link_instance:
		return
	
	var _link: = LINK_SCENCE.instance()
	get_parent().add_child(_link)
	
	_link.global_position = self.global_position
	_link.starting_point_parent = self
	_link.ending_point_parent = playerDetector.get_body()
