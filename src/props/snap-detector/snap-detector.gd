extends Area2D

# [] Scan for areas/bodies around it
# [] When found, find the one closest to it. 
# []

var closest_target = null

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	closest_target = _get_closest_body(self.get_overlapping_bodies())

func has_target() -> bool:
	return self.closest_target != null

func _get_closest_body(body_list: Array) -> PhysicsBody2D:
	var closest_body = null
	var least_distance: = 1000000.0
	for body in body_list:
		var distance_to_body: = self.global_position.distance_to(body.global_position)
		if distance_to_body <= least_distance:
			least_distance = distance_to_body
			closest_body = body
	return closest_body
	