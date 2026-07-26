extends RefCounted

signal changed
signal milestone(event_id: String)

const SAVE_SCHEMA := 3
const MOVING_STATES := [
	"walking_to_field",
	"walking_to_workshop",
	"walking_to_yard",
	"walking_home",
]

var config
var coins := 0
var house_built := false
var resident_invited := false
var resident_state := "uninvited"
var resident_cell := Vector2(2.0, 3.0)
var route: Array[Vector2] = []
var route_index := 0
var route_progress := 0.0
var route_target_id := ""
var current_job_id := ""
var work_remaining := 0.0
var carried_item := ""
var carried_count := 0
var blocked_roads: Dictionary = {}
var blocked_reason := ""
var resume_state := ""
var resume_target_id := ""
var loading_capacity := 1
var truck_state := "arriving"
var truck_progress := 0.0
var order_loaded := 0
var order_complete := false
var feedback_key := "tap_world_hint"
var feedback_args: Array = []
var elapsed_seconds := 0.0


func _init(resident_config) -> void:
	config = resident_config
	_reset()


func _reset() -> void:
	coins = config.setting_int("initial_coins")
	house_built = false
	resident_invited = false
	resident_state = "uninvited"
	resident_cell = Vector2(config.entry_cell("home_plot"))
	route.clear()
	route_index = 0
	route_progress = 0.0
	route_target_id = ""
	current_job_id = ""
	work_remaining = 0.0
	carried_item = ""
	carried_count = 0
	blocked_roads.clear()
	blocked_reason = ""
	resume_state = ""
	resume_target_id = ""
	loading_capacity = 1
	truck_state = "arriving"
	truck_progress = 0.0
	order_loaded = 0
	order_complete = false
	feedback_key = "tap_world_hint"
	feedback_args = []
	elapsed_seconds = 0.0


func tick(delta: float) -> bool:
	if delta <= 0.0:
		return false
	elapsed_seconds += delta
	var dirty := _tick_truck(delta)
	match resident_state:
		"walking_to_field", "walking_to_workshop", "walking_to_yard", "walking_home":
			dirty = _tick_route(delta) or dirty
		"working_field", "working_workshop", "loading":
			dirty = _tick_work(delta) or dirty
		"blocked":
			if _try_resume():
				dirty = true
	if dirty:
		changed.emit()
	return dirty


func build_house() -> bool:
	if house_built:
		return false
	var cost: int = config.setting_int("house_build_cost")
	if coins < cost:
		return _fail("not_enough_coins")
	if not validate_footprint("home_plot"):
		return _fail("placement_invalid")
	coins -= cost
	house_built = true
	feedback_key = "house_ready"
	feedback_args = []
	milestone.emit("house_built")
	changed.emit()
	return true


func invite_resident() -> bool:
	if not house_built or resident_invited:
		return false
	var resident: Dictionary = config.record("resident_types", "rabbit_resident")
	var cost: int = config.number(resident, "invite_cost")
	if coins < cost:
		return _fail("not_enough_coins")
	coins -= cost
	resident_invited = true
	resident_state = "home_idle"
	resident_cell = Vector2(2.0, 2.0)
	feedback_key = "resident_home"
	feedback_args = []
	milestone.emit("resident_invited")
	changed.emit()
	return true


func assign_default_job() -> bool:
	if not resident_invited or not house_built:
		return false
	if not ["home_idle", "unassigned"].has(resident_state):
		return false
	current_job_id = "harvest_wheat"
	resident_cell = Vector2(config.entry_cell("home_plot"))
	if not _begin_trip("walking_to_field", "field_wheat"):
		current_job_id = ""
		return _fail("road_missing")
	feedback_key = "resident_walk_field"
	feedback_args = []
	milestone.emit("job_assigned")
	changed.emit()
	return true


