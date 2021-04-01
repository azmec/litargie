# Despite being called only "snow", we're doing two things here:
# First, we're drawing snow onto the screen using CPUParticles; 
# Second, we're generating *Wind*. 

tool
extends Node2D

# This doesn't reflect the CPUParticles2D's extents. 
# Rather, this determines the limits of where we can 
# spawn particles from.
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

# Changes both the visual and functional direction of the snow.
func set_snow_direction(value: Vector2) -> void:
	# Get the unit direction e.g. Vector2(1, 0)
	# In this case, we want snow to PASS-IN from the left
	# and GOTO the right.  
	# In this case, we want to do a few things:
	# - We're assuming extents is Vector2(320, 180)
	# 1. Set CPUParticles2D's extents to Vector2(0, 180)
	#	 and position to Vector2(-320, 0)
	# 2. Set CPUParticles2D's direction to our direction.

	value = value.normalized()
	
	snowfallParticles.emission_rect_extents = Vector2(
		extents.x * value.y,
		extents.y * value.x
	)
	snowfallParticles.position = Vector2(
		extents.x * -value.x,
		extents.y * -value.y
	)

	snowfallParticles.direction = value

func _update_editor_variables() -> void:
	wind.set_direction(direction)
	wind.set_strength(wind_strength)
	
	set_snow_direction(direction)
	snowfallParticles.initial_velocity = wind_strength
