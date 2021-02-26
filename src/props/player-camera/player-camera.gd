class_name PlayerCamera
extends Camera2D

const LOOK_AHEAD_FACTOR: = 0.15

const SHIFT_TRANS: = Tween.TRANS_SINE
const SHIFT_EASE: = Tween.EASE_OUT
const SHIFT_DURATION: = 1.0 

var _facing: = 0 

onready var previous_camera_position: = get_camera_position()
onready var _parent: = get_parent()

onready var shiftTween: Tween = $ShiftTween
onready var topLeft: Position2D = $Limits/TopLeft
onready var bottomRight: Position2D = $Limits/BottomRight	

func _ready():
	_update_limits()

func _physics_process(delta: float) -> void:
	_facing = _check_facing(_facing)
	if _facing != 0:
		_set_horizontal_offset(_facing)
	previous_camera_position = get_camera_position()
	self.drag_margin_v_enabled = not _parent.is_on_floor()

# Reposition the limits of the camera and update the camera's position accordingly.
func set_limits(new_topLeft_position: Vector2, new_bottomRight_position: Vector2) -> void:
	topLeft.global_position = new_topLeft_position
	bottomRight.global_position = new_bottomRight_position
	_update_limits()

# Compare the current camera position's unit_vector with the given unit_vector.
func _check_facing(old_facing: int) -> int:
	var new_facing: = sign(get_camera_position().x  - previous_camera_position.x)
	if new_facing != 0 and old_facing != new_facing:
		return int(new_facing)
	else:
		return 0

# Shift the camera position according to given direction and a portion of the screen size.
func _set_horizontal_offset(direction: int) -> void:
	var target_offset: = get_viewport_rect().size.x * LOOK_AHEAD_FACTOR * direction
	shiftTween.interpolate_property(self, "position:x", position.x, target_offset, SHIFT_DURATION, SHIFT_TRANS, SHIFT_EASE)
	shiftTween.start()

# Update the camera's limit properties using the positions of the topLeft and bottomRight nodes
func _update_limits() -> void:
	self.limit_left = topLeft.global_position.x
	self.limit_right = bottomRight.global_position.x
	self.limit_top = topLeft.global_position.y
	self.limit_bottom = bottomRight.global_position.y

