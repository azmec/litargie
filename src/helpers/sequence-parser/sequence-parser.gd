# Intended to aid in the parsing and decoupling of "sequences." 
# Sequences are JSON->Dictionary files created at run-time that are 
# meant to be used as dialogue. 

class_name SequenceParser
extends Node

# Parses the given JSON file path and converts it into a Godot-friendly dictionary.
func load_dialogue(file_path: String) -> Dictionary:
	var file = File.new() 
	assert(file.file_exists(file_path))

	file.open(file_path, file.READ)
	var dialogue: Dictionary = parse_json(file.get_as_text())
	assert(dialogue.size() > 0)
	
	return dialogue

# Splits the trunks of a sequence into an array.
func split_sequence(sequence: Dictionary) -> Array:
	var _res: = []
	
	for trunk in sequence:
		_res.append(sequence[trunk])

	return _res

# Returns all branches of a root.
func get_branches(deviant_branch: Dictionary) -> Dictionary:
	return deviant_branch.branches

# Returns all events under the "events" key.
func get_events(sequence: Dictionary) -> Dictionary:
	return sequence.events 

# Returns ALL of the conditions of the "branches" key.
func get_all_conditions(branch_set: Dictionary) -> Array:
	var res = []

	for branch in branch_set:
		var condition = get_branch_condition(branch_set[branch])
		res.append(condition)

	return res

# Returns the condition of a specific branch within "branches."
func get_branch_condition(branch: Dictionary) -> Dictionary:
	if not branch["001"]:
		return {}
	else:
		return branch["001"]["condition"] 

# Returns the conditions required to reach the individual 
# paths of a branch set.
func get_conditions(branch_set: Dictionary) -> Array:
	var _res: = []
	for branch in branch_set:
		_res.append(branch_set[branch].condition)

	return _res

# Returns the actual "message" of a root.
func get_root_text(sequence: Dictionary) -> String:
	return sequence.message[Settings.language] 

# Determins if a root is itself deviant.
func root_is_deviant(root: Dictionary) -> bool:
	return root.branches.size() > 0
