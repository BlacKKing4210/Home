extends RefCounted

signal changed

const SAVE_SCHEMA := 2

var config
var plots: Array[Dictionary] = []
var inventory: Dictionary = {}
var storage_levels := {"granary": 1, "storehouse": 1}
var animals: Dictionary = {}
var machines: Dictionary = {}
var requests: Dictionary = {}
var coins := 0
var renown := 0
var elapsed_seconds := 0.0
var feedback_key := "town_name"
var feedback_args: Array = []


func _init(town_config) -> void:
	config = town_config
	_reset_to_defaults()


func _reset_to_defaults() -> void:
	plots.clear()
	inventory.clear()
	animals.clear()
	machines.clear()
	requests.clear()
	storage_levels = {"granary": 1, "storehouse": 1}
	for item in config.rows("items"):
		inventory[config.text(item, "id")] = max(config.number(item, "initial_amount"), 0)
	for ignored_index in range(config.world_int("starter_field_count")):
		plots.append({"state": "empty", "crop_id": "", "remaining": 0.0})
	for animal in config.rows("animals"):
		animals[config.text(animal, "id")] = {"state": "hungry", "remaining": 0.0}
	for recipe in config.rows("recipes"):
		var machine_id: String = config.text(recipe, "machine_id")
		if not machines.has(machine_id):
			machines[machine_id] = _new_machine_state()
	for request in config.rows("requests"):
		requests[config.text(request, "id")] = {"active": true, "refresh_remaining": 0.0}
	coins = config.world_int("initial_coins")
	renown = config.world_int("initial_renown")
	elapsed_seconds = 0.0
	set_feedback("town_name")


func _new_machine_state() -> Dictionary:
	return {
		"queue": [],
		"active_recipe": "",
		"remaining": 0.0,
		"output_item": "",
		"output_count": 0,
	}


func tick(delta: float) -> bool:
	if delta <= 0.0:
		return false
	elapsed_seconds += delta
	var transitioned := false
	for index in range(plots.size()):
		var plot: Dictionary = plots[index]
		if str(plot.get("state", "")) != "growing":
			continue
		plot["remaining"] = max(float(plot.get("remaining", 0.0)) - delta, 0.0)
		if float(plot["remaining"]) <= 0.0:
			plot["state"] = "ready"
			transitioned = true
		plots[index] = plot
	for animal_id_variant in animals.keys():
		var animal_id: String = str(animal_id_variant)
		var state: Dictionary = animals[animal_id]
		if str(state.get("state", "")) != "producing":
			continue
		state["remaining"] = max(float(state.get("remaining", 0.0)) - delta, 0.0)
		if float(state["remaining"]) <= 0.0:
			state["state"] = "ready"
			transitioned = true
		animals[animal_id] = state
	for machine_id_variant in machines.keys():
		if _tick_machine(str(machine_id_variant), delta):
			transitioned = true
	for request_id_variant in requests.keys():
		var request_id: String = str(request_id_variant)
		var request_state: Dictionary = requests[request_id]
		if bool(request_state.get("active", true)):
			continue
		request_state["refresh_remaining"] = max(float(request_state.get("refresh_remaining", 0.0)) - delta, 0.0)
		if float(request_state["refresh_remaining"]) <= 0.0:
			request_state["active"] = true
			transitioned = true
		requests[request_id] = request_state
	if transitioned:
		emit_signal("changed")
	return transitioned


func _tick_machine(machine_id: String, delta: float) -> bool:
	var state: Dictionary = machines.get(machine_id, _new_machine_state())
	var transitioned := false
	if not str(state.get("active_recipe", "")).is_empty():
		state["remaining"] = max(float(state.get("remaining", 0.0)) - delta, 0.0)
		if float(state["remaining"]) <= 0.0:
			var recipe: Dictionary = config.record("recipes", str(state["active_recipe"]))
			state["output_item"] = config.text(recipe, "output_item_id")
			state["output_count"] = config.number(recipe, "output_count")
			state["active_recipe"] = ""
			state["remaining"] = 0.0
			transitioned = true
	machines[machine_id] = state
	return transitioned


