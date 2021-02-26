class_name Dialogue
extends Control

const TYPING_SPEED: = 0.04 # the rate at which characters appear

onready var pauseCalculator: PauseCalculator = $PauseCalculator
onready var content: RichTextLabel = $Text
onready var typeTimer: Timer = $TypeTimer
onready var pauseTimer: Timer = $PauseTimer

# remove later
func _ready() -> void:
	typeTimer.connect("timeout", self, "_on_typeTimer_timeout")
	pauseCalculator.connect("pause_requested", self, "_on_pauseCalculator_pause_requested")
	pauseTimer.connect("timeout", self, "_on_pauseTimer_timeout")
	yield(get_tree().create_timer(1.0), "timeout")
	update_text("Hi!{p=0.5} Nice pause... {p=0.5}right?")

# Update the content and type out the provided text..
func update_text(text: String) -> void:
	content.bbcode_text = pauseCalculator.parse_pauses(text)
	content.visible_characters = 0
	typeTimer.start(TYPING_SPEED)

func _on_typeTimer_timeout() -> void:
	pauseCalculator.check_at_position(content.visible_characters)
	if content.visible_characters < content.text.length():
		content.visible_characters += 1
	else:
		typeTimer.stop()

func _on_pauseCalculator_pause_requested(duration: float) -> void:
	#something about a voice here
	typeTimer.stop()
	pauseTimer.wait_time = duration
	pauseTimer.start()

func _on_pauseTimer_timeout() -> void:
	#something about a voice here
	typeTimer.start(TYPING_SPEED)