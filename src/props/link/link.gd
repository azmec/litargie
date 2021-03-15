class_name Link
extends Line2D

var starting_point_parent: Node2D = null
var ending_point_parent: Node2D = null

var is_linked: bool = false

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if starting_point_parent != null:
		self.points[0] = to_local(starting_point_parent.global_position)
		self.points[0].y -= 8
	if ending_point_parent != null:
		self.points[-1] = to_local(ending_point_parent.global_position) 
		self.points[-1].y -= 8

func get_starting_point_position() -> Vector2:
	return self.points[0]

func get_working_point_position() -> Vector2:
	return self.points[-1]