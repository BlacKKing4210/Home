extends RefCounted

const CSV_PATHS := [
	"res://config/tables/f002_town_ui.csv",
	"res://config/tables/f003_town_ui.csv"
]
const PREFERENCE_PATH := "user://city_of_animals_settings.cfg"
const DEFAULT_LOCALE := "zh-CN"
const SUPPORTED_LOCALES := ["zh-CN", "en"]

var locale := DEFAULT_LOCALE
var entries: Dictionary = {}
var errors: Array[String] = []


func _init(locale_override: String = "") -> void:
	_load_catalog()
	locale = _normalise_locale(locale_override if not locale_override.is_empty() else read_preferred_locale())


func _load_catalog() -> void:
	entries.clear()
	errors.clear()
	for path in CSV_PATHS:
		_append_catalog(str(path))


func _append_catalog(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		errors.append("Could not open town language catalog: %s" % path)
		return
	var header := file.get_csv_line()
	if header != PackedStringArray(["key", "zh-CN", "en"]):
		errors.append("Town language catalog header is invalid: %s" % path)
		return
	while not file.eof_reached():
		var row := file.get_csv_line()
		if row.is_empty() or (row.size() == 1 and row[0].strip_edges().is_empty()):
			continue
		if row.size() != header.size() or row[0].strip_edges().is_empty():
			errors.append("Town language catalog contains a malformed row: %s" % path)
			continue
		if entries.has(row[0]):
			errors.append("Town language catalog contains a duplicate key: %s" % row[0])
			continue
		entries[row[0]] = {"zh-CN": row[1], "en": row[2]}


func is_valid() -> bool:
	return errors.is_empty()


func set_locale(next_locale: String) -> void:
	locale = _normalise_locale(next_locale)


func text(key: String, args: Array = []) -> String:
	var row: Dictionary = entries.get(key, {})
	var value := str(row.get(locale, row.get(DEFAULT_LOCALE, key)))
	for index in range(args.size()):
		value = value.replace("{%d}" % index, str(args[index]))
	return value


static func read_preferred_locale() -> String:
	var preferences := ConfigFile.new()
	if preferences.load(PREFERENCE_PATH) != OK:
		return DEFAULT_LOCALE
	return _normalise_locale(str(preferences.get_value("settings", "locale", DEFAULT_LOCALE)))


static func persist_locale(next_locale: String) -> int:
	var preferences := ConfigFile.new()
	preferences.load(PREFERENCE_PATH)
	preferences.set_value("settings", "locale", _normalise_locale(next_locale))
	return preferences.save(PREFERENCE_PATH)


static func _normalise_locale(candidate: String) -> String:
	return candidate if SUPPORTED_LOCALES.has(candidate) else DEFAULT_LOCALE
