extends Control

const Resident2Config = preload("res://scripts/town/f004_resident2_config.gd")
const Resident2Model = preload("res://scripts/town/f004_resident2_model.gd")
const Resident2Text = preload("res://scripts/town/f004_resident2_text.gd")
const Resident2Save = preload("res://scripts/town/f004_resident2_save.gd")

const DESIGN_SIZE := Vector2(720.0, 1280.0)
const SETTINGS_RECT := Rect2(642.0, 24.0, 58.0, 58.0)
const PANEL_RECT := Rect2(20.0, 920.0, 680.0, 292.0)
const PANEL_CLOSE_RECT := Rect2(592.0, 278.0, 52.0, 52.0)
const PRIMARY_RECT := Rect2(390.0, 1076.0, 270.0, 78.0)
const SECONDARY_RECT := Rect2(52.0, 1076.0, 220.0, 78.0)

const INK := Color("243F48")
const INK_SOFT := Color("48626A")
const PAPER := Color("FFF8E7")
const PAPER_DARK := Color("F0DEB5")
const WATER := Color("CDEBE8")
const WATER_LIGHT := Color("E5F6F2")
const GRASS := Color("8FCA70")
const GRASS_LIGHT := Color("B2DC8D")
const GRASS_DARK := Color("538F50")
const TEAL := Color("1B8D83")
const TEAL_DARK := Color("0D625F")
const GOLD := Color("F3C24F")
const CORAL := Color("D9664F")
const RED := Color("B8433D")
const WHITE := Color("FFFFFF")
const SHADOW := Color(0.04, 0.12, 0.13, 0.25)
const SCRIM := Color(0.03, 0.10, 0.12, 0.62)
const VALID_FILL := Color(0.18, 0.72, 0.48, 0.30)
const INVALID_FILL := Color(0.82, 0.20, 0.18, 0.32)

@export var disable_persistence := false
@export var disable_audio := false

var _config
var _model
var _text
var _save
var _textures: Dictionary = {}
var _hit_regions: Dictionary = {}
var _selected_id := ""
var _build_drawer := false
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
var _tone_amplitude := 0.08
var _last_audio_ms: Dictionary = {}
var _draw_scale := 1.0
var _draw_offset := Vector2.ZERO


func _ready() -> void:
	if "--f004-resident2-fresh" in OS.get_cmdline_user_args():
		disable_persistence = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	focus_mode = Control.FOCUS_ALL
	_config = Resident2Config.load_default()
	_text = Resident2Text.new()
	if not _config.is_valid():
		push_error("F004.2 configuration error: %s" % "; ".join(_config.errors))
		return
	if not _text.is_valid():
		push_error("F004.2 locale error: %s" % "; ".join(_text.errors))
		return
	_model = Resident2Model.new(_config)
	_save = Resident2Save.new()
	_model.changed.connect(_on_model_changed)
	_model.milestone.connect(_on_milestone)
	_load_textures()
	if not disable_audio:
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
		_celebration_elapsed = maxf(_celebration_elapsed - delta, 0.0)
	if _model.tick(delta):
		queue_redraw()
	if not disable_persistence:
		_autosave_elapsed += delta
		if _autosave_elapsed >= _config.setting_float("autosave_seconds"):
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
	if _celebration_elapsed > 0.0 and not _settings_open:
		_draw_celebration()
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw_background() -> void:
	draw_rect(Rect2(0, 0, 720, 1280), WATER)
	draw_rect(Rect2(0, 88, 720, 840), WATER_LIGHT)
	var island := PackedVector2Array([
		Vector2(28, 172),
		Vector2(360, 105),
		Vector2(692, 172),
		Vector2(707, 760),
		Vector2(598, 870),
		Vector2(122, 870),
		Vector2(13, 760),
	])
	draw_colored_polygon(island, GRASS_LIGHT)
	draw_polyline(island, GRASS_DARK.lightened(0.18), 6.0, true)
	for index in range(10):
		var point := Vector2(44 + (index % 2) * 626, 170 + index * 66)
		draw_circle(point, 72.0, GRASS)
		draw_circle(point + Vector2(-14, -10), 45.0, GRASS_LIGHT)
	for index in range(18):
		var x := 64.0 + float((index * 113) % 590)
		var y := 172.0 + float((index * 67) % 650)
		draw_circle(Vector2(x, y), 3.0, Color(0.96, 0.78, 0.31, 0.44))
		draw_circle(Vector2(x + 4, y + 2), 2.0, Color(1.0, 0.96, 0.77, 0.52))


func _draw_world() -> void:
	if not _model.placement_id.is_empty():
		_draw_placement_grid()
	_draw_roads()
	_draw_buildings()
	if _model.placements.has("dairy_pasture"):
		_draw_cow()
	_draw_rabbit()
	if _model.bear_invited:
		_draw_bear()
	_draw_truck()
	_draw_blocked_road_markers()
	if not _model.placement_id.is_empty():
		_draw_placement_ghost()
	_draw_world_status()


