class_name RespawnPoint
extends Area2D

signal passed_through(position)

var enabled: bool = false

onready var point: Position2D = $Point
onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	var _a: = self.connect("body_entered", self, "_on_body_detected")
	var _b: = self.connect("body_exited", self, "_on_body_detected")

func _on_body_detected(_player: Player) -> void:
	self.enabled = true
	emit_signal("passed_through", point.global_position)
