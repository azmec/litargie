# Intended to aid in the parsing and decoupling of "sequences." 
# Sequences are JSON->Dictionary files created at run-time that are 
# meant to be used as dialogue. 

class_name SequenceParser
extends Node

# Parses the given JSON file path and converts it into a Godot-friendly dictionary.
func _load_dialogue(file_path: String) -> Dictionary:
	var file = File.new() 
	assert(file.file_exists(file_path))

	file.open(file_path, file.READ)
	var dialogue: Dictionary = parse_json(file.get_as_text())
	assert(dialogue.size() > 0)
	
	return dialogue

func get_branches(deviant_branch: Dictionary) -> Dictionary:
	assert(_is_deviant(deviant_branch) == true)
	return deviant_branch.branches

func get_conditions(branch_set: Dictionary) -> Array:
	var _res: = []

	for sequence in branch_set:
		_res.append(sequence.condition)

	return _res

func get_root_text(sequence: Dictionary) -> String:
	return sequence.root[Settings.language] 

func _is_deviant(root: Dictionary) -> bool:
	return root.branches.size() > 0