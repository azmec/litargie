tool
extends Node2D

const ROTATION_SPEED: = 5

const BULLET_SCENE: Resource = preload("res://src/props/turret-objects/bullet/bullet.tscn")
const MISSILE_SCENE: Resource = preload("res://src/props/turret-objects/missile/missile.tscn")

const TARGETED_SPRITE: Texture = preload("res://assets/turret-assets/turret-targeted.png")
const TARGETING_SPRITE: Texture = preload("res://assets/turret-assets/turret-targeting.png")

export var body_rotation: float = 0
export(int, "Bullets", "Missiles") var fire_type: = 0 
export var fire_rate: float = 1.0
export var targeting_time: float = 0.5
export var vision: int = 10

var projectile: Resource = null
var target_acquired: bool = false
var flash_rate: float = 0.1

onready var bodyPivot: = $BodyPivot
onready var firingPoint: = $BodyPivot/FiringPoint
onready var detector: = $Detector
onready var detectorCollision: = $Detector/CollisionShape2D 
onready var fireTimer: = $FireTimer 

onready var targetingFlashTimer: = $TargetingFlashTimer
onready var targetingTimer: = $TargetingTimer
onready var targetingFlash: = $BodyPivot/TargetingFlash

func _ready() -> void:
	var _a: = targetingTimer.connect("timeout", self, "_on_targetingTimer_timeout") 
	var _b: = targetingFlashTimer.connect("timeout", self, "_on_targetingFlashTimer_timeout")

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

	if projectile == MISSILE_SCENE:
		targetingTimer.start(targeting_time) 
		targetingFlashTimer.start(flash_rate)

		targetingFlash.texture = TARGETING_SPRITE
		var distance_to_target = self.global_position.distance_to(target_position)

		targetingFlash.region_rect.size.y = distance_to_target
		targetingFlash.position.y = distance_to_target / 2
	
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
			projectile = MISSILE_SCENE

func _on_targetingTimer_timeout() -> void:
	target_acquired = true
	targetingFlash.texture = TARGETED_SPRITE

func _on_targetingFlashTimer_timeout() -> void:
	targetingFlash.visible = not targetingFlash.visible 
