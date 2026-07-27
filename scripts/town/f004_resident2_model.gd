extends RefCounted

signal changed
signal milestone(event_id: String)

const SAVE_SCHEMA := 4
const REQUIRED_BUILD_IDS := ["road_life_b", "resident_house_b", "dairy_pasture", "creamery"]
const MOVING_STATES := [
	"walking_to_pasture",
	"walking_to_creamery",
	"walking_to_truck",
	"walking_to_life",
]
const WORK_STATES := ["feeding", "milking", "processing", "loading"]

var config
var coins := 0
var placements: Dictionary = {}
var placement_id := ""
var placement_origin := Vector2i.ZERO
var placement_valid := false
var placement_reason := ""
var bear_invited := false
var bear_assigned := false
var bear_state := "uninvited"
var bear_cell := Vector2.ZERO
var route: Array[Vector2] = []
var route_index := 0
var route_progress := 0.0
var route_target_id := ""
var current_task := ""
var work_remaining := 0.0
var carried_item := ""
var cow_state := "idle"
var feed_units := 1
var creamery_input := 0
var creamery_output := 0
var rabbit_state := "home_idle"
var truck_state := "arriving"
var truck_progress := 0.0
var order_loaded := 0
var order_complete := false
var loading_capacity := 1
var blocked_roads: Dictionary = {}
var blocked_reason := ""
var resume_state := ""
var resume_target_id := ""
var feedback_key := "build_neighborhood"
var feedback_args: Array = []
var elapsed_seconds := 0.0
var cycle_id := 0
var build_transactions: Dictionary = {}
var invite_transactions: Dictionary = {}
var task_completion_ids: Dictionary = {}
var settlement_ids: Dictionary = {}


func _init(resident_config) -> void:
	config = resident_config
	_reset()


func _reset() -> void:
	coins = config.setting_int("initial_coins")
	placements.clear()
	for grid in config.grid_rows():
		if config.boolean(grid, "initial_placed"):
			placements[config.text(grid, "id")] = config.default_origin(config.text(grid, "id"))
	placement_id = ""
	placement_origin = Vector2i.ZERO
	placement_valid = false
	placement_reason = ""
	bear_invited = false
	bear_assigned = false
	bear_state = "uninvited"
	bear_cell = Vector2(config.entry_cell("resident_house_b"))
	route.clear()
	route_index = 0
	route_progress = 0.0
	route_target_id = ""
	current_task = ""
	work_remaining = 0.0
	carried_item = ""
	cow_state = "idle"
	feed_units = 1
	creamery_input = 0
	creamery_output = 0
	rabbit_state = "home_idle"
	truck_state = "arriving"
	truck_progress = 0.0
	order_loaded = 0
	order_complete = false
	loading_capacity = config.setting_int("loading_capacity")
	blocked_roads.clear()
	blocked_reason = ""
	resume_state = ""
	resume_target_id = ""
	feedback_key = "build_neighborhood"
	feedback_args = []
	elapsed_seconds = 0.0
	cycle_id = 0
	build_transactions.clear()
	invite_transactions.clear()
	task_completion_ids.clear()
	settlement_ids.clear()


func tick(delta: float) -> bool:
	if delta <= 0.0:
		return false
	elapsed_seconds += delta
	var dirty := _tick_truck(delta)
	match bear_state:
		"walking_to_pasture", "walking_to_creamery", "walking_to_truck", "walking_to_life":
			dirty = _tick_route(delta) or dirty
		"feeding", "milking", "processing", "loading":
			dirty = _tick_work(delta) or dirty
		"blocked":
			if _try_resume():
				dirty = true
	if order_complete and bear_state == "life_idle":
		rabbit_state = "life_idle"
	if dirty:
		changed.emit()
	return dirty


func select_placement(object_id: String) -> bool:
	if placements.has(object_id):
		return _fail("placed")
	var object_row: Dictionary = config.record("objects", object_id)
	if object_row.is_empty() or not config.object_unlocked(object_id, placements):
		return _fail("placement_illegal")
	placement_id = object_id
	placement_origin = Vector2i(config.number(object_row, "default_x"), config.number(object_row, "default_y"))
	_refresh_placement()
	changed.emit()
	return true


