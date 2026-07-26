extends Control

const DESIGN_SIZE := Vector2(720.0, 1280.0)
const MAX_EFFECTS := 4
const HARVEST_DURATION := 0.72
const REDUCED_DURATION := 0.34
const BLOCKED_DURATION := 0.48
const PARTICLE_COUNT := 6

const INK := Color("24434C")
const PAPER := Color("FFF9E8")
const GOLD := Color("F4C14E")
const TEAL := Color("159A8C")
const CORAL := Color("DA654C")
const WHITE := Color("FFFFFF")

var _effects: Array[Dictionary] = []
var _next_effect_id := 1
var _last_event_kind := ""
var _last_render_mode := ""


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	focus_mode = Control.FOCUS_NONE
	set_process(false)


func play_harvest(
	source_design: Vector2,
	target_design: Vector2,
	yield_count: int,
	crop_color: Color,
	reduced_motion: bool
) -> int:
	var duration := REDUCED_DURATION if reduced_motion else HARVEST_DURATION
	var effect := {
		"id": _next_effect_id,
		"kind": "harvest",
		"age": 0.0,
		"duration": duration,
		"source": source_design,
		"target": target_design,
		"yield": yield_count,
		"color": crop_color,
		"reduced_motion": reduced_motion,
	}
	_next_effect_id += 1
	_append_effect(effect)
	_last_event_kind = "harvest"
	_last_render_mode = "reduced" if reduced_motion else "motion"
	return int(effect["id"])


func play_blocked(
	source_design: Vector2,
	target_design: Vector2,
	reduced_motion: bool
) -> int:
	var effect := {
		"id": _next_effect_id,
		"kind": "blocked",
		"age": 0.0,
		"duration": BLOCKED_DURATION,
		"source": source_design,
		"target": target_design,
		"yield": 0,
		"color": CORAL,
		"reduced_motion": reduced_motion,
	}
	_next_effect_id += 1
	_append_effect(effect)
	_last_event_kind = "blocked"
	_last_render_mode = "reduced" if reduced_motion else "motion"
	return int(effect["id"])


func cancel_all() -> void:
	_effects.clear()
	set_process(false)
	queue_redraw()


func _exit_tree() -> void:
	cancel_all()


func _append_effect(effect: Dictionary) -> void:
	if _effects.size() >= MAX_EFFECTS:
		_effects.pop_front()
	_effects.append(effect)
	set_process(true)
	queue_redraw()


func _process(delta: float) -> void:
	for index in range(_effects.size() - 1, -1, -1):
		var effect: Dictionary = _effects[index]
		effect["age"] = float(effect["age"]) + delta
		if float(effect["age"]) >= float(effect["duration"]):
			_effects.remove_at(index)
		else:
			_effects[index] = effect
	if _effects.is_empty():
		set_process(false)
	queue_redraw()


func _draw() -> void:
	if _effects.is_empty():
		return
	var metrics := _metrics()
	draw_set_transform(metrics.offset, 0.0, Vector2(metrics.scale, metrics.scale))
	for effect in _effects:
		if str(effect["kind"]) == "harvest":
			_draw_harvest(effect)
		else:
			_draw_blocked(effect)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw_harvest(effect: Dictionary) -> void:
	var source: Vector2 = effect["source"]
	var target: Vector2 = effect["target"]
	var age := float(effect["age"])
	var duration := float(effect["duration"])
	var progress := clampf(age / duration, 0.0, 1.0)
	var crop_color: Color = effect["color"]
	var reduced_motion := bool(effect["reduced_motion"])

	if reduced_motion:
		var static_alpha := sin(progress * PI)
		_draw_focus_ring(source, GOLD, static_alpha, 58.0)
		_draw_focus_ring(target, TEAL, static_alpha, 38.0)
		_draw_yield_text(target + Vector2(-45.0, 64.0), int(effect["yield"]), static_alpha)
		return

	var source_alpha := clampf(1.0 - progress * 1.7, 0.0, 1.0)
	_draw_focus_ring(source, GOLD, source_alpha, 54.0 + sin(progress * PI) * 16.0)
	for index in range(PARTICLE_COUNT):
		var delay := float(index) * 0.045
		var particle_progress := clampf((age - delay) / 0.46, 0.0, 1.0)
		if age < delay or particle_progress >= 1.0:
			continue
		var spread := (float(index) - float(PARTICLE_COUNT - 1) * 0.5) * 12.0
		var particle_source := source + Vector2(spread, -8.0 + absf(spread) * 0.16)
		var control := (particle_source + target) * 0.5 + Vector2(spread * 0.8, -145.0 - float(index % 2) * 18.0)
		var position := _quadratic_bezier(particle_source, control, target, _ease_out_cubic(particle_progress))
		var particle_alpha := clampf(sin(particle_progress * PI) * 1.35, 0.0, 1.0)
		var particle_size := 7.0 + sin(particle_progress * PI) * 5.0
		_draw_crop_particle(position, particle_size, crop_color, particle_alpha, index)

	var target_progress := clampf((progress - 0.58) / 0.42, 0.0, 1.0)
	if target_progress > 0.0:
		var target_alpha := sin(target_progress * PI)
		_draw_focus_ring(target, TEAL, target_alpha, 34.0 + target_progress * 18.0)
		_draw_yield_text(target + Vector2(-45.0, 66.0 - target_progress * 12.0), int(effect["yield"]), target_alpha)


