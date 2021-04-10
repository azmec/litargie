# Psuedo Wind object or something. 

class_name Wind
extends Node

var _direction: Vector2 = Vector2.ZERO
var _strength: float = 0.0
var _active: bool = false

func _init(direction = Vector2.ZERO, strength = 0.0, active = false) -> void:
	self._direction = direction
	self._strength = strength
	self._active = active

func get_force() -> Vector2:
	return _direction * _strength

func set_direction(value: Vector2) -> void:
	self._direction = value

func set_strength(value: float) -> void:
	self._strength = value