func update_placement(origin: Vector2i) -> bool:
	if placement_id.is_empty():
		return false
	placement_origin = origin
	_refresh_placement()
	changed.emit()
	return placement_valid


func cancel_placement() -> void:
	placement_id = ""
	placement_valid = false
	placement_reason = ""
	feedback_key = "build_neighborhood" if not all_required_placed() else "status_ready"
	feedback_args = []
	changed.emit()


func confirm_placement() -> bool:
	if placement_id.is_empty():
		return false
	_refresh_placement()
	if not placement_valid:
		return _fail(placement_reason)
	var cost: int = config.object_cost(placement_id)
	if coins < cost:
		return _fail("not_enough_coins")
	var transaction_id := "build:%s:%d:%d" % [placement_id, placement_origin.x, placement_origin.y]
	if not build_transactions.has(transaction_id):
		coins -= cost
		build_transactions[transaction_id] = true
	placements[placement_id] = placement_origin
	var placed_id := placement_id
	placement_id = ""
	placement_valid = false
	placement_reason = ""
	feedback_key = "placed"
	feedback_args = []
	milestone.emit("building_placed:%s" % placed_id)
	changed.emit()
	return true


func _refresh_placement() -> void:
	var result := placement_check(placement_id, placement_origin)
	placement_valid = bool(result.get("valid", false))
	placement_reason = str(result.get("reason", "placement_illegal"))
	feedback_key = "placement_legal" if placement_valid else placement_reason
	feedback_args = []


func placement_check(object_id: String, origin: Vector2i) -> Dictionary:
	var grid: Dictionary = config.record("grid", object_id)
	if grid.is_empty() or not config.boolean(grid, "buildable"):
		return {"valid": false, "reason": "placement_illegal"}
	var size_value: Vector2i = config.footprint_size(object_id)
	if (
		origin.x < 0
		or origin.y < 0
		or origin.x + size_value.x > config.setting_int("map_columns")
		or origin.y + size_value.y > config.setting_int("map_rows")
	):
		return {"valid": false, "reason": "invalid_bounds"}
	var occupied := occupied_cells()
	for cell in config.footprint_cells(grid, origin):
		if occupied.has(cell):
			return {"valid": false, "reason": "invalid_overlap", "cell": cell}
	if config.text(grid, "kind") != "road":
		var entry: Vector2i = config.entry_cell(object_id, origin)
		if not road_cells().has(entry):
			return {"valid": false, "reason": "invalid_road", "cell": entry}
	return {"valid": true, "reason": "placement_legal"}


func occupied_cells() -> Dictionary:
	var occupied: Dictionary = {}
	for grid_id_variant in placements.keys():
		var grid_id := str(grid_id_variant)
		var row: Dictionary = config.record("grid", grid_id)
		var origin: Vector2i = placements[grid_id]
		for cell in config.footprint_cells(row, origin):
			occupied[cell] = grid_id
	return occupied


func road_cells() -> Dictionary:
	var result: Dictionary = {}
	for grid_id_variant in placements.keys():
		var grid_id := str(grid_id_variant)
		var row: Dictionary = config.record("grid", grid_id)
		if config.text(row, "kind") != "road" or blocked_roads.has(grid_id):
			continue
		var origin: Vector2i = placements[grid_id]
		for cell in config.footprint_cells(row, origin):
			result[cell] = grid_id
	return result


func all_required_placed() -> bool:
	for object_id in REQUIRED_BUILD_IDS:
		if not placements.has(object_id):
			return false
	return true


func invite_bear() -> bool:
	if not all_required_placed() or bear_invited:
		return false
	var resident: Dictionary = config.record("residents", "bear_resident")
	var cost: int = config.number(resident, "invite_cost")
	if coins < cost:
		return _fail("not_enough_coins")
	var transaction_id := "invite:bear_resident"
	if not invite_transactions.has(transaction_id):
		coins -= cost
		invite_transactions[transaction_id] = true
	bear_invited = true
	bear_state = "home_idle"
	bear_cell = Vector2(config.entry_cell("resident_house_b", placed_origin("resident_house_b")))
	feedback_key = "bear_home"
	feedback_args = []
	milestone.emit("resident_invited")
	changed.emit()
	return true


