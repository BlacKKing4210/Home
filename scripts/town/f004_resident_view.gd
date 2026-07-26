extends Control

const ResidentConfig = preload("res://scripts/town/f004_resident_config.gd")
const ResidentModel = preload("res://scripts/town/f004_resident_model.gd")
const ResidentText = preload("res://scripts/town/f004_resident_text.gd")
const ResidentSave = preload("res://scripts/town/f004_resident_save.gd")

const DESIGN_SIZE := Vector2(720.0, 1280.0)
const SETTINGS_RECT := Rect2(642.0, 24.0, 58.0, 58.0)
const PANEL_RECT := Rect2(24.0, 926.0, 672.0, 190.0)
const CTA_RECT := Rect2(424.0, 1010.0, 238.0, 76.0)
const PANEL_CLOSE_RECT := Rect2(592.0, 278.0, 52.0, 52.0)

const INK := Color("24434C")
const PAPER := Color("FFF8E7")
const PAPER_DARK := Color("F2E1BB")
const GRASS := Color("92CF78")
const GRASS_LIGHT := Color("B6E198")
const GRASS_DARK := Color("5E9B56")
const TEAL := Color("198F86")
const TEAL_DARK := Color("0D625F")
const GOLD := Color("F4C14E")
const CORAL := Color("D8664F")
const RED := Color("B9423C")
const WHITE := Color("FFFFFF")
const SHADOW := Color(0.05, 0.14, 0.15, 0.24)
const SCRIM := Color(0.04, 0.12, 0.14, 0.56)

@export var disable_persistence := false

var _config
var _model
var _text
var _save
var _textures: Dictionary = {}
var _hit_regions: Dictionary = {}
var _selected_id := ""
var _settings_open := false
var _runtime_ready := false
var _autosave_elapsed := 0.0
var _motion_clock := 0.0
var _celebration_elapsed := 0.0
var _last_milestone := ""
var _tone_player: AudioStreamPlayer
var _tone_playback
var _tone_remaining := 0.0
var _tone_phase := 0.0
var _tone_frequency := 440.0
var _draw_scale := 1.0
var _draw_offset := Vector2.ZERO


func _ready() -> void:
	if "--f004-acceptance-fresh" in OS.get_cmdline_user_args():
		disable_persistence = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	focus_mode = Control.FOCUS_ALL
	_config = ResidentConfig.load_default()
	_text = ResidentText.new()
	if not _config.is_valid():
		push_error("F004 resident configuration error: %s" % "; ".join(_config.errors))
		return
	if not _text.is_valid():
		push_error("F004 resident locale error: %s" % "; ".join(_text.errors))
		return
	_model = ResidentModel.new(_config)
	_save = ResidentSave.new()
	_model.changed.connect(_on_model_changed)
	_model.milestone.connect(_on_milestone)
	_load_textures()
	_setup_tone()
	if not disable_persistence:
		_save.load_into(_model)
	var window := get_window()
	if window != null:
		window.size = Vector2i(720, 1280)
		window.min_size = Vector2i(360, 640)
	_runtime_ready = true
	set_process(true)
	queue_redraw()


func _exit_tree() -> void:
	shutdown_audio()
	if _runtime_ready and not disable_persistence:
		_save.save_model(_model)


func _process(delta: float) -> void:
	if not _runtime_ready:
		return
	_motion_clock += delta
	if _celebration_elapsed > 0.0:
		_celebration_elapsed = max(_celebration_elapsed - delta, 0.0)
	if _model.tick(delta):
		queue_redraw()
	if not disable_persistence:
		_autosave_elapsed += delta
		if _autosave_elapsed >= float(_config.setting_int("autosave_seconds")):
			_autosave_elapsed = 0.0
			_save.save_model(_model)
	_pump_tone(delta)
	if not _text.reduced_motion or _celebration_elapsed > 0.0:
		queue_redraw()


func _gui_input(event: InputEvent) -> void:
	if not _runtime_ready:
		return
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and not mouse_event.pressed:
			_activate_target(_target_at(_to_design(mouse_event.position)))
			accept_event()
	elif event is InputEventScreenTouch:
		var touch_event := event as InputEventScreenTouch
		if not touch_event.pressed:
			_activate_target(_target_at(_to_design(touch_event.position)))
			accept_event()