func validate_footprint(grid_id: String) -> bool:
	var target: Dictionary = config.record("grid", grid_id)
	if target.is_empty():
		return false
	var target_cells: Array[Vector2i] = _footprint_cells(target)
	for other in config.grid_rows():
		if config.text(other, "id") == grid_id:
			continue
		if config.text(other, "kind") == "road":
			continue
		for cell in _footprint_cells(other):
			if target_cells.has(cell):
				return false
	return true


func set_road_blocked(road_id: String, blocked: bool) -> bool:
	var road_record: Dictionary = config.record("grid", road_id)
	if road_record.is_empty() or config.text(road_record, "kind") != "road":
		return false
	if blocked:
		blocked_roads[road_id] = true
	else:
		blocked_roads.erase(road_id)
	if blocked and MOVING_STATES.has(resident_state) and _remaining_route_uses(road_id):
		_interrupt("road")
	elif not blocked and resident_state == "blocked":
		_try_resume()
	feedback_key = "road_closed" if blocked else "road_open"
	feedback_args = []
	changed.emit()
	return true


func set_loading_capacity(capacity: int) -> void:
	loading_capacity = maxi(capacity, 0)
	if loading_capacity > 0 and resident_state == "blocked":
		_try_resume()
	changed.emit()


func _tick_truck(delta: float) -> bool:
	if not ["arriving", "departing"].has(truck_state):
		return false
	var route_record: Dictionary = config.route_for_state(truck_state)
	var duration: float = maxf(config.decimal(route_record, "duration_seconds"), 0.001)
	truck_progress = minf(truck_progress + delta / duration, 1.0)
	if truck_progress < 1.0:
		return true
	truck_progress = 0.0
	if truck_state == "arriving":
		truck_state = "waiting"
		feedback_key = "truck_waiting"
		milestone.emit("truck_waiting")
	else:
		truck_state = "gone"
		feedback_key = "truck_gone"
		milestone.emit("truck_departed")
	return true


func _tick_route(delta: float) -> bool:
	if route.size() < 2 or route_index >= route.size() - 1:
		_arrive_at_target()
		return true
	var resident: Dictionary = config.record("resident_types", "rabbit_resident")
	var speed: float = maxf(config.decimal(resident, "speed_cells_per_second"), 0.1)
	route_progress += delta * speed
	while route_progress >= 1.0 and route_index < route.size() - 1:
		route_progress -= 1.0
		route_index += 1
		resident_cell = route[route_index]
		if route_index >= route.size() - 1:
			_arrive_at_target()
			return true
	return true


func _tick_work(delta: float) -> bool:
	if resident_state == "loading" and (loading_capacity <= 0 or truck_state != "waiting"):
		_interrupt("loading")
		return true
	work_remaining = maxf(work_remaining - delta, 0.0)
	if work_remaining > 0.0:
		return true
	match resident_state:
		"working_field":
			var job: Dictionary = config.record("jobs", "harvest_wheat")
			carried_item = config.text(job, "output_item")
			carried_count = config.number(job, "output_count")
			current_job_id = config.text(job, "next_job_id")
			if not _begin_trip("walking_to_workshop", "workshop_granary"):
				_interrupt("road", "walking_to_workshop", "workshop_granary")
			else:
				feedback_key = "resident_walk_workshop"
				milestone.emit("field_work_complete")
		"working_workshop":
			var job: Dictionary = config.record("jobs", "sort_wheat")
			if carried_item != config.text(job, "input_item") or carried_count < config.number(job, "input_count"):
				_interrupt("workshop")
				return true
			carried_item = config.text(job, "output_item")
			carried_count = config.number(job, "output_count")
			current_job_id = ""
			if not _begin_trip("walking_to_yard", "loading_yard"):
				_interrupt("road", "walking_to_yard", "loading_yard")
			else:
				feedback_key = "resident_walk_yard"
				milestone.emit("workshop_work_complete")
		"loading":
			_complete_order()
	return true


