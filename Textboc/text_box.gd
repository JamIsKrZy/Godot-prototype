extends MarginContainer

signal finished_displaying

@onready var label: Label = $MarginContainer/Label
@onready var timer: Timer = $LetterDisplayTimer

const MAX_WIDTH := 256

var text: String = ""
var letter_index := 0

var letter_time := 0.03
var space_time := 0.08
var punctuation_time := 0.2

func display_text(text_to_display: String) -> void:
	text = text_to_display
	letter_index = 0
	label.text = ""

	label.text = text
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)

	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y

	global_position.x -= size.x / 2
	global_position.y -= size.y + 24

	label.text = ""
	_display_letter()

func _display_letter() -> void:
	if letter_index >= text.length():
		finished_displaying.emit()
		return

	label.text += text[letter_index]
	letter_index += 1

	var next_char := text[letter_index] if letter_index < text.length() else ""
	match next_char:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)

func _on_letter_display_timer_timeout() -> void:
	_display_letter()
