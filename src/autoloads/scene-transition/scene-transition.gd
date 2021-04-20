extends CanvasLayer

signal scene_changed()

enum TRANSITIONS {
	SWEEP,
	FADE
}

onready var animationPlayer: = $AnimationPlayer
onready var colorRect: = $Control/ColorRect

func change_scene_to(path: String, delay: float = 0.5, transition: int = 0) -> void:
	yield(get_tree().create_timer(delay), "timeout") 

	var game: = get_node("/root/Game") 
	
	_play_first_half(transition)

	game.currentLevel.queue_free()
	
	var next_scence = load(path).instance()
	game.add_child(next_scence)
	game.currentLevel = next_scence

	_play_second_half(transition)
	
	emit_signal("scene_changed")

func _play_first_half(transition: int = 0) -> void:
	match transition:
		TRANSITIONS.SWEEP:
			animationPlayer.play("sweep_left")
		TRANSITIONS.FADE:
			animationPlayer.play("fade")

func _play_second_half(transition: int = 0) -> void:
	match transition:
		TRANSITIONS.SWEEP:
			animationPlayer.play_backwards("sweep_right")
		TRANSITIONS.FADE:
			animationPlayer.play_backwards("fade")
