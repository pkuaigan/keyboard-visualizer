extends Node2D

# ---------------------------------- #

const KEY_PARTICLE = preload("res://Scenes/KeyParticle.tscn")
const KEY_VISUALS = preload("res://Scripts/key_visuals.gd")
const RHYTHM_TRACKER = preload("res://Scripts/rhythm_tracker.gd")

# ---------------------------------- #

@onready var key_visuals := KEY_VISUALS.new()
@onready var rhythm := RHYTHM_TRACKER.new()
@onready var particles_container : Node2D = $ParticlesContainer

# ---------------------------------- #

func _ready() -> void:
	key_visuals.set_origin_from_screen_size(get_viewport_rect().size)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if key_visuals.is_typable(event.keycode):
			_spawn_for_key(event.keycode)

func _spawn_for_key(keycode: int) -> void:
	var particle := KEY_PARTICLE.instantiate()
	var intensity : float = rhythm.get_intensity()
	print(intensity)
	particles_container.add_child(particle)
	particle.global_position = key_visuals.position_for_key(keycode)
	particle.setup(key_visuals.color_for_key(keycode), intensity)
