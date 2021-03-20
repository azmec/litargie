extends Area2D

onready var particles: = $CPUParticles2D
onready var deathZone: = $CollisionShape2D

func _ready() -> void:
	particles.emission_rect_extents = deathZone.shape.extents
