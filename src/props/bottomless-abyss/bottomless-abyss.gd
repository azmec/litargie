tool
extends Area2D

export var extents: = Vector2(10, 10)
export var particle_duration: float = 2
#export var particle_strength: int = 16

onready var particles: = $CPUParticles2D
onready var deathZone: = $CollisionShape2D

func _ready() -> void:
	particles.emission_rect_extents = deathZone.shape.extents
	_update_editor_variables()

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		_update_editor_variables()

func _update_editor_variables() -> void:
	#particles.amount = particle_strength
	particles.lifetime = particle_duration
	particles.emission_rect_extents = extents
	deathZone.shape.extents = extents
