class_name RisingPrompt
extends Node2D

const SPEED: = 0.5 

export var rising_offset: = -16
export var text: String
export var bubble_size: int = 20

var sitting_position: = Vector2(0, 0) 

onready var textLabel: Label = $Text
onready var tween: Tween = $RisingTween
onready var playerDetector: = $PlayerDetector
onready var detectionBubble: = $PlayerDetector/CollisionShape2D

func _ready() -> void:
	_set_text(text)
	detectionBubble.shape.radius = bubble_size
	playerDetector.connect("object_entered_zone", self, "_on_playerDetector_object_entered_zone")
	playerDetector.connect("object_left_zone", self, "_on_playerDetector_object_left_zone")
	_fall() 
	
func _rise() -> void:
	var _final_position: = sitting_position
	_final_position.y += rising_offset

	tween.interpolate_property(textLabel, "rect_position", sitting_position, _final_position, SPEED, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.interpolate_property(textLabel, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), SPEED, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()

func _fall() -> void:
	tween.interpolate_property(textLabel, "rect_position", textLabel.rect_position, sitting_position, SPEED, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.interpolate_property(textLabel, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), SPEED, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()

func _set_text(value: String) -> void:
	textLabel.text = value
	textLabel.rect_position.x = textLabel.rect_size.x / -2
	textLabel.rect_position.y = 0
	
	sitting_position = textLabel.rect_position
	
	text = value

func _on_playerDetector_object_entered_zone() -> void:
	_rise()

func _on_playerDetector_object_left_zone() -> void:
	_fall()
