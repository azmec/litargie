tool
extends Node2D

const ROTATION_SPEED: = 5

export var body_rotation: float = 0
export(int, "Bullets", "Missiles") var fire_type: = 0 
export var fire_rate: int = 1

export var vision: int = 10

onready var bodyPivot: = $BodyPivot
onready var detector: = $Detector
onready var detectorCollision: = $Detector/CollisionShape2D 
onready var fireTimer: = $FireTimer 

func _ready() -> void:
	_update_editor_variables()

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		_update_editor_variables()
	else:
		_look_to_player()

# Rotates the body such that it is looking at the player.
func _look_to_player() -> void:
	if detector.detects_body():
		var player = detector.get_body()

		bodyPivot.rotation = self.get_angle_to(player.global_position)
		bodyPivot.rotation_degrees -= 90

		body_rotation = bodyPivot.rotation

func _update_editor_variables() -> void:
	bodyPivot.rotation = body_rotation
	detectorCollision.shape.radius = vision
	fireTimer.wait_time = fire_rate