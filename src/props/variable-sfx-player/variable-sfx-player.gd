class_name VariableSFXPlayer
extends AudioStreamPlayer

export var minimum_pitch: float = 0.95
export var maximum_pitch: float = 1.12 

var _random_number_generator: Reference = RandomNumberGenerator.new()

func _ready() -> void:
	_random_number_generator.randomize()

func play(from_position: float = 0.0) -> void:
	pitch_scale = _random_number_generator.randf_range(minimum_pitch, maximum_pitch)
	.play(from_position)
