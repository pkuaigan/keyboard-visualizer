extends Node2D

var radius := 0
var time := 0.0
var color := Color.WHITE
var alpha := 1.0

func setup(p_color: Color, intensity: float) -> void:
	color = p_color
	var tween := create_tween()
	tween.set_parallel(true)
	_get_properties(intensity)
	tween.tween_method(_set_radius, 1.0, radius, time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_method(_set_alpha, 1.0, 0.0, time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(queue_free)

func _set_radius(r: int) -> void:
	radius = r
	queue_redraw()

func _set_alpha(a: float) -> void:
	alpha = a
	queue_redraw()

func _get_properties(intensity: float) -> void: # tweak
	if intensity > 0.95: # maybe a skill issue but only get .95 when mashing keys vs actually typing so larger radius.... the small radius for mashing looks silly
		radius = 200
		time = 0.1
	if intensity > 0.9:
		radius = 75
		time = 0.3
	elif intensity > 0.8:
		radius = 90
		time = 0.5
	elif intensity > 0.75:
		radius = 120
		time = 0.7
	else:
		radius = 150
		time = 0.75
		

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color(color.r, color.g, color.b, alpha))