func _draw() -> void:
	if not _runtime_ready:
		return
	_update_transform()
	draw_set_transform(_draw_offset, 0.0, Vector2(_draw_scale, _draw_scale))
	_hit_regions.clear()
	_draw_background()
	_draw_world()
	_draw_hud()
	_draw_context_panel()
	if _settings_open:
		_draw_settings()
	if _celebration_elapsed > 0.0 and not _text.reduced_motion:
		_draw_celebration()
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw_background() -> void:
	draw_rect(Rect2(0, 0, 720, 1280), Color("D9F0EE"))
	draw_rect(Rect2(0, 102, 720, 814), GRASS)
	for index in range(9):
		var y := 118.0 + index * 98.0
		draw_circle(Vector2(54.0 + (index % 2) * 620.0, y), 86.0, GRASS_LIGHT.darkened(0.03))
	var island := PackedVector2Array([
		Vector2(32, 170), Vector2(360, 112), Vector2(688, 170), Vector2(704, 770),
		Vector2(588, 872), Vector2(132, 872), Vector2(16, 770),
	])
	draw_colored_polygon(island, GRASS_LIGHT)
	for x in range(0, 9):
		for y in range(0, 8):
			var center := _iso(Vector2(x, y))
			var diamond := _diamond(center, 46.0, 23.0)
			draw_polyline(diamond, Color(0.15, 0.35, 0.29, 0.12), 1.0, true)


func _draw_world() -> void:
	for road in _config.road_rows():
		_draw_grid_asset(road, 106.0, 62.0, Color.WHITE)
		var road_id: String = _config.text(road, "id")
		var center: Vector2 = _iso(Vector2(_config.number(road, "grid_x"), _config.number(road, "grid_y")))
		var hit: Rect2 = Rect2(center - Vector2(52, 30), Vector2(104, 60))
		_hit_regions["road:%s" % road_id] = hit.grow(10.0)

	var sortable: Array[Dictionary] = []
	for grid_record in _config.grid_rows():
		if _config.text(grid_record, "kind") == "road":
			continue
		sortable.append(grid_record)
	sortable.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return _grid_sort_y(a) < _grid_sort_y(b)
	)
	for record_value in sortable:
		var grid_id: String = _config.text(record_value, "id")
		if grid_id == "home_plot" and not _model.house_built:
			_draw_ghost_house(record_value)
		else:
			_draw_object(record_value)

	if _model.resident_invited:
		_draw_resident()
	_draw_truck()
	_draw_blocked_road_markers()
	_draw_world_status()


func _draw_grid_asset(record_value: Dictionary, width: float, height: float, modulate: Color) -> void:
	var center := _iso(Vector2(_config.number(record_value, "grid_x"), _config.number(record_value, "grid_y")))
	var texture: Texture2D = _textures.get(_config.text(record_value, "asset_id"))
	if texture == null:
		return
	var rect := Rect2(center.x - width * 0.5, center.y - height * 0.52, width, height)
	draw_texture_rect(texture, rect, false, modulate)


func _draw_ghost_house(record_value: Dictionary) -> void:
	var center := _footprint_center(record_value)
	var footprint := _footprint_diamond(record_value)
	draw_colored_polygon(footprint, Color(0.95, 0.76, 0.30, 0.20))
	draw_polyline(footprint, GOLD, 4.0, true)
	var texture: Texture2D = _textures.get("resident_house")
	var rect := _asset_rect(texture, center + Vector2(0, 24), 188.0, 186.0)
	draw_texture_rect(texture, rect, false, Color(1, 1, 1, 0.42))
	_hit_regions["object:home_plot"] = rect.grow(14.0)


func _draw_object(record_value: Dictionary) -> void:
	var grid_id: String = _config.text(record_value, "id")
	var asset_id: String = _config.text(record_value, "asset_id")
	var texture: Texture2D = _textures.get(asset_id)
	if texture == null:
		return
	var center := _footprint_center(record_value)
	var width := 196.0
	var height := 190.0
	match grid_id:
		"field_wheat":
			width = 128.0
			height = 120.0
			center += Vector2(0, 24)
		"workshop_granary":
			width = 218.0
			height = 215.0
			center += Vector2(0, 26)
		"loading_yard":
			width = 272.0
			height = 246.0
			center += Vector2(0, 34)
		"home_plot":
			width = 196.0
			height = 188.0
			center += Vector2(0, 24)
	var rect := _asset_rect(texture, center, width, height)
	if _selected_id == grid_id:
		var footprint := _footprint_diamond(record_value)
		draw_colored_polygon(footprint, Color(0.10, 0.56, 0.52, 0.18))
		draw_polyline(footprint, TEAL, 4.0, true)
	draw_texture_rect(texture, rect, false)
	_hit_regions["object:%s" % grid_id] = rect.grow(10.0)


