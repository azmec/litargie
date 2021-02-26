# Here's my hopes:
# 1. Upload map data and immediately processing it into a walkable A* Grid
#	- we can "adopt" new tilemaps?
# 2. Be able to differentiate a queuer's capabilities and return different routes
# 3. Generally queue actors appropiately. 

extends Node2D

var foster_children: = {}
var _path_start_position: = Vector2.ZERO
var _path_end_position: = Vector2.ZERO

var _point_path: PoolVector2Array = []

var _cycles: int = 0

var _currentTileMap = null

const BASE_LINE_WIDTH = 1.0
const DRAW_COLOR = Color('#fff')


onready var aStar: = AStar2D.new()

func _physics_process(_delta: float) -> void:
	_cycles += 1
	if _cycles >= 50:
		_cycles = 0

# Add a PathFindableTileMap to the AStarPathfinder.
func foster_tilemap(tileMap: PathFindableTileMap) -> void:
	_currentTileMap = tileMap
	foster_children[tileMap.name] = _aStar_add_walkable_cells(tileMap)
	_aStar_connect_walkable_cells(tileMap, foster_children[tileMap.name])

func get_valid_path(tileMap: PathFindableTileMap, starting_point: Vector2, destination: Vector2) -> Array:
	if not foster_children[tileMap.name]:
		print_debug("Given tilemap has not been initialized!")
	
	_set_path_start_position(tileMap, starting_point)
	_set_path_end_position(tileMap, destination)

	return _find_path(tileMap, starting_point, destination)

# Find a viable path using the given tileMap and world boundaries.
func _find_path(tileMap: PathFindableTileMap, world_start: Vector2, world_end: Vector2) -> Array:
	#_path_start_position = tileMap.world_to_map(world_start)
	#_path_end_position = tileMap.world_to_map(world_end)
	_recalculate_path(tileMap)
	var world_path: = []
	for point in _point_path:
		var world_point: = tileMap.map_to_world(Vector2(point.x, point.y)) + tileMap.half_cell_size
		world_path.append(world_point)
	return world_path

# Loops through all *empty* cells within the given PathFindableTileMap's bounds
# and adds all points to the AStar node.
func _aStar_add_walkable_cells(tileMap: PathFindableTileMap) -> Array:
	var points_array = []
	for y in range(tileMap.map_size.y):
		for x in range(tileMap.map_size.x):
			var point = Vector2(x, y)
			if point in tileMap.obstacles:
				continue
			
			points_array.append(point)
			var point_index: = _calculate_point_index(tileMap, point)
			aStar.add_point(point_index, Vector2(point.x, point.y))
		
	return points_array

# Loop through all given points, check the points that surround them individually, 
# and connect them using the aStar node.
func _aStar_connect_walkable_cells(tileMap: PathFindableTileMap, points_array: Array) -> void:
	for point in points_array:
		var point_index = _calculate_point_index(tileMap, point)
	
		# storing and checking the points to the top, left, bottom, and right of the current point
		var surrounding_points: = PoolVector2Array([
			Vector2(point.x + 1, point.y),
			Vector2(point.x - 1, point.y),
			Vector2(point.x, point.y + 1),
			Vector2(point.y, point.y - 1)
		])
		for surrounding_point in surrounding_points:
			var surrounding_point_index: = _calculate_point_index(tileMap, surrounding_point)
			if _is_outside_map_bounds(tileMap, surrounding_point):
				continue
			if not aStar.has_point(surrounding_point_index):
				continue
			
			aStar.connect_points(point_index, surrounding_point_index, true)
	
# Set the starting point for a future path.
func _set_path_start_position(tileMap: PathFindableTileMap, position: Vector2) -> void:
	if position in tileMap.obstacles:
		print(str(position) + " is in an obstacle!")
		return
	if _is_outside_map_bounds(tileMap, position):
		return

	_path_start_position = position
	if _path_end_position and _path_start_position != _path_start_position:
		_recalculate_path(tileMap)

# Set the destination point for a future path.
func _set_path_end_position(tileMap: PathFindableTileMap, position: Vector2) -> void:
	if position in tileMap.obstacles:
		print(str(position) + " is in an obstacle!")
	if _is_outside_map_bounds(tileMap, position):
		return
	
	_path_end_position = position
	if _path_start_position != position:
		_recalculate_path(tileMap)

# AStar references points with indices; returns the correct index using the 
# given tileMap and point.
func _calculate_point_index(tileMap: PathFindableTileMap, point: Vector2) -> int:
	return int(point.x + tileMap.map_size.x * point.y)

# NOTE: this relies on the boundaries of map being measured in postitive lengths
# if you get any bugs, check here and how map_size is defined
func _is_outside_map_bounds(tileMap: PathFindableTileMap, point: Vector2) -> bool:
	return point.x < 0 or point.y < 0 or point.x >= tileMap.map_size.x or point.y >= tileMap.map_size.y

# Calculate a path using the A* node class based on our starting and ending points.
func _recalculate_path(tileMap: PathFindableTileMap) -> void:
	_clear_previous_path_drawing()
	var start_point_index: = _calculate_point_index(tileMap, _path_start_position)
	var end_point_index: = _calculate_point_index(tileMap, _path_end_position)
	#print("START POINT INDEX: " + str(start_point_index))
	#print("END POINT INDEX: " + str(end_point_index))
	#print("PATH START POSITION: " + str(aStar.get_point_position(start_point_index)))
	#print("PATH END POSITION: " + str(aStar.get_point_position(end_point_index)))

	_point_path = aStar.get_point_path(start_point_index, end_point_index)
	#print("POINT PATH: " + str(_point_path))
	#print("SUPPOSED PATH: " + str(aStar.get_id_path(_calculate_point_index(tileMap, Vector2(30, 14)), _calculate_point_index(tileMap, Vector2(40, 13)))))
	update()

func _clear_previous_path_drawing() -> void:
	if not _point_path:
		return
	# idk do some more drawing tools later

func _draw() -> void:
	if not _point_path:
		return
	var foilTileMap = _currentTileMap # just borrowing one for its methods
	var point_start = _point_path[0]
	var last_point = foilTileMap.map_to_world(Vector2(point_start.x, point_start.y)) + foilTileMap.half_cell_size
	for index in range(1, len(_point_path)):
		var current_point = foilTileMap.map_to_world(Vector2(_point_path[index].x, _point_path[index].y)) + foilTileMap.half_cell_size
		draw_line(last_point, current_point, DRAW_COLOR, BASE_LINE_WIDTH, true)
		draw_circle(current_point, BASE_LINE_WIDTH * 1.5, DRAW_COLOR)
		last_point = current_point


	
func _draw_everything() -> void:
	var foilTileMap = _currentTileMap
	var point_start = foster_children["BoringTileMap"][0]
	var last_point = foilTileMap.map_to_world(Vector2(point_start.x, point_start.y)) + foilTileMap.half_cell_size
	for index in range(1, len(foster_children["BoringTileMap"])):
		var current_point = foilTileMap.map_to_world(Vector2(foster_children["BoringTileMap"][index].x, foster_children["BoringTileMap"][index].y)) + foilTileMap.half_cell_size
		draw_line(last_point, current_point, DRAW_COLOR, BASE_LINE_WIDTH, true)
		draw_circle(current_point, BASE_LINE_WIDTH * 1.5, DRAW_COLOR)
		last_point = current_point