func _complete_order() -> void:
	var order: Dictionary = config.record("vehicle_orders", "bakery_delivery")
	if carried_item != config.text(order, "required_item") or carried_count < config.number(order, "required_count"):
		_interrupt("loading")
		return
	order_loaded += config.number(order, "required_count")
	carried_count -= config.number(order, "required_count")
	if carried_count <= 0:
		carried_item = ""
		carried_count = 0
	coins += config.number(order, "reward_coins")
	order_complete = true
	truck_state = "departing"
	truck_progress = 0.0
	feedback_key = "reward_received"
	feedback_args = [config.number(order, "reward_coins")]
	milestone.emit("order_completed")
	if not _begin_trip("walking_home", "home_plot"):
		_interrupt("road", "walking_home", "home_plot")


func _arrive_at_target() -> void:
	var arrived_target: String = route_target_id
	route.clear()
	route_index = 0
	route_progress = 0.0
	match resident_state:
		"walking_to_field":
			resident_state = "working_field"
			current_job_id = "harvest_wheat"
			work_remaining = config.decimal(config.record("jobs", current_job_id), "work_seconds")
			feedback_key = "resident_work_field"
			milestone.emit("field_work_started")
		"walking_to_workshop":
			resident_state = "working_workshop"
			current_job_id = "sort_wheat"
			work_remaining = config.decimal(config.record("jobs", current_job_id), "work_seconds")
			feedback_key = "resident_work_workshop"
			milestone.emit("workshop_work_started")
		"walking_to_yard":
			if loading_capacity <= 0 or truck_state != "waiting":
				_interrupt("loading", "loading", "loading_yard")
			else:
				resident_state = "loading"
				work_remaining = config.decimal(config.record("vehicle_orders", "bakery_delivery"), "load_seconds")
				feedback_key = "resident_loading"
				milestone.emit("loading_started")
		"walking_home":
			resident_state = "home_idle"
			resident_cell = Vector2(2.0, 2.0)
			route_target_id = ""
			feedback_key = "resident_home"
			milestone.emit("resident_home")
	if arrived_target.is_empty():
		route_target_id = ""


func _begin_trip(next_state: String, target_grid_id: String) -> bool:
	var start: Vector2i = Vector2i(roundi(resident_cell.x), roundi(resident_cell.y))
	if resident_state == "working_field":
		start = config.entry_cell("field_wheat")
	elif resident_state == "working_workshop":
		start = config.entry_cell("workshop_granary")
	elif resident_state == "loading":
		start = config.entry_cell("loading_yard")
	var target: Vector2i = config.entry_cell(target_grid_id)
	var path: Array[Vector2] = find_path(start, target)
	if path.is_empty():
		return false
	route = path
	route_index = 0
	route_progress = 0.0
	resident_cell = route[0]
	resident_state = next_state
	route_target_id = target_grid_id
	blocked_reason = ""
	resume_state = ""
	resume_target_id = ""
	return true


func find_path(start: Vector2i, target: Vector2i) -> Array[Vector2]:
	if start != target and _cell_is_blocked(target):
		return []
	var allowed: Dictionary = {}
	for road in config.road_rows():
		var road_id: String = config.text(road, "id")
		if blocked_roads.has(road_id):
			continue
		allowed[Vector2i(config.number(road, "grid_x"), config.number(road, "grid_y"))] = true
	allowed[start] = true
	allowed[target] = true
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
	var cursor: Vector2i = target
	while cursor != start:
		reverse_path.append(cursor)
		cursor = parent[cursor]
	reverse_path.append(start)
	reverse_path.reverse()
	var result: Array[Vector2] = []
	for cell in reverse_path:
		result.append(Vector2(cell))
	return result


func _cell_is_blocked(cell: Vector2i) -> bool:
	for road_id_variant in blocked_roads.keys():
		var road_id := str(road_id_variant)
		var road: Dictionary = config.record("grid", road_id)
		if Vector2i(config.number(road, "grid_x"), config.number(road, "grid_y")) == cell:
			return true
	return false