func _draw_placement_grid() -> void:
	for x in range(_config.setting_int("map_columns")):
		for y in range(_config.setting_int("map_rows")):
			var center := _iso(Vector2(x, y))
			var diamond := _cell_diamond(center)
			draw_colored_polygon(diamond, Color(1, 1, 1, 0.055))
			draw_polyline(diamond, Color(0.12, 0.30, 0.28, 0.20), 1.2, true)
			_hit_regions["grid:%d:%d" % [x, y]] = Rect2(center - Vector2(31, 17), Vector2(62, 34)).grow(5.0)


func _draw_roads() -> void:
	var road_ids: Array[String] = []
	for grid_id_variant in _model.placements.keys():
		var grid_id := str(grid_id_variant)
		if _config.text(_config.record("grid", grid_id), "kind") == "road":
			road_ids.append(grid_id)
	road_ids.sort_custom(func(a: String, b: String) -> bool:
		return _iso(Vector2(_model.placed_origin(a))).y < _iso(Vector2(_model.placed_origin(b))).y
	)
	for road_id in road_ids:
		var origin: Vector2i = _model.placed_origin(road_id)
		var asset_id: String = _config.text(_config.record("grid", road_id), "asset_id")
		var texture: Texture2D = _textures.get(asset_id)
		var center := _iso(Vector2(origin))
		var max_size := Vector2(88, 58)
		if road_id == "road_life_b":
			max_size = Vector2(120, 78)
		var rect := _asset_rect(texture, center + Vector2(0, 12), max_size.x, max_size.y)
		draw_texture_rect(texture, rect, false)
		_hit_regions["road:%s" % road_id] = Rect2(center - Vector2(34, 20), Vector2(68, 40)).grow(8.0)
		if _selected_id == road_id:
			var diamond := _cell_diamond(center)
			draw_colored_polygon(diamond, Color(0.10, 0.55, 0.50, 0.17))
			draw_polyline(diamond, TEAL, 3.0, true)


func _draw_buildings() -> void:
	var building_ids: Array[String] = []
	for grid_id_variant in _model.placements.keys():
		var grid_id := str(grid_id_variant)
		if _config.text(_config.record("grid", grid_id), "kind") == "building":
			building_ids.append(grid_id)
	building_ids.sort_custom(func(a: String, b: String) -> bool:
		return _footprint_center(a, _model.placed_origin(a)).y < _footprint_center(b, _model.placed_origin(b)).y
	)
	for grid_id in building_ids:
		_draw_building(grid_id, _model.placed_origin(grid_id))


func _draw_building(grid_id: String, origin: Vector2i) -> void:
	var row: Dictionary = _config.record("grid", grid_id)
	var texture: Texture2D = _textures.get(_config.text(row, "asset_id"))
	if texture == null:
		return
	var center := _footprint_center(grid_id, origin)
	var max_size := Vector2(184, 180)
	match grid_id:
		"existing_home_a":
			max_size = Vector2(170, 168)
			center += Vector2(0, 18)
		"resident_house_b":
			max_size = Vector2(190, 190)
			center += Vector2(0, 20)
		"dairy_pasture":
			max_size = Vector2(236, 178)
			center += Vector2(0, 22)
		"creamery":
			max_size = Vector2(194, 190)
			center += Vector2(0, 22)
		"loading_dock":
			max_size = Vector2(225, 188)
			center += Vector2(0, 26)
	var rect := _asset_rect(texture, center, max_size.x, max_size.y)
	if _selected_id == grid_id:
		var footprint := _footprint_outline(grid_id, origin)
		draw_colored_polygon(footprint, Color(0.10, 0.55, 0.50, 0.16))
		draw_polyline(footprint, TEAL, 4.0, true)
	draw_texture_rect(texture, rect, false)
	_hit_regions["object:%s" % grid_id] = rect.grow(10.0)


func _draw_cow() -> void:
	var texture: Texture2D = _textures.get("pasture_cow")
	var point := _iso(_model.cow_display_cell()) + Vector2(0, 12)
	var bob := 0.0
	if not _text.reduced_motion and _model.cow_state == "cared":
		bob = sin(_motion_clock * 3.2) * 1.8
	var rect := _asset_rect(texture, point + Vector2(0, bob), 92.0, 76.0)
	draw_circle(point + Vector2(0, 15), 27.0, SHADOW)
	draw_texture_rect(texture, rect, false)
	_hit_regions["cow"] = rect.grow(10.0)


