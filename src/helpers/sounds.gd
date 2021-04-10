extends Node

var library = {}

func _ready() -> void:
	var children: = self.get_children()
	for child in children:
		var _child_name: String = child.name
		library[_child_name] = child
	