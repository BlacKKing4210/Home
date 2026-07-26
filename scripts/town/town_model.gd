extends RefCounted

signal changed

var config
var plots: Array[Dictionary] = []
var inventory: Dictionary = {}
var coins := 0
var renown := 0
var buildings: Dictionary = {}
var feedback_key := "hint_start"
var feedback_args: Array = []

var bakery_state: String:
	get:
		return building_state("crumbworks")

var bakery_remaining: float:
	get:
		return building_remaining("crumbworks")


func _init(town_config) -> void:
	config = town_config
	for inventory_record in config.records_of_kind("inventory"):
		inventory[config.text(inventory_record, "id")] = config.number(inventory_record, "initial_value")
	for building_record in config.records_of_kind("building"):
		var building_id: String = config.text(building_record, "id")
		buildings[building_id] = _new_building_state()
	coins = config.number_by_id("initial_coins", "initial_value")
	renown = config.number_by_id("initial_renown", "initial_value")
	var open_plot_count: int = config.number_by_id("initial_open_plots", "initial_value")
	var locked_plot_count: int = config.number_by_id("initial_locked_plots", "initial_value")
	for ignored_index in range(open_plot_count):
		plots.append(_new_plot("empty"))
	for ignored_index in range(locked_plot_count):
		plots.append(_new_plot("locked"))
	set_feedback("hint_start")


func _new_plot(state_name: String) -> Dictionary:
	return {"state": state_name, "remaining": 0.0}


func _new_building_state() -> Dictionary:
	return {"state": "idle", "remaining": 0.0}


func tick(delta: float) -> bool:
	var state_changed := false
	for index in range(plots.size()):
		var plot: Dictionary = plots[index]
		if str(plot.get("state", "")) == "growing":
			plot["remaining"] = max(float(plot.get("remaining", 0.0)) - delta, 0.0)
			if float(plot["remaining"]) <= 0.0:
				plot["state"] = "ripe"
				set_feedback("feedback_crop_ready")
			plots[index] = plot
			state_changed = true
	for building_id_variant in buildings.keys():
		var building_id: String = str(building_id_variant)
		var building: Dictionary = buildings[building_id]
		if str(building.get("state", "")) != "busy":
			continue
		building["remaining"] = max(float(building.get("remaining", 0.0)) - delta, 0.0)
		if float(building.get("remaining", 0.0)) <= 0.0:
			building["state"] = "ready"
			set_feedback(_building_feedback_key(building_id, "ready"))
		buildings[building_id] = building
		state_changed = true
	if state_changed:
		emit_signal("changed")
	return state_changed


func interact_plot(index: int) -> bool:
	if index < 0 or index >= plots.size():
		return _fail("feedback_invalid_plot")
	var plot: Dictionary = plots[index]
	match str(plot.get("state", "")):
		"empty":
			return _plant(index)
		"growing":
			return _fail("feedback_growing", [int(ceil(float(plot.get("remaining", 0.0))))])
		"ripe":
			return _harvest(index)
		"locked":
			return unlock_plot(index)
	return _fail("feedback_invalid_plot")


func _plant(index: int) -> bool:
	var crop: Dictionary = config.first_of_kind("crop")
	if crop.is_empty():
		return _fail("feedback_invalid_plot")
	var plot: Dictionary = plots[index]
	plot["state"] = "growing"
	plot["remaining"] = float(config.number(crop, "seconds"))
	plots[index] = plot
	set_feedback("feedback_planted", [config.number(crop, "seconds")])
	_emit_changed()
	return true


func _harvest(index: int) -> bool:
	var crop: Dictionary = config.first_of_kind("crop")
	var output_item: String = config.text(crop, "output_item")
	var capacity: int = config.number_by_id(output_item, "capacity")
	if amount_of(output_item) >= capacity:
		return _fail("feedback_storage_full")
	add_amount(output_item, config.number(crop, "output_count"))
	var plot: Dictionary = plots[index]
	plot["state"] = "empty"
	plot["remaining"] = 0.0
	plots[index] = plot
	set_feedback("feedback_harvested")
	_emit_changed()
	return true


func interact_bakery() -> bool:
	return interact_building("crumbworks")


func start_bake() -> bool:
	return start_building("crumbworks")


func collect_bake() -> bool:
	return collect_building("crumbworks")


func interact_building(building_id: String) -> bool:
	match building_state(building_id):
		"idle":
			return start_building(building_id)
		"busy":
			return _fail(_building_feedback_key(building_id, "busy"), [int(ceil(building_remaining(building_id)))])
		"ready":
			return collect_building(building_id)
	return _fail("feedback_workshop_reset")