func _draw_rabbit() -> void:
	var texture: Texture2D = _textures.get("resident_rabbit")
	var point := _iso(_model.rabbit_display_cell()) + Vector2(0, 8)
	var bob := 0.0
	if not _text.reduced_motion and _model.rabbit_state == "life_idle":
		bob = sin(_motion_clock * 2.8 + 0.7) * _config.setting_float("life_bob_px")
	var rect := _asset_rect(texture, point + Vector2(0, bob), 64.0, 72.0)
	draw_circle(point + Vector2(0, 12), 18.0, SHADOW)
	draw_texture_rect(texture, rect, false)
	_hit_regions["rabbit"] = rect.grow(12.0)


func _draw_bear() -> void:
	var texture: Texture2D = _textures.get("resident_bear_dairy")
	var point := _iso(_model.bear_display_cell()) + Vector2(0, 10)
	var bob := 0.0
	if not _text.reduced_motion:
		if _model.MOVING_STATES.has(_model.bear_state):
			bob = sin(_motion_clock * 9.0) * _config.setting_float("walk_bob_px")
		elif _model.WORK_STATES.has(_model.bear_state):
			bob = sin(_motion_clock * 6.0) * _config.setting_float("work_bob_px")
		elif _model.bear_state == "life_idle":
			bob = sin(_motion_clock * 2.4) * _config.setting_float("life_bob_px")
	var rect := _asset_rect(texture, point + Vector2(0, bob), 72.0, 102.0)
	draw_circle(point + Vector2(0, 13), 22.0, SHADOW)
	draw_texture_rect(texture, rect, false)
	_hit_regions["bear"] = rect.grow(13.0)
	if not _model.carried_item.is_empty():
		_draw_carried_item(_model.carried_item, rect.position + Vector2(rect.size.x - 4, rect.size.y * 0.56 + bob))
	if _model.WORK_STATES.has(_model.bear_state):
		var progress: float = _model.resident_progress()
		var progress_center := point + Vector2(34, -58)
		draw_circle(progress_center, 19.0, Color(1.0, 0.98, 0.91, 0.92))
		draw_circle(progress_center, 18.0, INK, false, 2.0, true)
		draw_arc(progress_center, 14.0, -PI * 0.5, -PI * 0.5 + TAU * progress, 24, TEAL, 5.0, true)


func _draw_carried_item(item_id: String, center: Vector2) -> void:
	var texture: Texture2D = _textures.get("dairy_goods_set")
	if texture == null:
		return
	var source := Rect2(70, 0, 150, 275)
	var size_value := Vector2(38, 52)
	if item_id == "feed_sack":
		source = Rect2(0, 95, 120, 190)
		size_value = Vector2(35, 43)
	elif item_id == "dairy_crate":
		source = Rect2(180, 90, 164, 190)
		size_value = Vector2(43, 40)
	var rect := Rect2(center - size_value * 0.5, size_value)
	draw_circle(center + Vector2(0, 10), 13.0, SHADOW)
	draw_texture_rect_region(texture, rect, source)


func _draw_truck() -> void:
	if _model.truck_state == "settled":
		return
	var texture: Texture2D = _textures.get("dairy_order_truck")
	var point: Vector2 = _model.truck_position()
	var rect := _asset_rect(texture, point, 154.0, 126.0)
	draw_circle(point + Vector2(-6, 35), 38.0, SHADOW)
	draw_texture_rect(texture, rect, false)
	_hit_regions["truck"] = rect.grow(10.0)
	var order: Dictionary = _config.record("orders", "dairy_delivery")
	var badge := rect.position + Vector2(22, 24)
	draw_circle(badge, 21.0, PAPER)
	draw_circle(badge, 19.0, GOLD if _model.order_loaded >= _config.number(order, "quantity") else TEAL)
	_draw_text("%d/%d" % [_model.order_loaded, _config.number(order, "quantity")], badge - Vector2(14, -6), 15, INK)


func _draw_blocked_road_markers() -> void:
	for road_id_variant in _model.blocked_roads.keys():
		var road_id := str(road_id_variant)
		var center := _iso(Vector2(_model.placed_origin(road_id))) - Vector2(0, 14)
		draw_circle(center, 22.0, PAPER)
		draw_circle(center, 19.0, RED)
		draw_line(center - Vector2(8, 8), center + Vector2(8, 8), WHITE, 5.0, true)
		draw_line(center + Vector2(8, -8), center + Vector2(-8, 8), WHITE, 5.0, true)


