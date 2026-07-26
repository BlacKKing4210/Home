extends SceneTree

const ResidentConfig = preload("res://scripts/town/f004_resident_config.gd")
const ResidentModel = preload("res://scripts/town/f004_resident_model.gd")
const ResidentText = preload("res://scripts/town/f004_resident_text.gd")
const ResidentSave = preload("res://scripts/town/f004_resident_save.gd")
const ResidentView = preload("res://scripts/town/f004_resident_view.gd")

const TEST_SAVE_PATH := "user://city_of_animals_f004_resident_test.json"
const EVIDENCE_DIR := "res://output/runtime/F004-RESIDENT.1"


func _initialize() -> void:
	call_deferred("_start")


func _start() -> void:
	var result: int = await _run()
	quit(result)


func _run() -> int:
	var config = ResidentConfig.load_default()
	if not _expect(config.is_valid(), "F004 representative configuration must validate: %s" % "; ".join(config.errors)):
		return 1
	if not _expect(config.grid_rows().size() == 10, "Grid catalog must contain ten spatial objects."):
		return 1
	if not _expect(config.road_rows().size() == 6, "Road graph must contain six explicit 1x1 road cells."):
		return 1
	if not _expect(_footprint(config, "home_plot") == Vector2i(2, 2), "Resident house must be 2x2."):
		return 1
	if not _expect(_footprint(config, "field_wheat") == Vector2i(1, 1), "Field must be the minimum 1x1 unit."):
		return 1
	if not _expect(_footprint(config, "workshop_granary") == Vector2i(2, 2), "Representative workshop must be 2x2."):
		return 1
	if not _expect(_footprint(config, "loading_yard") == Vector2i(3, 2), "Loading yard must be 3x2."):
		return 1
	for asset_id_variant in ResidentConfig.RUNTIME_ASSET_PATHS.keys():
		var asset_id := str(asset_id_variant)
		if not _expect(FileAccess.file_exists(config.runtime_asset_path(asset_id)), "Approved runtime asset must exist: %s" % asset_id):
			return 1

	var model = ResidentModel.new(config)
	if not _expect(model.validate_footprint("home_plot"), "Approved house footprint must not overlap other structures."):
		return 1
	if not _expect(model.coins == 180, "Initial coins must come from the grid settings table."):
		return 1
	model.tick(3.0)
	if not _expect(model.truck_state == "waiting", "World vehicle must arrive and wait without a menu."):
		return 1
	if not _expect(model.build_house() and model.house_built and model.coins == 60, "One low-frequency build action must create the 2x2 house and deduct configured cost once."):
		return 1
	if not _expect(model.invite_resident() and model.resident_invited and model.coins == 40, "Invitation must place the rabbit resident in the new home and deduct cost once."):
		return 1
	if not _expect(model.assign_default_job() and model.resident_state == "walking_to_field", "Assignment must start autonomous road travel."):
		return 1
	if not _expect(model.set_road_blocked("road_center_a", true), "A real road cell must be closable."):
		return 1
	if not _expect(model.resident_state == "blocked" and model.blocked_reason == "road", "Road closure must visibly interrupt travel."):
		return 1
	if not _expect(model.set_road_blocked("road_center_a", false), "Closed road must be reopenable."):
		return 1
	if not _expect(model.resident_state == "walking_to_field", "Reopening the route must resume the interrupted assignment."):
		return 1
	model.tick(1.0)
	if not _expect(model.resident_state == "working_field", "Resident must reach and begin field work."):
		return 1

	var save_service = ResidentSave.new(TEST_SAVE_PATH)
	save_service.remove()
	model.tick(2.0)
	if not _expect(save_service.save_model(model) == OK, "Mid-job state must save."):
		return 1
	var resumed_model = ResidentModel.new(config)
	var load_result: Dictionary = save_service.load_into(resumed_model)
	if not _expect(bool(load_result.get("loaded", false)) and resumed_model.resident_state == "working_field", "Interrupted work must restore to the saved behavior state."):
		return 1
	if not _expect(resumed_model.work_remaining > 0.0 and resumed_model.work_remaining < 8.0, "Work timer must resume rather than restart."):
		return 1
	save_service.remove()

	model.tick(6.1)
	if not _expect(model.resident_state == "walking_to_workshop" and model.carried_item == "wheat_bundle", "Field completion must produce carried wheat and start autonomous delivery to the workshop."):
		return 1
	model.tick(2.0)
	if not _expect(model.resident_state == "working_workshop", "Resident must reach the 2x2 granary workshop."):
		return 1
	model.tick(5.1)
	if not _expect(model.resident_state == "walking_to_yard" and model.carried_item == "order_crate", "Workshop must transform the carried bundle into one order crate."):
		return 1
	model.tick(2.0)
	if not _expect(model.resident_state == "loading", "Resident must reach the 3x2 loading yard and start loading the waiting truck."):
		return 1
	var coins_before_order: int = model.coins
	model.tick(2.6)
	if not _expect(model.order_complete and model.order_loaded == 1, "Loading must atomically complete the configured world order."):
		return 1
	if not _expect(model.coins - coins_before_order == 80 and model.truck_state == "departing", "Order must award configured coins once and make the vehicle depart."):
		return 1
	model.tick(4.0)
	if not _expect(model.truck_state == "gone" and model.resident_state == "home_idle", "Vehicle must leave and resident must return home."):
		return 1

	var loading_model = ResidentModel.new(config)
	loading_model.tick(3.0)
	loading_model.build_house()
	loading_model.invite_resident()
	loading_model.assign_default_job()
	loading_model.tick(1.0)
	loading_model.tick(8.1)
	loading_model.tick(2.0)
	loading_model.tick(5.1)
	loading_model.set_loading_capacity(0)
	loading_model.tick(2.0)
	if not _expect(loading_model.resident_state == "blocked" and loading_model.blocked_reason == "loading", "Full loading bay must block without consuming the crate."):
		return 1
	loading_model.set_loading_capacity(1)
	if not _expect(loading_model.resident_state == "loading" and loading_model.carried_item == "order_crate", "Clearing capacity must resume with cargo intact."):
		return 1
	loading_model.tick(2.6)
	if not _expect(loading_model.order_complete, "Resumed loading must still complete exactly once."):
		return 1

	DirAccess.remove_absolute(ProjectSettings.globalize_path(ResidentText.PREFERENCE_PATH))
	var chinese_text = ResidentText.new()
	if not _expect(chinese_text.is_valid() and chinese_text.locale == "zh-CN", "First launch must default to Simplified Chinese."):
		return 1
	if not _expect(chinese_text.text("town_name") == "茸叶小镇", "Chinese locale must resolve player-facing text."):
		return 1
	chinese_text.set_locale("en")
	chinese_text.set_reduced_motion(true)
	var persisted_text = ResidentText.new()
	if not _expect(persisted_text.locale == "en" and persisted_text.reduced_motion, "English and reduced-motion preferences must persist."):
		return 1
	DirAccess.remove_absolute(ProjectSettings.globalize_path(ResidentText.PREFERENCE_PATH))

	var viewport := SubViewport.new()
	viewport.size = Vector2i(720, 1280)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	get_root().add_child(viewport)
	var view = ResidentView.new()
	view.disable_persistence = true
	viewport.add_child(view)
	view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	await process_frame
	await process_frame
	var snapshot: Dictionary = view.debug_snapshot()
	print("F004_VIEW_SNAPSHOT: %s" % JSON.stringify(snapshot))
	if not _expect(bool(snapshot.get("runtime_ready", false)), "F004 main view must initialise through the real entry script."):
		return 1
	if not _expect(int(snapshot.get("asset_count", 0)) == 7, "Runtime must load six approved slice assets plus the approved rabbit."):
		return 1
	if not _expect(view.debug_target_at_design(Vector2(670, 52)) == "settings", "Settings touch target must remain reachable at 720x1280."):
		return 1
	if "--f004-capture" in OS.get_cmdline_user_args():
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIR))
		if not _expect(_save_capture(viewport, "01-default-unbuilt.png"), "Default 720x1280 capture must save."):
			return 1

	view.debug_activate_target("panel:cta")
	await process_frame
	if not _expect(bool(view.debug_snapshot().get("house_built", false)), "Primary CTA must build the house."):
		return 1
	view.debug_activate_target("panel:cta")
	await process_frame
	if not _expect(bool(view.debug_snapshot().get("resident_invited", false)), "Next primary CTA must invite the resident."):
		return 1
	if "--f004-capture" in OS.get_cmdline_user_args():
		_save_capture(viewport, "02-resident-invited.png")

	view.debug_activate_target("panel:cta")
	var runtime_block_result: bool = view.debug_model().set_road_blocked("road_center_a", true)
	await process_frame
	print("F004_RUNTIME_BLOCK_SNAPSHOT: result=%s state=%s route=%s" % [runtime_block_result, view.debug_model().resident_state, view.debug_model().route])
	if not _expect(str(view.debug_snapshot().get("resident_state", "")) == "blocked", "Runtime interaction path must expose interruption."):
		return 1
	if "--f004-capture" in OS.get_cmdline_user_args():
		_save_capture(viewport, "03-road-blocked.png")
	view.debug_model().set_road_blocked("road_center_a", false)
	view.debug_model().tick(4.0)
	await process_frame
	if "--f004-capture" in OS.get_cmdline_user_args():
		_save_capture(viewport, "04-field-work.png")
	view.debug_model().tick(8.1)
	view.debug_model().tick(3.0)
	view.debug_model().tick(5.1)
	view.debug_model().tick(3.0)
	view.debug_model().tick(2.6)
	await process_frame
	if not _expect(bool(view.debug_snapshot().get("order_complete", false)), "Runtime path must complete the world vehicle order."):
		return 1
	if "--f004-capture" in OS.get_cmdline_user_args():
		_save_capture(viewport, "05-order-success.png")
	view.debug_activate_target("settings")
	view.debug_activate_target("panel:lang:en")
	view.debug_activate_target("panel:motion")
	await process_frame
	if not _expect(str(view.debug_snapshot().get("locale", "")) == "en" and bool(view.debug_snapshot().get("reduced_motion", false)), "Settings must switch language and reduced motion in the real view."):
		return 1
	if "--f004-capture" in OS.get_cmdline_user_args():
		_save_capture(viewport, "06-settings-en-reduced.png")
		var frame_sample_start := Time.get_ticks_usec()
		for _frame in range(120):
			await process_frame
		var frame_sample_seconds := float(Time.get_ticks_usec() - frame_sample_start) / 1000000.0
		var measured_fps: float = 120.0 / maxf(frame_sample_seconds, 0.001)
		if not _expect(_save_runtime_metrics(measured_fps, 120), "Normal-render runtime metrics must save beside the 720x1280 captures."):
			return 1

	view.shutdown_audio()
	viewport.queue_free()
	await process_frame
	DirAccess.remove_absolute(ProjectSettings.globalize_path(ResidentText.PREFERENCE_PATH))
	print("F004_RESIDENT_TESTS_PASSED")
	return 0