func plant_plot(index: int, crop_id: String) -> bool:
	if index < 0 or index >= plots.size():
		return _fail("feedback_missing_seed")
	var crop: Dictionary = config.record("crops", crop_id)
	if crop.is_empty() or str(plots[index].get("state", "")) != "empty":
		return _fail("feedback_missing_seed")
	var seed_id: String = config.text(crop, "seed_item_id")
	var cost: int = config.number(crop, "plant_cost")
	if amount_of(seed_id) < cost:
		return _fail("feedback_missing_seed")
	add_amount(seed_id, -cost)
	plots[index] = {
		"state": "growing",
		"crop_id": crop_id,
		"remaining": config.decimal(crop, "grow_seconds"),
	}
	set_feedback("feedback_planted", [crop_id, int(ceil(config.decimal(crop, "grow_seconds")))])
	_emit_changed()
	return true


func harvest_plot(index: int) -> bool:
	if index < 0 or index >= plots.size():
		return _fail("feedback_granary_full")
	var plot: Dictionary = plots[index]
	if str(plot.get("state", "")) != "ready":
		return false
	var crop: Dictionary = config.record("crops", str(plot.get("crop_id", "")))
	var item_id: String = config.text(crop, "harvest_item_id")
	var yield_count: int = config.number(crop, "harvest_yield")
	if not can_add(item_id, yield_count):
		return _fail("feedback_granary_full")
	add_amount(item_id, yield_count)
	plots[index] = {"state": "empty", "crop_id": "", "remaining": 0.0}
	set_feedback("feedback_harvested", [yield_count, item_id])
	_emit_changed()
	return true


func interact_plot(index: int, preferred_crop_id: String = "golden_sprig") -> bool:
	if index < 0 or index >= plots.size():
		return false
	match str(plots[index].get("state", "")):
		"empty":
			return plant_plot(index, preferred_crop_id)
		"ready":
			return harvest_plot(index)
	return false


func feed_animal(animal_id: String) -> bool:
	var animal: Dictionary = config.record("animals", animal_id)
	var state: Dictionary = animals.get(animal_id, {})
	if animal.is_empty() or str(state.get("state", "")) != "hungry":
		return false
	var feed_item: String = config.text(animal, "feed_item_id")
	var feed_cost: int = config.number(animal, "feed_cost")
	if amount_of(feed_item) < feed_cost:
		return _fail("feedback_missing_items")
	add_amount(feed_item, -feed_cost)
	state["state"] = "producing"
	state["remaining"] = config.decimal(animal, "duration_seconds")
	animals[animal_id] = state
	set_feedback("feedback_animal_started", [int(ceil(float(state["remaining"])))])
	_emit_changed()
	return true


func collect_animal(animal_id: String) -> bool:
	var animal: Dictionary = config.record("animals", animal_id)
	var state: Dictionary = animals.get(animal_id, {})
	if animal.is_empty() or str(state.get("state", "")) != "ready":
		return false
	var item_id: String = config.text(animal, "output_item_id")
	var output_count: int = config.number(animal, "output_count")
	if not can_add(item_id, output_count):
		return _fail("feedback_storehouse_full")
	add_amount(item_id, output_count)
	state["state"] = "hungry"
	state["remaining"] = 0.0
	animals[animal_id] = state
	set_feedback("feedback_collected", [item_id])
	_emit_changed()
	return true


func interact_animal(animal_id: String) -> bool:
	match animal_state(animal_id):
		"hungry":
			return feed_animal(animal_id)
		"ready":
			return collect_animal(animal_id)
	return false


func animal_state(animal_id: String) -> String:
	return str(animals.get(animal_id, {}).get("state", "invalid"))