func start_building(building_id: String) -> bool:
	if building_state(building_id) != "idle":
		return _fail(_building_feedback_key(building_id, "busy"), [int(ceil(building_remaining(building_id)))])
	var building: Dictionary = config.record_by_id(building_id)
	if building.is_empty():
		return _fail("feedback_workshop_reset")
	var input_item: String = config.text(building, "input_item")
	var output_item: String = config.text(building, "output_item")
	var input_count: int = config.number(building, "input_count")
	if amount_of(input_item) < input_count:
		return _fail(_building_feedback_key(building_id, "missing"), [input_count])
	if amount_of(output_item) >= config.number_by_id(output_item, "capacity"):
		return _fail(_building_feedback_key(building_id, "full"))
	add_amount(input_item, -input_count)
	var state: Dictionary = buildings.get(building_id, _new_building_state())
	state["state"] = "busy"
	state["remaining"] = float(config.number(building, "seconds"))
	buildings[building_id] = state
	set_feedback(_building_feedback_key(building_id, "started"))
	_emit_changed()
	return true


func collect_building(building_id: String) -> bool:
	if building_state(building_id) != "ready":
		return _fail("feedback_workshop_reset")
	var building: Dictionary = config.record_by_id(building_id)
	if building.is_empty():
		return _fail("feedback_workshop_reset")
	var output_item: String = config.text(building, "output_item")
	if amount_of(output_item) >= config.number_by_id(output_item, "capacity"):
		return _fail(_building_feedback_key(building_id, "full"))
	add_amount(output_item, config.number(building, "output_count"))
	var state: Dictionary = buildings.get(building_id, _new_building_state())
	state["state"] = "idle"
	state["remaining"] = 0.0
	buildings[building_id] = state
	set_feedback(_building_feedback_key(building_id, "collected"))
	_emit_changed()
	return true


func building_state(building_id: String) -> String:
	var state: Dictionary = buildings.get(building_id, {})
	return str(state.get("state", "invalid"))


func building_remaining(building_id: String) -> float:
	var state: Dictionary = buildings.get(building_id, {})
	return float(state.get("remaining", 0.0))


func fulfill_order(order_id: String = "market_cart") -> bool:
	var order: Dictionary = config.record_by_id(order_id)
	if order.is_empty():
		return _fail("feedback_choose_target")
	var input_item: String = config.text(order, "input_item")
	var required_count: int = config.number(order, "input_count")
	if amount_of(input_item) < required_count:
		return _fail(_order_missing_feedback_key(order_id), [required_count - amount_of(input_item)])
	add_amount(input_item, -required_count)
	coins += config.number(order, "reward_coins")
	renown += config.number(order, "reward_renown")
	set_feedback("feedback_order_delivered", [config.number(order, "reward_coins"), config.number(order, "reward_renown")])
	_emit_changed()
	return true


func _building_feedback_key(building_id: String, state_name: String) -> String:
	var keys := {
		"crumbworks": {
			"ready": "feedback_bakery_ready",
			"missing": "feedback_missing_grain",
			"full": "feedback_loaf_storage_full",
			"busy": "feedback_bakery_busy",
			"started": "feedback_baking_started",
			"collected": "feedback_bakery_collected"
		},
		"willow_pen": {
			"ready": "feedback_willow_pen_ready",
			"missing": "feedback_missing_feed",
			"full": "feedback_fleece_storage_full",
			"busy": "feedback_willow_pen_busy",
			"started": "feedback_feeding_started",
			"collected": "feedback_fleece_collected"
		},
		"threadmill": {
			"ready": "feedback_threadmill_ready",
			"missing": "feedback_missing_fleece",
			"full": "feedback_yarn_storage_full",
			"busy": "feedback_threadmill_busy",
			"started": "feedback_spinning_started",
			"collected": "feedback_yarn_collected"
		}
	}
	var building_keys: Dictionary = keys.get(building_id, {})
	return str(building_keys.get(state_name, "feedback_workshop_reset"))


func _order_missing_feedback_key(order_id: String) -> String:
	match order_id:
		"market_cart":
			return "feedback_cart_needs_loaf"
		"fleece_bundle":
			return "feedback_order_needs_fleece"
		"yarn_crate":
			return "feedback_order_needs_yarn"
	return "feedback_choose_target"


func unlock_plot(index: int) -> bool:
	if index < 0 or index >= plots.size() or str(plots[index].get("state", "")) != "locked":
		return _fail("feedback_plot_not_locked")
	var unlock: Dictionary = config.first_of_kind("unlock")
	var cost: int = config.number(unlock, "unlock_cost")
	if coins < cost:
		return _fail("feedback_need_coins", [cost - coins])
	coins -= cost
	var plot: Dictionary = plots[index]
	plot["state"] = "empty"
	plot["remaining"] = 0.0
	plots[index] = plot
	set_feedback("feedback_plot_unlocked")
	_emit_changed()
	return true


func amount_of(item_id: String) -> int:
	return int(inventory.get(item_id, 0))


func add_amount(item_id: String, delta: int) -> void:
	inventory[item_id] = amount_of(item_id) + delta


func set_feedback(next_key: String, args: Array = []) -> void:
	feedback_key = next_key
	feedback_args = args.duplicate()


func _fail(next_key: String, args: Array = []) -> bool:
	set_feedback(next_key, args)
	_emit_changed()
	return false


func _emit_changed() -> void:
	emit_signal("changed")
