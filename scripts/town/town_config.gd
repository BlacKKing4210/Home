extends RefCounted

const CSV_PATHS := [
	"res://config/tables/f001_market_meadow.csv",
	"res://config/tables/f003_farm_content.csv"
]
const REQUIRED_COLUMNS := [
	"kind", "id", "display_name", "emoji", "seconds", "input_item", "input_count",
	"output_item", "output_count", "initial_value", "reward_coins", "reward_renown",
	"unlock_cost", "capacity"
]

var rows: Array[Dictionary] = []
var errors: Array[String] = []
var _by_id: Dictionary = {}


static func load_default():
	var config = preload("res://scripts/town/town_config.gd").new()
	config._load_csvs(CSV_PATHS)
	return config


func _load_csv(path: String) -> void:
	_load_csvs([path])


func _load_csvs(paths: Array) -> void:
	rows.clear()
	errors.clear()
	_by_id.clear()
	for path in paths:
		_append_csv(str(path))
	if errors.is_empty():
		_validate_required_records()


func _append_csv(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		errors.append("Could not open town configuration: %s" % path)
		return
	var header: PackedStringArray = file.get_csv_line()
	if header.size() != REQUIRED_COLUMNS.size():
		errors.append("Expected %d configuration columns, found %d." % [REQUIRED_COLUMNS.size(), header.size()])
		return
	for required_column in REQUIRED_COLUMNS:
		if not header.has(required_column):
			errors.append("Missing configuration column: %s" % required_column)
	if not errors.is_empty():
		return
	while not file.eof_reached():
		var csv_row: PackedStringArray = file.get_csv_line()
		if csv_row.is_empty() or (csv_row.size() == 1 and csv_row[0].strip_edges().is_empty()):
			continue
		if csv_row.size() != header.size():
			errors.append("Malformed configuration row with %d columns." % csv_row.size())
			continue
		var record: Dictionary = {}
		for index in range(header.size()):
			record[header[index]] = csv_row[index]
		var identifier := text(record, "id")
		if identifier.is_empty():
			errors.append("Configuration row has no id.")
			continue
		if _by_id.has(identifier):
			errors.append("Duplicate configuration id: %s" % identifier)
			continue
		rows.append(record)
		_by_id[identifier] = record


func _validate_required_records() -> void:
	for identifier in ["sunseed", "crumbworks", "willow_pen", "threadmill", "market_cart", "fleece_bundle", "yarn_crate", "plot_four", "grainleaf", "meadow_loaf", "soft_fleece", "yarn_roll", "initial_open_plots", "initial_locked_plots", "initial_coins", "initial_renown"]:
		if not _by_id.has(identifier):
			errors.append("Missing required configuration id: %s" % identifier)


func is_valid() -> bool:
	return errors.is_empty()


func record_by_id(identifier: String) -> Dictionary:
	return _by_id.get(identifier, {})


func records_of_kind(kind_name: String) -> Array[Dictionary]:
	var matches: Array[Dictionary] = []
	for record in rows:
		if text(record, "kind") == kind_name:
			matches.append(record)
	return matches


func first_of_kind(kind_name: String) -> Dictionary:
	var matches := records_of_kind(kind_name)
	return matches[0] if not matches.is_empty() else {}


func text(record: Dictionary, field: String) -> String:
	return str(record.get(field, ""))


func number(record: Dictionary, field: String) -> int:
	return text(record, field).to_int()


func number_by_id(identifier: String, field: String) -> int:
	return number(record_by_id(identifier), field)
