extends Node2D

onready var area2D: = $Area2D
onready var animationPlayer: = $AnimationPlayer
onready var soundPlayer: = $VariableSFXPlayer

func _ready() -> void:
	var _a: = area2D.connect("body_entered", self, "_on_area2D_body_entered")

# Hard coding for player. Probably not a good idea.
func _on_area2D_body_entered(body: Player) -> void:
	soundPlayer.play()
	body.velocity.y = -body.JUMP_STRENGTH * 2
	animationPlayer.play("spring")