class_name HookPoint
extends Node2D

onready var hookDetector: Area2D = $HookDetector
onready var animationPlayer: AnimationPlayer = $AnimationPlayer
onready var hookingSFX: VariableSFXPlayer = $HookingSFX

func _ready() -> void:
	var _hookDetector_connected: = hookDetector.connect("area_entered", self, "_on_hookDetector_area_entered")

func _on_hookDetector_area_entered(hook: Area2D) -> void:
	var direction_to_hook = self.position.direction_to(hook.global_position)

	print("HOOK DIRECTION:" + str(direction_to_hook))

	self.rotation = direction_to_hook.angle()

	print("NEW ROTATION: " + str(self.rotation))

	animationPlayer.play("turn")
	hookingSFX.play()
