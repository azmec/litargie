# Despite being called only "snow", we're doing two things here:
# First, we're drawing snow onto the screen using CPUParticles; 
# Second, we're generating *Wind*. 

tool
extends Node2D

export var extents: Vector2 = Vector2(320, 180) 
export var direction: Vector2 = Vector2.ZERO
#export var amount: int = 16

export var wind_strength: float = 0.0
export var wind_active: bool = false

var wind = Wind.new() 

onready var snowfallParticles: = $SnowfallParticles

func _ready():
	pass

func _process(_delta: float) -> void:
	_update_editor_variables()

func _update_editor_variables() -> void:
	wind.set_direction(direction)
	wind.set_strength(wind_strength)
	
	snowfallParticles.emission_rect_extents = extents
	snowfallParticles.direction = direction
	#snowfallParticles.amount = amount
