extends Control

const TownConfig = preload("res://scripts/town/town_config.gd")
const TownModel = preload("res://scripts/town/town_model.gd")
const TownText = preload("res://scripts/town/town_text.gd")

const DESIGN_SIZE := Vector2(720.0, 1280.0)
const FARM_RECT := Rect2(18, 120, 684, 884)
const PLOT_RECTS := [
	Rect2(50, 208, 150, 126),
	Rect2(286, 188, 150, 126),
	Rect2(520, 210, 150, 126),
	Rect2(286, 372, 150, 126)
]
const BAKERY_RECT := Rect2(42, 590, 200, 180)
const WILLOW_PEN_RECT := Rect2(260, 590, 200, 180)
const THREADMILL_RECT := Rect2(478, 590, 200, 180)
const ORDER_BOARD_RECT := Rect2(42, 798, 636, 170)
const ORDER_RECTS := {
	"market_cart": Rect2(60, 844, 184, 102),
	"fleece_bundle": Rect2(268, 844, 184, 102),
	"yarn_crate": Rect2(476, 844, 184, 102)
}
const SETTINGS_RECT := Rect2(644, 32, 42, 42)
const SETTINGS_PANEL := Rect2(164, 342, 392, 284)
const LOCALE_ZH_RECT := Rect2(194, 468, 158, 88)
const LOCALE_EN_RECT := Rect2(368, 468, 158, 88)

const INK := Color("234551")
const CREAM := Color("FFF8E8")
const SKY := Color("DFF3F2")
const GRASS := Color("A8D987")
const GRASS_DARK := Color("70AF6E")
const SOIL := Color("C98654")
const SOIL_DARK := Color("9D633F")
const TEAL := Color("0C9B91")
const GOLD := Color("F6C75C")
const CORAL := Color("E87359")
const ROOF := Color("D95D4D")
const WHITE := Color("FFFFFF")
const LOCKED := Color("AEB9AF")
const SHADOW := Color("244B50", 0.16)

var _config
var _model
var _text_catalog
var _hovered_target := ""
var _settings_open := false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_config = TownConfig.load_default()
	_text_catalog = TownText.new()
	if not _config.is_valid() or not _text_catalog.is_valid():
		push_error("Town runtime configuration error.")
		return
	_model = TownModel.new(_config)
	_model.changed.connect(queue_redraw)
	var window := get_window()
	if window != null:
		window.size = Vector2i(int(DESIGN_SIZE.x), int(DESIGN_SIZE.y))
		window.min_size = Vector2i(360, 640)
	queue_redraw()


func _process(delta: float) -> void:
	if _model != null:
		_model.tick(delta)


func _gui_input(event: InputEvent) -> void:
	if _model == null:
		return
	if event is InputEventMouseMotion:
		var next_target := _target_at_design(_to_design(event.position))
		if next_target != _hovered_target:
			_hovered_target = next_target
			queue_redraw()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_activate_target(_target_at_design(_to_design(event.position)))
		accept_event()
	elif event is InputEventScreenTouch and event.pressed:
		_activate_target(_target_at_design(_to_design(event.position)))
		accept_event()


static func target_at_design(point: Vector2) -> String:
	if SETTINGS_RECT.has_point(point):
		return "settings"
	for index in range(PLOT_RECTS.size()):
		if PLOT_RECTS[index].has_point(point):
			return "plot:%d" % index
	if BAKERY_RECT.has_point(point):
		return "building:crumbworks"
	if WILLOW_PEN_RECT.has_point(point):
		return "building:willow_pen"
	if THREADMILL_RECT.has_point(point):
		return "building:threadmill"
	for order_id_variant in ORDER_RECTS.keys():
		var order_id := str(order_id_variant)
		if ORDER_RECTS[order_id].has_point(point):
			return "order:%s" % order_id
	return ""


func _target_at_design(point: Vector2) -> String:
	if not _settings_open:
		return target_at_design(point)
	if LOCALE_ZH_RECT.has_point(point):
		return "locale_zh"
	if LOCALE_EN_RECT.has_point(point):
		return "locale_en"
	if SETTINGS_PANEL.has_point(point):
		return "settings_panel"
	return "close_settings"


func _activate_target(target: String) -> void:
	if target == "settings":
		_settings_open = not _settings_open
	elif target == "close_settings":
		_settings_open = false
	elif target == "locale_zh":
		_set_locale("zh-CN")
	elif target == "locale_en":
		_set_locale("en")
	elif _settings_open:
		pass
	elif target.begins_with("plot:"):
		_model.interact_plot(target.trim_prefix("plot:").to_int())
	elif target.begins_with("building:"):
		_model.interact_building(target.trim_prefix("building:"))
	elif target.begins_with("order:"):
		_model.fulfill_order(target.trim_prefix("order:"))
	else:
		_model.set_feedback("feedback_choose_target")
		_model.emit_signal("changed")
	queue_redraw()