func _draw_blocked(effect: Dictionary) -> void:
	var source: Vector2 = effect["source"]
	var target: Vector2 = effect["target"]
	var progress := clampf(float(effect["age"]) / float(effect["duration"]), 0.0, 1.0)
	var reduced_motion := bool(effect["reduced_motion"])
	var pulse := 1.0 if reduced_motion else 0.78 + sin(progress * TAU * 2.0) * 0.22
	var alpha := sin(progress * PI)
	_draw_focus_ring(source, CORAL, alpha, 58.0 + pulse * 8.0)
	_draw_focus_ring(target, CORAL, alpha * 0.9, 38.0 + pulse * 5.0)
	_draw_blocked_symbol(source + Vector2(0.0, -78.0), alpha)


func _draw_focus_ring(center: Vector2, color: Color, alpha: float, radius: float) -> void:
	if alpha <= 0.0:
		return
	draw_circle(center, radius, Color(color.r, color.g, color.b, alpha * 0.13))
	draw_arc(center, radius, 0.0, TAU, 32, Color(PAPER.r, PAPER.g, PAPER.b, alpha * 0.9), 8.0, true)
	draw_arc(center, radius - 5.0, 0.0, TAU, 32, Color(color.r, color.g, color.b, alpha), 5.0, true)


func _draw_crop_particle(
	center: Vector2,
	radius: float,
	color: Color,
	alpha: float,
	index: int
) -> void:
	var fill := Color(color.r, color.g, color.b, alpha)
	var outline := Color(INK.r, INK.g, INK.b, alpha * 0.8)
	if index % 2 == 0:
		var points := PackedVector2Array([
			center + Vector2(0.0, -radius),
			center + Vector2(radius * 0.8, 0.0),
			center + Vector2(0.0, radius),
			center + Vector2(-radius * 0.8, 0.0),
		])
		draw_colored_polygon(points, fill)
		draw_polyline(PackedVector2Array([points[0], points[1], points[2], points[3], points[0]]), outline, 2.0, true)
	else:
		draw_circle(center, radius * 0.72, fill)
		draw_arc(center, radius * 0.72, 0.0, TAU, 18, outline, 2.0, true)


func _draw_yield_text(position: Vector2, yield_count: int, alpha: float) -> void:
	var plate_rect := Rect2(position, Vector2(90.0, 42.0))
	draw_rect(plate_rect, Color(PAPER.r, PAPER.g, PAPER.b, alpha * 0.94))
	draw_rect(plate_rect, Color(TEAL.r, TEAL.g, TEAL.b, alpha), false, 3.0)
	draw_string(
		ThemeDB.fallback_font,
		position + Vector2(0.0, 30.0),
		"+%d" % yield_count,
		HORIZONTAL_ALIGNMENT_CENTER,
		90.0,
		24,
		Color(INK.r, INK.g, INK.b, alpha)
	)


func _draw_blocked_symbol(center: Vector2, alpha: float) -> void:
	draw_circle(center, 23.0, Color(PAPER.r, PAPER.g, PAPER.b, alpha * 0.95))
	draw_circle(center, 18.0, Color(CORAL.r, CORAL.g, CORAL.b, alpha))
	draw_string(
		ThemeDB.fallback_font,
		center + Vector2(-12.0, 10.0),
		"!",
		HORIZONTAL_ALIGNMENT_CENTER,
		24.0,
		26,
		Color(WHITE.r, WHITE.g, WHITE.b, alpha)
	)


func _quadratic_bezier(a: Vector2, b: Vector2, c: Vector2, t: float) -> Vector2:
	var inverse := 1.0 - t
	return inverse * inverse * a + 2.0 * inverse * t * b + t * t * c


func _ease_out_cubic(value: float) -> float:
	return 1.0 - pow(1.0 - value, 3.0)


func _metrics() -> Dictionary:
	var scale_factor: float = minf(size.x / DESIGN_SIZE.x, size.y / DESIGN_SIZE.y)
	if scale_factor <= 0.0:
		scale_factor = 1.0
	var offset: Vector2 = (size - DESIGN_SIZE * scale_factor) * 0.5
	return {"scale": scale_factor, "offset": offset}


func debug_snapshot() -> Dictionary:
	return {
		"active_effects": _effects.size(),
		"last_event_kind": _last_event_kind,
		"last_render_mode": _last_render_mode,
		"max_effects": MAX_EFFECTS,
		"mouse_filter_ignore": mouse_filter == Control.MOUSE_FILTER_IGNORE,
		"focus_none": focus_mode == Control.FOCUS_NONE,
	}