func queue_recipe(recipe_id: String) -> bool:
	var recipe: Dictionary = config.record("recipes", recipe_id)
	if recipe.is_empty():
		return _fail("feedback_missing_items")
	var machine_id: String = config.text(recipe, "machine_id")
	var state: Dictionary = machines.get(machine_id, _new_machine_state())
	var queue: Array = state.get("queue", [])
	var queue_limit: int = config.number(recipe, "queue_slot")
	var occupied: int = queue.size() + (0 if str(state.get("active_recipe", "")).is_empty() else 1)
	if occupied >= queue_limit:
		return _fail("feedback_queue_full")
	var inputs: Dictionary = config.parse_pairs(config.text(recipe, "input_items"))
	if not has_items(inputs):
		return _fail("feedback_missing_items")
	remove_items(inputs)
	queue.append(recipe_id)
	state["queue"] = queue
	machines[machine_id] = state
	_start_next_machine_item(machine_id)
	set_feedback("feedback_machine_queued")
	_emit_changed()
	return true


func _start_next_machine_item(machine_id: String) -> bool:
	var state: Dictionary = machines.get(machine_id, _new_machine_state())
	if not str(state.get("active_recipe", "")).is_empty() or not str(state.get("output_item", "")).is_empty():
		return false
	var queue: Array = state.get("queue", [])
	if queue.is_empty():
		return false
	var recipe_id: String = str(queue.pop_front())
	var recipe: Dictionary = config.record("recipes", recipe_id)
	state["queue"] = queue
	state["active_recipe"] = recipe_id
	state["remaining"] = config.decimal(recipe, "duration_seconds")
	machines[machine_id] = state
	return true


func collect_machine(machine_id: String) -> bool:
	var state: Dictionary = machines.get(machine_id, _new_machine_state())
	var item_id: String = str(state.get("output_item", ""))
	var output_count: int = int(state.get("output_count", 0))
	if item_id.is_empty() or output_count <= 0:
		return false
	if not can_add(item_id, output_count):
		return _fail("feedback_storehouse_full")
	add_amount(item_id, output_count)
	state["output_item"] = ""
	state["output_count"] = 0
	machines[machine_id] = state
	_start_next_machine_item(machine_id)
	set_feedback("feedback_collected", [item_id])
	_emit_changed()
	return true


func machine_state(machine_id: String) -> String:
	var state: Dictionary = machines.get(machine_id, {})
	if state.is_empty():
		return "invalid"
	if not str(state.get("output_item", "")).is_empty():
		return "output_ready"
	if not str(state.get("active_recipe", "")).is_empty():
		return "processing"
	if not (state.get("queue", []) as Array).is_empty():
		return "queued"
	return "idle"


func machine_remaining(machine_id: String) -> float:
	return float(machines.get(machine_id, {}).get("remaining", 0.0))


func fulfill_request(request_id: String) -> bool:
	var request: Dictionary = config.record("requests", request_id)
	var state: Dictionary = requests.get(request_id, {})
	if request.is_empty() or not bool(state.get("active", true)):
		return false
	var requirements: Dictionary = config.parse_pairs(config.text(request, "requirements"))
	if not has_items(requirements):
		return _fail("feedback_request_missing")
	remove_items(requirements)
	coins += config.number(request, "reward_coins")
	renown += config.number(request, "reward_renown")
	state["active"] = false
	state["refresh_remaining"] = config.decimal(request, "refresh_seconds")
	requests[request_id] = state
	set_feedback("feedback_request_complete", [config.number(request, "reward_coins"), config.number(request, "reward_renown")])
	_emit_changed()
	return true


func discard_request(request_id: String) -> bool:
	var request: Dictionary = config.record("requests", request_id)
	var state: Dictionary = requests.get(request_id, {})
	if request.is_empty() or not bool(state.get("active", true)):
		return false
	state["active"] = false
	state["refresh_remaining"] = config.decimal(request, "refresh_seconds")
	requests[request_id] = state
	_emit_changed()
	return true


