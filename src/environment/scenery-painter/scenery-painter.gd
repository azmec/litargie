class_name SceneryPainter
extends TileMap

export var variable_scenery_path: String

func _ready() -> void:
	var variable_scene: = load(variable_scenery_path)
	for cell in get_used_cells():
		var new_scenery: Node = variable_scene.instance()
		self.add_child(new_scenery)

		new_scenery.global_position = self.map_to_world(Vector2(cell.x, cell.y + 1))
		# Erasing the cell so that we're not overlapping textures.
		set_cell(cell.x, cell.y, -1)
