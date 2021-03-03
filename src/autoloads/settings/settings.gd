# Autoload that houses the properties of most game options. 

extends Node

const POSSIBLE_LANGUAGES = ["ENG", "SPN"]
var language: String = "ENG"

func set_language(desired_language: String) -> void:
	if POSSIBLE_LANGUAGES.find(desired_language) == -1:
		print_debug("Invalid language!")