func _set_locale(next_locale: String) -> void:
	_text_catalog.set_locale(next_locale)
	TownText.persist_locale(next_locale)
	_settings_open = false
	queue_redraw()


func _draw() -> void:
	if _model == null:
		return
	var metrics := _metrics()
	draw_set_transform(metrics.offset, 0.0, Vector2(metrics.scale, metrics.scale))
	_draw_design()
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


func _draw_design() -> void:
	draw_rect(Rect2(Vector2.ZERO, DESIGN_SIZE), SKY)
	_draw_header()
	_draw_farmboard()
	_draw_footer()
	if _settings_open:
		_draw_settings_tray()


func _draw_header() -> void:
	draw_rect(Rect2(18, 18, 684, 86), CREAM)
	draw_rect(Rect2(18, 18, 684, 86), INK, false, 3.0)
	_label(Vector2(42, 52), _t("app_city"), 18, TEAL)
	_label(Vector2(42, 84), _t("farm_name"), 28, INK)
	_draw_resource_chip(Rect2(436, 34, 90, 54), "coin", _model.coins, GOLD)
	_draw_resource_chip(Rect2(536, 34, 90, 54), "renown", _model.renown, Color("BCE4C6"))
	_draw_gear(SETTINGS_RECT.get_center(), 13, TEAL if _hovered_target == "settings" else INK)


func _draw_resource_chip(rect: Rect2, icon: String, value: int, fill: Color) -> void:
	draw_rect(rect, fill)
	draw_rect(rect, INK, false, 2.0)
	if icon == "coin":
		_draw_coin(rect.position + Vector2(23, 27), 13)
	else:
		_draw_renown(rect.position + Vector2(23, 27), 10)
	_label(rect.position + Vector2(45, 35), str(value), 21, INK)


func _draw_farmboard() -> void:
	draw_rect(FARM_RECT, GRASS)
	draw_rect(FARM_RECT, INK, false, 3.0)
	_draw_cloud(Vector2(90, 152), 0.8)
	_draw_cloud(Vector2(603, 160), 0.62)
	_draw_path()
	_draw_fence(Rect2(44, 542, 632, 22))
	for index in range(min(_model.plots.size(), PLOT_RECTS.size())):
		_draw_plot(index, PLOT_RECTS[index])
	_draw_bakery()
	_draw_willow_pen()
	_draw_threadmill()
	_draw_order_board()
	_draw_flower(Vector2(88, 530), 0.85)
	_draw_flower(Vector2(635, 522), 0.72)
	_draw_flower(Vector2(630, 782), 0.86)
	_draw_tree(Vector2(666, 536), 0.9)


func _draw_path() -> void:
	draw_line(Vector2(132, 548), Vector2(575, 548), Color("E9CB96"), 28.0, true)
	draw_line(Vector2(360, 340), Vector2(360, 586), Color("E9CB96"), 24.0, true)
	draw_line(Vector2(510, 360), Vector2(510, 586), Color("E9CB96"), 24.0, true)
	draw_line(Vector2(360, 770), Vector2(360, 802), Color("E9CB96"), 22.0, true)


func _draw_plot(index: int, rect: Rect2) -> void:
	var plot: Dictionary = _model.plots[index]
	var state_name := str(plot.get("state", ""))
	var hovered := _hovered_target == "plot:%d" % index
	draw_rect(rect.grow(8), SHADOW)
	draw_rect(rect.grow(5), GRASS_DARK if not hovered else TEAL)
	draw_rect(rect, GRASS)
	var soil_rect := rect.grow(-12)
	draw_rect(soil_rect, SOIL if state_name != "locked" else LOCKED)
	draw_rect(soil_rect, INK, false, 2.0)
	for row in range(3):
		draw_line(soil_rect.position + Vector2(13, 27 + row * 26), soil_rect.position + Vector2(soil_rect.size.x - 13, 27 + row * 26), SOIL_DARK if state_name != "locked" else INK.lightened(0.3), 2.0)
	match state_name:
		"empty":
			for seed_index in range(3):
				_draw_seed(soil_rect.position + Vector2(43 + seed_index * 34, 62 + (seed_index % 2) * 20))
			_draw_action_pill(Rect2(rect.position.x + 30, rect.end.y - 29, 106, 31), _t("action_plant"), TEAL)
		"growing":
			_draw_sprout(soil_rect.position + Vector2(45, 79), 1.0)
			_draw_sprout(soil_rect.position + Vector2(85, 64), 1.18)
			_draw_sprout(soil_rect.position + Vector2(122, 83), 0.88)
			_draw_timer_badge(rect.position + Vector2(132, 16), 20, int(ceil(float(plot.get("remaining", 0.0)))), 6.0, CORAL)
		"ripe":
			_draw_grain(soil_rect.position + Vector2(36, 84), 1.08)
			_draw_grain(soil_rect.position + Vector2(78, 67), 1.22)
			_draw_grain(soil_rect.position + Vector2(118, 86), 1.0)
			_draw_action_pill(Rect2(rect.position.x + 30, rect.end.y - 29, 106, 31), _t("action_harvest"), GOLD)
		"locked":
			_draw_padlock(rect.get_center() + Vector2(0, -8), 19)
			_draw_coin(rect.get_center() + Vector2(-18, 38), 10)
			_label(rect.get_center() + Vector2(-3, 44), str(_config.number(_config.first_of_kind("unlock"), "unlock_cost")), 17, INK)