func _footprint(config, grid_id: String) -> Vector2i:
	var row: Dictionary = config.record("grid", grid_id)
	return Vector2i(config.number(row, "footprint_w"), config.number(row, "footprint_h"))


func _save_capture(viewport: SubViewport, filename: String) -> bool:
	var image := viewport.get_texture().get_image()
	if image == null or image.is_empty():
		return false
	var path := "%s/%s" % [EVIDENCE_DIR, filename]
	return image.save_png(ProjectSettings.globalize_path(path)) == OK


func _save_runtime_metrics(measured_fps: float, measured_frames: int) -> bool:
	var metrics := {
		"captured_at_utc": Time.get_datetime_string_from_system(true),
		"engine": Engine.get_version_info(),
		"viewport": {"width": 720, "height": 1280},
		"measured_fps": snappedf(measured_fps, 0.01),
		"measured_frames": measured_frames,
		"engine_fps_at_capture": Performance.get_monitor(Performance.TIME_FPS),
		"static_memory_bytes": Performance.get_monitor(Performance.MEMORY_STATIC),
		"node_count": Performance.get_monitor(Performance.OBJECT_NODE_COUNT),
		"render_objects_in_frame": Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME),
		"asset_count": 7,
		"capture_path": "normal Godot render path; SubViewport UPDATE_ALWAYS",
	}
	var file := FileAccess.open("%s/runtime-metrics.json" % EVIDENCE_DIR, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(metrics, "\t") + "\n")
	file.close()
	return true


func _expect(condition: bool, message: String) -> bool:
	if condition:
		print("PASS: %s" % message)
		return true
	push_error("FAIL: %s" % message)
	return false
