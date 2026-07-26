extends Control

const Farm2Config = preload("res://scripts/town/farm2_config.gd")
const Farm2Model = preload("res://scripts/town/farm2_model.gd")
const Farm2Text = preload("res://scripts/town/farm2_text.gd")
const Farm2Save = preload("res://scripts/town/farm2_save.gd")
const Farm2FeedbackLayer = preload("res://scripts/town/farm2_feedback_layer.gd")

const DESIGN_SIZE := Vector2(720.0, 1280.0)
const MAP_RECT := Rect2(0.0, 108.0, 720.0, 1036.0)
const SETTINGS_RECT := Rect2(650.0, 24.0, 48.0, 48.0)
const PANEL_RECT := Rect2(36.0, 650.0, 648.0, 442.0)
const PANEL_CLOSE_RECT := Rect2(628.0, 670.0, 38.0, 38.0)
const NAV_RECTS := [
	Rect2(0.0, 1144.0, 144.0, 136.0),
	Rect2(144.0, 1144.0, 144.0, 136.0),
	Rect2(288.0, 1144.0, 144.0, 136.0),
	Rect2(432.0, 1144.0, 144.0, 136.0),
	Rect2(576.0, 1144.0, 144.0, 136.0),
]

const INK := Color("24434C")
const PAPER := Color("FFF9E8")
const PAPER_DARK := Color("F4E4BE")
const SKY := Color("CFEDEE")
const GRASS := Color("94D37A")
const GRASS_LIGHT := Color("A9DE8B")
const GRASS_DARK := Color("65A85F")
const SOIL := Color("B96F42")
const SOIL_DARK := Color("86482F")
const PATH := Color("E8C98F")
const PATH_EDGE := Color("C39B64")
const TEAL := Color("159A8C")
const TEAL_DARK := Color("0B6D69")
const GOLD := Color("F4C14E")
const CORAL := Color("DA654C")
const RED := Color("BC433D")
const WHITE := Color("FFFFFF")
const SHADOW := Color(0.08, 0.18, 0.18, 0.22)
const SCRIM := Color(0.05, 0.14, 0.16, 0.45)
const LOCKED := Color("788A86")

@export var disable_persistence := false

var _config
var _model
var _text_catalog
var _save_service
var _textures: Dictionary = {}
var _asset_paths: Dictionary = {}
var _hit_regions: Dictionary = {}
var _camera_offset := Vector2(380.0, 180.0)
var _press_position := Vector2.ZERO
var _last_pointer_position := Vector2.ZERO
var _press_target := ""
var _dragging := false
var _pointer_down := false
var _hovered_target := ""
var _panel := ""
var _panel_subject := ""
var _selected_plot := -1
var _selected_building := ""
var _autosave_elapsed := 0.0
var _motion_clock := 0.0
var _runtime_ready := false
var _feedback_layer
var _map_hint_dismissed := false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	focus_mode = Control.FOCUS_ALL
	_config = Farm2Config.load_default()
	_text_catalog = Farm2Text.new()
	if not _config.is_valid():
		push_error("FARM.2 configuration error: %s" % "; ".join(_config.errors))
		return
	if not _text_catalog.is_valid():
		push_error("FARM.2 locale error: %s" % "; ".join(_text_catalog.errors))
		return
	_model = Farm2Model.new(_config)
	_save_service = Farm2Save.new()
	_model.changed.connect(_on_model_changed)
	_feedback_layer = Farm2FeedbackLayer.new()
	_feedback_layer.name = "Farm2FeedbackLayer"
	add_child(_feedback_layer)
	_feedback_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_index_runtime_assets()
	_load_runtime_textures()
	if not disable_persistence:
		var load_result: Dictionary = _save_service.load_into(_model)
		if bool(load_result.get("migrated", false)):
			_model.set_feedback("feedback_migrated")
	var window := get_window()
	if window != null:
		window.size = Vector2i(int(DESIGN_SIZE.x), int(DESIGN_SIZE.y))
		window.min_size = Vector2i(360, 640)
	_runtime_ready = true
	set_process(true)
	queue_redraw()


func _exit_tree() -> void:
	if _runtime_ready and not disable_persistence and _save_service != null and _model != null:
		_save_service.save_model(_model)


func _process(delta: float) -> void:
	if not _runtime_ready:
		return
	_motion_clock += delta
	if _model.tick(delta):
		queue_redraw()
	if not disable_persistence:
		_autosave_elapsed += delta
		if _autosave_elapsed >= float(_config.world_int("autosave_interval_seconds")):
			_autosave_elapsed = 0.0
			_save_service.save_model(_model)
	if not _text_catalog.reduced_motion:
		queue_redraw()


func _gui_input(event: InputEvent) -> void:
	if not _runtime_ready:
		return
	if event is InputEventMouseMotion:
		var mouse_event := event as InputEventMouseMotion
		var design_position := _to_design(mouse_event.position)
		if _pointer_down:
			_handle_pointer_motion(design_position)
		else:
			var next_target := _target_at_design(design_position)
			if next_target != _hovered_target:
				_hovered_target = next_target
				queue_redraw()
	elif event is InputEventMouseButton:
		var mouse_button := event as InputEventMouseButton
		if mouse_button.button_index != MOUSE_BUTTON_LEFT:
			return
		var design_position := _to_design(mouse_button.position)
		if mouse_button.pressed:
			_begin_pointer(design_position)
		else:
			_end_pointer(design_position)
		accept_event()
	elif event is InputEventScreenTouch:
		var touch_event := event as InputEventScreenTouch
		var design_position := _to_design(touch_event.position)
		if touch_event.pressed:
			_begin_pointer(design_position)
		else:
			_end_pointer(design_position)
		accept_event()
	elif event is InputEventScreenDrag:
		var drag_event := event as InputEventScreenDrag
		_handle_pointer_motion(_to_design(drag_event.position))
		accept_event()


func _begin_pointer(position: Vector2) -> void:
	_pointer_down = true
	_dragging = false
	_press_position = position
	_last_pointer_position = position
	_press_target = _target_at_design(position)


func _handle_pointer_motion(position: Vector2) -> void:
	if not _pointer_down:
		return
	var threshold: float = float(_config.world_int("camera_pan_threshold_px"))
	if position.distance_to(_press_position) >= threshold and _panel.is_empty() and MAP_RECT.has_point(_press_position):
		_dragging = true
	if _dragging:
		var delta := position - _last_pointer_position
		_feedback_layer.cancel_all()
		_map_hint_dismissed = true
		_camera_offset -= delta
		_clamp_camera()
		queue_redraw()
	_last_pointer_position = position


