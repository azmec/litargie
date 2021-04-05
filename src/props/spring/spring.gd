extends Node2D

onready var area2D: = $Area2D

func _ready() -> void:
	var _a: = area2D.connect("body_entered", self, "_on_area2D_body_entered")

func _on_area2D_body_entered(body: Player) -> void:
	body.velocity.y = -body.JUMP_STRENGTH * 2