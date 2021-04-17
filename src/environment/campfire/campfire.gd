tool
extends Node2D

export var process_editor: bool = false
export var on: bool = false
export var detection_radius: int = 10

onready var area2D: = $Area2D
onready var collision2D: = $Area2D/CollisionShape2D 
onready var animationPlayer: = $AnimationPlayer
onready var soundEffect: = $VariableSFXPlayer

func _ready() -> void:
	area2D.connect("body_entered", self, "_on_body_entered")
	animationPlayer.connect("animation_finished", self, "_on_animation_finished")

func _process(_delta: float) -> void:
	if Engine.editor_hint and process_editor:
		if self.on:
			animationPlayer.play("burning")
		else:
			animationPlayer.play("off")

		collision2D.shape.radius = detection_radius
		
func _on_body_entered(_body) -> void:
	if not self.on:
		soundEffect.play()
		animationPlayer.play("turn_on")
		self.on = true

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "turn_on":
		animationPlayer.play("burning")