func assign_dairy_job() -> bool:
	if not bear_invited or bear_assigned or not all_required_placed():
		return false
	bear_assigned = true
	cycle_id += 1
	current_task = "DAIRY_FEED"
	bear_cell = Vector2(config.entry_cell("resident_house_b", placed_origin("resident_house_b")))
	if not _begin_trip("walking_to_pasture", "dairy_pasture"):
		_interrupt("road", "walking_to_pasture", "dairy_pasture")
	feedback_key = status_text_key()
	feedback_args = []
	milestone.emit("job_assigned")
	changed.emit()
	return true


func set_road_blocked(road_id: String, blocked: bool) -> bool:
	if not placements.has(road_id):
		return false
	var road: Dictionary = config.record("grid", road_id)
	if config.text(road, "kind") != "road":
		return false
	if blocked:
		blocked_roads[road_id] = true
	else:
		blocked_roads.erase(road_id)
	if blocked and MOVING_STATES.has(bear_state) and _remaining_route_uses(road_id):
		_interrupt("road")
	elif not blocked and bear_state == "blocked":
		_try_resume()
	feedback_key = "road_missing" if blocked else status_text_key()
	feedback_args = []
	changed.emit()
	return true


func set_loading_capacity(capacity: int) -> void:
	loading_capacity = maxi(capacity, 0)
	if loading_capacity > 0 and bear_state == "blocked":
		_try_resume()
	changed.emit()


func _tick_truck(delta: float) -> bool:
	if not ["arriving", "departing"].has(truck_state):
		return false
	var route_record: Dictionary = config.route_for_state(truck_state)
	var duration := maxf(config.decimal(route_record, "duration_seconds"), 0.001)
	truck_progress = minf(truck_progress + delta / duration, 1.0)
	if truck_progress < 1.0:
		return true
	truck_progress = 0.0
	if truck_state == "arriving":
		truck_state = "waiting"
		feedback_key = "truck_waiting" if not bear_assigned else status_text_key()
		milestone.emit("truck_waiting")
	else:
		truck_state = "settled"
		feedback_key = "truck_settled"
		milestone.emit("truck_departed")
	return true


func _tick_route(delta: float) -> bool:
	if route.size() < 2 or route_index >= route.size() - 1:
		_arrive_at_target()
		return true
	var resident: Dictionary = config.record("residents", "bear_resident")
	var speed := maxf(config.decimal(resident, "speed_cells_per_second"), 0.1)
	route_progress += delta * speed
	while route_progress >= 1.0 and route_index < route.size() - 1:
		route_progress -= 1.0
		route_index += 1
		bear_cell = route[route_index]
		if route_index >= route.size() - 1:
			_arrive_at_target()
			return true
	return true


func _tick_work(delta: float) -> bool:
	if bear_state == "loading" and (loading_capacity <= 0 or truck_state != "waiting"):
		_interrupt("loading", "loading", "loading_dock")
		return true
	work_remaining = maxf(work_remaining - delta, 0.0)
	if work_remaining > 0.0:
		return true
	match bear_state:
		"feeding":
			_complete_feed()
		"milking":
			_complete_milk()
		"processing":
			_complete_processing()
		"loading":
			_complete_order()
	return true


func _complete_feed() -> void:
	var completion_id := _task_completion_id("DAIRY_FEED")
	if not task_completion_ids.has(completion_id):
		feed_units = maxi(feed_units - 1, 0)
		cow_state = "cared"
		task_completion_ids[completion_id] = true
	current_task = "DAIRY_MILK"
	bear_state = "milking"
	work_remaining = config.decimal(config.record("tasks", current_task), "duration_seconds")
	feedback_key = "milking"
	milestone.emit("feed_complete")


func _complete_milk() -> void:
	var completion_id := _task_completion_id("DAIRY_MILK")
	if not task_completion_ids.has(completion_id):
		carried_item = "milk_can"
		cow_state = "milked"
		task_completion_ids[completion_id] = true
	current_task = "DAIRY_CARRY_MILK"
	bear_cell = Vector2(config.entry_cell("dairy_pasture", placed_origin("dairy_pasture")))
	if not _begin_trip("walking_to_creamery", "creamery"):
		_interrupt("road", "walking_to_creamery", "creamery")
	else:
		feedback_key = "carry_milk"
		milestone.emit("milk_complete")


