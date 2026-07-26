extends RefCounted

const TABLE_PATHS := {
	"items": "res://config/tables/f003_v2_items.csv",
	"crops": "res://config/tables/f003_v2_crops.csv",
	"storage": "res://config/tables/f003_v2_storage.csv",
	"recipes": "res://config/tables/f003_v2_recipes.csv",
	"animals": "res://config/tables/f003_v2_animals.csv",
	"buildings": "res://config/tables/f003_v2_buildings.csv",
	"requests": "res://config/tables/f003_v2_requests.csv",
	"world": "res://config/tables/f003_v2_world.csv",
}

const REQUIRED_COLUMNS := {
	"items": ["id", "category", "storage_type", "initial_amount", "market_coin_value", "seed_reserve", "icon_key"],
	"crops": ["id", "seed_item_id", "harvest_item_id", "grow_seconds", "plant_cost", "harvest_yield", "unlock_level", "asset_id"],
	"storage": ["id", "storage_type", "base_capacity", "capacity_per_level", "initial_level", "upgrade_costs"],
	"recipes": ["id", "machine_id", "input_items", "output_item_id", "output_count", "duration_seconds", "queue_slot"],
	"animals": ["id", "pen_id", "feed_item_id", "feed_cost", "output_item_id", "output_count", "duration_seconds", "animal_count", "asset_id"],
	"buildings": ["id", "kind", "world_x", "world_y", "footprint_w", "footprint_h", "asset_id", "unlock_level", "machine_slots", "interactive"],
	"requests": ["id", "slot", "requirements", "reward_coins", "reward_renown", "refresh_seconds", "seed_salt"],
	"world": ["key", "value"],
}

var errors: Array[String] = []
var _tables: Dictionary = {}
var _indexes: Dictionary = {}


static func load_default():
	var database = preload("res://scripts/town/farm2_config.gd").new()
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
		_validate_references()


func _load_table(table_name: String, path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		errors.append("%s: could not open %s" % [table_name, path])
		return
	var header := file.get_csv_line()
	var required: Array = REQUIRED_COLUMNS.get(table_name, [])
	for column_variant in required:
		var column := str(column_variant)
		if not header.has(column):
			errors.append("%s: missing required column %s" % [table_name, column])
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
		var identifier_field := "key" if table_name == "world" else "id"
		var identifier := str(record_value.get(identifier_field, ""))
		if identifier.is_empty():
			errors.append("%s:%d has no %s" % [path, line_number, identifier_field])
			continue
		if index.has(identifier):
			errors.append("%s:%d duplicate %s %s" % [path, line_number, identifier_field, identifier])
			continue
		loaded_rows.append(record_value)
		index[identifier] = record_value
	_tables[table_name] = loaded_rows
	_indexes[table_name] = index


func _validate_references() -> void:
	for item in rows("items"):
		if not ["granary", "storehouse"].has(text(item, "storage_type")):
			errors.append("items:%s has invalid storage_type" % text(item, "id"))
		if number(item, "initial_amount") < 0 or number(item, "seed_reserve") < 0:
			errors.append("items:%s has an unsafe negative value" % text(item, "id"))
	for crop in rows("crops"):
		_require_record("items", text(crop, "seed_item_id"), "crops:%s seed" % text(crop, "id"))
		_require_record("items", text(crop, "harvest_item_id"), "crops:%s harvest" % text(crop, "id"))
		if decimal(crop, "grow_seconds") <= 0.0 or number(crop, "plant_cost") <= 0 or number(crop, "harvest_yield") <= number(crop, "plant_cost"):
			errors.append("crops:%s violates positive net-yield rules" % text(crop, "id"))
	for recipe in rows("recipes"):
		_require_record("buildings", text(recipe, "machine_id"), "recipes:%s machine" % text(recipe, "id"))
		_validate_item_pairs(text(recipe, "input_items"), "recipes:%s inputs" % text(recipe, "id"))
		_require_record("items", text(recipe, "output_item_id"), "recipes:%s output" % text(recipe, "id"))
		if number(recipe, "queue_slot") < 1:
			errors.append("recipes:%s has no queue slot" % text(recipe, "id"))
	for animal in rows("animals"):
		_require_record("buildings", text(animal, "pen_id"), "animals:%s pen" % text(animal, "id"))
		_require_record("items", text(animal, "feed_item_id"), "animals:%s feed" % text(animal, "id"))
		_require_record("items", text(animal, "output_item_id"), "animals:%s output" % text(animal, "id"))
	for request in rows("requests"):
		_validate_item_pairs(text(request, "requirements"), "requests:%s requirements" % text(request, "id"))
	for storage in rows("storage"):
		if number(storage, "base_capacity") <= 0 or number(storage, "capacity_per_level") < 0:
			errors.append("storage:%s has invalid capacity" % text(storage, "id"))
	for required_world_key in [
		"world_width", "world_height", "camera_pan_threshold_px", "camera_max_x", "camera_max_y",
		"starter_field_count", "initial_coins", "initial_renown", "request_slot_count",
		"autosave_interval_seconds", "save_schema",
	]:
		_require_record("world", required_world_key, "world")


func _validate_item_pairs(value: String, context: String) -> void:
	var pairs := parse_pairs(value)
	if pairs.is_empty():
		errors.append("%s is empty" % context)
		return
	for item_id_variant in pairs.keys():
		var item_id := str(item_id_variant)
		_require_record("items", item_id, context)
		if int(pairs[item_id]) <= 0:
			errors.append("%s has invalid count for %s" % [context, item_id])


func _require_record(table_name: String, identifier: String, context: String) -> void:
	if identifier.is_empty() or not _indexes.get(table_name, {}).has(identifier):
		errors.append("%s references missing %s:%s" % [context, table_name, identifier])


func is_valid() -> bool:
	return errors.is_empty()


func rows(table_name: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for record_variant in _tables.get(table_name, []):
		result.append(record_variant as Dictionary)
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


func world_int(key: String) -> int:
	return number(record("world", key), "value")


func parse_pairs(value: String) -> Dictionary:
	var result: Dictionary = {}
	for pair in value.split(";", false):
		var pieces := pair.split(":", false, 1)
		if pieces.size() != 2:
			continue
		var identifier := str(pieces[0]).strip_edges()
		var count := str(pieces[1]).strip_edges().to_int()
		if not identifier.is_empty():
			result[identifier] = count
	return result
