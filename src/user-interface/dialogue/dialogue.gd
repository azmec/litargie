class_name Dialogue
extends Control

signal message_completed()

const TYPING_SPEED: = 0.04 # the rate at which characters appear
const BLINKING_SPEED: = 0.5 # rate at which the indicator blinks 

onready var pauseCalculator: PauseCalculator = $PauseCalculator

onready var content: RichTextLabel = $Text
onready var blinker: TextureRect = $Blinker

onready var typeTimer: Timer = $TypeTimer
onready var pauseTimer: Timer = $PauseTimer
onready var blinkerTimer: Timer = $BlinkerTimer

# remove later
func _ready() -> void:
	typeTimer.connect("timeout", self, "_on_typeTimer_timeout")
	pauseCalculator.connect("pause_requested", self, "_on_pauseCalculator_pause_requested")
	pauseTimer.connect("timeout", self, "_on_pauseTimer_timeout")
	blinkerTimer.connect("timeout", self, "_on_blinkerTimer_timeout")

	self.rect_size = Vector2(208, 36)

# Update the content and type out the provided text..
func update_text(text: String) -> void:
	blinkerTimer.stop()
	blinker.visible = false

	content.bbcode_text = pauseCalculator.parse_pauses(text)
	content.visible_characters = 0
	typeTimer.start(TYPING_SPEED)

func message_is_fully_visible() -> bool:
	return content.visible_characters == content.text.length() 

func _on_typeTimer_timeout() -> void:
	pauseCalculator.check_at_position(content.visible_characters)
	if content.visible_characters < content.text.length():
		content.visible_characters += 1
	else:
		emit_signal("message_completed")
		blinker.visible = true
		blinkerTimer.start(BLINKING_SPEED)
		typeTimer.stop()

func _on_pauseCalculator_pause_requested(duration: float) -> void:
	#something about a voice here
	typeTimer.stop()
	pauseTimer.wait_time = duration
	pauseTimer.start()

func _on_pauseTimer_timeout() -> void:
	#something about a voice here
	typeTimer.start(TYPING_SPEED)

func _on_blinkerTimer_timeout() -> void:
	blinker.visible = not blinker.visible
