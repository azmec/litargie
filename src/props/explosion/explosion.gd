# Position2D node we likely instance in code. 
# Automatically plays an exploision animation and
# sound when instanced.

extends Position2D

signal explosion_finished 

onready var sprite: = $Sprite
onready var animationPlayer: = $AnimationPlayer
onready var sfx: = $VariableSFXPlayer 

func _ready() -> void:
	animationPlayer.connect("animation_finished", self, "_on_animationPlayer_animation_finished")
	animationPlayer.play("explosion") 
	

func _on_animationPlayer_animation_finished(_anim_name: String) -> void: 
	emit_signal("explosion_finished")
	self.queue_free()
