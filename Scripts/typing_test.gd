extends Control

const LOREM_IPSUM = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lobortis varius sem, non auctor nisi dapibus sit amet. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc aliquet nulla vitae ligula interdum, vitae dictum nisi pulvinar. Mauris tincidunt rhoncus pulvinar. Proin non sem sit amet turpis ultrices luctus in ut metus. Vestibulum in augue vitae lorem posuere bibendum et at massa. Cras nec sem pellentesque, facilisis leo non, ultrices eros."
const GREEN = Color(0.1,0.9,0.5)
const GREY = Color(0.8,0.8,1)
const RED = Color(0.9,0.2,0.3)

var target = []
var states = []
var letters_typed : int
var total_letters : int

func _ready(): # this code will be moved out of _ready() when we randomize text
	target = LOREM_IPSUM
	total_letters = len(target)
	letters_typed = 0
	states.resize(letters_typed)
	for i in total_letters:
		states[i] = ""
	print(target, states)
	

func _unhandled_input(event: InputEvent) -> void:
	if (not (event is InputEventKey) or not event.pressed) and (letters_typed < total_letters):
		var typed_char = char(event.unicode)
		if typed_char == target[letters_typed]:
			states[letters_typed] = true
		else:
			states[letters_typed] = false
		letters_typed += 1
		return
	if event.echo:
		return
