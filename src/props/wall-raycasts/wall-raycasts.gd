extends Node2D

onready var leftRaycast: RayCast2D = $LeftRaycast2D
onready var rightRaycast: RayCast2D = $RightRaycast2D

# Gives the direction a wall is immediately by the player. If there are two, return the given integer.
func get_wall_direction(default: int) -> int:
	var is_near_right_wall = rightRaycast.is_colliding()
	var is_near_left_wall = leftRaycast.is_colliding()

	if is_near_left_wall and is_near_right_wall:
		return default
	else:
		return -int(is_near_left_wall) + int(is_near_right_wall)
