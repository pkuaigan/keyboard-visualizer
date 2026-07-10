extends Control

const LOREM_IPSUM = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lobortis varius sem, non auctor nisi dapibus sit amet. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc aliquet nulla vitae ligula interdum, vitae dictum nisi pulvinar. Mauris tincidunt rhoncus pulvinar. Proin non sem sit amet turpis ultrices luctus in ut metus. Vestibulum in augue vitae lorem posuere bibendum et at massa. Cras nec sem pellentesque, facilisis leo non, ultrices eros."
const GREEN = "#1ae580"
const GREY = "#ccccff"
const RED = "#e63350"

@onready var text_label : RichTextLabel = %Text

enum CharState { UNTYPED, CORRECT, INCORRECT }

var target : String = ""
var output_text : String = ""
var states : Array = []
var letters_typed : int
var total_letters : int

func _handle_colours():
	output_text = ""
	for i in total_letters:
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
	print(target, states)

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
	if event.unicode == 0:
		return

	var typed_char = char(event.unicode)
	if typed_char == target[letters_typed]:
		states[letters_typed] = CharState.CORRECT
	else:
		states[letters_typed] = CharState.INCORRECT
	letters_typed += 1
	_handle_colours()