func _complete_processing() -> void:
	var completion_id := _task_completion_id("CREAMERY_PROCESS")
	if not task_completion_ids.has(completion_id):
		creamery_input = maxi(creamery_input - 1, 0)
		creamery_output = 1
		carried_item = "dairy_crate"
		task_completion_ids[completion_id] = true
	current_task = "DAIRY_LOAD_ORDER"
	bear_cell = Vector2(config.entry_cell("creamery", placed_origin("creamery")))
	if not _begin_trip("walking_to_truck", "loading_dock"):
		_interrupt("road", "walking_to_truck", "loading_dock")
	else:
		feedback_key = "carry_order"
		milestone.emit("process_complete")


func _complete_order() -> void:
	var order: Dictionary = config.record("orders", "dairy_delivery")
	if carried_item != config.text(order, "item_id") or creamery_output <= 0:
		_interrupt("loading", "loading", "loading_dock")
		return
	var settlement_id := "dairy_delivery:%d" % cycle_id
	if not settlement_ids.has(settlement_id):
		order_loaded = config.number(order, "quantity")
		creamery_output = maxi(creamery_output - 1, 0)
		carried_item = ""
		coins += config.number(order, "reward_coins")
		settlement_ids[settlement_id] = true
	order_complete = true
	truck_state = "departing"
	truck_progress = 0.0
	feedback_key = "reward_received"
	feedback_args = [config.number(order, "reward_coins")]
	milestone.emit("order_completed")
	bear_cell = Vector2(config.entry_cell("loading_dock", placed_origin("loading_dock")))
	if not _begin_trip("walking_to_life", "road_life_b"):
		_interrupt("road", "walking_to_life", "road_life_b")


func _arrive_at_target() -> void:
	route.clear()
	route_index = 0
	route_progress = 0.0
	match bear_state:
		"walking_to_pasture":
			bear_state = "feeding"
			current_task = "DAIRY_FEED"
			work_remaining = config.decimal(config.record("tasks", current_task), "duration_seconds")
			feedback_key = "feeding"
			milestone.emit("pasture_work_started")
		"walking_to_creamery":
			if carried_item != "milk_can":
				_interrupt("creamery", "walking_to_creamery", "creamery")
				return
			creamery_input = 1
			carried_item = ""
			bear_state = "processing"
			current_task = "CREAMERY_PROCESS"
			work_remaining = config.decimal(config.record("tasks", current_task), "duration_seconds")
			feedback_key = "processing"
			milestone.emit("creamery_work_started")
		"walking_to_truck":
			if loading_capacity <= 0 or truck_state != "waiting":
				_interrupt("loading", "loading", "loading_dock")
				return
			bear_state = "loading"
			current_task = "DAIRY_LOAD_ORDER"
			work_remaining = config.decimal(config.record("orders", "dairy_delivery"), "load_seconds")
			feedback_key = "loading"
			milestone.emit("loading_started")
		"walking_to_life":
			bear_state = "life_idle"
			bear_cell = Vector2(placed_origin("road_life_b"))
			rabbit_state = "life_idle"
			route_target_id = ""
			feedback_key = "bear_life"
			milestone.emit("residents_life")


func _begin_trip(next_state: String, target_grid_id: String) -> bool:
	var start := Vector2i(roundi(bear_cell.x), roundi(bear_cell.y))
	var target: Vector2i = config.entry_cell(target_grid_id, placed_origin(target_grid_id))
	if target_grid_id == "road_life_b":
		target = placed_origin("road_life_b")
	var path := find_path(start, target)
	if path.is_empty():
		return false
	route = path
	route_index = 0
	route_progress = 0.0
	bear_cell = route[0]
	bear_state = next_state
	route_target_id = target_grid_id
	blocked_reason = ""
	resume_state = ""
	resume_target_id = ""
	return true