func _end_pointer(position: Vector2) -> void:
	if not _pointer_down:
		return
	_pointer_down = false
	if not _dragging:
		var target := _target_at_design(position)
		if target == _press_target or _press_target.is_empty():
			_activate_target(target)
	_dragging = false
	_press_target = ""


func _target_at_design(point: Vector2) -> String:
	if not _panel.is_empty():
		if PANEL_CLOSE_RECT.has_point(point):
			return "panel:close"
		for target_variant in _hit_regions.keys():
			var target := str(target_variant)
			if target.begins_with("panel:") and (_hit_regions[target] as Rect2).has_point(point):
				return target
		if PANEL_RECT.has_point(point):
			return "panel:block"
		return "panel:close"
	if SETTINGS_RECT.has_point(point):
		return "nav:settings"
	for index in range(NAV_RECTS.size()):
		if NAV_RECTS[index].has_point(point):
			return "nav:%d" % index
	var ordered_targets: Array[String] = []
	for target_variant in _hit_regions.keys():
		var target := str(target_variant)
		if not target.begins_with("panel:"):
			ordered_targets.append(target)
	ordered_targets.reverse()
	for target in ordered_targets:
		if (_hit_regions[target] as Rect2).has_point(point):
			return target
	return ""


func _activate_target(target: String) -> void:
	if target == "panel:close":
		_close_panel()
	elif target == "panel:block" or target.is_empty():
		pass
	elif target == "nav:settings" or target == "nav:4":
		_open_panel("settings")
	elif target == "nav:1":
		_open_panel("requests")
	elif target == "nav:3":
		_open_panel("market")
	elif target == "nav:0":
		_close_panel()
		_camera_offset = Vector2(380.0, 180.0)
		_clamp_camera()
	elif target == "nav:2":
		_panel_subject = "build"
		_open_panel("building_info")
	elif target.begins_with("plot:"):
		_activate_plot(target.trim_prefix("plot:").to_int())
	elif target.begins_with("building:"):
		_activate_building(target.trim_prefix("building:"))
	elif target.begins_with("panel:crop:"):
		var crop_id := target.trim_prefix("panel:crop:")
		if _selected_plot >= 0:
			_model.plant_plot(_selected_plot, crop_id)
		_close_panel()
	elif target.begins_with("panel:recipe:"):
		var recipe_id := target.trim_prefix("panel:recipe:")
		_model.queue_recipe(recipe_id)
		_close_panel()
	elif target.begins_with("panel:request:"):
		_model.fulfill_request(target.trim_prefix("panel:request:"))
	elif target.begins_with("panel:sell:"):
		_model.market_sell(target.trim_prefix("panel:sell:"), 1)
	elif target == "panel:locale:zh-CN":
		_text_catalog.set_locale("zh-CN", not disable_persistence)
	elif target == "panel:locale:en":
		_text_catalog.set_locale("en", not disable_persistence)
	elif target == "panel:motion":
		_text_catalog.set_reduced_motion(not _text_catalog.reduced_motion, not disable_persistence)
	queue_redraw()


func _activate_plot(index: int) -> void:
	if index < 0 or index >= _model.plots.size():
		return
	_map_hint_dismissed = true
	var state := str(_model.plots[index].get("state", ""))
	if state == "empty":
		_selected_plot = index
		_open_panel("crops")
	elif state == "ready":
		var crop_id := str(_model.plots[index].get("crop_id", ""))
		var crop: Dictionary = _config.record("crops", crop_id)
		var yield_count: int = _config.number(crop, "harvest_yield")
		var source := _world_to_design(_plot_world_position(index)) + Vector2(0.0, -8.0)
		var target := Vector2(576.0, 50.0)
		if _model.harvest_plot(index):
			_feedback_layer.play_harvest(
				source,
				target,
				yield_count,
				_crop_feedback_color(crop_id),
				_text_catalog.reduced_motion
			)
		else:
			_feedback_layer.play_blocked(source, target, _text_catalog.reduced_motion)
	else:
		_selected_plot = index
		_panel_subject = "plot:%d" % index
		_open_panel("building_info")


func _activate_building(building_id: String) -> void:
	var building: Dictionary = _config.record("buildings", building_id)
	if building.is_empty():
		return
	_selected_building = building_id
	var kind: String = _config.text(building, "kind")
	if kind == "locked_machine":
		_model.set_feedback("feedback_locked", [_config.number(building, "unlock_level")])
		return
	match kind:
		"machine":
			var machine_state: String = _model.machine_state(building_id)
			if machine_state == "output_ready":
				_model.collect_machine(building_id)
			else:
				_panel_subject = building_id
				_open_panel("recipes")
		"animal_pen":
			var animal_id := _animal_for_pen(building_id)
			if not animal_id.is_empty() and not _model.interact_animal(animal_id):
				_panel_subject = building_id
				_open_panel("building_info")
		"request_board":
			_open_panel("requests")
		"market":
			_open_panel("market")
		_:
			_panel_subject = building_id
			_open_panel("building_info")


func _animal_for_pen(pen_id: String) -> String:
	for animal in _config.rows("animals"):
		if _config.text(animal, "pen_id") == pen_id:
			return _config.text(animal, "id")
	return ""


func _open_panel(panel_id: String) -> void:
	if _feedback_layer != null:
		_feedback_layer.cancel_all()
	_panel = panel_id
	queue_redraw()


func _close_panel() -> void:
	_panel = ""
	_panel_subject = ""
	_selected_plot = -1
	queue_redraw()


func _on_model_changed() -> void:
	queue_redraw()


func _index_runtime_assets() -> void:
	_asset_paths.clear()
	var animal_root := "res://assets/runtime/f003_farm2/animals/"
	var building_root := "res://assets/runtime/f003_farm2/buildings/"
	for file_name in DirAccess.get_files_at(animal_root):
		if file_name.ends_with(".png"):
			_asset_paths[file_name.trim_suffix(".png")] = animal_root + file_name
	for file_name in DirAccess.get_files_at(building_root):
		if file_name.ends_with(".png"):
			_asset_paths[file_name.trim_suffix(".png")] = building_root + file_name


