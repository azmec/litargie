class_name AreaDetector
extends Area2D

signal area_entered_zone
signal area_exited_zone

var _area: Area2D = null

func _ready() -> void:
	self.connect("area_entered", self, "_on_area_entered")
	self.connect("area_exited", self, "_on_area_exited")
func detects_area() -> bool:
	return _area != null

func get_area() -> Area2D:
	return _area 

func _on_area_entered(area: Area2D) -> void:
	_area = area
	emit_signal("area_entered_zone")

func _on_area_exited(_a: Area2D) -> void:
	_area = null
	emit_signal("area_exited_zone")