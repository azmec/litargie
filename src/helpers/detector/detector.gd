extends Area2D

signal object_entered_zone
signal object_left_zone

var _body = null

func _ready() -> void:
	self.connect("body_entered", self, "_on_body_entered")
	self.connect("body_exited", self, "_on_body_exited")

func detects_body() -> bool:
	return _body != null

func get_body():
	return _body

func _on_body_entered(body) -> void:
	_body = body
	emit_signal("object_entered_zone")

func _on_body_exited(_b) -> void:
	_body = null
	emit_signal("object_left_zone")