func _draw_resident() -> void:
	var texture: Texture2D = _textures.get("resident_rabbit")
	if texture == null:
		return
	var cell: Vector2 = _model.resident_display_cell()
	var point: Vector2 = _iso(cell) + Vector2(0, 7)
	var bob := 0.0
	if not _text.reduced_motion and _model.resident_state.begins_with("walking"):
		bob = sin(_motion_clock * 9.0) * 4.0
	var size := Vector2(72, 76)
	var rect := Rect2(point.x - size.x * 0.5, point.y - size.y + 12 + bob, size.x, size.y)
	draw_circle(Vector2(point.x, point.y + 7), 20.0, SHADOW)
	draw_texture_rect(texture, rect, false)
	_hit_regions["resident"] = rect.grow(14.0)
	if _model.carried_count > 0:
		var badge_center := rect.position + Vector2(rect.size.x - 6, 10)
		draw_circle(badge_center, 18.0, GOLD)
		draw_circle(badge_center, 18.0, INK, false, 3.0)
		_draw_text(str(_model.carried_count), badge_center - Vector2(8, -6), 18, INK)
	if _model.resident_state in ["working_field", "working_workshop", "loading"]:
		var progress: float = _model.resident_progress()
		draw_arc(point - Vector2(0, 72), 25.0, -PI * 0.5, -PI * 0.5 + TAU * progress, 32, TEAL, 6.0, true)


func _draw_truck() -> void:
	if _model.truck_state == "gone":
		return
	var texture: Texture2D = _textures.get("order_truck")
	var point: Vector2 = _model.truck_position()
	var rect := _asset_rect(texture, point, 150.0, 118.0)
	draw_circle(point + Vector2(-8, 37), 39.0, SHADOW)
	draw_texture_rect(texture, rect, false)
	_hit_regions["truck"] = rect.grow(10.0)
	if _model.order_loaded > 0:
		draw_circle(rect.position + Vector2(24, 24), 18.0, GOLD)
		_draw_text("✓", rect.position + Vector2(15, 32), 22, INK)


func _draw_blocked_road_markers() -> void:
	for road_id_variant in _model.blocked_roads.keys():
		var road_id := str(road_id_variant)
		var road: Dictionary = _config.record("grid", road_id)
		var center: Vector2 = _iso(Vector2(_config.number(road, "grid_x"), _config.number(road, "grid_y"))) - Vector2(0, 14)
		draw_circle(center, 22.0, PAPER)
		draw_circle(center, 20.0, RED)
		draw_circle(center, 20.0, INK, false, 3.0)
		draw_line(center - Vector2(9, 9), center + Vector2(9, 9), WHITE, 5.0, true)
		draw_line(center + Vector2(9, -9), center + Vector2(-9, 9), WHITE, 5.0, true)


func _draw_world_status() -> void:
	var status: String = _text.text(_model.status_text_key())
	var anchor := Vector2(360, 824)
	var card := Rect2(86, 786, 548, 76)
	draw_style_box(_panel_style(Color(1, 0.98, 0.91, 0.96), INK, 18), card)
	var accent := RED if _model.resident_state == "blocked" else TEAL
	draw_circle(Vector2(card.position.x + 34, card.position.y + 38), 13.0, accent)
	_draw_text(status, Vector2(card.position.x + 60, card.position.y + 47), 21, INK)
	var order: Dictionary = _config.record("vehicle_orders", "bakery_delivery")
	var order_text: String = _text.text("order_progress", [_model.order_loaded, _config.number(order, "required_count")])
	_draw_text(order_text, anchor + Vector2(-108, 74), 17, TEAL_DARK)


