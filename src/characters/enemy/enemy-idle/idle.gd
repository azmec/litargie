# This is the idle logic for a base enemy.

extends State

func enter(host: KinematicBody2D) -> void:
	print(host.name)

func update(host: KinematicBody2D, delta: float) -> String:
	if host.direction != 0:
		return "Move"
	return self.name