func resident_display_cell() -> Vector2:
	match resident_state:
		"uninvited":
			return Vector2(2.0, 2.0)
		"home_idle":
			return Vector2(2.0, 2.0)
		"working_field":
			return Vector2(config.work_cell("field_wheat"))
		"working_workshop":
			return Vector2(config.work_cell("workshop_granary"))
		"loading":
			return Vector2(config.work_cell("loading_yard"))
	if route.size() >= 2 and route_index < route.size() - 1:
		return route[route_index].lerp(route[route_index + 1], route_progress)
	return resident_cell


func resident_progress() -> float:
	if resident_state in ["working_field", "working_workshop"]:
		var duration: float = config.decimal(config.record("jobs", current_job_id), "work_seconds")
		return clampf(1.0 - work_remaining / maxf(duration, 0.001), 0.0, 1.0)
	if resident_state == "loading":
		var duration: float = config.decimal(config.record("vehicle_orders", "bakery_delivery"), "load_seconds")
		return clampf(1.0 - work_remaining / maxf(duration, 0.001), 0.0, 1.0)
	return 0.0


func truck_position() -> Vector2:
	var route_record: Dictionary = config.route_for_state(truck_state if truck_state != "gone" else "departing")
	var from: Vector2 = Vector2(config.decimal(route_record, "from_x"), config.decimal(route_record, "from_y"))
	var to: Vector2 = Vector2(config.decimal(route_record, "to_x"), config.decimal(route_record, "to_y"))
	if truck_state == "waiting" or truck_state == "loading":
		return to
	if truck_state == "gone":
		return Vector2(900.0, 700.0)
	return from.lerp(to, truck_progress)


func status_text_key() -> String:
	match resident_state:
		"uninvited": return "resident_uninvited"
		"home_idle": return "resident_home"
		"walking_to_field": return "resident_walk_field"
		"working_field": return "resident_work_field"
		"walking_to_workshop": return "resident_walk_workshop"
		"working_workshop": return "resident_work_workshop"
		"walking_to_yard": return "resident_walk_yard"
		"loading": return "resident_loading"
		"walking_home": return "resident_walk_home"
		"blocked": return "loading_blocked" if blocked_reason == "loading" else "resident_blocked"
	return "resident_home"


func _interrupt(reason: String, next_resume_state: String = "", next_resume_target: String = "") -> void:
	if next_resume_state.is_empty():
		next_resume_state = resident_state
	if next_resume_target.is_empty():
		next_resume_target = route_target_id
	blocked_reason = reason
	resume_state = next_resume_state
	resume_target_id = next_resume_target
	resident_state = "blocked"
	route.clear()
	route_index = 0
	route_progress = 0.0
	feedback_key = "loading_blocked" if reason == "loading" else "resident_blocked"
	feedback_args = []
	milestone.emit("resident_blocked")


func _try_resume() -> bool:
	if resident_state != "blocked":
		return false
	if blocked_reason == "loading":
		if loading_capacity <= 0 or truck_state != "waiting":
			return false
		resident_state = "loading"
		work_remaining = maxf(work_remaining, config.decimal(config.record("vehicle_orders", "bakery_delivery"), "load_seconds"))
		blocked_reason = ""
		feedback_key = "resident_loading"
		milestone.emit("resident_resumed")
		return true
	if resume_state.is_empty() or resume_target_id.is_empty():
		return false
	var next_state: String = resume_state
	var next_target: String = resume_target_id
	if not _begin_trip(next_state, next_target):
		resident_state = "blocked"
		blocked_reason = "road"
		resume_state = next_state
		resume_target_id = next_target
		return false
	feedback_key = status_text_key()
	milestone.emit("resident_resumed")
	return true


func _remaining_route_uses(road_id: String) -> bool:
	var road: Dictionary = config.record("grid", road_id)
	var road_cell: Vector2 = Vector2(config.number(road, "grid_x"), config.number(road, "grid_y"))
	for index in range(route_index, route.size()):
		if route[index].distance_to(road_cell) < 0.1:
			return true
	return false


