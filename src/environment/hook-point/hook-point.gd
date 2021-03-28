class_name HookPoint
extends Node2D

onready var hookDetector: Area2D = $HookDetector
onready var animationPlayer: = $AnimationPlayer

func _ready() -> void:
	var _hookDetector_connected: = hookDetector.connect("area_entered", self, "_on_hookDetector_area_entered")

func _on_hookDetector_area_entered(hook: Area2D) -> void:
	var local_hook_location: = to_local(hook.global_position)
	var direction_to_hook = self.position.direction_to(local_hook_location)

	self.rotation = direction_to_hook.angle()
	animationPlayer.play("turn")