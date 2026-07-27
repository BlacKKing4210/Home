extends RefCounted

const TABLE_PATHS := {
	"grid": "res://config/tables/f004_resident2_grid.csv",
	"objects": "res://config/tables/f004_resident2_objects.csv",
	"residents": "res://config/tables/f004_resident2_residents.csv",
	"jobs": "res://config/tables/f004_resident2_jobs.csv",
	"workplaces": "res://config/tables/f004_resident2_workplaces.csv",
	"tasks": "res://config/tables/f004_resident2_tasks.csv",
	"orders": "res://config/tables/f004_resident2_orders.csv",
	"routes": "res://config/tables/f004_resident2_routes.csv",
	"schedules": "res://config/tables/f004_resident2_schedules.csv",
	"visuals": "res://config/tables/f004_resident2_visuals.csv",
	"audio": "res://config/tables/f004_resident2_audio.csv",
}

const REQUIRED_COLUMNS := {
	"grid": ["id", "kind", "grid_x", "grid_y", "footprint_w", "footprint_h", "entry_dx", "entry_dy", "asset_id", "initial_placed", "buildable", "cost", "workpoint_offsets"],
	"objects": ["object_id", "display_key", "category", "asset_id", "cost", "unlock_rule", "placement_priority", "default_x", "default_y"],
	"residents": ["resident_id", "type_id", "display_key", "asset_id", "house_id", "job_id", "speed_cells_per_second", "invite_cost", "initially_invited", "schedule_id"],
	"jobs": ["job_id", "resident_id", "workplace_ids", "task_types", "priority", "interrupt_policy"],
	"workplaces": ["workplace_id", "grid_id", "entry_dx", "entry_dy", "workpoint_offsets", "input_cap", "output_cap", "blocked_key"],
	"tasks": ["task_type", "input_id", "input_count", "output_id", "output_count", "duration_seconds", "checkpoint", "next_task", "workplace_id", "carry_asset"],
	"orders": ["order_id", "vehicle_id", "item_id", "quantity", "reward_coins", "hard_timeout_seconds", "load_seconds", "arrival_seconds", "departure_seconds", "repeat_delay_seconds"],
	"routes": ["route_id", "state", "from_x", "from_y", "to_x", "to_y", "duration_seconds"],
	"schedules": ["schedule_id", "work_block_seconds", "life_block_seconds", "life_point_policy", "idle_variants"],
	"visuals": ["token_id", "value", "reduced_motion_value", "usage"],
	"audio": ["event_id", "priority", "cooldown_ms", "max_concurrency", "gain_db", "frequency", "duration_seconds"],
}

const ASSET_MANIFEST_PATH := "res://assets/runtime/f004_resident_slice2/runtime-manifest.json"
const SHARED_APPROVED_ASSETS := {
	"resident_house_a": "res://assets/runtime/f004_resident_slice/approved/resident_house.png",
	"road_base": "res://assets/runtime/f004_resident_slice/approved/road_tile.png",
	"loading_yard": "res://assets/runtime/f004_resident_slice/approved/loading_yard.png",
	"resident_rabbit": "res://assets/runtime/f003_farm2/animals/animal_rabbit_v1.png",
}

var errors: Array[String] = []
var _tables: Dictionary = {}
var _indexes: Dictionary = {}
var _approved_assets: Dictionary = {}
var _manifest: Dictionary = {}


static func load_default():
	var database = preload("res://scripts/town/f004_resident2_config.gd").new()
	database._load_all()
	return database


func _load_all() -> void:
	errors.clear()
	_tables.clear()
	_indexes.clear()
	_approved_assets = SHARED_APPROVED_ASSETS.duplicate(true)
	_manifest.clear()
	for table_name_variant in TABLE_PATHS.keys():
		var table_name := str(table_name_variant)
		_load_table(table_name, str(TABLE_PATHS[table_name]))
	_load_asset_manifest()
	if errors.is_empty():
		_validate()