func _draw_placement_ghost() -> void:
	var row: Dictionary = _config.record("grid", _model.placement_id)
	var origin: Vector2i = _model.placement_origin
	var color := VALID_FILL if _model.placement_valid else INVALID_FILL
	var outline := TEAL if _model.placement_valid else RED
	for cell in _config.footprint_cells(row, origin):
		var diamond := _cell_diamond(_iso(Vector2(cell)))
		draw_colored_polygon(diamond, color)
		draw_polyline(diamond, outline, 3.0, true)
	var texture: Texture2D = _textures.get(_config.text(row, "asset_id"))
	var center := _footprint_center(_model.placement_id, origin) + Vector2(0, 20)
	var max_size := Vector2(180, 170)
	match _model.placement_id:
		"road_life_b": max_size = Vector2(112, 72)
		"resident_house_b": max_size = Vector2(188, 188)
		"dairy_pasture": max_size = Vector2(230, 174)
		"creamery": max_size = Vector2(190, 188)
	var rect := _asset_rect(texture, center, max_size.x, max_size.y)
	draw_texture_rect(texture, rect, false, Color(1, 1, 1, 0.72 if _model.placement_valid else 0.48))
	if not _model.placement_valid:
		var mark := rect.get_center()
		draw_circle(mark, 28.0, RED)
		draw_line(mark - Vector2(12, 12), mark + Vector2(12, 12), WHITE, 6.0, true)
		draw_line(mark + Vector2(12, -12), mark + Vector2(-12, 12), WHITE, 6.0, true)


func _draw_world_status() -> void:
	var card := Rect2(52, 806, 616, 92)
	draw_style_box(_panel_style(Color(1, 0.98, 0.91, 0.96), INK, 20), card)
	var blocked: bool = _model.bear_state == "blocked" or (not _model.placement_id.is_empty() and not _model.placement_valid)
	var accent := RED if blocked else TEAL
	draw_circle(Vector2(card.position.x + 38, card.position.y + 39), 14.0, accent)
	var status: String = _text.text(_model.status_text_key())
	_draw_text(status, Vector2(card.position.x + 66, card.position.y + 42), 20, INK)
	var order: Dictionary = _config.record("orders", "dairy_delivery")
	var order_text: String = _text.text("order_progress", [_model.order_loaded, _config.number(order, "quantity")])
	_draw_text(order_text, Vector2(card.position.x + 66, card.position.y + 72), 15, TEAL_DARK)


func _draw_hud() -> void:
	draw_style_box(_panel_style(PAPER, INK, 0), Rect2(0, 0, 720, 106))
	draw_circle(Vector2(48, 52), 27.0, TEAL)
	draw_circle(Vector2(48, 52), 19.0, GOLD)
	draw_circle(Vector2(48, 52), 9.0, PAPER)
	_draw_text(_text.text("town_name"), Vector2(86, 61), 26, INK)
	draw_style_box(_panel_style(PAPER_DARK, INK, 22), Rect2(424, 25, 182, 56))
	draw_circle(Vector2(453, 53), 14.0, GOLD)
	_draw_text("%s  %d" % [_text.text("coins"), _model.coins], Vector2(475, 61), 19, INK)
	draw_style_box(_panel_style(PAPER_DARK, INK, 18), SETTINGS_RECT)
	draw_circle(SETTINGS_RECT.get_center(), 15.0, TEAL)
	draw_circle(SETTINGS_RECT.get_center(), 6.0, PAPER)
	for index in range(8):
		var angle := float(index) * TAU / 8.0
		var from := SETTINGS_RECT.get_center() + Vector2(cos(angle), sin(angle)) * 13.0
		var to := SETTINGS_RECT.get_center() + Vector2(cos(angle), sin(angle)) * 18.0
		draw_line(from, to, TEAL_DARK, 3.0, true)
	_hit_regions["settings"] = SETTINGS_RECT


func _draw_context_panel() -> void:
	draw_style_box(_panel_style(PAPER, INK, 26), PANEL_RECT)
	if _build_drawer and _model.placement_id.is_empty():
		_draw_build_drawer()
		return
	if not _model.placement_id.is_empty():
		_draw_placement_panel()
		return
	if _selected_id.begins_with("road:"):
		_draw_road_panel()
		return
	var title: String = _text.text(_model.status_text_key())
	var detail: String = _text.text(_model.feedback_key, _model.feedback_args)
	if detail == title:
		detail = _text.text("order_progress", [_model.order_loaded, _config.number(_config.record("orders", "dairy_delivery"), "quantity")])
	_draw_text(title, Vector2(50, 970), 25, INK)
	_draw_multiline(detail, Rect2(50, 995, 610, 60), 17, TEAL_DARK)
	if not _model.all_required_placed():
		_draw_button(PRIMARY_RECT, _text.text("build_neighborhood"), true, true)
		_hit_regions["panel:build"] = PRIMARY_RECT
	elif not _model.bear_invited:
		var cost: int = _config.number(_config.record("residents", "bear_resident"), "invite_cost")
		_draw_text(_text.text("invite_cost", [cost]), Vector2(50, 1062), 17, INK_SOFT)
		_draw_button(PRIMARY_RECT, _text.text("invite_bear"), true, true)
		_hit_regions["panel:invite"] = PRIMARY_RECT
	elif not _model.bear_assigned:
		_draw_button(PRIMARY_RECT, _text.text("confirm_assign"), true, true)
		_hit_regions["panel:assign"] = PRIMARY_RECT
	elif _model.bear_state == "blocked":
		_draw_button(PRIMARY_RECT, _text.text("locate_gap"), true, true)
		_hit_regions["panel:locate"] = PRIMARY_RECT
	elif _model.bear_assigned:
		if _model.WORK_STATES.has(_model.bear_state):
			var progress_rect := Rect2(52, 1060, 590, 16)
			draw_style_box(_panel_style(PAPER_DARK, INK, 8), progress_rect)
			var fill := Rect2(progress_rect.position + Vector2(3, 3), Vector2((progress_rect.size.x - 6) * _model.resident_progress(), progress_rect.size.y - 6))
			draw_rect(fill, TEAL)
		_draw_task_journey()


