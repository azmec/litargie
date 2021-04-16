# There are a thousand good ways to create functional, 
# fully traversable menus. This is not one of them. Godspeed. 

extends Control

signal playButton_pressed() 

signal pause_requested()
signal pause_exited()

signal restart_requested()
signal level_restart_requested()

var _current_menu: SlidingMenu
var _previous_menu: SlidingMenu

onready var mainMenu: = $MainMenu
onready var mainMenuPlayButton: = $MainMenu/Sliding/PrimaryMenu/PlayButton
onready var mainMenuSettingsButton: = $MainMenu/Sliding/PrimaryMenu/SettingsButton

onready var settingsMenu: = $SettingsMenu
onready var settingsBackButton: = $SettingsMenu/Sliding/VolumeSliders/BackButton

onready var pauseMenu: = $PauseMenu
onready var pauseMenuResumeButton: = $PauseMenu/Sliding/PauseMenu/ResumeButton
onready var pauseMenuRestartButton: = $PauseMenu/Sliding/PauseMenu/RestartGame 
onready var pauseMenuSettingsButton: = $PauseMenu/Sliding/PauseMenu/SettingsButton
onready var pauseMenuRestartLevelButton: = $PauseMenu/Sliding/PauseMenu/RestartLevel

func _ready() -> void:
	mainMenu.connect("slide_completed", self, "_slide_completed")	
	mainMenuPlayButton.connect("pressed", self, "_on_mainMenuPlayButton_pressed")
	mainMenuSettingsButton.connect("pressed", self, "_on_mainMenuSettingsButton_pressed")
	
	settingsBackButton.connect("pressed", self, "_on_settingsBackButton_pressed")
	
	pauseMenu.connect("slide_completed", self, "_on_slide_completed")
	pauseMenuResumeButton.connect("pressed", self, "_on_pauseMenuResumeButton_pressed")
	pauseMenuRestartButton.connect("pressed", self, "_on_pauseMenuRestartButton_pressed")
	pauseMenuSettingsButton.connect("pressed", self, "_on_pauseMenuSettingsButton_pressed")
	pauseMenuRestartLevelButton.connect("pressed", self, "_on_pauseMenuRestartLevelButton_pressed")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and _all_offscreen():
		self.visible = true
		pauseMenu.slide_onscreen()

		emit_signal("pause_requested")
	elif Input.is_action_just_pressed("pause") and not pauseMenu.is_offscreen():
		pauseMenu.slide_offscreen()
		emit_signal("pause_exited")
	
func _all_offscreen() -> bool:
	return mainMenu.is_offscreen() and settingsMenu.is_offscreen() and pauseMenu.is_offscreen()

# Swaps the two given menus; slides the first offscreen
# and the second onscreen.
func _switch(menuA: SlidingMenu, menuB: SlidingMenu) -> void:
	menuA.slide_offscreen()
	menuB.slide_onscreen()

	_previous_menu = menuA
	_current_menu = menuB

func _on_slide_completed() -> void:
	# If all of these are offscreen then we know we're
	# just playing the game.
	if _all_offscreen():
		self.visible = false 

func _on_mainMenuPlayButton_pressed() -> void:
	mainMenu.slide_offscreen() 
	emit_signal("playButton_pressed") 

	_previous_menu = mainMenu
	_current_menu = null

	self.visible = false

func _on_mainMenuSettingsButton_pressed() -> void:
	_switch(mainMenu, settingsMenu)

func _on_settingsBackButton_pressed() -> void:
	_switch(settingsMenu, _previous_menu)

func _on_pauseMenuResumeButton_pressed() -> void: 
	pauseMenu.slide_offscreen()
	emit_signal("pause_exited")

	_previous_menu = pauseMenu
	_current_menu = null

func _on_pauseMenuRestartButton_pressed() -> void:
	emit_signal("restart_requested") 

func _on_pauseMenuSettingsButton_pressed() -> void:
	_switch(pauseMenu, settingsMenu)

func _on_pauseMenuRestartLevelButton_pressed() -> void:
	emit_signal("level_restart_requested")