func _load_runtime_textures() -> void:
	_textures.clear()
	for asset_id_variant in _asset_paths.keys():
		var asset_id := str(asset_id_variant)
		var path := str(_asset_paths[asset_id])
		var image := Image.load_from_file(ProjectSettings.globalize_path(path))
		if image == null or image.is_empty():
			push_error("Could not load FARM.2 runtime image: %s" % path)
			continue
		_textures[asset_id] = ImageTexture.create_from_image(image)


func _draw() -> void:
	if not _runtime_ready:
		return
	var metrics := _metrics()
	draw_set_transform(metrics.offset, 0.0, Vector2(metrics.scale, metrics.scale))
	_hit_regions.clear()
	_draw_map()
	_draw_header()
	_draw_footer()
	if not _panel.is_empty():
		_draw_panel()
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _metrics() -> Dictionary:
	var scale_factor: float = minf(size.x / DESIGN_SIZE.x, size.y / DESIGN_SIZE.y)
	if scale_factor <= 0.0:
		scale_factor = 1.0
	var offset: Vector2 = (size - DESIGN_SIZE * scale_factor) * 0.5
	return {"scale": scale_factor, "offset": offset}


func _to_design(local_position: Vector2) -> Vector2:
	var metrics := _metrics()
	return (local_position - metrics.offset) / metrics.scale


func _clamp_camera() -> void:
	_camera_offset.x = clampf(
		_camera_offset.x,
		float(_config.world_int("camera_min_x")),
		float(_config.world_int("camera_max_x"))
	)
	_camera_offset.y = clampf(
		_camera_offset.y,
		float(_config.world_int("camera_min_y")),
		float(_config.world_int("camera_max_y"))
	)


func _world_to_design(world_position: Vector2) -> Vector2:
	return world_position - _camera_offset + MAP_RECT.position


func _plot_world_position(index: int) -> Vector2:
	var column := index % 4
	var row := index / 4
	return Vector2(470.0 + float(column) * 132.0, 300.0 + float(row) * 104.0)


func _draw_map() -> void:
	draw_rect(MAP_RECT, GRASS)
	_draw_ground_tiles()
	_draw_farm_focus_ground()
	_draw_water_and_paths()
	var drawables: Array[Dictionary] = []
	for index in range(_model.plots.size()):
		var plot_position := _plot_world_position(index)
		drawables.append({"depth": plot_position.y, "kind": "plot", "index": index, "position": plot_position})
	for building in _config.rows("buildings"):
		var position := Vector2(_config.decimal(building, "world_x"), _config.decimal(building, "world_y"))
		drawables.append({"depth": position.y, "kind": "building", "row": building, "position": position})
	drawables.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return float(a["depth"]) < float(b["depth"]))
	for drawable in drawables:
		if str(drawable["kind"]) == "plot":
			_draw_plot(int(drawable["index"]), drawable["position"])
		else:
			_draw_building(drawable["row"], drawable["position"])
	_draw_wandering_animals()
	if not _map_hint_dismissed:
		_draw_map_hint()


func _draw_ground_tiles() -> void:
	var tile_width := 240.0
	var tile_height := 120.0
	var row_step := 96.0
	var camera_shift := Vector2(fmod(_camera_offset.x, tile_width), fmod(_camera_offset.y, row_step))
	for row in range(-1, 13):
		for column in range(-1, 5):
			var center := Vector2(
				float(column) * tile_width + (tile_width * 0.5 if row % 2 != 0 else 0.0),
				MAP_RECT.position.y + float(row) * row_step
			) - Vector2(camera_shift.x, camera_shift.y * 0.25)
			var color := Color(0.88, 0.97, 0.74, 0.18) if (row + column) % 2 == 0 else Color(0.40, 0.70, 0.36, 0.10)
			draw_colored_polygon(PackedVector2Array([
				center + Vector2(0.0, -tile_height * 0.5),
				center + Vector2(tile_width * 0.5, 0.0),
				center + Vector2(0.0, tile_height * 0.5),
				center + Vector2(-tile_width * 0.5, 0.0),
			]), color)


func _draw_farm_focus_ground() -> void:
	var field_center := _world_to_design(Vector2(668.0, 402.0))
	var field_plate := PackedVector2Array([
		field_center + Vector2(0.0, -236.0),
		field_center + Vector2(356.0, -30.0),
		field_center + Vector2(0.0, 198.0),
		field_center + Vector2(-356.0, -30.0),
	])
	draw_colored_polygon(field_plate, Color(0.74, 0.90, 0.59, 0.72))
	draw_polyline(
		PackedVector2Array([field_plate[0], field_plate[1], field_plate[2], field_plate[3], field_plate[0]]),
		Color(0.32, 0.58, 0.29, 0.36),
		5.0,
		true
	)
	for index in range(8):
		var angle := TAU * float(index) / 8.0
		var tuft_center := field_center + Vector2(cos(angle) * 310.0, sin(angle) * 168.0 - 18.0)
		if not _map_visible(tuft_center, 20.0):
			continue
		draw_line(tuft_center, tuft_center + Vector2(-5.0, -11.0), Color(0.25, 0.53, 0.25, 0.42), 3.0)
		draw_line(tuft_center, tuft_center + Vector2(5.0, -12.0), Color(0.25, 0.53, 0.25, 0.42), 3.0)


func _draw_water_and_paths() -> void:
	var stream_points := PackedVector2Array()
	for index in range(14):
		var world_y := 120.0 + float(index) * 132.0
		var world_x := 1710.0 + sin(float(index) * 0.8) * 55.0
		stream_points.append(_world_to_design(Vector2(world_x, world_y)))
	if stream_points.size() > 1:
		draw_polyline(stream_points, Color("82C9D0"), 92.0, true)
		draw_polyline(stream_points, Color("BDE7E6"), 58.0, true)
	var path_points := PackedVector2Array([
		_world_to_design(Vector2(280.0, 580.0)),
		_world_to_design(Vector2(650.0, 700.0)),
		_world_to_design(Vector2(980.0, 780.0)),
		_world_to_design(Vector2(1290.0, 1060.0)),
		_world_to_design(Vector2(1580.0, 1330.0)),
	])
	draw_polyline(path_points, PATH_EDGE, 74.0, true)
	draw_polyline(path_points, PATH, 58.0, true)