func _draw_task_journey() -> void:
	var active_step := _active_task_step()
	var start := Vector2(92, 1130)
	var spacing := 134.0
	draw_line(start, start + Vector2(spacing * 4.0, 0), INK_SOFT, 5.0, true)
	for step in range(5):
		var center := start + Vector2(spacing * float(step), 0)
		var completed := active_step > step or active_step >= 5
		var active := active_step == step
		var fill := GOLD if completed else CORAL if active else PAPER_DARK
		draw_circle(center, 25.0, PAPER)
		draw_circle(center, 22.0, fill)
		draw_circle(center, 22.0, INK, false, 3.0, true)
		_draw_task_icon(center, step, INK)


func _active_task_step() -> int:
	match _model.bear_state:
		"walking_to_pasture", "feeding", "milking":
			return 0
		"walking_to_creamery":
			return 1
		"processing":
			return 2
		"walking_to_truck", "loading":
			return 3
		"walking_to_life":
			return 4
		"life_idle":
			return 5
	return 0


func _draw_task_icon(center: Vector2, step: int, color: Color) -> void:
	match step:
		0:
			draw_circle(center + Vector2(-5, 1), 7.0, color)
			draw_circle(center + Vector2(5, -4), 7.0, color)
			draw_line(center + Vector2(-10, 9), center + Vector2(10, -10), color, 3.0, true)
		1:
			var drop := PackedVector2Array([
				center + Vector2(0, -12),
				center + Vector2(10, 4),
				center + Vector2(7, 11),
				center + Vector2(-7, 11),
				center + Vector2(-10, 4),
			])
			draw_colored_polygon(drop, color)
		2:
			draw_circle(center, 11.0, color)
			draw_circle(center, 4.0, PAPER)
			for index in range(8):
				var angle := float(index) * TAU / 8.0
				draw_line(center + Vector2(cos(angle), sin(angle)) * 10.0, center + Vector2(cos(angle), sin(angle)) * 15.0, color, 4.0, true)
		3:
			draw_rect(Rect2(center - Vector2(11, 9), Vector2(22, 18)), color, false, 4.0)
			draw_line(center + Vector2(0, -9), center + Vector2(0, 9), color, 3.0)
			draw_line(center + Vector2(-11, 0), center + Vector2(11, 0), color, 3.0)
		4:
			var roof := PackedVector2Array([
				center + Vector2(-13, -2),
				center + Vector2(0, -14),
				center + Vector2(13, -2),
			])
			draw_polyline(roof, color, 4.0, true)
			draw_rect(Rect2(center + Vector2(-10, -2), Vector2(20, 15)), color, false, 4.0)


func _draw_build_drawer() -> void:
	_draw_text(_text.text("choose_building"), Vector2(48, 962), 24, INK)
	var object_ids := ["road_life_b", "resident_house_b", "dairy_pasture", "creamery"]
	for index in range(object_ids.size()):
		var object_id: String = object_ids[index]
		var rect := Rect2(36 + index * 164, 990, 150, 150)
		_draw_build_card(object_id, rect)
	_draw_button(Rect2(274, 1148, 172, 48), _text.text("cancel"), false, true)
	_hit_regions["panel:build-close"] = Rect2(274, 1148, 172, 48)


func _draw_build_card(object_id: String, rect: Rect2) -> void:
	var object_row: Dictionary = _config.record("objects", object_id)
	var placed: bool = _model.placements.has(object_id)
	var unlocked: bool = _config.object_unlocked(object_id, _model.placements)
	var enabled: bool = unlocked and not placed
	var fill := PAPER_DARK if enabled else Color("DDD5C4")
	draw_style_box(_panel_style(fill, INK, 16), rect)
	var texture: Texture2D = _textures.get(_config.text(object_row, "asset_id"))
	var image_rect := _asset_rect(texture, rect.get_center() + Vector2(0, -5), 102.0, 88.0)
	draw_texture_rect(texture, image_rect, false, Color(1, 1, 1, 1.0 if enabled else 0.42))
	var label: String = _text.text(_config.text(object_row, "display_key"))
	_draw_centered_text(label, Rect2(rect.position.x + 6, rect.position.y + 104, rect.size.x - 12, 22), 14, INK)
	var cost_text := "✓" if placed else "%d" % _config.number(object_row, "cost")
	var badge := Vector2(rect.end.x - 24, rect.position.y + 24)
	draw_circle(badge, 17.0, TEAL if placed else GOLD)
	_draw_centered_text(cost_text, Rect2(badge - Vector2(15, 10), Vector2(30, 20)), 14, INK)
	if enabled:
		_hit_regions["build:%s" % object_id] = rect


