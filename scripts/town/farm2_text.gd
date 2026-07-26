extends RefCounted

const LOCALE_PATH := "res://config/tables/f003_v2_locale.csv"
const PREFERENCE_PATH := "user://city_of_animals_preferences.cfg"
const DEFAULT_LOCALE := "zh-CN"
const SUPPORTED_LOCALES := ["zh-CN", "en"]

var locale := DEFAULT_LOCALE
var reduced_motion := false
var entries: Dictionary = {}
var errors: Array[String] = []


func _init(locale_override: String = "") -> void:
	_load_catalog()
	var preferences := read_preferences()
	locale = _normalise_locale(locale_override if not locale_override.is_empty() else str(preferences.get("language_code", DEFAULT_LOCALE)))
	reduced_motion = bool(preferences.get("reduced_motion", false))


func _load_catalog() -> void:
	entries.clear()
	errors.clear()
	var file := FileAccess.open(LOCALE_PATH, FileAccess.READ)
	if file == null:
		errors.append("Could not open locale catalog: %s" % LOCALE_PATH)
		return
	var header := file.get_csv_line()
	if header != PackedStringArray(["key", "zh-CN", "en"]):
		errors.append("Locale catalog header is invalid.")
		return
	var line_number := 1
	while not file.eof_reached():
		line_number += 1
		var row := file.get_csv_line()
		if row.is_empty() or (row.size() == 1 and row[0].strip_edges().is_empty()):
			continue
		if row.size() != header.size() or row[0].strip_edges().is_empty():
			errors.append("Locale catalog malformed row %d." % line_number)
			continue
		if entries.has(row[0]):
			errors.append("Locale catalog duplicate key: %s" % row[0])
			continue
		entries[row[0]] = {"zh-CN": row[1], "en": row[2]}


func is_valid() -> bool:
	return errors.is_empty()


func set_locale(next_locale: String, persist: bool = true) -> int:
	locale = _normalise_locale(next_locale)
	return persist_preferences() if persist else OK


func set_reduced_motion(enabled: bool, persist: bool = true) -> int:
	reduced_motion = enabled
	return persist_preferences() if persist else OK


func text(key: String, args: Array = []) -> String:
	var row: Dictionary = entries.get(key, {})
	var value := str(row.get(locale, row.get(DEFAULT_LOCALE, key)))
	for index in range(args.size()):
		value = value.replace("{%d}" % index, str(args[index]))
	return value


func persist_preferences() -> int:
	var preferences := ConfigFile.new()
	preferences.set_value("settings", "language_code", locale)
	preferences.set_value("settings", "reduced_motion", reduced_motion)
	return preferences.save(PREFERENCE_PATH)


static func read_preferences() -> Dictionary:
	var result := {"language_code": DEFAULT_LOCALE, "reduced_motion": false}
	var preferences := ConfigFile.new()
	if preferences.load(PREFERENCE_PATH) != OK:
		return result
	result["language_code"] = _normalise_locale(str(preferences.get_value("settings", "language_code", DEFAULT_LOCALE)))
	result["reduced_motion"] = bool(preferences.get_value("settings", "reduced_motion", false))
	return result


static func _normalise_locale(candidate: String) -> String:
	return candidate if SUPPORTED_LOCALES.has(candidate) else DEFAULT_LOCALE
