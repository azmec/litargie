class_name PauseCalculator
extends Node

signal pause_requested(duration)

# Regular expresion to find pauses in given source
const PAUSE_PATTERN: = "({p=\\d([.]\\d+)?[}])"

# Other regular expressions to clean up the source
const CUSTOM_TAG_PATTERN: = ("({(.*?)})")

var _pause_regex: = RegEx.new()
var _pauses: = []

func _ready() -> void:
	_pause_regex.compile(PAUSE_PATTERN)

func parse_pauses(source: String) -> String:
	_pauses = []
	_find_pauses(source)
	return _extract_tags(source)

func check_at_position(position: int) -> void:
	for _pause in _pauses:
		if _pause.position == position:
			emit_signal("pause_requested", _pause.duration)
	
func _find_pauses(source: String) -> void:
	var _found_pauses: = _pause_regex.search_all(source)
	for _result in _found_pauses:
		var _tag_string: String = _result.get_string()
		var _tag_position: int = _adjust_position(_result.get_start(), source)
		var _pause = Pause.new(_tag_position, _tag_string)
		_pauses.append(_pause)

func _extract_tags(source: String) -> String:
	var _custom_regex = RegEx.new()
	_custom_regex.compile("({(.*?)})")
	return _custom_regex.sub(source, "", true)

func _adjust_position(position: int, source: String) -> int:
	var _custom_tag_regex: = RegEx.new()
	_custom_tag_regex.compile(CUSTOM_TAG_PATTERN)

	var _new_position: = position
	var _left_of_position: = source.left(position)
	var _all_previous_tags: = _custom_tag_regex.search_all(_left_of_position)

	for _tag in _all_previous_tags:
		_new_position -= _tag.get_string().length()

	return _new_position