func _draw_placement_panel() -> void:
	var object_row: Dictionary = _config.record("objects", _model.placement_id)
	var title: String = _text.text(_config.text(object_row, "display_key"))
	var detail: String = _text.text(_model.placement_reason if not _model.placement_reason.is_empty() else "tap_grid")
	_draw_text(title, Vector2(50, 968), 26, INK)
	_draw_multiline(detail, Rect2(50, 1002, 610, 62), 18, TEAL_DARK if _model.placement_valid else RED)
	_draw_button(SECONDARY_RECT, _text.text("cancel"), false, true)
	_draw_button(PRIMARY_RECT, _text.text("confirm_place"), true, _model.placement_valid)
	_hit_regions["panel:cancel"] = SECONDARY_RECT
	if _model.placement_valid:
		_hit_regions["panel:confirm"] = PRIMARY_RECT


func _draw_road_panel() -> void:
	var road_id := _selected_id.trim_prefix("road:")
	var blocked: bool = _model.blocked_roads.has(road_id)
	_draw_text(_text.text("road_life"), Vector2(50, 970), 25, INK)
	_draw_multiline(_text.text("road_missing" if blocked else "placement_legal"), Rect2(50, 1000, 610, 60), 18, RED if blocked else TEAL_DARK)
	var label: String = _text.text("open_road") if blocked else _text.text("close_road")
	_draw_button(PRIMARY_RECT, label, false, true)
	_hit_regions["panel:road-toggle"] = PRIMARY_RECT


func _draw_settings() -> void:
	draw_rect(Rect2(0, 0, 720, 1280), SCRIM)
	var panel := Rect2(48, 252, 624, 650)
	draw_style_box(_panel_style(PAPER, INK, 28), panel)
	_draw_text(_text.text("settings"), Vector2(82, 316), 32, INK)
	_draw_button(PANEL_CLOSE_RECT, "×", false, true)
	_hit_regions["panel:close"] = PANEL_CLOSE_RECT
	_draw_text(_text.text("language"), Vector2(84, 392), 22, INK)
	var zh_rect := Rect2(84, 420, 246, 70)
	var en_rect := Rect2(390, 420, 246, 70)
	_draw_button(zh_rect, _text.text("chinese"), _text.locale == "zh-CN", true)
	_draw_button(en_rect, _text.text("english"), _text.locale == "en", true)
	_hit_regions["panel:lang:zh"] = zh_rect
	_hit_regions["panel:lang:en"] = en_rect
	_draw_text(_text.text("reduced_motion"), Vector2(84, 580), 22, INK)
	var motion_rect := Rect2(84, 612, 552, 76)
	_draw_button(motion_rect, _text.text("on" if _text.reduced_motion else "off"), _text.reduced_motion, true)
	_hit_regions["panel:motion"] = motion_rect
	_draw_multiline(_text.text("settings_note"), Rect2(84, 742, 552, 90), 18, TEAL_DARK)


func _draw_celebration() -> void:
	var duration := maxf(_config.setting_float("celebration_seconds", _text.reduced_motion), 0.1)
	var progress := 1.0 - _celebration_elapsed / duration
	var colors: Array[Color] = [GOLD, TEAL, CORAL, WHITE]
	var particle_count: int = _config.setting_int("max_particles", _text.reduced_motion)
	for index in range(particle_count):
		var angle := float(index) * TAU / float(maxi(particle_count, 1))
		var radius := 54.0 + progress * (92.0 + float(index % 5) * 10.0)
		var point := Vector2(574, 680) + Vector2(cos(angle), sin(angle)) * radius
		draw_circle(point, 4.0 + float(index % 3), colors[index % colors.size()])


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
	elif target == "panel:build":
		_build_drawer = true
		_selected_id = ""
	elif target == "panel:build-close":
		_build_drawer = false
	elif target.begins_with("build:"):
		if _model.select_placement(target.trim_prefix("build:")):
			_build_drawer = false
			_play_event("placement_valid" if _model.placement_valid else "placement_invalid")
	elif target.begins_with("grid:"):
		var parts := target.split(":")
		if parts.size() == 3:
			var valid: bool = _model.update_placement(Vector2i(parts[1].to_int(), parts[2].to_int()))
			_play_event("placement_valid" if valid else "placement_invalid")
	elif target == "panel:confirm":
		_model.confirm_placement()
	elif target == "panel:cancel":
		_model.cancel_placement()
	elif target == "panel:invite":
		_model.invite_bear()
	elif target == "panel:assign":
		_model.assign_dairy_job()
	elif target == "panel:locate":
		_selected_id = "road:road_mid_b"
	elif target == "panel:road-toggle":
		var road_id := _selected_id.trim_prefix("road:")
		_model.set_road_blocked(road_id, not _model.blocked_roads.has(road_id))
	elif target.begins_with("road:"):
		_selected_id = target
	elif target.begins_with("object:"):
		_selected_id = target.trim_prefix("object:")
	elif target in ["rabbit", "bear", "cow", "truck"]:
		_selected_id = target
	queue_redraw()


