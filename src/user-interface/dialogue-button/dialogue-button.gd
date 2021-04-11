class_name DialogueButton
extends Button

const CHARACTER_LIMIT: = 18

signal condition_choosen(branch)

var _condition: String = ""
var _root_text: String = ""
var _branch: Dictionary = {}

onready var patchRect: NinePatchRect = $Background

func _ready() -> void:
	self.connect("pressed", self, "_on_pressed")
	_set_child_rect_sizes()

func initialize(branched_sequence: Dictionary) -> void:
	_condition = branched_sequence.condition[Settings.language]
	_root_text = branched_sequence.message[Settings.language]
	_branch = branched_sequence

	if _is_above_character_limit(_condition):
		print_debug('Condition "' + _condition + '" is above the character limit!')

	self.text = _condition
	#_set_child_rect_sizes()

func _is_above_character_limit(condition: String) -> bool:
	return condition.length() > CHARACTER_LIMIT

func _set_child_rect_sizes() -> void:
	patchRect.rect_size = self.rect_size

func _on_pressed() -> void:
	emit_signal("condition_choosen", _branch)
