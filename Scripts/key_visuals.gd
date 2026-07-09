extends Resource

# ---------------------------------- #

const KEY_WIDTH := 100
const KEY_HEIGHT := 100
const ROW_OFFSETS := [0, 60, 90, 150]  # Attempts to match a real board
const KEY_LAYOUT := {
	KEY_1:[0,0], KEY_2:[0,1], KEY_3:[0,2], KEY_4:[0,3], KEY_5:[0,4],
	KEY_6:[0,5], KEY_7:[0,6], KEY_8:[0,7], KEY_9:[0,8], KEY_0:[0,9],
	KEY_MINUS:[0,10], KEY_EQUAL:[0,11], KEY_BACKSPACE:[0,12],

	KEY_Q:[1,0], KEY_W:[1,1], KEY_E:[1,2], KEY_R:[1,3], KEY_T:[1,4],
	KEY_Y:[1,5], KEY_U:[1,6], KEY_I:[1,7], KEY_O:[1,8], KEY_P:[1,9],
	KEY_BRACKETLEFT:[1,10], KEY_BRACKETRIGHT:[1,11], KEY_BACKSLASH:[1,12],

	KEY_A:[2,0], KEY_S:[2,1], KEY_D:[2,2], KEY_F:[2,3], KEY_G:[2,4],
	KEY_H:[2,5], KEY_J:[2,6], KEY_K:[2,7], KEY_L:[2,8], 
	KEY_SEMICOLON:[2,9], KEY_APOSTROPHE:[2,10], KEY_ENTER:[2,11],
	
	KEY_Z:[3,0], KEY_X:[3,1], KEY_C:[3,2], KEY_V:[3,3], KEY_B:[3,4],
	KEY_N:[3,5], KEY_M:[3,6], KEY_COMMA:[3,7], KEY_PERIOD:[3,8],
	
	KEY_SPACE:[4,0]
}

# ---------------------------------- #

var origin := Vector2(100,100) # placeholder for now

# ---------------------------------- #

func set_origin_from_screen_size(screen_size: Vector2) -> void:
	origin = Vector2(screen_size.x / 2.0 - 540, screen_size.y - 520 - 40)
	print(origin)

func is_typable(keycode: int) -> bool: # Checks if the keypress is an alpha/number, not a modifier (except for spacebar) 
	return keycode in KEY_LAYOUT

func position_for_key(keycode: int) -> Vector2:
	if keycode == KEY_SPACE:
		return origin + Vector2(5.5 * KEY_WIDTH, 4 * KEY_HEIGHT)
	if KEY_LAYOUT.has(keycode):
		var rc = KEY_LAYOUT[keycode]
		return origin + Vector2(ROW_OFFSETS[rc[0]] + rc[1] * KEY_WIDTH, rc[0] * KEY_HEIGHT)
	return origin + Vector2(5 * KEY_WIDTH, 2 * KEY_HEIGHT)

func color_for_key(keycode: int) -> Color:
	if keycode == KEY_SPACE:
		return Color(0.3, 0.9, 0.4, 1)   # spacebar
	if keycode >= KEY_0 and keycode <= KEY_9:
		return Color(0.3, 0.6, 1.0, 1)   # numbers
	return Color(1.0, 0.7, 0.2, 1)   # alphas
