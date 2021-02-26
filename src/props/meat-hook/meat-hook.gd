class_name Meathook
extends Node2D

signal hooked_onto_something(force, target_position)

enum STATES {
	IDLE,
	SHOOTING,
	RETRACTING
}

const HOOK_ACCELERATION: int = 10
const HOOK_DISTANCE: int = 75
const IDLE_HOOK_POSITION_X: int = 12
const FORCE_MULTIPLIER: int = 400

var state: int = 0
var flip_h: bool = false setget _set_flip_h
var flip_v: bool = false setget _set_flip_v

var _target_position: Vector2 = Vector2.ZERO

onready var label: Label = $Node/Label 
onready var hook: Area2D = $Hook

func _ready() -> void:
	hook.connect("body_entered", self, "_on_hook_body_entered")

	state = change_state_to(STATES.IDLE)

func _physics_process(delta: float) -> void:
	label.text = "rotation_degrees: " + str(self.rotation_degrees)
	match state:
		STATES.IDLE:
			_look_to_mouse()
			if Input.is_action_just_pressed("shoot"):
				state = change_state_to(STATES.SHOOTING)
		STATES.SHOOTING:
			hook.position.x += HOOK_ACCELERATION # accelerate the hook
			if hook.position.x >= HOOK_DISTANCE: # retract the hook after a certain distance
				state = change_state_to(STATES.RETRACTING)
		STATES.RETRACTING:
			hook.position.x -= 10 # accelerate the hook to us
			if hook.position.x <= IDLE_HOOK_POSITION_X: # stop retracting when its in the idle position
				hook.position.x = IDLE_HOOK_POSITION_X
				state = change_state_to(STATES.IDLE)

func change_state_to(new_state: int) -> int:
	match new_state:
		STATES.IDLE:
			pass
		STATES.SHOOTING:
			pass
		STATES.RETRACTING:
			pass
	
	return new_state

# Mimic Sprite.flip_h with Node2D.scale.x 
func _set_flip_h(value: bool) -> void:
	if value == false:
		self.scale.x = 1
	else:
		self.scale.x = -1
	flip_h = value

# Mimic Sprite.flip_v with Node2D.scale.y
func _set_flip_v(value: bool) -> void:
	if value == false:
		self.scale.y = 1
	else:
		self.scale.y = -1
	flip_v = value


# Rotate ourselves to the face the mouse and flip the sprite to always be "upright"
func _look_to_mouse() -> void:
	self.look_at(get_global_mouse_position())
	self.rotation_degrees = fmod(self.rotation_degrees, 360)
	if self.rotation_degrees < -90 and self.rotation_degrees > -270 or self.rotation_degrees > 90 and self.rotation_degrees < 270:
		self.flip_v = true
	else:
		self.flip_v = false

func _calculate_pull_force() -> Vector2:
	_target_position = hook.global_position
	var distance_to_target: = _target_position - self.global_position
	var direction: = distance_to_target.normalized()

	return direction * FORCE_MULTIPLIER 

func _on_hook_body_entered(body) -> void:
	if state == STATES.SHOOTING:
		var pull_force = _calculate_pull_force()
		emit_signal("hooked_onto_something", pull_force, _target_position)
		state = change_state_to(STATES.RETRACTING)
