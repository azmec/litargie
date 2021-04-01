tool
extends Area2D

export var sequence_path: String
export var radius: int = 10

var _has_been_activated: bool = false

onready var collisionShape2D: = $CollisionShape2D 

func _ready() -> void:
	var _a = self.connect("body_entered", self, "_on_body_entered")

	collisionShape2D.shape.radius = radius 

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		collisionShape2D.shape.radius = radius 

func _on_body_entered(_body: PhysicsBody2D) -> void:
	if _has_been_activated: return

	if sequence_path != "":
		DialogueGod.queue_sequence_to_message_stack(sequence_path)

	_has_been_activated = true