func _target_at(point: Vector2) -> String:
	if _settings_open:
		for key in ["panel:close", "panel:lang:zh", "panel:lang:en", "panel:motion"]:
			if _hit_regions.has(key) and (_hit_regions[key] as Rect2).has_point(point):
				return key
		return ""
	var priority_prefixes := ["settings", "panel:", "build:", "grid:", "bear", "rabbit", "cow", "truck", "object:", "road:"]
	for prefix in priority_prefixes:
		for target_variant in _hit_regions.keys():
			var target := str(target_variant)
			if (target == prefix or target.begins_with(prefix)) and (_hit_regions[target] as Rect2).has_point(point):
				return target
	return ""


func _load_textures() -> void:
	for asset_id in _config.approved_asset_ids():
		var path: String = _config.asset_path(asset_id)
		var texture = load(path)
		if texture != null:
			_textures[asset_id] = texture


func _on_model_changed() -> void:
	queue_redraw()


func _on_milestone(event_id: String) -> void:
	_last_milestone = event_id
	if event_id.begins_with("building_placed"):
		_play_event("building_placed")
	elif event_id == "resident_invited":
		_play_event("resident_invited")
	elif event_id == "job_assigned":
		_play_event("job_assigned")
	elif event_id == "feed_complete":
		_play_event("feed_complete")
	elif event_id == "milk_complete":
		_play_event("milk_complete")
	elif event_id == "process_complete":
		_play_event("process_complete")
	elif event_id == "resident_blocked":
		_play_event("resident_blocked")
	elif event_id == "resident_resumed":
		_play_event("resident_resumed")
	elif event_id == "order_completed":
		_play_event("order_completed")
		_celebration_elapsed = _config.setting_float("celebration_seconds", _text.reduced_motion)
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


func _play_event(event_id: String) -> void:
	var row: Dictionary = _config.audio_event(event_id)
	if row.is_empty():
		return
	var now := Time.get_ticks_msec()
	var cooldown: int = _config.number(row, "cooldown_ms")
	if now - int(_last_audio_ms.get(event_id, -cooldown)) < cooldown:
		return
	_last_audio_ms[event_id] = now
	_tone_frequency = _config.decimal(row, "frequency")
	_tone_remaining = _config.decimal(row, "duration_seconds")
	_tone_amplitude = minf(pow(10.0, _config.decimal(row, "gain_db") / 20.0), 0.22)
	_tone_phase = 0.0


func _pump_tone(delta: float) -> void:
	if _tone_remaining <= 0.0 or _tone_playback == null:
		return
	var frames := mini(int(_tone_playback.get_frames_available()), int(22050.0 * minf(delta, _tone_remaining)))
	for _frame_index in range(frames):
		var envelope := minf(_tone_remaining * 8.0, 1.0)
		var sample := sin(_tone_phase) * _tone_amplitude * envelope
		_tone_playback.push_frame(Vector2(sample, sample))
		_tone_phase += TAU * _tone_frequency / 22050.0
	_tone_remaining = maxf(_tone_remaining - delta, 0.0)


func shutdown_audio() -> void:
	_tone_playback = null
	if _tone_player != null:
		_tone_player.stop()
		_tone_player.stream = null
		if is_instance_valid(_tone_player):
			_tone_player.free()
		_tone_player = null


func _update_transform() -> void:
	_draw_scale = minf(size.x / DESIGN_SIZE.x, size.y / DESIGN_SIZE.y)
	_draw_offset = (size - DESIGN_SIZE * _draw_scale) * 0.5


func _to_design(point: Vector2) -> Vector2:
	_update_transform()
	return (point - _draw_offset) / maxf(_draw_scale, 0.001)


func _iso(cell: Vector2) -> Vector2:
	var half_width: float = _config.setting_float("tile_width") * 0.5
	var half_height: float = _config.setting_float("tile_height") * 0.5
	return Vector2(
		_config.setting_float("origin_x") + (cell.x - cell.y) * half_width,
		_config.setting_float("origin_y") + (cell.x + cell.y) * half_height
	)


func _footprint_center(grid_id: String, origin: Vector2i) -> Vector2:
	var size_value: Vector2i = _config.footprint_size(grid_id)
	var center_cell := Vector2(origin) + Vector2(float(size_value.x - 1), float(size_value.y - 1)) * 0.5
	return _iso(center_cell)