func _draw_hud() -> void:
	draw_style_box(_panel_style(PAPER, INK, 0), Rect2(0, 0, 720, 106))
	draw_circle(Vector2(48, 52), 26.0, TEAL)
	draw_circle(Vector2(48, 52), 18.0, GOLD)
	_draw_text(_text.text("town_name"), Vector2(86, 60), 26, INK)
	draw_style_box(_panel_style(PAPER_DARK, INK, 22), Rect2(430, 25, 176, 55))
	draw_circle(Vector2(458, 52), 14.0, GOLD)
	_draw_text("%s  %d" % [_text.text("coins"), _model.coins], Vector2(480, 60), 20, INK)
	draw_style_box(_panel_style(PAPER_DARK, INK, 18), SETTINGS_RECT)
	draw_circle(SETTINGS_RECT.get_center(), 14.0, TEAL)
	draw_circle(SETTINGS_RECT.get_center(), 5.0, PAPER)
	_hit_regions["settings"] = SETTINGS_RECT


func _draw_context_panel() -> void:
	draw_style_box(_panel_style(PAPER, INK, 24), PANEL_RECT)
	var title := ""
	var detail := ""
	var cta := ""
	if _selected_id.begins_with("road:"):
		var road_id: String = _selected_id.trim_prefix("road:")
		title = _text.text("select_road")
		detail = _text.text("road_closed" if _model.blocked_roads.has(road_id) else "road_open")
		cta = _text.text("open_road" if _model.blocked_roads.has(road_id) else "close_road")
	elif not _model.house_built:
		title = _text.text("build_house")
		detail = _text.text("build_cost", [_config.setting_int("house_build_cost")])
		cta = _text.text("confirm_build")
	elif not _model.resident_invited:
		var resident: Dictionary = _config.record("resident_types", "rabbit_resident")
		title = _text.text("invite_resident")
		detail = _text.text("invite_cost", [_config.number(resident, "invite_cost")])
		cta = _text.text("confirm_invite")
	elif _model.resident_state == "home_idle" and not _model.order_complete:
		title = _text.text("assign_job")
		detail = _text.text("tap_world_hint")
		cta = _text.text("confirm_assign")
	else:
		title = _text.text(_model.status_text_key())
		detail = _text.text(_model.feedback_key, _model.feedback_args)
		if detail == title:
			if _model.resident_state in ["working_field", "working_workshop", "loading"]:
				detail = _text.text("time_remaining", [int(ceil(_model.work_remaining))])
			else:
				var order: Dictionary = _config.record("vehicle_orders", "bakery_delivery")
				detail = _text.text("order_progress", [_model.order_loaded, _config.number(order, "required_count")])
		cta = ""
	_draw_text(title, Vector2(54, 974), 25, INK)
	_draw_text(detail, Vector2(54, 1018), 18, TEAL_DARK)
	if not cta.is_empty():
		_draw_button(CTA_RECT, cta, true)
		_hit_regions["panel:cta"] = CTA_RECT


func _draw_settings() -> void:
	draw_rect(Rect2(0, 0, 720, 1280), SCRIM)
	var panel := Rect2(48, 252, 624, 650)
	draw_style_box(_panel_style(PAPER, INK, 28), panel)
	_draw_text(_text.text("settings"), Vector2(82, 316), 32, INK)
	_draw_button(PANEL_CLOSE_RECT, "×", false)
	_hit_regions["panel:close"] = PANEL_CLOSE_RECT
	_draw_text(_text.text("language"), Vector2(84, 392), 22, INK)
	var zh_rect := Rect2(84, 420, 246, 70)
	var en_rect := Rect2(390, 420, 246, 70)
	_draw_button(zh_rect, _text.text("chinese"), _text.locale == "zh-CN")
	_draw_button(en_rect, _text.text("english"), _text.locale == "en")
	_hit_regions["panel:lang:zh"] = zh_rect
	_hit_regions["panel:lang:en"] = en_rect
	_draw_text(_text.text("reduced_motion"), Vector2(84, 580), 22, INK)
	var motion_rect := Rect2(84, 612, 552, 76)
	_draw_button(motion_rect, _text.text("on" if _text.reduced_motion else "off"), _text.reduced_motion)
	_hit_regions["panel:motion"] = motion_rect
	var note: String = _text.text("interrupted_saved")
	_draw_multiline(note, Rect2(84, 742, 552, 100), 18, TEAL_DARK)


func _draw_celebration() -> void:
	var progress: float = 1.0 - _celebration_elapsed / 1.6
	var colors: Array[Color] = [GOLD, TEAL, CORAL, WHITE]
	for index in range(24):
		var angle := float(index) * TAU / 24.0
		var radius := 70.0 + progress * (110.0 + float(index % 5) * 12.0)
		var point := Vector2(555, 650) + Vector2(cos(angle), sin(angle)) * radius
		var color: Color = colors[index % 4]
		draw_circle(point, 5.0 + float(index % 3), color)


