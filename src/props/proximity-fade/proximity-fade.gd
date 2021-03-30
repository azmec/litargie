tool

class_name ProximityFade
extends Node2D

signal faded_in
signal faded_out 

export var image: Texture
export var message: String

export var proximity: int = 10
export var fade_duration: float = 0.5
export var fade_offset: float = 32
export var starting_position: Vector2 = Vector2.ZERO

onready var fading_objects: Node2D = $FadingObjects
onready var sprite: Sprite = $FadingObjects/Sprite
onready var objectDetector: Area2D = $ObjectDetector
onready var collision: CollisionShape2D = $ObjectDetector/CollisionShape2D
onready var startingPositionMarker: Position2D = $StartingPositionMarker
onready var text: Label = $FadingObjects/Text 
onready var tween: Tween = $Tween

func _ready() -> void:
	var _a: = objectDetector.connect("area_entered", self, "_on_objectDetector_entered")
	var _b: = objectDetector.connect("area_exited", self, "_on_objectDetector_exited")
	var _c: = objectDetector.connect("body_entered", self, "_on_objectDetector_entered")
	var _d: = objectDetector.connect("body_exited", self, "_on_objectDetector_exited")

	_update_editor_variables()

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		_update_editor_variables()

func fade_in() -> void:
	emit_signal("faded_in")

func fade_out() -> void:
	emit_signal("faded_out")

func _update_editor_variables() -> void:
	sprite.texture = image
	collision.shape.radius = proximity
	startingPositionMarker.position = starting_position

func _on_objectDetector_entered(_object: CollisionObject2D) -> void:
	fade_in()

func _on_objectDetector_exited(_object: CollisionObject2D) -> void:
	fade_out()