func find_path(start: Vector2i, target: Vector2i) -> Array[Vector2]:
	var allowed := road_cells()
	if start != target and not allowed.has(target):
		return []
	allowed[start] = "start"
	allowed[target] = "target"
	var frontier: Array[Vector2i] = [start]
	var parent: Dictionary = {start: start}
	while not frontier.is_empty():
		var current: Vector2i = frontier.pop_front()
		if current == target:
			break
		for direction in [Vector2i.RIGHT, Vector2i.LEFT, Vector2i.DOWN, Vector2i.UP]:
			var next: Vector2i = current + direction
			if not allowed.has(next) or parent.has(next):
				continue
			parent[next] = current
			frontier.append(next)
	if not parent.has(target):
		return []
	var reverse_path: Array[Vector2i] = []
	var cursor := target
	while cursor != start:
		reverse_path.append(cursor)
		cursor = parent[cursor]
	reverse_path.append(start)
	reverse_path.reverse()
	var result: Array[Vector2] = []
	for cell in reverse_path:
		result.append(Vector2(cell))
	return result


func _interrupt(reason: String, next_resume_state: String = "", next_resume_target: String = "") -> void:
	if next_resume_state.is_empty():
		next_resume_state = bear_state
	if next_resume_target.is_empty():
		next_resume_target = route_target_id
	blocked_reason = reason
	resume_state = next_resume_state
	resume_target_id = next_resume_target
	bear_state = "blocked"
	route.clear()
	route_index = 0
	route_progress = 0.0
	feedback_key = "loading_blocked" if reason == "loading" else "road_missing" if reason == "road" else "%s_blocked" % reason
	feedback_args = []
	milestone.emit("resident_blocked")


func _try_resume() -> bool:
	if bear_state != "blocked":
		return false
	if blocked_reason == "loading":
		if loading_capacity <= 0 or truck_state != "waiting":
			return false
		bear_state = "loading"
		current_task = "DAIRY_LOAD_ORDER"
		work_remaining = maxf(work_remaining, config.decimal(config.record("orders", "dairy_delivery"), "load_seconds"))
		blocked_reason = ""
		feedback_key = "loading"
		milestone.emit("resident_resumed")
		return true
	if resume_state.is_empty() or resume_target_id.is_empty():
		return false
	var next_state := resume_state
	var next_target := resume_target_id
	if not _begin_trip(next_state, next_target):
		bear_state = "blocked"
		blocked_reason = "road"
		resume_state = next_state
		resume_target_id = next_target
		return false
	feedback_key = status_text_key()
	milestone.emit("resident_resumed")
	return true


func _remaining_route_uses(road_id: String) -> bool:
	if not placements.has(road_id):
		return false
	var road_cell: Vector2 = Vector2(placements[road_id])
	for index in range(route_index, route.size()):
		if route[index].distance_to(road_cell) < 0.1:
			return true
	return false


func placed_origin(grid_id: String) -> Vector2i:
	return placements.get(grid_id, config.default_origin(grid_id))


func bear_display_cell() -> Vector2:
	if route.size() >= 2 and route_index < route.size() - 1 and MOVING_STATES.has(bear_state):
		return route[route_index].lerp(route[route_index + 1], route_progress)
	match bear_state:
		"uninvited", "home_idle":
			return Vector2(config.entry_cell("resident_house_b", placed_origin("resident_house_b")))
		"feeding":
			return Vector2(config.work_cells("dairy_pasture", placed_origin("dairy_pasture"))[0])
		"milking":
			return Vector2(config.work_cells("dairy_pasture", placed_origin("dairy_pasture"))[1])
		"processing":
			return Vector2(config.work_cells("creamery", placed_origin("creamery"))[1])
		"loading":
			return Vector2(config.entry_cell("loading_dock", placed_origin("loading_dock")))
		"life_idle":
			return Vector2(placed_origin("road_life_b")) + Vector2(0.18, -0.08)
	return bear_cell


func rabbit_display_cell() -> Vector2:
	if rabbit_state == "life_idle" and placements.has("road_life_b"):
		return Vector2(placed_origin("road_life_b")) + Vector2(-0.26, 0.12)
	return Vector2(config.entry_cell("existing_home_a", placed_origin("existing_home_a")))


func cow_display_cell() -> Vector2:
	if not placements.has("dairy_pasture"):
		return Vector2(-100, -100)
	return Vector2(placed_origin("dairy_pasture")) + Vector2(1.45, 1.20)