func _activate_target(target: String) -> void:
	if target.is_empty():
		return
	if target == "settings":
		_settings_open = true
	elif target == "panel:close":
		_settings_open = false
	elif target == "panel:lang:zh":
		_text.set_locale("zh-CN")
	elif target == "panel:lang:en":
		_text.set_locale("en")
	elif target == "panel:motion":
		_text.set_reduced_motion(not _text.reduced_motion)
	elif target.begins_with("road:"):
		_selected_id = target
	elif target.begins_with("object:"):
		_selected_id = target.trim_prefix("object:")
	elif target == "resident":
		_selected_id = "resident"
	elif target == "truck":
		_selected_id = "truck"
	elif target == "panel:cta":
		_activate_context_cta()
	queue_redraw()


func _activate_context_cta() -> void:
	if _selected_id.begins_with("road:"):
		var road_id: String = _selected_id.trim_prefix("road:")
		_model.set_road_blocked(road_id, not _model.blocked_roads.has(road_id))
	elif not _model.house_built:
		_model.build_house()
	elif not _model.resident_invited:
		_model.invite_resident()
	elif _model.resident_state == "home_idle" and not _model.order_complete:
		_model.assign_default_job()


func _target_at(point: Vector2) -> String:
	if _settings_open:
		for target_variant in _hit_regions.keys():
			var target := str(target_variant)
			if target.begins_with("panel:") and (_hit_regions[target] as Rect2).has_point(point):
				return target
		return ""
	for target_variant in _hit_regions.keys():
		var target := str(target_variant)
		if (_hit_regions[target] as Rect2).has_point(point):
			return target
	return ""


func _load_textures() -> void:
	for asset_id_variant in ResidentConfig.RUNTIME_ASSET_PATHS.keys():
		var asset_id := str(asset_id_variant)
		var path: String = _config.runtime_asset_path(asset_id)
		_textures[asset_id] = load(path)
	var resident: Dictionary = _config.record("resident_types", "rabbit_resident")
	_textures["resident_rabbit"] = load(_config.text(resident, "asset_path"))


func _on_model_changed() -> void:
	queue_redraw()


func _on_milestone(event_id: String) -> void:
	_last_milestone = event_id
	match event_id:
		"house_built": _play_tone(440.0, 0.13)
		"resident_invited": _play_tone(560.0, 0.16)
		"resident_blocked": _play_tone(190.0, 0.16)
		"resident_resumed": _play_tone(420.0, 0.10)
		"order_completed":
			_play_tone(760.0, 0.26)
			_celebration_elapsed = 1.6
	queue_redraw()


func _setup_tone() -> void:
	_tone_player = AudioStreamPlayer.new()
	var stream := AudioStreamGenerator.new()
	stream.mix_rate = 22050.0
	stream.buffer_length = 0.25
	_tone_player.stream = stream
	add_child(_tone_player)
	_tone_player.play()
	_tone_playback = _tone_player.get_stream_playback()


func _play_tone(frequency: float, duration: float) -> void:
	_tone_frequency = frequency
	_tone_remaining = duration
	_tone_phase = 0.0


func _pump_tone(delta: float) -> void:
	if _tone_remaining <= 0.0 or _tone_playback == null:
		return
	var frames: int = mini(int(_tone_playback.get_frames_available()), int(22050.0 * minf(delta, _tone_remaining)))
	for frame_index in range(frames):
		var envelope: float = minf(_tone_remaining * 8.0, 1.0)
		var sample: float = sin(_tone_phase) * 0.11 * envelope
		_tone_playback.push_frame(Vector2(sample, sample))
		_tone_phase += TAU * _tone_frequency / 22050.0
	_tone_remaining = max(_tone_remaining - delta, 0.0)


func shutdown_audio() -> void:
	_tone_playback = null
	if _tone_player != null:
		_tone_player.stop()
		_tone_player.stream = null
		if is_instance_valid(_tone_player):
			_tone_player.free()
		_tone_player = null


func _update_transform() -> void:
	_draw_scale = min(size.x / DESIGN_SIZE.x, size.y / DESIGN_SIZE.y)
	_draw_offset = (size - DESIGN_SIZE * _draw_scale) * 0.5


