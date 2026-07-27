extends RefCounted

const DEFAULT_SAVE_PATH := "user://city_of_animals_f004_resident2.json"

var save_path := DEFAULT_SAVE_PATH


func _init(path_override: String = "") -> void:
	if not path_override.is_empty():
		save_path = path_override


func save_model(model) -> int:
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(JSON.stringify(model.to_save_data(), "\t") + "\n")
	file.close()
	return OK


func load_into(model) -> Dictionary:
	if not FileAccess.file_exists(save_path):
		return {"loaded": false, "migrated": false}
	var file := FileAccess.open(save_path, FileAccess.READ)
	if file == null:
		return {"loaded": false, "migrated": false, "error": FileAccess.get_open_error()}
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()
	if not (parsed is Dictionary):
		return {"loaded": false, "migrated": false, "error": ERR_PARSE_ERROR}
	var result: Dictionary = model.apply_save_data(parsed)
	result["loaded"] = true
	return result


func remove() -> void:
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
