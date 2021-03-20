class_name TransitionEffect
extends Control

signal finished 
signal midpoint_reached

enum TRANSITION {
	Sweep,
	Fade,
	Pull
}

var active: = true 

onready var animationPlayer: = $AnimationPlayer 
onready var colorRect: = $ColorRect

func _ready() -> void:
	animationPlayer.connect("animation_finished", self, "_on_animationPlayer_animation_finished") 

func start_transition(transition_type: int) -> void:
	match transition_type:
		TRANSITION.Sweep: 
			animationPlayer.play("sweep") 

		TRANSITION.Fade: 
			animationPlayer.play("fade") 

		TRANSITION.Pull: 
			animationPlayer.play("pull")  

func _on_animationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("finished")