func _to_design(point: Vector2) -> Vector2:
	_update_transform()
	return (point - _draw_offset) / max(_draw_scale, 0.001)


func _iso(cell: Vector2) -> Vector2:
	var half_width := float(_config.setting_int("tile_width")) * 0.5
	var half_height := float(_config.setting_int("tile_height")) * 0.5
	return Vector2(
		float(_config.setting_int("origin_x")) + (cell.x - cell.y) * half_width,
		float(_config.setting_int("origin_y")) + (cell.x + cell.y) * half_height
	)


func _footprint_center(record_value: Dictionary) -> Vector2:
	var center_cell := Vector2(
		float(_config.number(record_value, "grid_x")) + float(_config.number(record_value, "footprint_w") - 1) * 0.5,
		float(_config.number(record_value, "grid_y")) + float(_config.number(record_value, "footprint_h") - 1) * 0.5
	)
	return _iso(center_cell)


func _footprint_diamond(record_value: Dictionary) -> PackedVector2Array:
	var center := _footprint_center(record_value)
	var width := float(_config.setting_int("tile_width")) * float(_config.number(record_value, "footprint_w") + _config.number(record_value, "footprint_h")) * 0.5
	var height := float(_config.setting_int("tile_height")) * float(_config.number(record_value, "footprint_w") + _config.number(record_value, "footprint_h")) * 0.5
	return _diamond(center + Vector2(0, 14), width * 0.5, height * 0.5)


func _diamond(center: Vector2, half_width: float, half_height: float) -> PackedVector2Array:
	return PackedVector2Array([
		center + Vector2(0, -half_height),
		center + Vector2(half_width, 0),
		center + Vector2(0, half_height),
		center + Vector2(-half_width, 0),
		center + Vector2(0, -half_height),
	])


func _grid_sort_y(record_value: Dictionary) -> float:
	return _footprint_center(record_value).y


func _asset_rect(texture: Texture2D, center: Vector2, max_width: float, max_height: float) -> Rect2:
	if texture == null:
		return Rect2(center, Vector2.ZERO)
	var texture_size: Vector2 = texture.get_size()
	var scale: float = minf(max_width / maxf(texture_size.x, 1.0), max_height / maxf(texture_size.y, 1.0))
	var draw_size: Vector2 = texture_size * scale
	return Rect2(center.x - draw_size.x * 0.5, center.y - draw_size.y + max_height * 0.45, draw_size.x, draw_size.y)


func _panel_style(fill: Color, border: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(3)
	style.set_corner_radius_all(radius)
	style.shadow_color = SHADOW
	style.shadow_size = 8
	return style


func _draw_button(rect: Rect2, label: String, primary: bool) -> void:
	var fill := CORAL if primary else PAPER_DARK
	var text_color := WHITE if primary else INK
	draw_style_box(_panel_style(fill, INK, 18), rect)
	var font := ThemeDB.fallback_font
	var font_size := 21
	var text_width := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	_draw_text(label, Vector2(rect.get_center().x - text_width * 0.5, rect.get_center().y + 8), font_size, text_color)


func _draw_text(value: String, position: Vector2, font_size: int, color: Color) -> void:
	draw_string(ThemeDB.fallback_font, position, value, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)


func _draw_multiline(value: String, rect: Rect2, font_size: int, color: Color) -> void:
	draw_multiline_string(ThemeDB.fallback_font, rect.position, value, HORIZONTAL_ALIGNMENT_LEFT, rect.size.x, font_size, -1, color)


func debug_snapshot() -> Dictionary:
	return {
		"runtime_ready": _runtime_ready,
		"design_size": [720, 1280],
		"config_valid": _config != null and _config.is_valid(),
		"locale": _text.locale if _text != null else "",
		"reduced_motion": _text.reduced_motion if _text != null else false,
		"house_built": _model.house_built if _model != null else false,
		"resident_invited": _model.resident_invited if _model != null else false,
		"resident_state": _model.resident_state if _model != null else "",
		"truck_state": _model.truck_state if _model != null else "",
		"order_complete": _model.order_complete if _model != null else false,
		"asset_count": _textures.size(),
		"selected": _selected_id,
		"settings_open": _settings_open,
		"last_milestone": _last_milestone,
	}


func debug_activate_target(target: String) -> void:
	_activate_target(target)


func debug_model():
	return _model


func debug_text():
	return _text


func debug_target_at_design(point: Vector2) -> String:
	return _target_at(point)
