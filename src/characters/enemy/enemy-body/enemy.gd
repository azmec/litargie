# Ideally, this is the class all enemies inherit from. Let's keep it simple.
# Using a state machine, enemies will have different states, but we still
# need a basic state machine to draw from.

# I need to know how *high* I can jump. 

class_name Enemy
extends KinematicBody2D

enum STATES {
	IDLE,
	MOVE,
	JUMP
}
# FAUX-CONSTANTS
var MAX_SPEED: int = 150
var TERMINAL_VELOCITY: int = 600
var ACCELERATION: int = 350
var DECCELERATION: int = 20
var GRAVITY: int = 600
var JUMP_STRENGTH: int = 170

var velocity: Vector2 = Vector2.ZERO
var direction: int = 0
var state: int = 0
var previous_state: int = 0

var _target_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	match state:
		STATES.IDLE:
			velocity.x = lerp(velocity.x, 0, delta * DECCELERATION)
			if direction != 0:
				state = STATES.MOVE
			velocity.y = _set_gravity(velocity.y, delta)
		STATES.MOVE:
			pass # who knows? Let's get A* framework up first
		STATES.JUMP:
			velocity.y = _set_gravity(velocity.y, delta)
			if is_on_floor():
				state = STATES.IDLE
	velocity = move_and_slide(velocity)
			
# accelerates the given value according to GRAVITY
func _set_gravity(y_value: float, delta: float) -> float:
	y_value += GRAVITY * delta
	y_value = clamp(y_value, -TERMINAL_VELOCITY, TERMINAL_VELOCITY)
	return y_value

func _accelerate_property(speed: int, direction: int, delta: float) -> int:
	speed += direction * ACCELERATION * delta
	if sign(direction) != sign(speed):
		speed = speed / 2
	speed = clamp(speed, -MAX_SPEED, MAX_SPEED)

	return speed

func _enter_jump_state() -> void:
	velocity.y -= JUMP_STRENGTH
	state = STATES.JUMP
