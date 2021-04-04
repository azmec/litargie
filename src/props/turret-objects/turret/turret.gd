tool
extends Node2D

const ROTATION_SPEED: = 5

const BULLET_SCENE: Resource = preload("res://src/props/turret-objects/bullet/bullet.tscn")

export var body_rotation: float = 0
export(int, "Bullets", "Missiles") var fire_type: = 0 
export var fire_rate: float = 1.0
export var vision: int = 10

var projectile: Resource = null

onready var bodyPivot: = $BodyPivot
onready var firingPoint: = $BodyPivot/FiringPoint
onready var detector: = $Detector
onready var detectorCollision: = $Detector/CollisionShape2D 
onready var fireTimer: = $FireTimer 

func _ready() -> void:
	_update_editor_variables()
	_update_fire_type()

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		_update_editor_variables()
	else:
		var player = _look_to_player()

		if fireTimer.is_stopped() and player != null:
			_shoot(player.global_position)

# Rotates the body such that it is looking at the player.
func _look_to_player() -> Player:
	var player = detector.get_body()

	if detector.detects_body():
		bodyPivot.rotation = self.get_angle_to(player.global_position)
		bodyPivot.rotation_degrees -= 90

		body_rotation = bodyPivot.rotation

	return player

func _shoot(target_position: Vector2) -> void:
	var dir_to_target: = self.global_position.direction_to(target_position)
	var new_projectile: Node = projectile.instance()

	new_projectile.velocity = dir_to_target * new_projectile.speed
	new_projectile.global_position = firingPoint.global_position
	get_parent().add_child(new_projectile)

	fireTimer.start(fire_rate)

func _update_editor_variables() -> void:
	bodyPivot.rotation = body_rotation
	detectorCollision.shape.radius = vision
	fireTimer.wait_time = fire_rate

func _update_fire_type() -> void:
	match fire_type:
		0:
			projectile = BULLET_SCENE
		1:
			projectile = null
