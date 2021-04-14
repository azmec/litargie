# There has to a better way to do this, but...
# We organize three LabeledSliders here whose values
# we directly connect to the Settings' volume parameters.

extends VBoxContainer

signal backRequested 

onready var masterSlider: = $Master
onready var sfxSlider: = $SFX
onready var bgmSlider: = $BGM 

# In any project worth its salt we wouldn't do this this way.
onready var backButton: = $BackButton

func _ready() -> void:
	masterSlider.connect("value_changed", self, "_on_masterSlider_value_changed")
	sfxSlider.connect("value_changed", self, "_on_sfxSlider_value_changed")
	bgmSlider.connect("value_changed", self, "_on_bgmSlider_value_changed")

	backButton.connect("pressed", self, "_on_backButton_pressed")

func _on_masterSlider_value_changed(value: float) -> void:
	Settings.master_volume = value

func _on_sfxSlider_value_changed(value: float) -> void:
	Settings.sfx_volume = value

func _on__on_bgmSlider_value_changed(value: float) -> void:
	Settings.bgm_volume = value

func _on_backButton_pressed() -> void:
	emit_signal("backRequested")