func _draw_plot(index: int, world_position: Vector2) -> void:
	var center := _world_to_design(world_position)
	if not _map_visible(center, 110.0):
		return
	var plot: Dictionary = _model.plots[index]
	var state := str(plot.get("state", "empty"))
	_draw_custom_ellipse(center + Vector2(0.0, 22.0), Vector2(66.0, 18.0), Color(0.08, 0.18, 0.18, 0.18))
	if state == "ready":
		var ready_pulse := 0.0 if _text_catalog.reduced_motion else (sin(_motion_clock * 3.2 + float(index)) + 1.0) * 3.0
		var ready_outline := PackedVector2Array([
			center + Vector2(0.0, -50.0 - ready_pulse),
			center + Vector2(84.0 + ready_pulse, 0.0),
			center + Vector2(0.0, 50.0 + ready_pulse),
			center + Vector2(-84.0 - ready_pulse, 0.0),
			center + Vector2(0.0, -50.0 - ready_pulse),
		])
		draw_colored_polygon(
			PackedVector2Array([ready_outline[0], ready_outline[1], ready_outline[2], ready_outline[3]]),
			Color(0.96, 0.76, 0.31, 0.20)
		)
		draw_polyline(ready_outline, GOLD, 6.0, true)
	var diamond := PackedVector2Array([
		center + Vector2(0.0, -42.0),
		center + Vector2(74.0, 0.0),
		center + Vector2(0.0, 42.0),
		center + Vector2(-74.0, 0.0),
	])
	draw_colored_polygon(diamond, SOIL_DARK)
	var inner := PackedVector2Array([
		center + Vector2(0.0, -34.0),
		center + Vector2(62.0, 0.0),
		center + Vector2(0.0, 34.0),
		center + Vector2(-62.0, 0.0),
	])
	draw_colored_polygon(inner, SOIL)
	for line_index in range(-2, 3):
		var y_offset := float(line_index) * 11.0
		draw_line(center + Vector2(-44.0, y_offset), center + Vector2(44.0, y_offset), Color(0.35, 0.15, 0.08, 0.32), 2.0)
	if state == "empty":
		draw_circle(center + Vector2(0.0, -8.0), 19.0, PAPER)
		_label(center + Vector2(-18.0, 1.0), "+", 30, TEAL_DARK, 36.0)
	else:
		var crop_id := str(plot.get("crop_id", ""))
		var crop: Dictionary = _config.record("crops", crop_id)
		var asset_id: String = _config.text(crop, "asset_id")
		var bob := 0.0 if _text_catalog.reduced_motion else sin(_motion_clock * 2.0 + float(index)) * 2.0
		_draw_asset(asset_id, center + Vector2(0.0, 14.0 + bob), Vector2(112.0, 112.0), 1.0 if state == "ready" else 0.72)
		if state == "growing":
			_draw_timer_badge(center + Vector2(46.0, -40.0), int(ceil(float(plot.get("remaining", 0.0)))))
		elif state == "ready":
			_draw_ready_badge(center + Vector2(46.0, -40.0))
	_hit_regions["plot:%d" % index] = Rect2(center - Vector2(76.0, 48.0), Vector2(152.0, 96.0))


func _crop_feedback_color(crop_id: String) -> Color:
	match crop_id:
		"golden_sprig":
			return GOLD
		"cloud_bean":
			return Color("70B96C")
		"root_carrot":
			return CORAL
	return TEAL


func _draw_building(building: Dictionary, world_position: Vector2) -> void:
	var center := _world_to_design(world_position)
	if not _map_visible(center, 180.0):
		return
	var footprint_w: float = maxf(_config.decimal(building, "footprint_w"), 1.0)
	var footprint_h: float = maxf(_config.decimal(building, "footprint_h"), 1.0)
	var asset_size := Vector2(142.0 + footprint_w * 22.0, 142.0 + footprint_h * 22.0)
	_draw_custom_ellipse(center + Vector2(0.0, -2.0), Vector2(asset_size.x * 0.36, 17.0), SHADOW)
	var kind: String = _config.text(building, "kind")
	var opacity := 0.58 if kind == "locked_machine" else 1.0
	_draw_asset(_config.text(building, "asset_id"), center + Vector2(0.0, 14.0), asset_size, opacity)
	var building_id: String = _config.text(building, "id")
	var hit_rect := Rect2(
		center - Vector2(asset_size.x * 0.38, asset_size.y * 0.72),
		Vector2(asset_size.x * 0.76, asset_size.y * 0.76)
	)
	_hit_regions["building:%s" % building_id] = hit_rect
	_draw_building_state(building, center, asset_size)
	if _hovered_target == "building:%s" % building_id:
		_draw_name_tag(center + Vector2(-90.0, -asset_size.y * 0.72), _t("building_%s" % building_id))


