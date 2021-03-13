class_name Player
extends KinematicBody2D

enum STATES {
	IDLE,
	RUN,
	JUMP,
	FALL,
	DASH,
	WALL_SLIDE,
	HOOKED
}

const MH_ANIMS: = preload("res://assets/actors/player/player-mh-anims.png")
const BASE_ANIMS: = preload("res://assets/actors/player/player-anims.png")

const MAX_SPEED: int = 150
const TERMINAL_VELOCITY: int = 600
const ACCELERATION: int = 350
const DECCELERATION: int = 20
const GRAVITY: int = 600
const JUMP_STRENGTH: int = 170
const COYOTE_TIME: float = 0.1
const JUMP_TIME: float = 0.1
const DASH_TIME: float = 0.2
const DASH_COOLDOWN: float = 2.0
const WALL_SLIDE_COOLDOWN: float = 0.2
const WALL_STICKINESS: float = 0.2

export var has_meathook: bool = true 

var velocity: Vector2 = Vector2.ZERO
var x_input: int = 0
var wall_direction: int = 0
var state: int = 0
var previous_state: int = 0

var current_jumps: int = 0
var max_jumps: int = 2 

var _hook_pull_force: Vector2 = Vector2.ZERO
var _hook_target_position: Vector2 = Vector2.ZERO

onready var sprite: Sprite = $Sprite
onready var animationPlayer: AnimationPlayer = $AnimationPlayer
onready var meathook: Meathook = $Meathook
onready var wallRaycasts: Node2D = $WallRaycasts
onready var stateText: Label = $StateText

onready var coyoteTimer: Timer = $Timers/CoyoteTimer
onready var jumpTimer: Timer = $Timers/JumpTimer
onready var dashTimer: Timer = $Timers/DashTimer
onready var dashCooldownTimer: Timer = $Timers/DashCooldownTimer
onready var wallJumpCooldownTimer: Timer = $Timers/WallJumpCooldownTimer
onready var wallJumpStickyTimer: Timer = $Timers/WallJumpStickyTimer

func _ready():
	meathook.connect("hooked_onto_something", self, "_on_meathook_hooked_onto_something")
	dashTimer.connect("timeout", self, "_on_dashTimer_timeout")
	wallJumpStickyTimer.connect("timeout", self, "_on_wallJumpStickyTimer_timeout")
	state = change_state_to(STATES.IDLE)

	if has_meathook:
		meathook.enabled = true
		sprite.texture = MH_ANIMS
	else:
		meathook.enabled = false
		sprite.texture = BASE_ANIMS