func market_sell(item_id: String, count: int = 1) -> bool:
	var item: Dictionary = config.record("items", item_id)
	if item.is_empty() or count <= 0 or amount_of(item_id) < count:
		return false
	var reserve: int = config.number(item, "seed_reserve")
	if amount_of(item_id) - count < reserve:
		return _fail("feedback_market_reserve")
	add_amount(item_id, -count)
	var reward: int = config.number(item, "market_coin_value") * count
	coins += reward
	set_feedback("feedback_market_sold", [count, item_id, reward])
	_emit_changed()
	return true


func has_items(requirements: Dictionary) -> bool:
	for item_id_variant in requirements.keys():
		var item_id := str(item_id_variant)
		if amount_of(item_id) < int(requirements[item_id]):
			return false
	return true


func remove_items(requirements: Dictionary) -> void:
	for item_id_variant in requirements.keys():
		var item_id := str(item_id_variant)
		add_amount(item_id, -int(requirements[item_id]))


func amount_of(item_id: String) -> int:
	return int(inventory.get(item_id, 0))


func add_amount(item_id: String, delta: int) -> void:
	inventory[item_id] = max(amount_of(item_id) + delta, 0)


func storage_used(storage_type: String) -> int:
	var total := 0
	for item in config.rows("items"):
		if config.text(item, "storage_type") == storage_type:
			total += amount_of(config.text(item, "id"))
	return total


func storage_capacity(storage_type: String) -> int:
	var storage: Dictionary = config.record("storage", storage_type)
	var level: int = int(storage_levels.get(storage_type, config.number(storage, "initial_level")))
	return config.number(storage, "base_capacity") + (level - 1) * config.number(storage, "capacity_per_level")


func can_add(item_id: String, count: int) -> bool:
	var item: Dictionary = config.record("items", item_id)
	if item.is_empty() or count < 0:
		return false
	var storage_type: String = config.text(item, "storage_type")
	return storage_used(storage_type) + count <= storage_capacity(storage_type)


func has_meaningful_action() -> bool:
	for plot in plots:
		var state: String = str(plot.get("state", ""))
		if state == "ready":
			var crop: Dictionary = config.record("crops", str(plot.get("crop_id", "")))
			if can_add(config.text(crop, "harvest_item_id"), config.number(crop, "harvest_yield")):
				return true
		if state == "empty":
			for crop in config.rows("crops"):
				if amount_of(config.text(crop, "seed_item_id")) >= config.number(crop, "plant_cost"):
					return true
	for animal_id_variant in animals.keys():
		var animal_id: String = str(animal_id_variant)
		var animal: Dictionary = config.record("animals", animal_id)
		if animal_state(animal_id) == "ready" and can_add(config.text(animal, "output_item_id"), config.number(animal, "output_count")):
			return true
		if animal_state(animal_id) == "hungry" and amount_of(config.text(animal, "feed_item_id")) >= config.number(animal, "feed_cost"):
			return true
	for machine_id_variant in machines.keys():
		var machine_id: String = str(machine_id_variant)
		if machine_state(machine_id) == "output_ready":
			var state: Dictionary = machines[machine_id]
			if can_add(str(state["output_item"]), int(state["output_count"])):
				return true
	for request in config.rows("requests"):
		var request_id: String = config.text(request, "id")
		if bool(requests.get(request_id, {}).get("active", true)) and has_items(config.parse_pairs(config.text(request, "requirements"))):
			return true
	for item in config.rows("items"):
		var item_id: String = config.text(item, "id")
		if amount_of(item_id) > config.number(item, "seed_reserve"):
			return true
	return false


func to_save_data() -> Dictionary:
	return {
		"schema": SAVE_SCHEMA,
		"saved_unix": int(Time.get_unix_time_from_system()),
		"coins": coins,
		"renown": renown,
		"elapsed_seconds": elapsed_seconds,
		"inventory": inventory.duplicate(true),
		"storage_levels": storage_levels.duplicate(true),
		"plots": plots.duplicate(true),
		"animals": animals.duplicate(true),
		"machines": machines.duplicate(true),
		"requests": requests.duplicate(true),
	}


