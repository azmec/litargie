# Basic script for any tilemap that wants to add itself to the AStarPathfinder family
class_name PathFindableTileMap
extends TileMap

onready var obstacles: = self.get_used_cells_by_id(0)
onready var map_size: = self.get_used_rect().size 
onready var half_cell_size: = self.cell_size / 2

func _ready() -> void:
    print(get_cell(36, 8))


# Return the grid-based coordinates corresponding to the given global position.
func global_to_tile(position: Vector2) -> Vector2:
    var res = self.world_to_map(to_local(position))
    res.y -= 1
    return res