func resident_progress() -> float:
	if not WORK_STATES.has(bear_state):
		return 0.0
	var duration := 1.0
	if bear_state == "loading":
		duration = config.decimal(config.record("orders", "dairy_delivery"), "load_seconds")
	else:
		duration = config.decimal(config.record("tasks", current_task), "duration_seconds")
	return clampf(1.0 - work_remaining / maxf(duration, 0.001), 0.0, 1.0)


func truck_position() -> Vector2:
	var state := truck_state
	if state == "waiting":
		state = "waiting"
	elif state == "settled":
		state = "settled"
	var route_record: Dictionary = config.route_for_state(state)
	var from := Vector2(config.decimal(route_record, "from_x"), config.decimal(route_record, "from_y"))
	var to := Vector2(config.decimal(route_record, "to_x"), config.decimal(route_record, "to_y"))
	if truck_state in ["waiting", "settled"]:
		return to
	return from.lerp(to, truck_progress)


func status_text_key() -> String:
	if not placement_id.is_empty():
		return "placement_legal" if placement_valid else placement_reason
	if not all_required_placed():
		return "build_neighborhood"
	if not bear_invited:
		return "invite_bear"
	if not bear_assigned:
		return "assign_dairy"
	match bear_state:
		"home_idle": return "bear_home"
		"walking_to_pasture": return "bear_walk_pasture"
		"feeding": return "feeding"
		"milking": return "milking"
		"walking_to_creamery": return "carry_milk"
		"processing": return "processing"
		"walking_to_truck": return "carry_order"
		"loading": return "loading"
		"walking_to_life": return "bear_walk_life"
		"life_idle": return "bear_life"
		"blocked": return "loading_blocked" if blocked_reason == "loading" else "road_missing"
	return "status_ready"


func next_unbuilt_id() -> String:
	for object_id in REQUIRED_BUILD_IDS:
		if not placements.has(object_id) and config.object_unlocked(object_id, placements):
			return object_id
	return ""


func _task_completion_id(task_id: String) -> String:
	return "cycle:%d:%s" % [cycle_id, task_id]


func _fail(key: String) -> bool:
	feedback_key = key
	feedback_args = []
	changed.emit()
	return false


func to_save_data() -> Dictionary:
	var placement_data: Dictionary = {}
	for grid_id_variant in placements.keys():
		var grid_id := str(grid_id_variant)
		var origin: Vector2i = placements[grid_id]
		placement_data[grid_id] = [origin.x, origin.y]
	var route_data: Array = []
	for cell in route:
		route_data.append([cell.x, cell.y])
	return {
		"schema": SAVE_SCHEMA,
		"coins": coins,
		"placements": placement_data,
		"bear_invited": bear_invited,
		"bear_assigned": bear_assigned,
		"bear_state": bear_state,
		"bear_cell": [bear_cell.x, bear_cell.y],
		"route": route_data,
		"route_index": route_index,
		"route_progress": route_progress,
		"route_target_id": route_target_id,
		"current_task": current_task,
		"work_remaining": work_remaining,
		"carried_item": carried_item,
		"cow_state": cow_state,
		"feed_units": feed_units,
		"creamery_input": creamery_input,
		"creamery_output": creamery_output,
		"rabbit_state": rabbit_state,
		"truck_state": truck_state,
		"truck_progress": truck_progress,
		"order_loaded": order_loaded,
		"order_complete": order_complete,
		"loading_capacity": loading_capacity,
		"blocked_roads": blocked_roads.keys(),
		"blocked_reason": blocked_reason,
		"resume_state": resume_state,
		"resume_target_id": resume_target_id,
		"feedback_key": feedback_key,
		"feedback_args": feedback_args,
		"elapsed_seconds": elapsed_seconds,
		"cycle_id": cycle_id,
		"build_transactions": build_transactions.keys(),
		"invite_transactions": invite_transactions.keys(),
		"task_completion_ids": task_completion_ids.keys(),
		"settlement_ids": settlement_ids.keys(),
	}


