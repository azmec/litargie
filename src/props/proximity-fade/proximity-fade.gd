tool

class_name ProximityFade
extends Node2D

signal faded_in
signal faded_out 

export var image: Texture
export var message: String

export var proximity: int = 10
export var fade_duration: float = 0.5
export var fade_offset: Vector2 = Vector2(0, 32)
export var starting_position: Vector2 = Vector2.ZERO

onready var fadingObjects: Node2D = $FadingObjects
onready var sprite: Sprite = $FadingObjects/Sprite
onready var objectDetector: Area2D = $ObjectDetector
onready var collision: CollisionShape2D = $ObjectDetector/CollisionShape2D
onready var startingPositionMarker: Position2D = $StartingPositionMarker
onready var text: Label = $FadingObjects/Text 
onready var tween: Tween = $Tween

var _visible = Color(1, 1, 1, 1)
var _invisible = Color(1, 1, 1, 0)

func _ready() -> void:
	var _a: = objectDetector.connect("area_entered", self, "_on_objectDetector_entered")
	var _b: = objectDetector.connect("area_exited", self, "_on_objectDetector_exited")
	var _c: = objectDetector.connect("body_entered", self, "_on_objectDetector_entered")
	var _d: = objectDetector.connect("body_exited", self, "_on_objectDetector_exited")

	_update_editor_variables()
	fade_out()

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		_update_editor_variables()

func fade_out() -> void:
	var _a: = tween.interpolate_property(fadingObjects, "position", starting_position + fade_offset, starting_position, fade_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	var _b: = tween.interpolate_property(fadingObjects, "modulate", _visible, _invisible, fade_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)

	var _started: = tween.start()

	yield(get_tree().create_timer(fade_duration), "timeout")
	emit_signal("faded_out")

func fade_in() -> void:
	var _a: = tween.interpolate_property(fadingObjects, "position", starting_position, starting_position + fade_offset, fade_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)
	var _b: = tween.interpolate_property(fadingObjects, "modulate", _invisible, _visible, fade_duration, Tween.TRANS_EXPO, Tween.EASE_OUT)

	var _started: = tween.start()

	yield(get_tree().create_timer(fade_duration), "timeout")
	emit_signal("faded_in")

func _update_editor_variables() -> void:
	sprite.texture = image
	collision.shape.radius = proximity
	startingPositionMarker.position = starting_position
	text.text = message
	_align_text() 
	
func _align_text() -> void:
	var text_size = text.rect_size.x
	text.rect_position.x = -text_size / 2 

func _on_objectDetector_entered(_object: CollisionObject2D) -> void:
	fade_in()

func _on_objectDetector_exited(_object: CollisionObject2D) -> void:
	fade_out()