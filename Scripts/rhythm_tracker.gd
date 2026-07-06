extends Resource

@export var fast_threshold := 60.0
@export var slow_threshold := 500.0
@export var weight := 0.3
@export var neutral_intensity := 0.5

var last_keystroke_time : float = -1 ## remember to add something that resets this later, keep still for now tho
var smoothed_intensity := 0.5

func get_intensity():
	var now = Time.get_ticks_msec()
	if last_keystroke_time == -1:
		last_keystroke_time = now
		smoothed_intensity = neutral_intensity
		return smoothed_intensity
	
	var gap := float(now - last_keystroke_time)
	last_keystroke_time = now
	
	if gap >= 2000: # Reset,, ie the user looked away, stopped typing, etc
		smoothed_intensity = neutral_intensity
		return smoothed_intensity
	
	var raw_intensity := _gap_to_intensity(gap)
	smoothed_intensity = (smoothed_intensity * (1.0 - weight)) + (raw_intensity * weight)
	return smoothed_intensity

func _gap_to_intensity(gap: float) -> float:
	var t : float = clamp((gap - fast_threshold) / (slow_threshold - fast_threshold), 0.0, 1.0)
	return 1.0 - t
	