func _draw_custom_ellipse(center: Vector2, radii: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for index in range(24):
		var angle := TAU * float(index) / 24.0
		points.append(center + Vector2(cos(angle) * radii.x, sin(angle) * radii.y))
	draw_colored_polygon(points, color)


func _draw_building_state(building: Dictionary, center: Vector2, asset_size: Vector2) -> void:
	var building_id: String = _config.text(building, "id")
	var kind: String = _config.text(building, "kind")
	var badge_position := center + Vector2(asset_size.x * 0.31, -asset_size.y * 0.55)
	if kind == "locked_machine":
		_draw_lock_badge(badge_position, _config.number(building, "unlock_level"))
	elif kind == "machine":
		var state: String = _model.machine_state(building_id)
		if state == "output_ready":
			_draw_ready_badge(badge_position)
		elif state == "processing":
			_draw_timer_badge(badge_position, int(ceil(_model.machine_remaining(building_id))))
		elif state == "idle":
			_draw_plus_badge(badge_position)
	elif kind == "animal_pen":
		var animal_id := _animal_for_pen(building_id)
		var state: String = _model.animal_state(animal_id)
		if state == "ready":
			_draw_ready_badge(badge_position)
		elif state == "producing":
			_draw_timer_badge(badge_position, int(ceil(float(_model.animals[animal_id].get("remaining", 0.0)))))
		else:
			_draw_feed_badge(badge_position)
	elif kind == "request_board":
		_draw_request_badge(badge_position)
	elif kind == "market":
		_draw_coin_badge(badge_position)


func _draw_wandering_animals() -> void:
	var animal_positions := {
		"chicken": [Vector2(1010.0, 900.0), Vector2(1085.0, 925.0), Vector2(1130.0, 875.0)],
		"cow": [Vector2(1390.0, 995.0), Vector2(1495.0, 1010.0)],
	}
	for animal_id_variant in animal_positions.keys():
		var animal_id := str(animal_id_variant)
		var animal: Dictionary = _config.record("animals", animal_id)
		var asset_id: String = _config.text(animal, "asset_id")
		var positions: Array = animal_positions[animal_id]
		for index in range(positions.size()):
			var center := _world_to_design(positions[index])
			if not _map_visible(center, 70.0):
				continue
			var bob := 0.0
			if not _text_catalog.reduced_motion:
				bob = sin(_motion_clock * 2.4 + float(index) * 1.7) * 3.0
			_draw_asset(asset_id, center + Vector2(0.0, bob), Vector2(72.0, 72.0))


func _map_visible(point: Vector2, margin: float) -> bool:
	return Rect2(MAP_RECT.position - Vector2.ONE * margin, MAP_RECT.size + Vector2.ONE * margin * 2.0).has_point(point)


func _draw_asset(asset_id: String, bottom_center: Vector2, draw_size: Vector2, opacity: float = 1.0) -> void:
	var texture: Texture2D = _textures.get(asset_id)
	if texture == null:
		draw_rect(Rect2(bottom_center - draw_size * Vector2(0.5, 1.0), draw_size), CORAL, false, 3.0)
		return
	var rect := Rect2(bottom_center - Vector2(draw_size.x * 0.5, draw_size.y), draw_size)
	draw_texture_rect(texture, rect, false, Color(1.0, 1.0, 1.0, opacity))


func _draw_header() -> void:
	draw_rect(Rect2(0.0, 0.0, 720.0, 112.0), PAPER)
	draw_rect(Rect2(0.0, 104.0, 720.0, 8.0), PAPER_DARK)
	_label(Vector2(24.0, 35.0), _t("town_name"), 28, INK, 245.0)
	_draw_resource_chip(Rect2(270.0, 18.0, 112.0, 66.0), GOLD, str(_model.coins), "coin")
	_draw_resource_chip(Rect2(392.0, 18.0, 112.0, 66.0), TEAL, str(_model.renown), "star")
	_draw_storage_chip(Rect2(514.0, 15.0, 122.0, 72.0))
	draw_circle(SETTINGS_RECT.get_center(), 25.0, TEAL_DARK)
	_draw_gear(SETTINGS_RECT.get_center(), 13.0)


func _draw_resource_chip(rect: Rect2, fill: Color, value: String, icon_kind: String) -> void:
	draw_rect(rect, WHITE)
	draw_rect(rect, fill, false, 3.0)
	var center := Vector2(rect.position.x + 25.0, rect.get_center().y)
	if icon_kind == "coin":
		draw_circle(center, 14.0, GOLD)
		draw_circle(center, 14.0, INK, false, 2.0)
	else:
		_draw_star(center, 15.0, fill)
	_label(Vector2(rect.position.x + 48.0, rect.position.y + 42.0), value, 22, INK, rect.size.x - 52.0)


func _draw_storage_chip(rect: Rect2) -> void:
	draw_rect(rect, WHITE)
	draw_rect(rect, TEAL_DARK, false, 3.0)
	var granary_used: int = _model.storage_used("granary")
	var granary_capacity: int = _model.storage_capacity("granary")
	var store_used: int = _model.storage_used("storehouse")
	var store_capacity: int = _model.storage_capacity("storehouse")
	_draw_storage_bar(Rect2(rect.position + Vector2(10.0, 12.0), Vector2(102.0, 18.0)), granary_used, granary_capacity, GOLD)
	_draw_storage_bar(Rect2(rect.position + Vector2(10.0, 42.0), Vector2(102.0, 18.0)), store_used, store_capacity, TEAL)


func _draw_storage_bar(rect: Rect2, used: int, capacity: int, fill: Color) -> void:
	draw_rect(rect, PAPER_DARK)
	var ratio: float = clampf(float(used) / maxf(float(capacity), 1.0), 0.0, 1.0)
	draw_rect(Rect2(rect.position, Vector2(rect.size.x * ratio, rect.size.y)), fill)
	draw_rect(rect, INK, false, 2.0)
	_label(rect.position + Vector2(2.0, 15.0), "%d/%d" % [used, capacity], 13, INK, rect.size.x - 4.0)


func _draw_footer() -> void:
	draw_rect(Rect2(0.0, 1136.0, 720.0, 144.0), PAPER)
	draw_rect(Rect2(0.0, 1136.0, 720.0, 8.0), PAPER_DARK)
	var labels := ["nav_town", "nav_requests", "nav_build", "nav_market", "nav_settings"]
	for index in range(NAV_RECTS.size()):
		var rect: Rect2 = NAV_RECTS[index]
		var active := (
			(index == 1 and _panel == "requests")
			or (index == 3 and _panel == "market")
			or (index == 4 and _panel == "settings")
			or (index == 0 and _panel.is_empty())
		)
		var icon_center := rect.get_center() + Vector2(0.0, -18.0)
		_draw_nav_icon(index, icon_center, TEAL if active else LOCKED)
		_label(Vector2(rect.position.x + 8.0, rect.position.y + 108.0), _t(labels[index]), 17, INK, rect.size.x - 16.0)
		if active:
			draw_rect(Rect2(rect.position.x + 30.0, 1268.0, rect.size.x - 60.0, 6.0), TEAL)


func _draw_nav_icon(index: int, center: Vector2, color: Color) -> void:
	match index:
		0:
			draw_colored_polygon(PackedVector2Array([center + Vector2(-24.0, -2.0), center + Vector2(0.0, -25.0), center + Vector2(24.0, -2.0)]), color)
			draw_rect(Rect2(center + Vector2(-18.0, -2.0), Vector2(36.0, 30.0)), color)
		1:
			draw_rect(Rect2(center + Vector2(-22.0, -27.0), Vector2(44.0, 54.0)), PAPER)
			draw_rect(Rect2(center + Vector2(-22.0, -27.0), Vector2(44.0, 54.0)), color, false, 4.0)
			for line_index in range(3):
				draw_line(center + Vector2(-13.0, -15.0 + float(line_index) * 16.0), center + Vector2(13.0, -15.0 + float(line_index) * 16.0), color, 3.0)
		2:
			draw_rect(Rect2(center + Vector2(-25.0, 2.0), Vector2(50.0, 24.0)), color)
			draw_line(center + Vector2(-20.0, 0.0), center + Vector2(0.0, -22.0), color, 8.0)
			draw_line(center + Vector2(0.0, -22.0), center + Vector2(20.0, 0.0), color, 8.0)
		3:
			draw_rect(Rect2(center + Vector2(-27.0, -18.0), Vector2(54.0, 36.0)), color)
			draw_circle(center + Vector2(-17.0, 23.0), 7.0, INK)
			draw_circle(center + Vector2(17.0, 23.0), 7.0, INK)
		4:
			_draw_gear(center, 24.0, color)


func _draw_map_hint() -> void:
	if _camera_offset.length() < 20.0:
		return
	var hint_rect := Rect2(18.0, 124.0, 92.0, 40.0)
	draw_rect(hint_rect, Color(1.0, 1.0, 1.0, 0.8))
	draw_rect(hint_rect, TEAL_DARK, false, 2.0)
	draw_line(Vector2(34.0, 144.0), Vector2(88.0, 144.0), TEAL_DARK, 4.0)
	draw_colored_polygon(PackedVector2Array([Vector2(30.0, 144.0), Vector2(42.0, 136.0), Vector2(42.0, 152.0)]), TEAL_DARK)
	draw_colored_polygon(PackedVector2Array([Vector2(92.0, 144.0), Vector2(80.0, 136.0), Vector2(80.0, 152.0)]), TEAL_DARK)


func _draw_panel() -> void:
	draw_rect(MAP_RECT, SCRIM)
	draw_rect(PANEL_RECT, PAPER)
	draw_rect(PANEL_RECT, INK, false, 4.0)
	draw_circle(PANEL_CLOSE_RECT.get_center(), 20.0, CORAL)
	_label(PANEL_CLOSE_RECT.position + Vector2(1.0, 29.0), "×", 26, WHITE, PANEL_CLOSE_RECT.size.x - 2.0)
	match _panel:
		"crops":
			_draw_crop_panel()
		"recipes":
			_draw_recipe_panel()
		"requests":
			_draw_request_panel()
		"market":
			_draw_market_panel()
		"settings":
			_draw_settings_panel()
		_:
			_draw_info_panel()


func _draw_panel_title(title_key: String) -> void:
	_label(Vector2(PANEL_RECT.position.x + 28.0, PANEL_RECT.position.y + 60.0), _t(title_key), 28, INK, 520.0)


func _draw_crop_panel() -> void:
	_draw_panel_title("panel_choose_crop")
	var crops: Array[Dictionary] = _config.rows("crops")
	for index in range(crops.size()):
		var crop: Dictionary = crops[index]
		var rect := Rect2(62.0 + float(index) * 204.0, 752.0, 188.0, 238.0)
		var crop_id: String = _config.text(crop, "id")
		_draw_choice_card(rect, "panel:crop:%s" % crop_id, _config.text(crop, "asset_id"))
		_label(Vector2(rect.position.x + 12.0, rect.position.y + 154.0), _t("item_%s" % crop_id), 18, INK, rect.size.x - 24.0)
		_label(Vector2(rect.position.x + 12.0, rect.position.y + 187.0), "%ds  •  %d→%d" % [
			_config.number(crop, "grow_seconds"),
			_config.number(crop, "plant_cost"),
			_config.number(crop, "harvest_yield"),
		], 16, TEAL_DARK, rect.size.x - 24.0)
		_draw_inventory_amount(Vector2(rect.get_center().x, rect.position.y + 220.0), crop_id)


func _draw_recipe_panel() -> void:
	_draw_panel_title("panel_choose_recipe")
	var recipes: Array[Dictionary] = []
	for recipe in _config.rows("recipes"):
		if _config.text(recipe, "machine_id") == _panel_subject:
			recipes.append(recipe)
	if recipes.is_empty():
		_draw_info_panel()
		return
	for index in range(recipes.size()):
		var recipe: Dictionary = recipes[index]
		var rect := Rect2(74.0 + float(index) * 288.0, 760.0, 270.0, 226.0)
		var recipe_id: String = _config.text(recipe, "id")
		var output_id: String = _config.text(recipe, "output_item_id")
		_draw_choice_card(rect, "panel:recipe:%s" % recipe_id, "")
		_draw_item_symbol(output_id, Vector2(rect.get_center().x, rect.position.y + 68.0), 30.0)
		_label(Vector2(rect.position.x + 14.0, rect.position.y + 134.0), _t("item_%s" % output_id), 20, INK, rect.size.x - 28.0)
		_label(Vector2(rect.position.x + 14.0, rect.position.y + 168.0), _format_pairs(_config.text(recipe, "input_items")), 15, TEAL_DARK, rect.size.x - 28.0)
		_label(Vector2(rect.position.x + 14.0, rect.position.y + 204.0), "%ds" % _config.number(recipe, "duration_seconds"), 17, INK, rect.size.x - 28.0)


func _draw_request_panel() -> void:
	_draw_panel_title("panel_requests")
	var requests: Array[Dictionary] = _config.rows("requests")
	for index in range(requests.size()):
		var request: Dictionary = requests[index]
		var request_id: String = _config.text(request, "id")
		var rect := Rect2(58.0, 744.0 + float(index) * 104.0, 604.0, 88.0)
		var request_state: Dictionary = _model.requests.get(request_id, {})
		var active := bool(request_state.get("active", true))
		draw_rect(rect, WHITE if active else PAPER_DARK)
		draw_rect(rect, TEAL_DARK, false, 3.0)
		_label(rect.position + Vector2(14.0, 31.0), _t("request_%s" % request_id), 18, INK, 210.0)
		_label(rect.position + Vector2(218.0, 31.0), _format_pairs(_config.text(request, "requirements")), 15, INK, 214.0)
		if active:
			_draw_small_action(Rect2(rect.position + Vector2(446.0, 14.0), Vector2(142.0, 60.0)), "panel:request:%s" % request_id, "%d + %d★" % [
				_config.number(request, "reward_coins"),
				_config.number(request, "reward_renown"),
			])
		else:
			_draw_timer_badge(rect.position + Vector2(520.0, 44.0), int(ceil(float(request_state.get("refresh_remaining", 0.0)))))


func _draw_market_panel() -> void:
	_draw_panel_title("panel_market")
	var sellable: Array[Dictionary] = []
	for item in _config.rows("items"):
		if _model.amount_of(_config.text(item, "id")) > _config.number(item, "seed_reserve"):
			sellable.append(item)
	for index in range(mini(sellable.size(), 6)):
		var item: Dictionary = sellable[index]
		var column := index % 3
		var row := index / 3
		var rect := Rect2(62.0 + float(column) * 204.0, 744.0 + float(row) * 142.0, 188.0, 122.0)
		var item_id: String = _config.text(item, "id")
		draw_rect(rect, WHITE)
		draw_rect(rect, GOLD, false, 3.0)
		_draw_item_symbol(item_id, rect.position + Vector2(38.0, 42.0), 22.0)
		_label(rect.position + Vector2(67.0, 37.0), _t("item_%s" % item_id), 15, INK, 108.0)
		_label(rect.position + Vector2(67.0, 66.0), "%d × %d" % [_model.amount_of(item_id), _config.number(item, "market_coin_value")], 15, TEAL_DARK, 108.0)
		_draw_small_action(Rect2(rect.position + Vector2(14.0, 82.0), Vector2(160.0, 30.0)), "panel:sell:%s" % item_id, _t("action_sell"))


func _draw_settings_panel() -> void:
	_draw_panel_title("panel_settings")
	_label(Vector2(70.0, 772.0), _t("action_language"), 20, INK, 200.0)
	_draw_small_action(Rect2(272.0, 732.0, 164.0, 70.0), "panel:locale:zh-CN", _t("settings_chinese"), _text_catalog.locale == "zh-CN")
	_draw_small_action(Rect2(454.0, 732.0, 164.0, 70.0), "panel:locale:en", _t("settings_english"), _text_catalog.locale == "en")
	_label(Vector2(70.0, 880.0), _t("action_reduced_motion"), 20, INK, 300.0)
	_draw_small_action(
		Rect2(398.0, 832.0, 220.0, 70.0),
		"panel:motion",
		_t("settings_motion_on") if _text_catalog.reduced_motion else _t("settings_motion_off"),
		_text_catalog.reduced_motion
	)


func _draw_info_panel() -> void:
	var title := _t("nav_build")
	var body := _t("feedback_locked", [2])
	if _panel_subject.begins_with("plot:"):
		title = _t("item_%s" % str(_model.plots[_selected_plot].get("crop_id", "golden_sprig")))
		body = _t("state_growing")
	elif not _panel_subject.is_empty() and not _config.record("buildings", _panel_subject).is_empty():
		var building: Dictionary = _config.record("buildings", _panel_subject)
		title = _t("building_%s" % _panel_subject)
		var kind: String = _config.text(building, "kind")
		if kind == "storage":
			var storage_id := "granary" if _panel_subject == "granary" else "storehouse"
			body = "%d / %d" % [_model.storage_used(storage_id), _model.storage_capacity(storage_id)]
		elif kind == "animal_pen":
			var animal_id := _animal_for_pen(_panel_subject)
			body = _t("state_%s" % _model.animal_state(animal_id))
		else:
			body = _t("state_%s" % _model.machine_state(_panel_subject))
	_label(Vector2(76.0, 742.0), title, 31, INK, 520.0)
	_label(Vector2(76.0, 818.0), body, 22, TEAL_DARK, 520.0)
	_label(Vector2(76.0, 922.0), _t(_model.feedback_key, _translated_feedback_args()), 18, INK, 560.0)


func _translated_feedback_args() -> Array:
	var translated: Array = []
	for value in _model.feedback_args:
		var identifier := str(value)
		if not _config.record("items", identifier).is_empty():
			translated.append(_t("item_%s" % identifier))
		elif not _config.record("crops", identifier).is_empty():
			translated.append(_t("item_%s" % identifier))
		else:
			translated.append(value)
	return translated


func _draw_choice_card(rect: Rect2, target: String, asset_id: String) -> void:
	draw_rect(rect, WHITE)
	draw_rect(rect, TEAL_DARK, false, 3.0)
	if not asset_id.is_empty():
		_draw_asset(asset_id, Vector2(rect.get_center().x, rect.position.y + 128.0), Vector2(116.0, 116.0))
	_hit_regions[target] = rect


func _draw_small_action(rect: Rect2, target: String, label_text: String, active: bool = false) -> void:
	draw_rect(rect, TEAL_DARK if active else TEAL)
	draw_rect(rect, INK, false, 2.0)
	_label(Vector2(rect.position.x + 8.0, rect.get_center().y + 7.0), label_text, 15, WHITE, rect.size.x - 16.0)
	_hit_regions[target] = rect


func _draw_inventory_amount(center: Vector2, item_id: String) -> void:
	draw_circle(center, 20.0, GOLD)
	_label(center + Vector2(-18.0, 6.0), str(_model.amount_of(item_id)), 15, INK, 36.0)


func _format_pairs(value: String) -> String:
	var parts: Array[String] = []
	var pairs: Dictionary = _config.parse_pairs(value)
	for item_id_variant in pairs.keys():
		var item_id := str(item_id_variant)
		parts.append("%s×%d" % [_t("item_%s" % item_id), int(pairs[item_id])])
	return "  ".join(parts)


func _draw_ready_badge(center: Vector2) -> void:
	var pulse := 0.0 if _text_catalog.reduced_motion else (sin(_motion_clock * 4.0) + 1.0) * 1.5
	draw_circle(center, 23.0 + pulse, WHITE)
	draw_circle(center, 20.0 + pulse, TEAL)
	draw_line(center + Vector2(-8.0, 0.0), center + Vector2(-2.0, 7.0), WHITE, 4.0)
	draw_line(center + Vector2(-2.0, 7.0), center + Vector2(10.0, -8.0), WHITE, 4.0)


func _draw_timer_badge(center: Vector2, seconds_left: int) -> void:
	draw_circle(center, 24.0, WHITE)
	draw_circle(center, 20.0, GOLD)
	_label(center + Vector2(-20.0, 6.0), str(maxi(seconds_left, 0)), 13, INK, 40.0)


func _draw_plus_badge(center: Vector2) -> void:
	draw_circle(center, 22.0, WHITE)
	draw_circle(center, 18.0, TEAL)
	draw_line(center + Vector2(-8.0, 0.0), center + Vector2(8.0, 0.0), WHITE, 4.0)
	draw_line(center + Vector2(0.0, -8.0), center + Vector2(0.0, 8.0), WHITE, 4.0)


func _draw_feed_badge(center: Vector2) -> void:
	draw_circle(center, 22.0, WHITE)
	draw_circle(center, 18.0, GOLD)
	draw_colored_polygon(PackedVector2Array([
		center + Vector2(-8.0, 6.0),
		center + Vector2(0.0, -10.0),
		center + Vector2(8.0, 6.0),
	]), GRASS_DARK)


func _draw_request_badge(center: Vector2) -> void:
	draw_circle(center, 22.0, WHITE)
	draw_rect(Rect2(center + Vector2(-11.0, -13.0), Vector2(22.0, 27.0)), CORAL)
	for line_index in range(3):
		draw_line(center + Vector2(-6.0, -7.0 + float(line_index) * 7.0), center + Vector2(6.0, -7.0 + float(line_index) * 7.0), WHITE, 2.0)


func _draw_coin_badge(center: Vector2) -> void:
	draw_circle(center, 22.0, WHITE)
	draw_circle(center, 17.0, GOLD)
	draw_circle(center, 17.0, INK, false, 2.0)


func _draw_lock_badge(center: Vector2, level: int) -> void:
	draw_circle(center, 23.0, WHITE)
	draw_rect(Rect2(center + Vector2(-10.0, -2.0), Vector2(20.0, 18.0)), LOCKED)
	draw_arc(center + Vector2(0.0, -2.0), 9.0, PI, TAU, 16, LOCKED, 4.0)
	_label(center + Vector2(-18.0, 35.0), str(level), 13, INK, 36.0)


func _draw_name_tag(position: Vector2, value: String) -> void:
	var rect := Rect2(position, Vector2(180.0, 38.0))
	draw_rect(rect, Color(1.0, 1.0, 1.0, 0.92))
	draw_rect(rect, INK, false, 2.0)
	_label(rect.position + Vector2(6.0, 26.0), value, 15, INK, rect.size.x - 12.0)


func _draw_item_symbol(item_id: String, center: Vector2, radius: float) -> void:
	var item: Dictionary = _config.record("items", item_id)
	var icon_key: String = _config.text(item, "icon_key")
	match icon_key:
		"grain":
			draw_line(center + Vector2(-8.0, 18.0), center + Vector2(8.0, -18.0), GRASS_DARK, 5.0)
			for index in range(4):
				draw_circle(center + Vector2(-5.0 + float(index) * 4.0, 8.0 - float(index) * 8.0), radius * 0.24, GOLD)
		"carrot":
			draw_colored_polygon(PackedVector2Array([center + Vector2(-12.0, -8.0), center + Vector2(12.0, -8.0), center + Vector2(0.0, 22.0)]), CORAL)
			draw_line(center + Vector2(0.0, -8.0), center + Vector2(-8.0, -22.0), GRASS_DARK, 5.0)
			draw_line(center + Vector2(0.0, -8.0), center + Vector2(8.0, -22.0), GRASS_DARK, 5.0)
		"bean":
			draw_circle(center, radius * 0.65, GRASS_DARK)
			draw_circle(center + Vector2(radius * 0.18, -radius * 0.15), radius * 0.42, PAPER)
		"egg":
			_draw_custom_ellipse(center, Vector2(radius * 0.65, radius * 0.9), WHITE)
			draw_circle(center + Vector2(4.0, 5.0), radius * 0.2, CORAL)
		"milk", "cream":
			draw_rect(Rect2(center - Vector2(radius * 0.55, radius * 0.75), Vector2(radius * 1.1, radius * 1.5)), WHITE)
			draw_rect(Rect2(center - Vector2(radius * 0.55, radius * 0.75), Vector2(radius * 1.1, radius * 1.5)), TEAL_DARK, false, 3.0)
		"bread":
			_draw_custom_ellipse(center, Vector2(radius * 0.9, radius * 0.58), GOLD)
		_:
			draw_circle(center, radius * 0.75, TEAL)


func _draw_star(center: Vector2, radius: float, color: Color) -> void:
	var points := PackedVector2Array()
	for index in range(10):
		var point_radius := radius if index % 2 == 0 else radius * 0.46
		var angle := -PI * 0.5 + float(index) * PI / 5.0
		points.append(center + Vector2(cos(angle), sin(angle)) * point_radius)
	draw_colored_polygon(points, color)


func _draw_gear(center: Vector2, radius: float, color: Color = WHITE) -> void:
	draw_circle(center, radius, color)
	for index in range(8):
		var angle := TAU * float(index) / 8.0
		var direction := Vector2(cos(angle), sin(angle))
		draw_line(center + direction * radius, center + direction * (radius + 7.0), color, 5.0)
	draw_circle(center, radius * 0.36, TEAL_DARK)


func _t(key: String, args: Array = []) -> String:
	return _text_catalog.text(key, args)


func _label(position: Vector2, value: String, font_size: int, color: Color, width: float = -1.0) -> void:
	draw_string(ThemeDB.fallback_font, position, value, HORIZONTAL_ALIGNMENT_CENTER if width > 0.0 else HORIZONTAL_ALIGNMENT_LEFT, width, font_size, color)


func debug_snapshot() -> Dictionary:
	var metrics := _metrics()
	return {
		"runtime_ready": _runtime_ready,
		"control_size": size,
		"design_scale": metrics.scale,
		"design_offset": metrics.offset,
		"world_width": _config.world_int("world_width") if _config != null else 0,
		"world_height": _config.world_int("world_height") if _config != null else 0,
		"camera_offset": _camera_offset,
		"plot_count": _model.plots.size() if _model != null else 0,
		"building_count": _config.rows("buildings").size() if _config != null else 0,
		"object_count": (_model.plots.size() + _config.rows("buildings").size()) if _model != null and _config != null else 0,
		"runtime_texture_count": _textures.size(),
		"locale": _text_catalog.locale if _text_catalog != null else "",
		"reduced_motion": _text_catalog.reduced_motion if _text_catalog != null else false,
		"panel": _panel,
		"feedback": _feedback_layer.debug_snapshot() if _feedback_layer != null else {},
		"active_modules": ["farm2_config", "farm2_model", "farm2_text", "farm2_save", "farm2_view"],
	}


func debug_pan_to(next_offset: Vector2) -> Vector2:
	_camera_offset = next_offset
	_clamp_camera()
	queue_redraw()
	return _camera_offset


func debug_target_at_design(point: Vector2) -> String:
	return _target_at_design(point)


func debug_activate_target(target: String) -> void:
	_activate_target(target)


func debug_feedback_snapshot() -> Dictionary:
	return _feedback_layer.debug_snapshot() if _feedback_layer != null else {}


func debug_model():
	return _model
