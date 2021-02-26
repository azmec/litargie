class_name PauseCalculator
extends Node

signal pause_requested(duration)

const PAUSE_PATTERN: = "({p=\\d([.]\\d+)?[}])"

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
		var _tag_position: int = _result.get_start()

		var _pause = Pause.new(_tag_position, _tag_string)
		_pauses.append(_pause)

func _extract_tags(source: String) -> String:
	var _custom_regex = RegEx.new()
	_custom_regex.compile("({(.*?)})")
	return _custom_regex.sub(source, "", true)
