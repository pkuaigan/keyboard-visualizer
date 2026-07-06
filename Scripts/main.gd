extends Node2D

const KEY_PARTICLE = preload("res://Scenes/KeyParticle.tscn")

const KEY_WIDTH := 60
const KEY_HEIGHT := 60
const ROW_OFFSETS := [0, 30, 45, 75]  # stagger per row, roughly matches a real board

@onready var particles_container : Node2D = $ParticlesContainer

const KEY_LAYOUT := {
	KEY_1:[0,0], KEY_2:[0,1], KEY_3:[0,2], KEY_4:[0,3], KEY_5:[0,4],
	KEY_6:[0,5], KEY_7:[0,6], KEY_8:[0,7], KEY_9:[0,8], KEY_0:[0,9],

	KEY_Q:[1,0], KEY_W:[1,1], KEY_E:[1,2], KEY_R:[1,3], KEY_T:[1,4],
	KEY_Y:[1,5], KEY_U:[1,6], KEY_I:[1,7], KEY_O:[1,8], KEY_P:[1,9],

	KEY_A:[2,0], KEY_S:[2,1], KEY_D:[2,2], KEY_F:[2,3], KEY_G:[2,4],
	KEY_H:[2,5], KEY_J:[2,6], KEY_K:[2,7], KEY_L:[2,8],

	KEY_Z:[3,0], KEY_X:[3,1], KEY_C:[3,2], KEY_V:[3,3], KEY_B:[3,4],
	KEY_N:[3,5], KEY_M:[3,6],
}

const MODIFIER_KEYS := [KEY_SHIFT, KEY_CTRL, KEY_ALT, KEY_TAB, KEY_ENTER, KEY_BACKSPACE, KEY_ESCAPE, KEY_CAPSLOCK]

var origin := Vector2(200, 200)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		_spawn_for_key(event.keycode)

func _spawn_for_key(keycode: int) -> void:
	var particle := KEY_PARTICLE.instantiate()
	particles_container.add_child(particle)
	particle.global_position = _position_for_key(keycode)
	particle.setup(_color_for_key(keycode))

func _position_for_key(keycode: int) -> Vector2:
	if keycode == KEY_SPACE:
		return origin + Vector2(4 * KEY_WIDTH, 4 * KEY_HEIGHT)
	if KEY_LAYOUT.has(keycode):
		var rc = KEY_LAYOUT[keycode]
		return origin + Vector2(ROW_OFFSETS[rc[0]] + rc[1] * KEY_WIDTH, rc[0] * KEY_HEIGHT)
	if keycode in MODIFIER_KEYS:
		return origin + Vector2(-KEY_WIDTH * 1.5, 4 * KEY_HEIGHT)
	return origin + Vector2(5 * KEY_WIDTH, 2 * KEY_HEIGHT)

func _color_for_key(keycode: int) -> Color:
	if keycode == KEY_SPACE:
		return Color(0.3, 0.9, 0.4)   # green
	if keycode in MODIFIER_KEYS:
		return Color(0.6, 0.4, 0.9)   # purple
	if keycode >= KEY_0 and keycode <= KEY_9:
		return Color(0.3, 0.6, 1.0)   # blue
	return Color(1.0, 0.7, 0.2)       # warm orange, letters