func _footprint_cells(grid_record: Dictionary) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for cell_x in range(config.number(grid_record, "grid_x"), config.number(grid_record, "grid_x") + config.number(grid_record, "footprint_w")):
		for cell_y in range(config.number(grid_record, "grid_y"), config.number(grid_record, "grid_y") + config.number(grid_record, "footprint_h")):
			result.append(Vector2i(cell_x, cell_y))
	return result


func _fail(key: String) -> bool:
	feedback_key = key
	feedback_args = []
	changed.emit()
	return false


func to_save_data() -> Dictionary:
	var route_data: Array = []
	for cell in route:
		route_data.append([cell.x, cell.y])
	return {
		"schema": SAVE_SCHEMA,
		"coins": coins,
		"house_built": house_built,
		"resident_invited": resident_invited,
		"resident_state": resident_state,
		"resident_cell": [resident_cell.x, resident_cell.y],
		"route": route_data,
		"route_index": route_index,
		"route_progress": route_progress,
		"route_target_id": route_target_id,
		"current_job_id": current_job_id,
		"work_remaining": work_remaining,
		"carried_item": carried_item,
		"carried_count": carried_count,
		"blocked_roads": blocked_roads.keys(),
		"blocked_reason": blocked_reason,
		"resume_state": resume_state,
		"resume_target_id": resume_target_id,
		"loading_capacity": loading_capacity,
		"truck_state": truck_state,
		"truck_progress": truck_progress,
		"order_loaded": order_loaded,
		"order_complete": order_complete,
		"elapsed_seconds": elapsed_seconds,
	}


func apply_save_data(data: Dictionary) -> Dictionary:
	if int(data.get("schema", 0)) != SAVE_SCHEMA:
		_reset()
		return {"migrated": true}
	coins = max(int(data.get("coins", config.setting_int("initial_coins"))), 0)
	house_built = bool(data.get("house_built", false))
	resident_invited = bool(data.get("resident_invited", false))
	resident_state = str(data.get("resident_state", "home_idle" if resident_invited else "uninvited"))
	var saved_cell: Array = data.get("resident_cell", [2.0, 3.0])
	if saved_cell.size() >= 2:
		resident_cell = Vector2(float(saved_cell[0]), float(saved_cell[1]))
	route.clear()
	for saved_route_cell_variant in data.get("route", []):
		var saved_route_cell: Array = saved_route_cell_variant
		if saved_route_cell.size() >= 2:
			route.append(Vector2(float(saved_route_cell[0]), float(saved_route_cell[1])))
	route_index = clamp(int(data.get("route_index", 0)), 0, max(route.size() - 1, 0))
	route_progress = clamp(float(data.get("route_progress", 0.0)), 0.0, 0.999)
	route_target_id = str(data.get("route_target_id", ""))
	current_job_id = str(data.get("current_job_id", ""))
	work_remaining = max(float(data.get("work_remaining", 0.0)), 0.0)
	carried_item = str(data.get("carried_item", ""))
	carried_count = max(int(data.get("carried_count", 0)), 0)
	blocked_roads.clear()
	for road_id_variant in data.get("blocked_roads", []):
		var road_id := str(road_id_variant)
		if config.text(config.record("grid", road_id), "kind") == "road":
			blocked_roads[road_id] = true
	blocked_reason = str(data.get("blocked_reason", ""))
	resume_state = str(data.get("resume_state", ""))
	resume_target_id = str(data.get("resume_target_id", ""))
	loading_capacity = max(int(data.get("loading_capacity", 1)), 0)
	truck_state = str(data.get("truck_state", "arriving"))
	if not ["arriving", "waiting", "departing", "gone"].has(truck_state):
		truck_state = "arriving"
	truck_progress = clamp(float(data.get("truck_progress", 0.0)), 0.0, 0.999)
	order_loaded = max(int(data.get("order_loaded", 0)), 0)
	order_complete = bool(data.get("order_complete", false))
	elapsed_seconds = max(float(data.get("elapsed_seconds", 0.0)), 0.0)
	feedback_key = "interrupted_saved" if resident_state == "blocked" or MOVING_STATES.has(resident_state) else status_text_key()
	feedback_args = []
	return {"migrated": false}
