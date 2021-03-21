extends Position2D

signal explosion_finished 

onready var sprite: = $Sprite
onready var animationPlayer: = $AnimationPlayer
onready var sfx: = $VariableSFXPlayer 

func _ready() -> void:
	var _i = animationPlayer.connect("animation_finished", self, "_on_animationPlayer_animation_finished")
	animationPlayer.play("explosion") 
	

func _on_animationPlayer_animation_finished(_anim_name: String) -> void: 
	emit_signal("explosion_finished")
