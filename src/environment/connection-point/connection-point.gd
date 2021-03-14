class_name ConnectionPoint
extends Node2D

const ACTIVE_COLOR: = Color.red

onready var playerDetector: = $PlayerDetector

func _ready() -> void:
	playerDetector.connect("object_entered_zone", self, "_on_playerDetector_entered_zone")
	playerDetector.connect("object_left_zone", self, "_on_playerDetector_exited_zone")

func _on_playerDetector_entered_zone() -> void:
	self.modulate = ACTIVE_COLOR

func _on_playerDetector_exited_zone() -> void:
	self.modulate = Color(1, 1, 1, 1)
