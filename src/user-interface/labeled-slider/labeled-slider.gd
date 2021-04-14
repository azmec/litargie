# HSlider which as an exportable label above it and 
# emits audible feedback when interacted with. 

tool
extends HSlider

export (String) var parameter: = ""

onready var panel: = $Panel
onready var label: = $Label

onready var hoverSFX: = $Hover
onready var pressedSFX: = $Pressed

func _ready() -> void:
	self.connect("value_changed", self, "_on_value_changed")
	self.connect("mouse_entered", self, "_on_mouse_entered") 

	panel.rect_size.x = label.rect_size.x
	label.text = parameter 

func _process(_delta: float) -> void:
	if Engine.editor_hint:
		panel.rect_size.x = label.rect_size.x
		label.text = parameter

func _on_value_changed(_value: float) -> void:
	pressedSFX.play()

func _on_mouse_entered() -> void:
	hoverSFX.play()