func _physics_process(delta: float) -> void:
	x_input = get_input()
	wall_direction = wallRaycasts.get_wall_direction(x_input) 

	if is_on_floor(): 
		current_jumps = max_jumps
		coyoteTimer.start(COYOTE_TIME)

	if Input.is_action_just_pressed("jump"):
		jumpTimer.start(JUMP_TIME)

	if dashCooldownTimer.is_stopped() and Input.is_action_just_pressed("dash"):
		state = change_state_to(STATES.DASH)
	
	match state:
		STATES.IDLE:
			velocity.x = lerp(velocity.x, 0, DECCELERATION * delta)
			if x_input != 0:
				state = change_state_to(STATES.RUN)
			if !jumpTimer.is_stopped() and current_jumps > 0:
				state = change_state_to(STATES.JUMP)

			velocity.y = _set_gravity(velocity.y, delta)
		STATES.RUN:
			velocity.x = _accelerate_property(velocity.x, x_input, delta)

			if x_input == 0:
				state = change_state_to(STATES.IDLE)
			if !jumpTimer.is_stopped() and current_jumps > 0:
				state = change_state_to(STATES.JUMP)

			velocity.y = _set_gravity(velocity.y, delta)
		STATES.JUMP:
			if x_input == 0:
				velocity.x = lerp(velocity.x, 0, DECCELERATION * delta)
			else:
				velocity.x = _accelerate_property(velocity.x, x_input, delta)
				
			if Input.is_action_just_released("jump") and velocity.y < -JUMP_STRENGTH / 2:
				velocity.y = -JUMP_STRENGTH / 2

			if velocity.y > -JUMP_STRENGTH / 2:
				state = change_state_to(STATES.FALL)

			if !jumpTimer.is_stopped() and current_jumps > 0:
				state = change_state_to(STATES.JUMP)
			
			velocity.y = _set_gravity(velocity.y, delta)

		STATES.FALL:
			if x_input == 0:
				velocity.x = lerp(velocity.x, 0, DECCELERATION * delta)
			else:
				velocity.x = _accelerate_property(velocity.x, x_input, delta)

			if !jumpTimer.is_stopped() and current_jumps > 0:
				state = change_state_to(STATES.JUMP)
			if is_on_floor():
				if x_input == 0:
					state = change_state_to(STATES.IDLE)
				else:
					state = change_state_to(STATES.RUN)
			
			if wall_direction != 0 and wallJumpCooldownTimer.is_stopped():
				state = change_state_to(STATES.WALL_SLIDE) 
	
			velocity.y = _set_gravity(velocity.y, delta)
			
		STATES.DASH:
			velocity.y = 0

		STATES.WALL_SLIDE:
			velocity.y += 200 * delta
			velocity.y = clamp(velocity.y, -GRAVITY, GRAVITY)

			# Here we're setting a minimum time in which the player has to hold away from the wall
			# to leave it.
			if x_input != 0 and x_input != wall_direction:
				if wallJumpStickyTimer.is_stopped():
					wallJumpStickyTimer.start(WALL_STICKINESS)
			else:
				wallJumpStickyTimer.stop()
			
			if !jumpTimer.is_stopped():
				velocity.x += 150 * -wall_direction
				state = change_state_to(STATES.JUMP)
				
			if is_on_floor():
				state = change_state_to(STATES.IDLE)

			if wall_direction == 0:
				state = change_state_to(STATES.FALL)
		STATES.HOOKED:
			velocity = _hook_pull_force
			if self.global_position <= _hook_target_position + Vector2(5, 5) and self.global_position >= _hook_target_position - Vector2(5, 5):
				state = change_state_to(STATES.FALL)
			if !jumpTimer.is_stopped():
				state = change_state_to(STATES.JUMP)

	if x_input != 0 and state != STATES.WALL_SLIDE:
		sprite.flip_h = x_input < 0
	velocity = move_and_slide(velocity, Vector2.UP)

# Return 1 if player is pressing left, -1 if right, 0 if neither
func get_input() -> int:
	return int(Input.get_action_strength("move_right")) - int(Input.get_action_strength("move_left"))

# perform logic that runs only when we enter a state
func change_state_to(new_state: int) -> int:
	if previous_state == STATES.WALL_SLIDE:
		wallJumpCooldownTimer.start(WALL_SLIDE_COOLDOWN) 

	match new_state:
		STATES.IDLE:
			stateText.text = "idle"
			animationPlayer.play("idle")

		STATES.RUN:
			stateText.text = "run"
			animationPlayer.play("run")

		STATES.JUMP:
			stateText.text = "jump"
			
			if previous_state == STATES.WALL_SLIDE:
				animationPlayer.play("dash")
			else:
				animationPlayer.play("jump") 
		
			jumpTimer.stop()
			velocity.y = -JUMP_STRENGTH
			current_jumps -= 1

		STATES.FALL:
			stateText.text = "fall"
			animationPlayer.play("fall")

		STATES.DASH:
			stateText.text = "dash"
			animationPlayer.play("dash") 

			dashTimer.start(DASH_TIME)
			velocity.x = 400 * x_input
		
		STATES.WALL_SLIDE:
			stateText.text = "wall slide"
			animationPlayer.play("wallSlide") 

			velocity.y = 0

		STATES.HOOKED:
			stateText.text = "hooked"

	previous_state = state
	return new_state

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

func _on_meathook_hooked_onto_something(force: Vector2, target_position: Vector2) -> void:
	_hook_pull_force = force
	_hook_target_position = target_position
	state = change_state_to(STATES.HOOKED)

func _on_dashTimer_timeout() -> void:
	dashCooldownTimer.start(DASH_COOLDOWN)
	state = change_state_to(previous_state)

func _on_wallJumpStickyTimer_timeout() -> void:
	if state == STATES.WALL_SLIDE:
		state = change_state_to(STATES.FALL)

