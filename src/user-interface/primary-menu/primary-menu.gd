extends VBoxContainer

signal playRequested()
signal settingsRequested() 

onready var playButton: = $PlayButton
onready var settingsButton: = $SettingsButton 

func _ready() -> void:
	playButton.connect("pressed", self, "_on_playButton_pressed")
	settingsButton.connect("pressed", self, "_on_settingsButton_pressed")

func _on_playButton_pressed() -> void:
	emit_signal("playRequested") 

func _on_settingsButton_pressed() -> void:
	emit_signal("settingsRequested")