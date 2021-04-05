extends Node2D

export var speed: = 100

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
	self.queue_free()