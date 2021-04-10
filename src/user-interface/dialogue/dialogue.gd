class_name Dialogue
extends Control

signal message_completed()

const CHARACTER_LIMIT: = 140
const TYPING_SPEED: = 0.04 # the rate at which characters appear
const BLINKING_SPEED: = 0.5 # rate at which the indicator blinks 

var _playing_voice: bool = false
var _sync_voice_to_text: bool = true

onready var pauseCalculator: PauseCalculator = $PauseCalculator

onready var content: RichTextLabel = $Text
onready var blinker: TextureRect = $Blinker

onready var typeTimer: Timer = $TypeTimer
onready var pauseTimer: Timer = $PauseTimer
onready var blinkerTimer: Timer = $BlinkerTimer

onready var background: NinePatchRect = $Background
onready var voicePlayer: VariableSFXPlayer = $DialogueVoicePlayer
onready var nameHandle: DialogueNameHandle = $DialogueNameHandle

func _ready() -> void:
	typeTimer.connect("timeout", self, "_on_typeTimer_timeout")
	pauseCalculator.connect("pause_requested", self, "_on_pauseCalculator_pause_requested")
	pauseTimer.connect("timeout", self, "_on_pauseTimer_timeout")
	blinkerTimer.connect("timeout", self, "_on_blinkerTimer_timeout")
	voicePlayer.connect("finished", self, "_on_voicePlayer_finished") 

func _process(_delta: float) -> void: 
	self.rect_size = Vector2(208, 36)
	background.rect_size = self.rect_size

# Update the content and type out the provided text.
func update_text(text: String) -> void:
	blinkerTimer.stop()
	blinker.visible = false

	content.bbcode_text = pauseCalculator.parse_pauses(text)

	if _is_above_character_limit(content.text):
		print_debug('Message "' + content.text + '" is above the character limit!')
	
	content.visible_characters = 0
	typeTimer.start(TYPING_SPEED)

	voicePlayer.play(0.0)
	_playing_voice = true

func set_name(new_name: String) -> void:
	nameHandle.character_name = new_name

func message_is_fully_visible() -> bool:
	return content.visible_characters == content.text.length() 

func toggle_panel(value: bool) -> void:
	blinker.visible = value
	nameHandle.visible = value 
	background.visible = value

func _is_above_character_limit(message: String) -> bool:
	return message.length() > CHARACTER_LIMIT

func _on_typeTimer_timeout() -> void:
	pauseCalculator.check_at_position(content.visible_characters)
	if content.visible_characters < content.text.length():
		if _sync_voice_to_text:
			voicePlayer.play(0.0) 
		
		content.visible_characters += 1
	else:
		emit_signal("message_completed")
		_playing_voice = false
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

func _on_voicePlayer_finished() -> void:
	if _playing_voice and not _sync_voice_to_text:
		voicePlayer.play(0)
