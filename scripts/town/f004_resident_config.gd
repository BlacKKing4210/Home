extends RefCounted

const TABLE_PATHS := {
	"grid": "res://config/tables/f004_resident_grid.csv",
	"resident_types": "res://config/tables/f004_resident_types.csv",
	"jobs": "res://config/tables/f004_resident_jobs.csv",
	"workplaces": "res://config/tables/f004_resident_workplaces.csv",
	"vehicle_orders": "res://config/tables/f004_vehicle_orders.csv",
	"vehicle_routes": "res://config/tables/f004_vehicle_routes.csv",
}

const REQUIRED_COLUMNS := {
	"grid": ["id", "kind", "grid_x", "grid_y", "footprint_w", "footprint_h", "entry_x", "entry_y", "asset_id", "initial_state", "interactive", "value"],
	"resident_types": ["id", "display_key", "asset_path", "speed_cells_per_second", "invite_cost", "home_id", "default_job_id"],
	"jobs": ["id", "display_key", "sequence", "workplace_id", "work_seconds", "input_item", "input_count", "output_item", "output_count", "next_job_id", "carry_target_id"],
	"workplaces": ["id", "display_key", "grid_id", "work_x", "work_y", "queue_capacity", "output_capacity", "blocked_key"],
	"vehicle_orders": ["id", "display_key", "required_item", "required_count", "reward_coins", "load_seconds", "repeat_delay_seconds", "hard_timeout_seconds"],
	"vehicle_routes": ["id", "state", "from_x", "from_y", "to_x", "to_y", "duration_seconds"],
}

const RUNTIME_ASSET_PATHS := {
	"resident_house": "res://assets/runtime/f004_resident_slice/approved/resident_house.png",
	"road_tile": "res://assets/runtime/f004_resident_slice/approved/road_tile.png",
	"wheat_field": "res://assets/runtime/f004_resident_slice/approved/wheat_field.png",
	"workshop_granary": "res://assets/runtime/f004_resident_slice/approved/workshop_granary.png",
	"loading_yard": "res://assets/runtime/f004_resident_slice/approved/loading_yard.png",
	"order_truck": "res://assets/runtime/f004_resident_slice/approved/order_truck.png",
}

var errors: Array[String] = []
var _tables: Dictionary = {}
var _indexes: Dictionary = {}


static func load_default():
	var database = preload("res://scripts/town/f004_resident_config.gd").new()
	database._load_all()
	return database


func _load_all() -> void:
	errors.clear()
	_tables.clear()
	_indexes.clear()
	for table_name_variant in TABLE_PATHS.keys():
		var table_name := str(table_name_variant)
		_load_table(table_name, str(TABLE_PATHS[table_name]))
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
		var record_value: Dictionary = {}
		for column_index in range(header.size()):
			record_value[str(header[column_index])] = str(csv_row[column_index]).strip_edges()
		var identifier := str(record_value.get("id", ""))
		if identifier.is_empty() or index.has(identifier):
			errors.append("%s:%d invalid or duplicate id %s" % [path, line_number, identifier])
			continue
		loaded_rows.append(record_value)
		index[identifier] = record_value
	_tables[table_name] = loaded_rows
	_indexes[table_name] = index


