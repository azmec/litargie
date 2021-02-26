extends Control

const WAIT_TIME: = 0.1
const TEXT_SPEED: = 0.05

var _dialogue_queue: Array = []
var _animation_finished: bool = false

onready var textPanel: = $Text
onready var scrollBar = textPanel.get_v_scroll()
onready var nextIndicator: = $NextIndicator
onready var waitTimer: = $WaitTimer
onready var textTimer: = $TextTimer

func _ready() -> void:
	textTimer.connect("timeout", self, "_on_textTimer_timeout")
	waitTimer.connect("timeout", self, "_on_waitTimer_timeout")
	insert_dialogue_array([
		"Hello.",
		"This is a dialogue box.",
		"Hope you had fun waiting for that laptop.",
		"One problem is that text can get too big for the box to contain, in which case we need to start making things look pretty."
	])
	display_dialogue()

func _process(_delta: float) -> void:
	print(scrollBar.value)
	if _animation_finished:
		nextIndicator.show()
	else:
		nextIndicator.hide()

	if Input.is_action_just_pressed("ui_accept"):
		if _animation_finished:
			if waitTimer.is_stopped():
				if _dialogue_queue:
					_display_next_dialogue()
				else:
					self.hide()
		else:
			waitTimer.start(WAIT_TIME)
			textPanel.percent_visible = 1
			_animation_finished = true
		
func display_dialogue() -> void:
	if _dialogue_queue:
		self.show()
		_display_next_dialogue()
	else:
		self.hide()

func insert_dialogue_array(dialogue_array: Array) -> void:
	for part in dialogue_array:
		if part is String:
			_dialogue_queue.push_back(part)
		else:
			print_debug("Give part of dialogue isn't a string! Erasing...")
			dialogue_array.remove(part)
		
func insert_new_dialogue(text: String) -> void:
	_dialogue_queue.push_back(text) 

func _display_next_dialogue() -> void:
	var new_dialogue = _dialogue_queue.pop_front()
	_set_new_text(new_dialogue) 
	_animate_dialogue()

func _set_new_text(new_text: String) -> void:
	textPanel.bbcode_text = new_text
	textPanel.percent_visible = 0

func _animate_dialogue() -> void:
	_animation_finished = false
	# duration should be a constant that the player can set
	textTimer.start(TEXT_SPEED)	

func _on_textTimer_timeout() -> void:
	if textPanel.visible_characters < len(textPanel.bbcode_text):
		textPanel.visible_characters += 1
		scrollBar.value = textPanel.get_visible_line_count() * 8
		textTimer.start(TEXT_SPEED)
	else:
		textPanel.visible_characters = -1
		waitTimer.start(WAIT_TIME)
		

func _on_waitTimer_timeout() -> void:
	_animation_finished = true