func _draw_bakery() -> void:
	_draw_compact_bakery()
	return
	var rect := BAKERY_RECT
	var hovered := _hovered_target == "building:crumbworks"
	draw_rect(rect.grow(6), SHADOW)
	draw_rect(rect, CREAM if not hovered else Color("FFF0BB"))
	draw_rect(rect, INK, false, 3.0)
	var house := Rect2(rect.position + Vector2(34, 65), Vector2(164, 112))
	draw_rect(house, Color("FFE6B4"))
	draw_rect(house, INK, false, 2.0)
	draw_colored_polygon(PackedVector2Array([house.position + Vector2(-12, 2), house.position + Vector2(82, -56), house.position + Vector2(176, 2)]), ROOF)
	draw_polyline(PackedVector2Array([house.position + Vector2(-12, 2), house.position + Vector2(82, -56), house.position + Vector2(176, 2)]), INK, 3.0, true)
	draw_rect(Rect2(house.position + Vector2(118, -34), Vector2(24, 46)), CORAL)
	draw_rect(Rect2(house.position + Vector2(118, -34), Vector2(24, 46)), INK, false, 2.0)
	draw_rect(Rect2(house.position + Vector2(67, 62), Vector2(34, 50)), Color("9B664A"))
	draw_rect(Rect2(house.position + Vector2(67, 62), Vector2(34, 50)), INK, false, 2.0)
	draw_rect(Rect2(house.position + Vector2(23, 45), Vector2(28, 28)), WHITE)
	draw_rect(Rect2(house.position + Vector2(23, 45), Vector2(28, 28)), INK, false, 2.0)
	_draw_loaf(house.position + Vector2(132, 80), 0.78)
	_label(rect.position + Vector2(26, 37), _t("label_bakery"), 23, INK)
	_draw_grain(rect.position + Vector2(222, 72), 0.55)
	_label(rect.position + Vector2(238, 76), "×2", 15, INK)
	match _model.bakery_state:
		"idle":
			_draw_action_pill(Rect2(rect.position.x + 28, rect.end.y - 45, 130, 34), _t("action_bake"), TEAL)
		"busy":
			_draw_timer_badge(rect.position + Vector2(238, 57), 26, int(ceil(_model.bakery_remaining)), 5.0, CORAL)
		"ready":
			_draw_loaf(rect.position + Vector2(240, 91), 1.1)
			_draw_action_pill(Rect2(rect.position.x + 28, rect.end.y - 45, 130, 34), _t("action_collect"), GOLD)


