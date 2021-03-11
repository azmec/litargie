extends Control

onready var startButton: = $HBoxContainer/VBoxContainer/StartButton
onready var settingsButton: = $HBoxContainer/VBoxContainer/SettingsButton 
onready var aboutButton: = $HBoxContainer/VBoxContainer/AboutButton

func _ready() -> void:
	startButton.connect("pressed", self,"_on_button_pressed", [startButton.scene])
	settingsButton.connect("pressed", self, "_on_button_pressed", [settingsButton.scene])
	aboutButton.connect("pressed", self, "_on_button_pressed", [aboutButton.scene]) 

func _on_button_pressed(scene_path: String) -> void:
	var _scene: Node = load(scene_path).instance()
	get_parent().add_child(_scene)
	call_deferred("queue_free")