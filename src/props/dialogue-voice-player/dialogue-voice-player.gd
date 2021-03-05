class_name DialogueVoicePlayer
extends AudioStreamPlayer

const MINIMUM_PITCH: float = 0.95
const MAXMIUM_PITCH: float = 1.12 

var _random_number_generator: Reference = RandomNumberGenerator.new()

func _ready() -> void:
	_random_number_generator.randomize()

func play(from_position: float = 0.0) -> void:
	pitch_scale = _random_number_generator.randf_range(MINIMUM_PITCH, MAXMIUM_PITCH)
	.play(from_position)