func _validate() -> void:
	for required_setting in [
		"tile_width", "tile_height", "origin_x", "origin_y", "initial_coins",
		"house_build_cost", "autosave_seconds", "save_schema",
	]:
		var setting_record := record("grid", required_setting)
		if setting_record.is_empty() or number(setting_record, "value") <= 0:
			errors.append("grid setting %s must be positive" % required_setting)
	var occupied: Dictionary = {}
	for grid_record in grid_rows():
		var identifier := text(grid_record, "id")
		var width := number(grid_record, "footprint_w")
		var height := number(grid_record, "footprint_h")
		if width <= 0 or height <= 0:
			errors.append("grid:%s has invalid footprint" % identifier)
		if not RUNTIME_ASSET_PATHS.has(text(grid_record, "asset_id")):
			errors.append("grid:%s references unapproved asset %s" % [identifier, text(grid_record, "asset_id")])
		for cell_x in range(number(grid_record, "grid_x"), number(grid_record, "grid_x") + width):
			for cell_y in range(number(grid_record, "grid_y"), number(grid_record, "grid_y") + height):
				var cell_key := "%d,%d" % [cell_x, cell_y]
				if occupied.has(cell_key):
					errors.append("grid overlap %s between %s and %s" % [cell_key, occupied[cell_key], identifier])
				occupied[cell_key] = identifier
	for resident in rows("resident_types"):
		_require("grid", text(resident, "home_id"), "resident home")
		_require("jobs", text(resident, "default_job_id"), "resident default job")
		if decimal(resident, "speed_cells_per_second") <= 0.0 or number(resident, "invite_cost") < 0:
			errors.append("resident:%s has invalid speed or invite cost" % text(resident, "id"))
		if not FileAccess.file_exists(text(resident, "asset_path")):
			errors.append("resident:%s asset does not exist" % text(resident, "id"))
	for job in rows("jobs"):
		_require("workplaces", text(job, "workplace_id"), "job workplace")
		if decimal(job, "work_seconds") <= 0.0 or number(job, "output_count") <= 0:
			errors.append("job:%s has invalid timing/output" % text(job, "id"))
		var next_job := text(job, "next_job_id")
		if not next_job.is_empty():
			_require("jobs", next_job, "job next")
		var carry_target := text(job, "carry_target_id")
		if not carry_target.is_empty():
			_require("workplaces", carry_target, "job carry target")
	for workplace in rows("workplaces"):
		_require("grid", text(workplace, "grid_id"), "workplace grid")
		if number(workplace, "queue_capacity") < 1 or number(workplace, "output_capacity") < 1:
			errors.append("workplace:%s has invalid capacity" % text(workplace, "id"))
	for order in rows("vehicle_orders"):
		if number(order, "required_count") <= 0 or number(order, "reward_coins") <= 0:
			errors.append("order:%s has invalid requirement/reward" % text(order, "id"))
		if decimal(order, "load_seconds") <= 0.0 or decimal(order, "hard_timeout_seconds") != 0.0:
			errors.append("order:%s must load positively and have no hard timeout" % text(order, "id"))
	for route_state in ["arriving", "waiting", "departing"]:
		if route_for_state(route_state).is_empty():
			errors.append("vehicle route missing state %s" % route_state)
	for asset_path_variant in RUNTIME_ASSET_PATHS.values():
		if not FileAccess.file_exists(str(asset_path_variant)):
			errors.append("approved runtime asset does not exist: %s" % str(asset_path_variant))


func _require(table_name: String, identifier: String, context: String) -> void:
	if identifier.is_empty() or not _indexes.get(table_name, {}).has(identifier):
		errors.append("%s references missing %s:%s" % [context, table_name, identifier])


func is_valid() -> bool:
	return errors.is_empty()


func rows(table_name: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for record_variant in _tables.get(table_name, []):
		result.append(record_variant as Dictionary)
	return result


func grid_rows() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for row in rows("grid"):
		if text(row, "kind") != "setting":
			result.append(row)
	return result


func road_rows() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for row in grid_rows():
		if text(row, "kind") == "road":
			result.append(row)
	return result


func record(table_name: String, identifier: String) -> Dictionary:
	return _indexes.get(table_name, {}).get(identifier, {})


func text(record_value: Dictionary, field: String) -> String:
	return str(record_value.get(field, ""))


func number(record_value: Dictionary, field: String) -> int:
	return text(record_value, field).to_int()


func decimal(record_value: Dictionary, field: String) -> float:
	return text(record_value, field).to_float()


func boolean(record_value: Dictionary, field: String) -> bool:
	return text(record_value, field).to_lower() in ["true", "1", "yes"]


func setting_int(identifier: String) -> int:
	return number(record("grid", identifier), "value")


func entry_cell(grid_id: String) -> Vector2i:
	var row := record("grid", grid_id)
	return Vector2i(number(row, "entry_x"), number(row, "entry_y"))


func work_cell(workplace_id: String) -> Vector2i:
	var row := record("workplaces", workplace_id)
	return Vector2i(number(row, "work_x"), number(row, "work_y"))


func route_for_state(state: String) -> Dictionary:
	for route in rows("vehicle_routes"):
		if text(route, "state") == state:
			return route
	return {}


func runtime_asset_path(asset_id: String) -> String:
	return str(RUNTIME_ASSET_PATHS.get(asset_id, ""))
