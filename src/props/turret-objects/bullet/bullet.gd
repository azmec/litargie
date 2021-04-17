extends Node2D

const EXPLOSION_SCENE: = preload("res://src/props/explosion/explosion.tscn")

export var speed: = 100
export var explode_on_impact: bool = false

var velocity: Vector2 = Vector2.ZERO 

onready var worldDetector: Area2D = $WorldDetector
onready var audioPlayer: = $VariableSFXPlayer

func _ready() -> void:
	var _a: = worldDetector.connect("body_entered", self, "_on_worldDetector_body_entered")
	audioPlayer.play()

func _physics_process(delta: float) -> void:
	self.rotation_degrees = rad2deg(velocity.angle()) - 90 
	self.global_position = lerp(self.global_position, self.global_position + velocity, delta)

func _on_worldDetector_body_entered(_body: PhysicsBody2D) -> void:
	if explode_on_impact:
		var new_explosion = EXPLOSION_SCENE.instance()
		get_parent().add_child(new_explosion)
		new_explosion.global_position = self.global_position
		ScreenShaker.start(3.0, 0.2, 1.41)
	
	self.queue_free()