class_name PlayerCamera
extends Camera2D

var is_looking_at_mouse: bool = true 

onready var _parent: = get_parent()

onready var topLeft: Position2D = $Limits/TopLeft
onready var bottomRight: Position2D = $Limits/BottomRight	

func _ready():
	_update_limits()

func _physics_process(_delta: float) -> void:
	if is_looking_at_mouse:
		_look_at_mouse()

func _look_at_mouse() -> void:
	var mouse_position = get_local_mouse_position()
	self.position = mouse_position / 2

func _update_limits() -> void:
	self.limit_left = topLeft.global_position.x
	self.limit_right = bottomRight.global_position.x
	self.limit_top = topLeft.global_position.y
	self.limit_bottom = bottomRight.global_position.y

