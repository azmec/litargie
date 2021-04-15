# Extension of button that automatically plays "hover" or
# "selected" sound effects when relevant. 

extends Button

onready var hoverSFX: = $Hover
onready var pressedSFX: = $Pressed

func _ready() -> void:
	self.connect("pressed", self, "_on_pressed")
	self.connect("mouse_entered", self, "_on_mouse_entered")

func _on_pressed() -> void:
	pressedSFX.play()

func _on_mouse_entered() -> void:
	hoverSFX.play()