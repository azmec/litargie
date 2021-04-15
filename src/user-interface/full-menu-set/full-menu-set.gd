# There are a thousand good ways to create functional, 
# fully traversable menus. This is not one of them. Godspeed. 

extends Control

signal playButton_pressed() 

onready var settingsMenu: = $SettingsMenu
onready var settingsBackButton: = $SettingsMenu/Sliding/VolumeSliders/BackButton

onready var mainMenu: = $MainMenu
onready var mainMenuPlayButton: = $MainMenu/Sliding/PrimaryMenu/PlayButton
onready var mainMenuSettingsButton: = $MainMenu/Sliding/PrimaryMenu/SettingsButton
onready var pauseMenu: = $PauseMenu

func _ready() -> void:
	mainMenu.connect("slide_completed", self, "_on_mainMenu_slide_completed")
	mainMenuPlayButton.connect("pressed", self, "_on_mainMenuPlayButton_pressed")
	mainMenuSettingsButton.connect("pressed", self, "_on_mainMenuSettingsButton_pressed")
	settingsBackButton.connect("pressed", self, "_on_settingsBackButton_pressed")

func _all_offscreen() -> bool:
	return mainMenu.is_offscreen() and settingsMenu.is_offscreen() and pauseMenu.is_offscreen()

func _on_mainMenu_slide_completed() -> void:
	# If all of these are offscreen then we know we're
	# just playing the game.
	if _all_offscreen():
		self.visible = false 

func _on_mainMenuPlayButton_pressed() -> void:
	mainMenu.slide_offscreen() 
	emit_signal("playButton_pressed") 

func _on_mainMenuSettingsButton_pressed() -> void:
	mainMenu.slide_offscreen() 
	settingsMenu.slide_onscreen() 

func _on_settingsBackButton_pressed() -> void:
	settingsMenu.slide_offscreen()
	mainMenu.slide_onscreen()
