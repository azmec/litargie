class_name DialogueButton
extends Button

signal condition_choosen(branch)

var _condition: String = ""
var _root_text: String = ""
var _branch: Dictionary = {}

onready var patchRect: NinePatchRect = $Background

func _ready() -> void:
	self.connect("pressed", self, "_on_pressed")
	_set_child_rect_sizes()

func initialize(branched_sequence: Dictionary) -> void:
	_condition = branched_sequence.condition
	_root_text = branched_sequence.root[Settings.language]
	_branch = branched_sequence

	self.text = _condition
	#_set_child_rect_sizes()

func _set_child_rect_sizes() -> void:
	patchRect.rect_size = self.rect_size

func _on_pressed() -> void:
	emit_signal("condition_choosen", _branch)