func apply_save_data(data: Dictionary) -> Dictionary:
	if int(data.get("schema", 0)) != SAVE_SCHEMA:
		_reset()
		return {"migrated": true}
	_reset()
	coins = max(int(data.get("coins", config.setting_int("initial_coins"))), 0)
	var saved_placements: Dictionary = data.get("placements", {})
	for grid_id_variant in saved_placements.keys():
		var grid_id := str(grid_id_variant)
		var grid: Dictionary = config.record("grid", grid_id)
		if grid.is_empty() or not config.boolean(grid, "buildable") or placements.has(grid_id):
			continue
		var coordinates: Array = saved_placements[grid_id]
		if coordinates.size() < 2:
			continue
		var origin := Vector2i(int(coordinates[0]), int(coordinates[1]))
		var check := placement_check(grid_id, origin)
		if bool(check.get("valid", false)):
			placements[grid_id] = origin
	bear_invited = bool(data.get("bear_invited", false))
	bear_assigned = bool(data.get("bear_assigned", false))
	bear_state = str(data.get("bear_state", "home_idle" if bear_invited else "uninvited"))
	if not (["uninvited", "home_idle", "feeding", "milking", "processing", "loading", "life_idle", "blocked"] + MOVING_STATES).has(bear_state):
		bear_state = "home_idle" if bear_invited else "uninvited"
	var saved_bear_cell: Array = data.get("bear_cell", [bear_cell.x, bear_cell.y])
	if saved_bear_cell.size() >= 2:
		bear_cell = Vector2(float(saved_bear_cell[0]), float(saved_bear_cell[1]))
	route.clear()
	for route_cell_variant in data.get("route", []):
		var route_cell: Array = route_cell_variant
		if route_cell.size() >= 2:
			route.append(Vector2(float(route_cell[0]), float(route_cell[1])))
	route_index = clamp(int(data.get("route_index", 0)), 0, max(route.size() - 1, 0))
	route_progress = clamp(float(data.get("route_progress", 0.0)), 0.0, 0.999)
	route_target_id = str(data.get("route_target_id", ""))
	current_task = str(data.get("current_task", ""))
	work_remaining = max(float(data.get("work_remaining", 0.0)), 0.0)
	carried_item = str(data.get("carried_item", ""))
	cow_state = str(data.get("cow_state", "idle"))
	feed_units = max(int(data.get("feed_units", 1)), 0)
	creamery_input = max(int(data.get("creamery_input", 0)), 0)
	creamery_output = max(int(data.get("creamery_output", 0)), 0)
	rabbit_state = str(data.get("rabbit_state", "home_idle"))
	truck_state = str(data.get("truck_state", "arriving"))
	if not ["arriving", "waiting", "departing", "settled"].has(truck_state):
		truck_state = "arriving"
	truck_progress = clamp(float(data.get("truck_progress", 0.0)), 0.0, 0.999)
	order_loaded = max(int(data.get("order_loaded", 0)), 0)
	order_complete = bool(data.get("order_complete", false))
	loading_capacity = max(int(data.get("loading_capacity", config.setting_int("loading_capacity"))), 0)
	blocked_roads.clear()
	for road_id_variant in data.get("blocked_roads", []):
		var road_id := str(road_id_variant)
		if placements.has(road_id) and config.text(config.record("grid", road_id), "kind") == "road":
			blocked_roads[road_id] = true
	blocked_reason = str(data.get("blocked_reason", ""))
	resume_state = str(data.get("resume_state", ""))
	resume_target_id = str(data.get("resume_target_id", ""))
	feedback_key = str(data.get("feedback_key", status_text_key()))
	feedback_args = data.get("feedback_args", [])
	elapsed_seconds = max(float(data.get("elapsed_seconds", 0.0)), 0.0)
	cycle_id = max(int(data.get("cycle_id", 0)), 0)
	build_transactions = _keys_to_dictionary(data.get("build_transactions", []))
	invite_transactions = _keys_to_dictionary(data.get("invite_transactions", []))
	task_completion_ids = _keys_to_dictionary(data.get("task_completion_ids", []))
	settlement_ids = _keys_to_dictionary(data.get("settlement_ids", []))
	if bear_state == "blocked" or MOVING_STATES.has(bear_state) or WORK_STATES.has(bear_state):
		feedback_key = "interrupted_saved"
		feedback_args = []
	return {"migrated": false}


func _keys_to_dictionary(values: Array) -> Dictionary:
	var result: Dictionary = {}
	for value in values:
		result[str(value)] = true
	return result