func _draw_delivery_van() -> void:
	var rect := ORDER_BOARD_RECT
	var hovered := _hovered_target == "order:market_cart"
	draw_rect(rect.grow(6), SHADOW)
	draw_rect(rect, CREAM if not hovered else Color("DFF2DE"))
	draw_rect(rect, INK, false, 3.0)
	_label(rect.position + Vector2(26, 37), _t("label_delivery"), 23, INK)
	var van_origin := rect.position + Vector2(46, 103)
	draw_rect(Rect2(van_origin, Vector2(142, 58)), CORAL)
	draw_rect(Rect2(van_origin, Vector2(142, 58)), INK, false, 2.0)
	draw_colored_polygon(PackedVector2Array([van_origin + Vector2(91, 0), van_origin + Vector2(126, 0), van_origin + Vector2(154, 26), van_origin + Vector2(154, 58), van_origin + Vector2(91, 58)]), Color("F3A35E"))
	draw_polyline(PackedVector2Array([van_origin + Vector2(91, 0), van_origin + Vector2(126, 0), van_origin + Vector2(154, 26), van_origin + Vector2(154, 58)]), INK, 2.0, true)
	draw_rect(Rect2(van_origin + Vector2(112, 10), Vector2(26, 19)), SKY)
	draw_rect(Rect2(van_origin + Vector2(112, 10), Vector2(26, 19)), INK, false, 1.5)
	draw_circle(van_origin + Vector2(35, 63), 15, INK)
	draw_circle(van_origin + Vector2(35, 63), 7, CREAM)
	draw_circle(van_origin + Vector2(122, 63), 15, INK)
	draw_circle(van_origin + Vector2(122, 63), 7, CREAM)
	var has_loaf: bool = _model.amount_of("meadow_loaf") > 0
	var bubble_center := rect.position + Vector2(237, 97)
	draw_circle(bubble_center, 38, WHITE if has_loaf else Color("E7E6DF"))
	draw_circle(bubble_center, 38, INK, false, 2.0)
	_draw_loaf(bubble_center, 0.72 if has_loaf else 0.56)
	if has_loaf:
		_draw_action_pill(Rect2(rect.position.x + 28, rect.end.y - 45, 130, 34), _t("action_deliver"), TEAL)
	else:
		_draw_coin(rect.position + Vector2(224, 161), 10)
		_label(rect.position + Vector2(240, 166), "+%d" % _config.number(_config.first_of_kind("order"), "reward_coins"), 16, INK)
		_draw_renown(rect.position + Vector2(224, 190), 8)
		_label(rect.position + Vector2(240, 195), "+%d" % _config.number(_config.first_of_kind("order"), "reward_renown"), 16, INK)


func _draw_compact_bakery() -> void:
	var rect := BAKERY_RECT
	var hovered := _hovered_target == "building:crumbworks"
	draw_rect(rect.grow(6), SHADOW)
	draw_rect(rect, CREAM if not hovered else Color("FFF0BB"))
	draw_rect(rect, INK, false, 3.0)
	_label(rect.position + Vector2(16, 32), _t("label_bakery"), 17, INK)
	var house := Rect2(rect.position + Vector2(22, 59), Vector2(118, 86))
	draw_rect(house, Color("FFE6B4"))
	draw_rect(house, INK, false, 2.0)
	draw_colored_polygon(PackedVector2Array([house.position + Vector2(-8, 2), house.position + Vector2(59, -40), house.position + Vector2(126, 2)]), ROOF)
	draw_polyline(PackedVector2Array([house.position + Vector2(-8, 2), house.position + Vector2(59, -40), house.position + Vector2(126, 2)]), INK, 2.5, true)
	draw_rect(Rect2(house.position + Vector2(46, 46), Vector2(28, 40)), Color("9B664A"))
	draw_rect(Rect2(house.position + Vector2(46, 46), Vector2(28, 40)), INK, false, 1.5)
	_draw_loaf(house.position + Vector2(96, 59), 0.5)
	_draw_grain(rect.position + Vector2(162, 58), 0.38)
	_label(rect.position + Vector2(176, 62), "x2", 13, INK)
	match _model.building_state("crumbworks"):
		"idle":
			_draw_action_pill(Rect2(rect.position.x + 16, rect.end.y - 37, 112, 27), _t("action_bake"), TEAL)
		"busy":
			_draw_timer_badge(rect.position + Vector2(166, 106), 22, int(ceil(_model.building_remaining("crumbworks"))), 5.0, CORAL)
		"ready":
			_draw_loaf(rect.position + Vector2(166, 106), 0.78)
			_draw_action_pill(Rect2(rect.position.x + 16, rect.end.y - 37, 112, 27), _t("action_collect"), GOLD)


func _draw_willow_pen() -> void:
	var rect := WILLOW_PEN_RECT
	var hovered := _hovered_target == "building:willow_pen"
	draw_rect(rect.grow(6), SHADOW)
	draw_rect(rect, CREAM if not hovered else Color("E6F5DF"))
	draw_rect(rect, INK, false, 3.0)
	_label(rect.position + Vector2(16, 32), _t("label_willow_pen"), 17, INK)
	_draw_fence(Rect2(rect.position + Vector2(18, 82), Vector2(123, 22)))
	_draw_wool_sheep(rect.position + Vector2(67, 93), 0.78)
	_draw_wool_sheep(rect.position + Vector2(112, 111), 0.58)
	_draw_grain(rect.position + Vector2(164, 61), 0.38)
	_label(rect.position + Vector2(177, 65), "x1", 13, INK)
	match _model.building_state("willow_pen"):
		"idle":
			_draw_action_pill(Rect2(rect.position.x + 16, rect.end.y - 37, 112, 27), _t("action_feed"), TEAL)
		"busy":
			_draw_timer_badge(rect.position + Vector2(166, 106), 22, int(ceil(_model.building_remaining("willow_pen"))), 7.0, CORAL)
		"ready":
			_draw_fleece(rect.position + Vector2(166, 106), 0.8)
			_draw_action_pill(Rect2(rect.position.x + 16, rect.end.y - 37, 112, 27), _t("action_collect"), GOLD)


