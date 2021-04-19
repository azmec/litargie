# Autoload that houses the properties of most game options. 

extends Node

const POSSIBLE_LANGUAGES = ["en", "es"]

var language: String = "en" setget _set_language

var master_volume: float = 1.0 setget _set_master_volume
var sfx_volume: float = 1.0 setget _set_sfx_volume
var bgm_volume: float = 1.0 setget _set_bgm_volume

onready var master_id = AudioServer.get_bus_index("Master")
onready var sfx_id = AudioServer.get_bus_index("SFX")
onready var bgm_id = AudioServer.get_bus_index("BGM") 

func _set_language(value: String) -> void:
	if POSSIBLE_LANGUAGES.find(value) == -1:
		print_debug('"' + value + '" is not a valid language.')

	TranslationServer.set_locale(value)
	language = value

func _set_master_volume(value: float) -> void:
	_set_volume(master_id, value) 

func _set_sfx_volume(value: float) -> void:
	_set_volume(sfx_id, value)

func _set_bgm_volume(value: float) -> void:
	_set_volume(bgm_id, value)

func _set_volume(bus_id: int, new_volume: float) -> void:
	var db_volume: = linear2db(new_volume)
	AudioServer.set_bus_volume_db(bus_id, db_volume)