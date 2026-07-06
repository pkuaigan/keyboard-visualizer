extends Node2D

var radius := 10.0
var color := Color.WHITE
var alpha := 1.0

func setup(p_color: Color) -> void:
	color = p_color
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_method(_set_radius, 10.0, 60.0, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_method(_set_alpha, 1.0, 0.0, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(queue_free)

func _set_radius(r: float) -> void:
	radius = r
	queue_redraw()

func _set_alpha(a: float) -> void:
	alpha = a
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color(color.r, color.g, color.b, alpha))
