class_name DialogueNameHandle
extends Control

const CHARACTER_LIMIT: int = 45
const CORRECTION_FACTOR: int = 5

var character_name: String = "" setget _set_character_name

onready var rectButton: Button = $RectButton
onready var nameLabel: RichTextLabel = $NameLabel 
onready var background: NinePatchRect = $Background 

func _ready() -> void:
	self.character_name = "Carlos Alejandro Aldana Lira" 

# Sets the name of the label.
func _set_character_name(name: String) -> void:
	print("Hello!")
	nameLabel.bbcode_text = name

	# should be the same thing as bbcode_text 
	# but with the bbcode filtered out
	rectButton.text = nameLabel.text 
	
	yield(get_tree().create_timer(0.1), "timeout") 
	_correct_rect_length()

# Corrects the size of the rect according to the length of the name.
func _correct_rect_length() -> void:
	var _proper_rect_size: = rectButton.rect_size

	self.rect_size = _proper_rect_size
	#background.rect_size = _proper_rect_size
	nameLabel.rect_size = _proper_rect_size

func _is_above_character_limit(name: String) -> bool:
	return name.length() > CHARACTER_LIMIT