func apply_save_data(data: Dictionary) -> Dictionary:
	var migrated: bool = int(data.get("schema", 0)) < SAVE_SCHEMA
	if migrated:
		_apply_legacy_save(data)
	else:
		coins = max(int(data.get("coins", coins)), 0)
		renown = max(int(data.get("renown", renown)), 0)
		elapsed_seconds = max(float(data.get("elapsed_seconds", 0.0)), 0.0)
		_merge_nonnegative_inventory(data.get("inventory", {}))
		_merge_storage_levels(data.get("storage_levels", {}))
		plots = _sanitise_state_array(data.get("plots", plots), plots)
		animals = _sanitise_state_dictionary(data.get("animals", animals), animals)
		machines = _sanitise_state_dictionary(data.get("machines", machines), machines)
		requests = _sanitise_state_dictionary(data.get("requests", requests), requests)
	var saved_unix: int = int(data.get("saved_unix", Time.get_unix_time_from_system()))
	var offline_seconds: int = clampi(int(Time.get_unix_time_from_system()) - saved_unix, 0, 86400)
	if offline_seconds > 0:
		tick(float(offline_seconds))
	_ensure_seed_floor()
	_emit_changed()
	return {"migrated": migrated, "offline_seconds": offline_seconds}


func _apply_legacy_save(data: Dictionary) -> void:
	_reset_to_defaults()
	coins = max(int(data.get("coins", coins)), 0)
	renown = max(int(data.get("renown", renown)), 0)
	_merge_nonnegative_inventory(data.get("inventory", {}))
	set_feedback("feedback_migrated")


func _merge_nonnegative_inventory(source_variant) -> void:
	if not (source_variant is Dictionary):
		return
	var source: Dictionary = source_variant
	for item_id_variant in inventory.keys():
		var item_id := str(item_id_variant)
		if source.has(item_id):
			inventory[item_id] = max(int(source[item_id]), 0)


func _merge_storage_levels(source_variant) -> void:
	if not (source_variant is Dictionary):
		return
	var source: Dictionary = source_variant
	for storage_id_variant in storage_levels.keys():
		var storage_id := str(storage_id_variant)
		if source.has(storage_id):
			storage_levels[storage_id] = max(int(source[storage_id]), 1)


func _sanitise_state_array(source_variant, fallback: Array[Dictionary]) -> Array[Dictionary]:
	if not (source_variant is Array) or source_variant.size() != fallback.size():
		return fallback
	var result: Array[Dictionary] = []
	for value in source_variant:
		if value is Dictionary:
			result.append((value as Dictionary).duplicate(true))
		else:
			return fallback
	return result


func _sanitise_state_dictionary(source_variant, fallback: Dictionary) -> Dictionary:
	if not (source_variant is Dictionary):
		return fallback
	var result: Dictionary = fallback.duplicate(true)
	var source: Dictionary = source_variant
	for key_variant in result.keys():
		if source.get(key_variant) is Dictionary:
			result[key_variant] = (source[key_variant] as Dictionary).duplicate(true)
	return result


func _ensure_seed_floor() -> void:
	for crop in config.rows("crops"):
		var seed_id: String = config.text(crop, "seed_item_id")
		var item: Dictionary = config.record("items", seed_id)
		var minimum: int = max(config.number(item, "seed_reserve"), config.number(crop, "plant_cost"))
		if amount_of(seed_id) < minimum:
			inventory[seed_id] = minimum


func set_feedback(next_key: String, args: Array = []) -> void:
	feedback_key = next_key
	feedback_args = args.duplicate()


func _fail(next_key: String, args: Array = []) -> bool:
	set_feedback(next_key, args)
	_emit_changed()
	return false


func _emit_changed() -> void:
	emit_signal("changed")
