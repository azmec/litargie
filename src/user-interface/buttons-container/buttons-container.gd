class_name ButtonContainer
extends VBoxContainer

const DIALOGUE_BUTTON_SCENCE: = preload("res://src/user-interface/dialogue-button/dialogue-button.tscn")

func add_button(branch_data: Dictionary) -> void:
	var new_button: = DIALOGUE_BUTTON_SCENCE.instance()
	new_button.initialize(branch_data)
	new_button.connect("condition_choosen", DialogueGod, "_on_condition_choosen")

	self.add_child(new_button)

func clear_buttons() -> void:
	var _buttons: = self.get_children()
	for b in _buttons: 
		b.disconnect("condition_choosen", DialogueGod, "_on_condition_choosen")
		b.queue_free()