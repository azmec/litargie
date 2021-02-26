class_name PlayerCamera
extends Camera2D

onready var topLeft: Position2D = $Limits/TopLeft
onready var bottomRight: Position2D = $Limits/BottomRight	

## Reposition the limits of the camera and update the camera's position accordingly.
func set_limits(new_topLeft_position: Vector2, new_bottomRight_position: Vector2) -> void:
	topLeft.global_position = new_topLeft_position
	bottomRight.global_position = new_bottomRight_position
	_update_limits()

func _ready():
	_update_limits()

## Update the camera's limit properties using the positions of the topLeft and bottomRight nodes
func _update_limits() -> void:
	self.limit_left = topLeft.global_position.x
	self.limit_right = bottomRight.global_position.x
	self.limit_top = topLeft.global_position.y
	self.limit_bottom = bottomRight.global_position.y

