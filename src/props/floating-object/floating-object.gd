# Node2D extension that carries an ID and waits for 
# contact with player. "Hovers" when given an image.

class_name FloatingObject
extends Node2D

signal made_contact(id)

export var id: String 
export var destroy_on_contact: bool = false
export var sprite: Texture 
export var hover_offset: float = 1.0
export var hover_speed: float = 0.5

var is_up: = false 

onready var tween: Tween = $Tween
onready var objectSprite: Sprite = $ObjectSprite 
onready var detector: Area2D = $Area2D 

func _ready() -> void:
	objectSprite.texture = sprite 
	detector.connect("body_entered", self, "_on_detector_body_entered")
	tween.connect("tween_all_completed", self, "_on_tween_all_completed") 
	_hover_up()

func _hover_up() -> void:
	var _current_y: = objectSprite.position.y
	var _current_x_scale: = objectSprite.scale.x

	tween.interpolate_property(objectSprite, "position:y", _current_y,
								_current_y - hover_offset, hover_speed,
								Tween.TRANS_LINEAR)
	tween.interpolate_property(objectSprite, "scale:x", _current_x_scale,
								_current_x_scale * -1, hover_speed, 
								Tween.TRANS_LINEAR)
	tween.start()

func _hover_down() -> void:
	var _current_y: = objectSprite.position.y
	var _current_x_scale: = objectSprite.scale.x

	tween.interpolate_property(objectSprite, "position:y", _current_y,
								_current_y + hover_offset, hover_speed,
								Tween.TRANS_LINEAR)
	tween.interpolate_property(objectSprite, "scale:x", _current_x_scale,
								_current_x_scale * -1, hover_speed, 
								Tween.TRANS_LINEAR)
	tween.start()

func _on_detector_body_entered(_body) -> void:
	emit_signal("made_contact", id)

	if destroy_on_contact:
		self.queue_free()

func _on_tween_all_completed() -> void: 
	var default_position: = Vector2.ZERO
	if objectSprite.position == Vector2(default_position.x, default_position.y - hover_offset):
		is_up = true
		_hover_down()
	else:
		is_up = false
		_hover_up()
