# Intended to aid in the parsing and decoupling of "sequences." 
# Sequences are JSON->Dictionary files created at run-time that are 
# meant to be used as dialogue. 

class_name SequenceParser
extends Node

# root_text: String, conditions: Array
signal deviance_detected(root_text, conditions)

# Parses the given JSON file path and converts it into a Godot-friendly dictionary.
func load_dialogue(file_path: String) -> Dictionary:
	var file = File.new() 
	assert(file.file_exists(file_path))

	file.open(file_path, file.READ)
	var dialogue: Dictionary = parse_json(file.get_as_text())
	assert(dialogue.size() > 0)
	
	return dialogue

# Returns all messages of a sequence, **up to the first point of deviance.**
func get_messages(sequence: Dictionary) -> Array:
	var _message_list: = []
	
	for root in sequence:
		var _message: = get_root_text(sequence[root])
		_message_list.push_back(_message)

		if _root_is_deviant(sequence[root]):
			var _branches: = get_branches(sequence[root])
			var _conditions: = get_conditions(_branches)
			emit_signal("deviance_detected", _message, _conditions)
		
			break

	return _message_list

# Returns all branches of a root.
func get_branches(deviant_branch: Dictionary) -> Dictionary:
	assert(_root_is_deviant(deviant_branch) == true)
	return deviant_branch.branches

# Returns the conditions required to reach a particular root.
func get_conditions(branch_set: Dictionary) -> Array:
	var _res: = []
	for branch in branch_set:
		_res.append(branch_set[branch].condition)

	return _res

# Returns the actual "message" of a root.
func get_root_text(sequence: Dictionary) -> String:
	return sequence.root[Settings.language] 

# Returns the first, *surfacemost* occurance of a deviance in a sequence.
# Rather, it doesn't look beyond the first layer of the given sequence. 
func _get_first_deviance(sequence: Dictionary) -> Dictionary:
	if !_sequence_has_deviance(sequence):
		print_debug("Given sequence has no deviance!")
		return {}
	
	var _res: = {}

	for root in sequence:
		if _root_is_deviant(sequence[root]):
			_res = sequence[root]
			break

	return _res

# Determines if a sequence has a deviant root in it.
func _sequence_has_deviance(sequence: Dictionary) -> bool:
	var _has_deviance: = false
	for root in sequence:
		if _root_is_deviant(sequence[root]):
			_has_deviance = true
	
	return _has_deviance

# Determins if a root is itself deviant.
func _root_is_deviant(root: Dictionary) -> bool:
	return root.branches.size() > 0
