# Autoload that houses the properties of most game options. 

extends Node

const POSSIBLE_LANGUAGES = ["ENG", "SPN"]

var language: String = "ENG"

onready var master_id = AudioServer.get_bus_index("Master")
onready var sfx_id = AudioServer.get_bus_index("SFX")
onready var bgm_id = AudioServer.get_bus_index("BGM") 

func set_language(desired_language: String) -> void:
	if POSSIBLE_LANGUAGES.find(desired_language) == -1:
		print_debug("Invalid language!")

func _set_master_volume(new_volume: float) -> void:
	_set_volume(master_id, new_volume) 

func set_sfx_volume(new_volume: float) -> void:
	_set_volume(sfx_id, new_volume)

func set_bgm_volume(new_volume: float) -> void:
	_set_volume(bgm_id, new_volume)

func _set_volume(bus_id: int, new_volume: float) -> void:
	var db_volume: = linear2db(new_volume)
	AudioServer.set_bus_volume_db(bus_id, db_volume)

func _get_volume(bus_id: int) -> float:
	return db2linear(AudioServer.get_bus_volume_db(bus_id))