func _load_table(table_name: String, path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		errors.append("%s: could not open %s" % [table_name, path])
		return
	var header := file.get_csv_line()
	for required_variant in REQUIRED_COLUMNS.get(table_name, []):
		var required := str(required_variant)
		if not header.has(required):
			errors.append("%s: missing required column %s" % [table_name, required])
	var loaded_rows: Array[Dictionary] = []
	var index: Dictionary = {}
	var line_number := 1
	while not file.eof_reached():
		line_number += 1
		var csv_row := file.get_csv_line()
		if csv_row.is_empty() or (csv_row.size() == 1 and csv_row[0].strip_edges().is_empty()):
			continue
		if csv_row.size() != header.size():
			errors.append("%s:%d expected %d columns, found %d" % [path, line_number, header.size(), csv_row.size()])
			continue
		var row: Dictionary = {}
		for column_index in range(header.size()):
			row[str(header[column_index])] = str(csv_row[column_index]).strip_edges()
		var id_column := _id_column(table_name)
		var identifier := str(row.get(id_column, ""))
		if identifier.is_empty() or index.has(identifier):
			errors.append("%s:%d invalid or duplicate id %s" % [path, line_number, identifier])
			continue
		loaded_rows.append(row)
		index[identifier] = row
	_tables[table_name] = loaded_rows
	_indexes[table_name] = index


func _id_column(table_name: String) -> String:
	match table_name:
		"objects": return "object_id"
		"residents": return "resident_id"
		"jobs": return "job_id"
		"workplaces": return "workplace_id"
		"tasks": return "task_type"
		"orders": return "order_id"
		"routes": return "route_id"
		"schedules": return "schedule_id"
		"visuals": return "token_id"
		"audio": return "event_id"
	return "id"


func _load_asset_manifest() -> void:
	var file := FileAccess.open(ASSET_MANIFEST_PATH, FileAccess.READ)
	if file == null:
		errors.append("asset manifest could not open: %s" % ASSET_MANIFEST_PATH)
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if not (parsed is Dictionary):
		errors.append("asset manifest is not a JSON object")
		return
	_manifest = parsed
	if str(_manifest.get("status", "")) != "ASSET_SET_APPROVED" or not bool(_manifest.get("runtime_allowed", false)):
		errors.append("asset manifest is not runtime approved")
		return
	var approved_rows: Array = _manifest.get("approved_assets", [])
	if approved_rows.size() != 8:
		errors.append("asset manifest must contain exactly eight approved F004.2 assets")
	for asset_variant in approved_rows:
		var asset: Dictionary = asset_variant
		var asset_id := str(asset.get("id", ""))
		var relative_path := str(asset.get("path", ""))
		if asset_id.is_empty() or relative_path.is_empty():
			errors.append("asset manifest contains an incomplete row")
			continue
		if not bool(asset.get("approved", false)) or not bool(asset.get("runtime_allowed", false)):
			errors.append("asset manifest row is not approved: %s" % asset_id)
			continue
		if relative_path.contains("/source/") or relative_path.contains("/qa/") or relative_path.contains("candidate"):
			errors.append("asset manifest leaks a non-runtime path: %s" % relative_path)
			continue
		_approved_assets[asset_id] = "res://%s" % relative_path


func _validate() -> void:
	for required_setting in [
		"tile_width", "tile_height", "origin_x", "origin_y", "map_columns", "map_rows",
		"initial_coins", "autosave_seconds", "save_schema", "loading_capacity",
	]:
		if setting_float(required_setting) <= 0.0:
			errors.append("visual setting %s must be positive" % required_setting)

	var occupied: Dictionary = {}
	for grid in grid_rows():
		var identifier := text(grid, "id")
		var width := number(grid, "footprint_w")
		var height := number(grid, "footprint_h")
		var origin := Vector2i(number(grid, "grid_x"), number(grid, "grid_y"))
		if width <= 0 or height <= 0:
			errors.append("grid:%s has invalid footprint" % identifier)
			continue
		if not _approved_assets.has(text(grid, "asset_id")):
			errors.append("grid:%s references an unapproved asset %s" % [identifier, text(grid, "asset_id")])
		if not _within_bounds(origin, Vector2i(width, height)):
			errors.append("grid:%s default footprint is outside map bounds" % identifier)
		for cell in footprint_cells(grid, origin):
			var key := "%d,%d" % [cell.x, cell.y]
			if occupied.has(key):
				errors.append("grid overlap %s between %s and %s" % [key, occupied[key], identifier])
			occupied[key] = identifier
		if text(grid, "kind") != "road":
			var entry := entry_cell(identifier, origin)
			if footprint_cells(grid, origin).has(entry):
				errors.append("grid:%s entrance must be outside its footprint" % identifier)

	for object_row in rows("objects"):
		var object_id := text(object_row, "object_id")
		_require("grid", object_id, "object grid")
		var grid := record("grid", object_id)
		if not boolean(grid, "buildable"):
			errors.append("object:%s must reference a buildable grid row" % object_id)
		if number(object_row, "cost") != number(grid, "cost"):
			errors.append("object:%s cost differs from grid cost" % object_id)
		if text(object_row, "asset_id") != text(grid, "asset_id"):
			errors.append("object:%s asset differs from grid asset" % object_id)
		var unlock_rule := text(object_row, "unlock_rule")
		if unlock_rule != "always":
			_require("objects", unlock_rule, "object unlock")

	for resident in rows("residents"):
		_require("grid", text(resident, "house_id"), "resident home")
		_require("jobs", text(resident, "job_id"), "resident job")
		_require("schedules", text(resident, "schedule_id"), "resident schedule")
		if decimal(resident, "speed_cells_per_second") <= 0.0 or number(resident, "invite_cost") < 0:
			errors.append("resident:%s has invalid speed or invite cost" % text(resident, "resident_id"))
		if not _approved_assets.has(text(resident, "asset_id")):
			errors.append("resident:%s references an unapproved asset" % text(resident, "resident_id"))

	for job in rows("jobs"):
		_require("residents", text(job, "resident_id"), "job resident")
		for workplace_id in list_field(job, "workplace_ids"):
			if workplace_id == "existing_home_a" or workplace_id == "road_life_b":
				_require("grid", workplace_id, "life workplace")
			else:
				_require("workplaces", workplace_id, "job workplace")
		for task_id in list_field(job, "task_types"):
			if task_id != "LIFE_IDLE":
				_require("tasks", task_id, "job task")

	for workplace in rows("workplaces"):
		_require("grid", text(workplace, "grid_id"), "workplace grid")
		if number(workplace, "input_cap") < 1 or number(workplace, "output_cap") < 1:
			errors.append("workplace:%s has invalid capacity" % text(workplace, "workplace_id"))
		if vector_list(workplace, "workpoint_offsets").is_empty():
			errors.append("workplace:%s must expose a workpoint" % text(workplace, "workplace_id"))

	for task in rows("tasks"):
		if number(task, "input_count") < 0 or number(task, "output_count") <= 0 or decimal(task, "duration_seconds") <= 0.0:
			errors.append("task:%s has invalid input, output or duration" % text(task, "task_type"))
		_require("workplaces", text(task, "workplace_id"), "task workplace")
		var next_task := text(task, "next_task")
		if not next_task.is_empty():
			_require("tasks", next_task, "task next")

	for order in rows("orders"):
		if number(order, "quantity") <= 0 or number(order, "reward_coins") <= 0:
			errors.append("order:%s has invalid quantity or reward" % text(order, "order_id"))
		if decimal(order, "hard_timeout_seconds") != 0.0:
			errors.append("order:%s must not punish the player with a hard timeout" % text(order, "order_id"))
		if not _approved_assets.has(text(order, "vehicle_id")):
			errors.append("order:%s references an unapproved vehicle asset" % text(order, "order_id"))

	for state in ["arriving", "waiting", "departing", "settled"]:
		if route_for_state(state).is_empty():
			errors.append("vehicle route missing state %s" % state)

	for schedule in rows("schedules"):
		if decimal(schedule, "life_block_seconds") <= 0.0 or list_field(schedule, "idle_variants").is_empty():
			errors.append("schedule:%s has invalid life settings" % text(schedule, "schedule_id"))

	for audio in rows("audio"):
		if number(audio, "max_concurrency") <= 0 or decimal(audio, "frequency") <= 0.0 or decimal(audio, "duration_seconds") <= 0.0:
			errors.append("audio:%s has invalid playback limits" % text(audio, "event_id"))

	for asset_path_variant in _approved_assets.values():
		var asset_path := str(asset_path_variant)
		if not FileAccess.file_exists(asset_path):
			errors.append("approved runtime asset does not exist: %s" % asset_path)


func _within_bounds(origin: Vector2i, size_value: Vector2i) -> bool:
	return (
		origin.x >= 0
		and origin.y >= 0
		and origin.x + size_value.x <= setting_int("map_columns")
		and origin.y + size_value.y <= setting_int("map_rows")
	)


func _require(table_name: String, identifier: String, context: String) -> void:
	if identifier.is_empty() or not _indexes.get(table_name, {}).has(identifier):
		errors.append("%s references missing %s:%s" % [context, table_name, identifier])


func is_valid() -> bool:
	return errors.is_empty()


func rows(table_name: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for row_variant in _tables.get(table_name, []):
		result.append(row_variant as Dictionary)
	return result


func record(table_name: String, identifier: String) -> Dictionary:
	return _indexes.get(table_name, {}).get(identifier, {})


func grid_rows() -> Array[Dictionary]:
	return rows("grid")


func road_rows() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for row in rows("grid"):
		if text(row, "kind") == "road":
			result.append(row)
	return result


func buildable_rows() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for row in rows("grid"):
		if boolean(row, "buildable"):
			result.append(row)
	result.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return number(record("objects", text(a, "id")), "placement_priority") < number(record("objects", text(b, "id")), "placement_priority")
	)
	return result


func text(row: Dictionary, field: String) -> String:
	return str(row.get(field, ""))


func number(row: Dictionary, field: String) -> int:
	return text(row, field).to_int()


func decimal(row: Dictionary, field: String) -> float:
	return text(row, field).to_float()


func boolean(row: Dictionary, field: String) -> bool:
	return text(row, field).to_lower() in ["true", "1", "yes"]


func list_field(row: Dictionary, field: String) -> Array[String]:
	var result: Array[String] = []
	for value in text(row, field).split("|", false):
		var cleaned := value.strip_edges()
		if not cleaned.is_empty():
			result.append(cleaned)
	return result


func vector_list(row: Dictionary, field: String) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for value in list_field(row, field):
		var parts := value.split(":", false)
		if parts.size() == 2:
			result.append(Vector2i(parts[0].to_int(), parts[1].to_int()))
	return result


func setting_float(identifier: String, reduced_motion: bool = false) -> float:
	var row := record("visuals", identifier)
	var field := "reduced_motion_value" if reduced_motion else "value"
	return decimal(row, field)


func setting_int(identifier: String, reduced_motion: bool = false) -> int:
	return roundi(setting_float(identifier, reduced_motion))


func default_origin(grid_id: String) -> Vector2i:
	var row := record("grid", grid_id)
	return Vector2i(number(row, "grid_x"), number(row, "grid_y"))


func footprint_size(grid_id: String) -> Vector2i:
	var row := record("grid", grid_id)
	return Vector2i(number(row, "footprint_w"), number(row, "footprint_h"))


func footprint_cells(row: Dictionary, origin: Vector2i) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for x in range(origin.x, origin.x + number(row, "footprint_w")):
		for y in range(origin.y, origin.y + number(row, "footprint_h")):
			result.append(Vector2i(x, y))
	return result


func entry_cell(grid_id: String, origin: Vector2i = Vector2i(-9999, -9999)) -> Vector2i:
	var row := record("grid", grid_id)
	var actual_origin := default_origin(grid_id) if origin.x <= -9000 else origin
	return actual_origin + Vector2i(number(row, "entry_dx"), number(row, "entry_dy"))


func work_cells(grid_id: String, origin: Vector2i = Vector2i(-9999, -9999)) -> Array[Vector2i]:
	var row := record("grid", grid_id)
	var actual_origin := default_origin(grid_id) if origin.x <= -9000 else origin
	var result: Array[Vector2i] = []
	for offset in vector_list(row, "workpoint_offsets"):
		result.append(actual_origin + offset)
	return result


func object_cost(object_id: String) -> int:
	return number(record("objects", object_id), "cost")


func object_unlocked(object_id: String, placements: Dictionary) -> bool:
	var rule := text(record("objects", object_id), "unlock_rule")
	return rule == "always" or placements.has(rule)


func asset_path(asset_id: String) -> String:
	return str(_approved_assets.get(asset_id, ""))


func approved_asset_ids() -> Array[String]:
	var result: Array[String] = []
	for asset_id_variant in _approved_assets.keys():
		result.append(str(asset_id_variant))
	result.sort()
	return result


func route_for_state(state: String) -> Dictionary:
	for route in rows("routes"):
		if text(route, "state") == state:
			return route
	return {}


func audio_event(event_id: String) -> Dictionary:
	return record("audio", event_id)
