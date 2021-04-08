# Configurable Area2D that waits for valid entity contact
# and emits the relevant signal. 

class_name RespawnPoint
extends Area2D

signal passed_through(position)

var enabled: bool = false

onready var point: Position2D = $Point
onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	self.connect("body_entered", self, "_on_body_detected")
	self.connect("body_exited", self, "_on_body_detected")

func _on_body_detected(_player: Player) -> void:
	self.enabled = true
	emit_signal("passed_through", point.global_position)
