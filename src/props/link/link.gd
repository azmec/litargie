class_name Link
extends Line2D

var starting_point_parent: Node2D = null
var ending_point_parent: Node2D = null

onready var startingPointArea2D: = $StartingPointArea2D
onready var endingPointArea2D: = $EndingPointArea2D

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if starting_point_parent != null:
		self.points[0] = to_local(starting_point_parent.global_position)
		self.points[0].y -= 8
	if ending_point_parent != null:
		self.points[-1] = to_local(ending_point_parent.global_position) 
		self.points[-1].y -= 8

	startingPointArea2D.position = self.points[0]
	endingPointArea2D.position = self.points[-1]

func get_starting_point_position() -> Vector2:
	return self.points[0]

func get_working_point_position() -> Vector2:
	return self.points[-1]
	
func is_player(point_parent) -> bool:
	return point_parent is Player

func is_connection_point(point_parent) -> bool:
	# Scuff rating is off the charts
	return "_current_link_instance" in point_parent

func is_linked() -> bool:
	return is_connection_point(starting_point_parent) and is_connection_point(ending_point_parent)
