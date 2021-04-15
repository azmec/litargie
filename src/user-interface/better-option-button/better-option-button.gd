# Extension of OptionButton that allows the user to 
# create *String* options in editor. 

class_name BetterOptionButton
extends OptionButton

export (Array, String) var options = []

func _ready() -> void:
	for option in options:
		self.add_item(option)
