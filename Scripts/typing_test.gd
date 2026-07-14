extends Control

const LOREM_IPSUM = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lobortis varius sem, non auctor nisi dapibus sit amet. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc aliquet nulla vitae ligula interdum, vitae dictum nisi pulvinar. Mauris tincidunt rhoncus pulvinar. Proin non sem sit amet turpis ultrices luctus in ut metus. Vestibulum in augue vitae lorem posuere bibendum et at massa. Cras nec sem pellentesque, facilisis leo non, ultrices eros."
const GREEN = "#1ae580"
const GREY = "#ccccff"
const RED = "#e63350"

@onready var text_label : RichTextLabel = %Text

enum CharState { UNTYPED, CORRECT, INCORRECT }

var target : String = "" # Source of truth, we must check against this
var output_text : String = "" # Text shown to user with bbcode tags
var letters_typed : int # Keeps track of where the user is
var total_letters : int # Keeps track of the total amount of letters in the text -- might be irrelevant when we add randomization?
var slice : Array = []
var states : Array = []
var line_starts : Array = []

func _split_text():
	var temp : String
	for i in target:
		if i == " ":
			slice.append(temp)
			temp = ""
		else:
			temp += i
	slice.append(temp)
	return slice

func _greedy_lines():
	await get_tree().process_frame
	var font = text_label.get_theme_font("normal_font")
	var font_size = text_label.get_theme_font_size("normal_font_size")
	var horizontal_size = text_label.size.x

	var current_line : String = ""
	var current_line_start_index : int = 0
	var character_cursor : int = 0

	for word in slice:
		if font.get_string_size(current_line + " " + word, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x <= horizontal_size:
			current_line = current_line + " " + word
		else: 
			line_starts.append(current_line_start_index)
			current_line = word
			current_line_start_index = character_cursor
		character_cursor += word.length() + 1 # +1 accounts for the space
	line_starts.append(current_line_start_index)



func _handle_colours():
	output_text = ""
	for i in total_letters:
		if i in line_starts:
			output_text += "\n"

		if states[i] == CharState.UNTYPED:
			output_text += "[color=" + GREY + "]" + target[i] + "[/color]"
		elif states[i] == CharState.CORRECT:
			output_text += "[color=" + GREEN + "]" + target[i] + "[/color]"
		elif states[i] == CharState.INCORRECT:
			output_text += "[color=" + RED + "]" + target[i] + "[/color]"

func _ready(): # this code will be moved out of _ready() when we randomize text
	target = LOREM_IPSUM
	output_text = target
	total_letters = len(target)
	letters_typed = 0
	states.resize(total_letters)
	for i in total_letters:
		states[i] = CharState.UNTYPED
	_split_text()
	await _greedy_lines()
	_handle_colours()

func _process(_float) -> void:
	text_label.text = output_text

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return
	if not event.pressed:
		return
	if event.echo:
		return
	if letters_typed >= total_letters:
		return
		
	if letters_typed > 0 and event.keycode == KEY_BACKSPACE:
		if states[letters_typed-1] == CharState.CORRECT:
			return
		else:
			letters_typed -= 1
			states[letters_typed] = CharState.UNTYPED
			_handle_colours()
			return
		
	if event.unicode == 0:
		return

	var typed_char = char(event.unicode)
	if typed_char == target[letters_typed]:
		states[letters_typed] = CharState.CORRECT
	else:
		states[letters_typed] = CharState.INCORRECT
	letters_typed += 1
	_handle_colours()
	_greedy_lines()
