tool
extends Area2D

export var radius: int = 10
# In normal games we'd have a "damage" export
# variable too but I just want to instantly 
# kill the player.

onready var collisionShape2D: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collisionShape2D.shape.radius = radius

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		collisionShape2D.shape.radius = radius