func _draw_threadmill() -> void:
	var rect := THREADMILL_RECT
	var hovered := _hovered_target == "building:threadmill"
	draw_rect(rect.grow(6), SHADOW)
	draw_rect(rect, CREAM if not hovered else Color("E5F3F5"))
	draw_rect(rect, INK, false, 3.0)
	_label(rect.position + Vector2(16, 32), _t("label_threadmill"), 17, INK)
	var house := Rect2(rect.position + Vector2(24, 67), Vector2(96, 76))
	draw_rect(house, Color("DCE8D1"))
	draw_rect(house, INK, false, 2.0)
	draw_colored_polygon(PackedVector2Array([house.position + Vector2(-9, 1), house.position + Vector2(48, -34), house.position + Vector2(105, 1)]), Color("6FA7A0"))
	draw_polyline(PackedVector2Array([house.position + Vector2(-9, 1), house.position + Vector2(48, -34), house.position + Vector2(105, 1)]), INK, 2.5, true)
	_draw_spool(house.position + Vector2(72, 49), 0.68)
	_draw_fleece(rect.position + Vector2(158, 58), 0.47)
	_label(rect.position + Vector2(176, 64), "x2", 13, INK)
	match _model.building_state("threadmill"):
		"idle":
			_draw_action_pill(Rect2(rect.position.x + 16, rect.end.y - 37, 112, 27), _t("action_spin"), TEAL)
		"busy":
			_draw_timer_badge(rect.position + Vector2(166, 106), 22, int(ceil(_model.building_remaining("threadmill"))), 7.0, CORAL)
		"ready":
			_draw_spool(rect.position + Vector2(166, 106), 0.88)
			_draw_action_pill(Rect2(rect.position.x + 16, rect.end.y - 37, 112, 27), _t("action_collect"), GOLD)


func _draw_order_board() -> void:
	var rect := ORDER_BOARD_RECT
	draw_rect(rect.grow(6), SHADOW)
	draw_rect(rect, Color("FFF0CC"))
	draw_rect(rect, INK, false, 3.0)
	_label(rect.position + Vector2(20, 33), _t("label_orders"), 19, INK)
	_draw_mini_van(rect.position + Vector2(548, 17))
	_draw_order_ticket("market_cart", "label_delivery", "meadow_loaf")
	_draw_order_ticket("fleece_bundle", "order_fleece", "soft_fleece")
	_draw_order_ticket("yarn_crate", "order_yarn", "yarn_roll")


func _draw_order_ticket(order_id: String, label_key: String, item_id: String) -> void:
	var rect = ORDER_RECTS.get(order_id, Rect2())
	var hovered := _hovered_target == "order:%s" % order_id
	var order: Dictionary = _config.record_by_id(order_id)
	var required_count: int = _config.number(order, "input_count")
	var has_item: bool = _model.amount_of(item_id) >= required_count
	draw_rect(rect, WHITE if has_item else Color("F3EFE3"))
	draw_rect(rect, TEAL if hovered else INK, false, 2.0)
	_label(rect.position + Vector2(10, 20), _t(label_key), 14, INK, rect.size.x - 20)
	_draw_item_icon(item_id, rect.position + Vector2(35, 57), 0.65 if has_item else 0.5)
	_label(rect.position + Vector2(55, 63), "x%d" % required_count, 16, INK)
	_draw_coin(rect.position + Vector2(112, 55), 9)
	_label(rect.position + Vector2(126, 60), "+%d" % _config.number(order, "reward_coins"), 14, INK)
	_draw_renown(rect.position + Vector2(111, 80), 7)
	_label(rect.position + Vector2(126, 85), "+%d" % _config.number(order, "reward_renown"), 13, INK)
	_draw_action_pill(Rect2(rect.position.x + 10, rect.end.y - 28, 84, 22), _t("action_ship"), TEAL if has_item else Color("C9D4D0"))


