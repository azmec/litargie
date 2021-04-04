extends Node2D

export var speed: = 100

var velocity: Vector2 = Vector2.ZERO 

onready var worldDetector: Area2D = $WorldDetector

func _ready() -> void:
	var _a: = worldDetector.connect("body_entered", self, "_on_worldDetector_body_entered")

func _physics_process(delta: float) -> void:
	self.global_position = lerp(self.global_position, self.global_position + velocity, delta)

func _on_worldDetector_body_entered(_body: PhysicsBody2D) -> void:
	self.queue_free()