func _footprint_outline(grid_id: String, origin: Vector2i) -> PackedVector2Array:
	var size_value: Vector2i = _config.footprint_size(grid_id)
	var center := _footprint_center(grid_id, origin) + Vector2(0, 8)
	var half_width: float = _config.setting_float("tile_width") * float(size_value.x + size_value.y) * 0.25
	var half_height: float = _config.setting_float("tile_height") * float(size_value.x + size_value.y) * 0.25
	return _diamond(center, half_width, half_height)


func _cell_diamond(center: Vector2) -> PackedVector2Array:
	return _diamond(center + Vector2(0, 8), _config.setting_float("tile_width") * 0.5, _config.setting_float("tile_height") * 0.5)


func _diamond(center: Vector2, half_width: float, half_height: float) -> PackedVector2Array:
	return PackedVector2Array([
		center + Vector2(0, -half_height),
		center + Vector2(half_width, 0),
		center + Vector2(0, half_height),
		center + Vector2(-half_width, 0),
		center + Vector2(0, -half_height),
	])


func _asset_rect(texture: Texture2D, center: Vector2, max_width: float, max_height: float) -> Rect2:
	if texture == null:
		return Rect2(center, Vector2.ZERO)
	var texture_size := texture.get_size()
	var scale_value := minf(max_width / maxf(texture_size.x, 1.0), max_height / maxf(texture_size.y, 1.0))
	var draw_size := texture_size * scale_value
	return Rect2(center.x - draw_size.x * 0.5, center.y - draw_size.y + max_height * 0.46, draw_size.x, draw_size.y)


func _panel_style(fill: Color, border: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(3)
	style.set_corner_radius_all(radius)
	style.shadow_color = SHADOW
	style.shadow_size = 8
	return style


func _draw_button(rect: Rect2, label: String, primary: bool, enabled: bool) -> void:
	var fill := CORAL if primary else PAPER_DARK
	var text_color := WHITE if primary else INK
	if not enabled:
		fill = Color("C8C4B8")
		text_color = INK_SOFT
	draw_style_box(_panel_style(fill, INK, 18), rect)
	_draw_centered_text(label, rect, 20, text_color)


func _draw_text(value: String, position: Vector2, font_size: int, color: Color) -> void:
	draw_string(ThemeDB.fallback_font, position, value, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)


func _draw_centered_text(value: String, rect: Rect2, font_size: int, color: Color) -> void:
	var font := ThemeDB.fallback_font
	var width := font.get_string_size(value, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	var x := rect.get_center().x - width * 0.5
	var y := rect.get_center().y + float(font_size) * 0.35
	_draw_text(value, Vector2(x, y), font_size, color)


func _draw_multiline(value: String, rect: Rect2, font_size: int, color: Color) -> void:
	draw_multiline_string(ThemeDB.fallback_font, rect.position, value, HORIZONTAL_ALIGNMENT_LEFT, rect.size.x, font_size, -1, color)


func debug_snapshot() -> Dictionary:
	var leaked_assets: Array[String] = []
	for asset_id in _config.approved_asset_ids():
		var path: String = _config.asset_path(asset_id)
		if path.contains("/source/") or path.contains("/qa/") or path.contains("candidate"):
			leaked_assets.append(path)
	return {
		"runtime_ready": _runtime_ready,
		"design_size": [720, 1280],
		"config_valid": _config != null and _config.is_valid(),
		"locale": _text.locale if _text != null else "",
		"reduced_motion": _text.reduced_motion if _text != null else false,
		"coins": _model.coins if _model != null else 0,
		"placements_count": _model.placements.size() if _model != null else 0,
		"required_placed": _model.all_required_placed() if _model != null else false,
		"placement_id": _model.placement_id if _model != null else "",
		"placement_valid": _model.placement_valid if _model != null else false,
		"placement_reason": _model.placement_reason if _model != null else "",
		"bear_invited": _model.bear_invited if _model != null else false,
		"bear_assigned": _model.bear_assigned if _model != null else false,
		"bear_state": _model.bear_state if _model != null else "",
		"rabbit_state": _model.rabbit_state if _model != null else "",
		"cow_state": _model.cow_state if _model != null else "",
		"carried_item": _model.carried_item if _model != null else "",
		"truck_state": _model.truck_state if _model != null else "",
		"order_loaded": _model.order_loaded if _model != null else 0,
		"order_complete": _model.order_complete if _model != null else false,
		"asset_count": _textures.size(),
		"candidate_asset_leak": not leaked_assets.is_empty(),
		"leaked_assets": leaked_assets,
		"audio_enabled": not disable_audio,
		"selected": _selected_id,
		"settings_open": _settings_open,
		"build_drawer": _build_drawer,
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