func _draw_mini_van(origin: Vector2) -> void:
	draw_rect(Rect2(origin, Vector2(50, 23)), CORAL)
	draw_rect(Rect2(origin, Vector2(50, 23)), INK, false, 1.5)
	draw_colored_polygon(PackedVector2Array([origin + Vector2(31, 0), origin + Vector2(43, 0), origin + Vector2(55, 11), origin + Vector2(55, 23), origin + Vector2(31, 23)]), Color("F3A35E"))
	draw_circle(origin + Vector2(13, 25), 6, INK)
	draw_circle(origin + Vector2(42, 25), 6, INK)


func _draw_compact_footer() -> void:
	var rect := Rect2(18, 1028, 684, 216)
	draw_rect(rect, CREAM)
	draw_rect(rect, INK, false, 3.0)
	_draw_compact_inventory_chip(Rect2(34, 1050, 154, 68), "grainleaf", GRASS)
	_draw_compact_inventory_chip(Rect2(198, 1050, 154, 68), "meadow_loaf", GOLD)
	_draw_compact_inventory_chip(Rect2(362, 1050, 154, 68), "soft_fleece", Color("D4E8D7"))
	_draw_compact_inventory_chip(Rect2(526, 1050, 154, 68), "yarn_roll", Color("CBE5E5"))
	draw_rect(Rect2(42, 1141, 636, 66), WHITE)
	draw_rect(Rect2(42, 1141, 636, 66), INK, false, 2.0)
	_label(Vector2(62, 1182), _text_catalog.text(_model.feedback_key, _model.feedback_args), 18, INK, 594.0)
	_label(Vector2(44, 1229), _t("label_settings"), 14, INK.lightened(0.25))


func _draw_compact_inventory_chip(rect: Rect2, item_id: String, fill: Color) -> void:
	draw_rect(rect, fill)
	draw_rect(rect, INK, false, 2.0)
	_draw_item_icon(item_id, rect.position + Vector2(22, 38), 0.48)
	_label(rect.position + Vector2(42, 36), _t(_resource_key(item_id)), 14, INK, 72.0)
	_label(rect.position + Vector2(101, 59), "%d/%d" % [_model.amount_of(item_id), _config.number_by_id(item_id, "capacity")], 15, INK)


func _resource_key(item_id: String) -> String:
	match item_id:
		"grainleaf":
			return "resource_grain"
		"meadow_loaf":
			return "resource_loaf"
		"soft_fleece":
			return "resource_fleece"
		"yarn_roll":
			return "resource_yarn"
	return item_id


func _draw_item_icon(item_id: String, center: Vector2, scale: float) -> void:
	match item_id:
		"grainleaf":
			_draw_grain(center, scale)
		"meadow_loaf":
			_draw_loaf(center, scale)
		"soft_fleece":
			_draw_fleece(center, scale)
		"yarn_roll":
			_draw_spool(center, scale)


func _draw_footer() -> void:
	_draw_compact_footer()
	return
	var rect := Rect2(18, 1028, 684, 216)
	draw_rect(rect, CREAM)
	draw_rect(rect, INK, false, 3.0)
	_draw_inventory_chip(Rect2(42, 1052, 298, 70), "grain", _model.amount_of("grainleaf"), _config.number_by_id("grainleaf", "capacity"), GRASS)
	_draw_inventory_chip(Rect2(380, 1052, 298, 70), "loaf", _model.amount_of("meadow_loaf"), _config.number_by_id("meadow_loaf", "capacity"), GOLD)
	draw_rect(Rect2(42, 1141, 636, 66), WHITE)
	draw_rect(Rect2(42, 1141, 636, 66), INK, false, 2.0)
	_label(Vector2(62, 1182), _text_catalog.text(_model.feedback_key, _model.feedback_args), 18, INK, 594.0)
	_label(Vector2(44, 1229), _t("label_settings"), 14, INK.lightened(0.25))


func _draw_inventory_chip(rect: Rect2, icon: String, amount: int, capacity: int, fill: Color) -> void:
	draw_rect(rect, fill)
	draw_rect(rect, INK, false, 2.0)
	if icon == "grain":
		_draw_grain(rect.position + Vector2(28, 43), 0.65)
		_label(rect.position + Vector2(52, 44), _t("resource_grain"), 18, INK)
	else:
		_draw_loaf(rect.position + Vector2(30, 36), 0.55)
		_label(rect.position + Vector2(52, 44), _t("resource_loaf"), 18, INK)
	_label(rect.position + Vector2(238, 44), "%d/%d" % [amount, capacity], 20, INK)


