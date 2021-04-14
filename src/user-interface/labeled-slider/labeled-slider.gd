tool
extends HSlider

export (String) var parameter: = ""

onready var panel: = $Panel
onready var label: = $Label

func _ready() -> void:
	panel.rect_size.x = label.rect_size.x
	label.text = parameter 

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		panel.rect_size.x = label.rect_size.x
		label.text = parameter