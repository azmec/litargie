extends VBoxContainer

onready var languageOptions: = $LanguageOptions 

func _ready() -> void:
	languageOptions.connect("item_selected", self, "_on_languageOptions_item_selected") 

func _on_languageOptions_item_selected(index: int) -> void:
	match index:
		0:
			Settings.language = "en"
		1: 
			Settings.language = "es"