func _draw_settings_tray() -> void:
	draw_rect(Rect2(Vector2.ZERO, DESIGN_SIZE), Color("123943", 0.55))
	draw_rect(SETTINGS_PANEL, CREAM)
	draw_rect(SETTINGS_PANEL, INK, false, 3.0)
	_label(SETTINGS_PANEL.position + Vector2(28, 48), _t("label_settings"), 28, INK)
	_label(SETTINGS_PANEL.position + Vector2(28, 84), _t("label_language"), 18, TEAL)
	_draw_locale_button(LOCALE_ZH_RECT, _t("locale_zh"), "zh-CN")
	_draw_locale_button(LOCALE_EN_RECT, _t("locale_en"), "en")


func _draw_locale_button(rect: Rect2, label: String, locale_id: String) -> void:
	var selected: bool = _text_catalog.locale == locale_id
	var fill := TEAL if selected else WHITE
	draw_rect(rect, fill)
	draw_rect(rect, INK, false, 2.0)
	_label(rect.position + Vector2(20, 54), label, 22, WHITE if selected else INK)


func _draw_action_pill(rect: Rect2, label: String, fill: Color) -> void:
	draw_rect(rect, fill)
	draw_rect(rect, INK, false, 2.0)
	var compact: bool = rect.size.y < 30.0
	_label(rect.position + Vector2(10 if compact else 14, rect.size.y * 0.72), label, 14 if compact else 17, INK)


func _draw_timer_badge(center: Vector2, radius: float, seconds_left: int, total_seconds: float, fill: Color) -> void:
	draw_circle(center, radius + 4.0, WHITE)
	draw_circle(center, radius + 4.0, INK, false, 2.0)
	var fraction := clampf(float(seconds_left) / total_seconds, 0.0, 1.0)
	draw_arc(center, radius, -PI * 0.5, -PI * 0.5 + TAU * fraction, 20, fill, 5.0, true)
	_label(center + Vector2(-7, 6), str(seconds_left), 15, INK)


func _draw_seed(position: Vector2) -> void:
	draw_circle(position, 7, GOLD)
	draw_circle(position, 7, INK, false, 1.5)


func _draw_sprout(base: Vector2, scale: float) -> void:
	draw_line(base, base + Vector2(0, -30 * scale), GRASS_DARK, 5.0, true)
	draw_circle(base + Vector2(-9 * scale, -22 * scale), 9 * scale, Color("7BCB76"))
	draw_circle(base + Vector2(9 * scale, -15 * scale), 8 * scale, Color("65B96A"))


func _draw_grain(base: Vector2, scale: float) -> void:
	draw_line(base, base + Vector2(0, -42 * scale), GRASS_DARK, 4.0, true)
	for grain_index in range(4):
		var y := -16.0 - grain_index * 7.0
		draw_circle(base + Vector2(-5 * scale, y * scale), 4 * scale, GOLD)
		draw_circle(base + Vector2(5 * scale, (y + 3) * scale), 4 * scale, GOLD)


func _draw_loaf(center: Vector2, scale: float) -> void:
	draw_circle(center + Vector2(-12, 4) * scale, 14 * scale, Color("F4C46A"))
	draw_circle(center + Vector2(0, -3) * scale, 16 * scale, Color("F6CF78"))
	draw_circle(center + Vector2(12, 4) * scale, 14 * scale, Color("F4C46A"))
	draw_rect(Rect2(center + Vector2(-26, 3) * scale, Vector2(52, 18) * scale), Color("F4C46A"))
	draw_arc(center + Vector2(0, 1) * scale, 12 * scale, -2.45, -0.7, 10, INK.lightened(0.35), 1.5)


func _draw_fleece(center: Vector2, scale: float) -> void:
	for puff in [Vector2(-9, 2), Vector2(-2, -7), Vector2(8, -3), Vector2(10, 7), Vector2(-3, 9)]:
		draw_circle(center + puff * scale, 9 * scale, WHITE)
		draw_circle(center + puff * scale, 9 * scale, INK, false, 1.3)


func _draw_spool(center: Vector2, scale: float) -> void:
	draw_circle(center, 15 * scale, Color("73B6B4"))
	draw_circle(center, 15 * scale, INK, false, 1.6)
	draw_circle(center, 6 * scale, CREAM)
	draw_circle(center, 6 * scale, INK, false, 1.3)
	draw_line(center + Vector2(-10, -8) * scale, center + Vector2(10, 8) * scale, WHITE, 2.0, true)
	draw_line(center + Vector2(-10, 8) * scale, center + Vector2(10, -8) * scale, WHITE, 2.0, true)


func _draw_wool_sheep(center: Vector2, scale: float) -> void:
	_draw_fleece(center + Vector2(-5, -4) * scale, scale * 0.78)
	draw_circle(center + Vector2(14, -2) * scale, 8 * scale, Color("90705D"))
	draw_circle(center + Vector2(16, -5) * scale, 1.8 * scale, INK)
	draw_line(center + Vector2(-4, 10) * scale, center + Vector2(-4, 16) * scale, INK, 2.0, true)
	draw_line(center + Vector2(7, 10) * scale, center + Vector2(7, 16) * scale, INK, 2.0, true)


func _draw_coin(center: Vector2, radius: float) -> void:
	draw_circle(center, radius, GOLD)
	draw_circle(center, radius, INK, false, 1.5)
	draw_circle(center, radius * 0.48, Color("FFE59B"))


func _draw_renown(center: Vector2, radius: float) -> void:
	for petal in range(5):
		var angle := TAU * float(petal) / 5.0 - PI * 0.5
		draw_circle(center + Vector2(cos(angle), sin(angle)) * radius * 0.72, radius * 0.52, CORAL)
	draw_circle(center, radius * 0.48, GOLD)


func _draw_padlock(center: Vector2, radius: float) -> void:
	draw_arc(center + Vector2(0, -radius * 0.34), radius * 0.58, PI, TAU, 12, INK, 4.0, true)
	draw_rect(Rect2(center + Vector2(-radius * 0.72, -radius * 0.04), Vector2(radius * 1.44, radius * 1.12)), CREAM)
	draw_rect(Rect2(center + Vector2(-radius * 0.72, -radius * 0.04), Vector2(radius * 1.44, radius * 1.12)), INK, false, 2.5)
	draw_circle(center + Vector2(0, radius * 0.42), 3.5, INK)


func _draw_gear(center: Vector2, radius: float, color: Color) -> void:
	for tooth in range(8):
		var angle := TAU * float(tooth) / 8.0
		draw_line(center + Vector2(cos(angle), sin(angle)) * radius * 0.65, center + Vector2(cos(angle), sin(angle)) * radius, color, 4.0, true)
	draw_circle(center, radius * 0.62, CREAM)
	draw_circle(center, radius * 0.62, color, false, 3.0)
	draw_circle(center, radius * 0.18, color)


func _draw_tree(base: Vector2, scale: float) -> void:
	draw_rect(Rect2(base + Vector2(-5, -2) * scale, Vector2(10, 30) * scale), Color("90603F"))
	draw_circle(base + Vector2(-12, -16) * scale, 19 * scale, Color("6EB76D"))
	draw_circle(base + Vector2(10, -22) * scale, 23 * scale, Color("78C978"))
	draw_circle(base + Vector2(22, -10) * scale, 17 * scale, Color("5EAB68"))


func _draw_flower(center: Vector2, scale: float) -> void:
	for petal in range(5):
		var angle := TAU * float(petal) / 5.0
		draw_circle(center + Vector2(cos(angle), sin(angle)) * 7 * scale, 5 * scale, CORAL)
	draw_circle(center, 4 * scale, GOLD)


func _draw_cloud(center: Vector2, scale: float) -> void:
	draw_circle(center + Vector2(-20, 0) * scale, 15 * scale, Color("FFFFFF", 0.7))
	draw_circle(center + Vector2(0, -8) * scale, 20 * scale, Color("FFFFFF", 0.7))
	draw_circle(center + Vector2(22, 1) * scale, 14 * scale, Color("FFFFFF", 0.7))
	draw_rect(Rect2(center + Vector2(-28, 0) * scale, Vector2(56, 15) * scale), Color("FFFFFF", 0.7))


func _draw_fence(rect: Rect2) -> void:
	for post_x in range(int(rect.position.x), int(rect.end.x), 42):
		draw_rect(Rect2(post_x, rect.position.y - 8, 8, 34), Color("F2D69B"))
		draw_rect(Rect2(post_x, rect.position.y - 8, 8, 34), INK, false, 1.0)
	draw_line(rect.position + Vector2(0, 2), rect.position + Vector2(rect.size.x, 2), Color("F2D69B"), 5.0, true)
	draw_line(rect.position + Vector2(0, 17), rect.position + Vector2(rect.size.x, 17), Color("F2D69B"), 5.0, true)


func _t(key: String, args: Array = []) -> String:
	return _text_catalog.text(key, args)


func _label(position: Vector2, value: String, font_size: int, color: Color, width: float = -1.0) -> void:
	draw_string(ThemeDB.fallback_font, position, value, HORIZONTAL_ALIGNMENT_LEFT, width, font_size, color)
